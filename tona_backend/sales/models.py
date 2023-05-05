from django.db import models
from django.conf import settings
from django.core.validators import MinValueValidator
from datetime import date
from django.utils import timezone
from phonenumber_field.modelfields import PhoneNumberField
from store.models import *
from django.contrib.auth import get_user_model

# Create your models here.
class DailySales(models.Model):
    date = models.DateField(default=date.today, unique=True)
    total_sales_revenue_on_day = models.DecimalField(max_digits=9, decimal_places=2, default=0)
    total_quantity_sold_on_day = models.IntegerField(default=0)

    class Meta:
        ordering = ['date']

    def __str__(self) -> str:
        return f"sales for {self.date.strftime('%A %Y-%m-%d')}"

    def calc_total_sales_revenue_on_day(self):
        sales_of_day = Sale.objects.filter(date__date=self.date)
        total_sales_revenue_on_day = 0
        total_quantity_sold_on_day = 0
        for sale in sales_of_day:
            total_sales_revenue_on_day += sale.sale_revenue
            total_quantity_sold_on_day += sale.total_quantity_sold
        self.total_sales_revenue_on_day = total_sales_revenue_on_day
        self.total_quantity_sold_on_day = total_quantity_sold_on_day
        self.save()


class Sale(models.Model):
    customer_name = models.CharField(max_length=255,blank=True,null=True)
    phone_number = PhoneNumberField(verbose_name="phone number")
    date = models.DateTimeField(default=timezone.now)
    description = models.TextField(blank=True,null=True,max_length=1000)
    total_quantity_sold = models.IntegerField(default=0)
    sale_revenue = models.DecimalField(max_digits=9, decimal_places=2, default=0)

    class Meta:
        ordering = ['date']


    def __str__(self) -> str:
        return f"Sale to {self.customer_name} for {self.date.strftime('%A %Y-%m-%d %H:%M')}"

    def delete(self, *args, **kwargs):
        if self.sold_products.exists():
            raise ValidationError('Cannot delete Sale instance with associated SoldProduct instances, delete the individual sold products in this sale first')
        super().delete(*args, **kwargs)
    
    def calculate_sale_revenue(self):
        sale_revenue = 0
        for sold_product in self.sold_products.all():
            sale_revenue += sold_product.quantity * sold_product.product.unit_price
        self.sale_revenue = sale_revenue
        self.save()


class SoldProduct(models.Model):
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name='productSold')
    quantity = models.IntegerField(validators=[MinValueValidator(1)])
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE, related_name='sold_products')
    discount = models.DecimalField(max_digits=5, decimal_places=2, default=0)

    class Meta:
        # add unique constraint for product and sale fields, 
        # This will ensure that a product can only be sold once per sale.
        unique_together = ('product', 'sale')
    
    def __str__(self) -> str:
        return f"{self.product.title} for {self.sale}"

    def save(self, *args, **kwargs):
        if self.product.inventory >= self.quantity:
            # save the soldProduct instance first
            super().save(*args, **kwargs)
            # update inventory
            self.product.inventory -= self.quantity
            self.product.save()

            # update sale
            sale = self.sale
            sale.sold_products.add(self)
            sale.total_quantity_sold += self.quantity
            if self.discount > 0:
                discount_amount = (self.product.unit_price * self.discount) / 100
                sale.sale_revenue += (self.product.unit_price - discount_amount) * self.quantity
            else:
                sale.sale_revenue += self.product.unit_price * self.quantity
            sale.save()
        else:
            raise ValueError("Not enough inventory to fulfill this request.") 
    
    def delete(self, *args, **kwargs):
        # re-update inventory to reinstate to original state
        self.product.inventory += self.quantity
        self.product.save()

        # re-update sale
        sale = self.sale
        sale.total_quantity_sold -= self.quantity
        discount_amount = ((self.product.unit_price * self.discount) / 100)
        sale.sale_revenue -= ((self.product.unit_price - discount_amount) * self.quantity)
        sale.save()
        # delete the soldProduct instance
        super().delete(*args, **kwargs)

    def update_sold_product(self, instance, validated_data, *args, **kwargs):
        old_quantity = self.quantity
        new_quantity = validated_data.get('quantity')
        old_discount = self.discount
        new_discount = validated_data.get('discount')

        if old_quantity != new_quantity or old_discount != new_discount:
            quantity_diff = abs(old_quantity - new_quantity)

            if new_quantity < old_quantity and new_discount > old_discount:
                raise ValueError("you can't reduce quantity and increase discount.")

            if old_quantity > new_quantity:
                if self.return_inwards.filter(is_authorized=False):
                    raise ValueError("you can't add another return when there's another unauthorised.")
                else:
                    return_inwards = ReturnInwards(sold_product=self, quantity_returned=quantity_diff, return_reason=validated_data['return_reason'])
                    return_inwards.save()
                    return self
                
            else:
                # quantity or discount has increased
                if self.product.inventory >= quantity_diff:
                    self.product.inventory -= quantity_diff
                    self.product.save()

                    sale = self.sale
                    sale.total_quantity_sold += quantity_diff

                    new_discount_amount = ((self.product.unit_price * new_discount) / 100)
                    old_discount_amount = ((self.product.unit_price * old_discount) / 100)
                    # revenue without the old price and and old quantity
                    sale.sale_revenue -= ((self.product.unit_price - old_discount_amount) * old_quantity)
                    # revenue_difference = abs(sale.sale_revenue - (self.product.unit_price - discount_amount) * new_quantity) ##this is the old method
                    sale.sale_revenue += ((self.product.unit_price - new_discount_amount) * new_quantity)
                    sale.save()
                else:
                    raise ValueError("Not enough inventory to fulfill this request.")

        # update other fields
        self.quantity = new_quantity
        self.discount = new_discount
        super().save(*args, **kwargs)

        return self

class ReturnInwards(models.Model):
    sold_product = models.ForeignKey(SoldProduct, on_delete=models.CASCADE, related_name='return_inwards')
    quantity_returned = models.IntegerField(default=0)
    date = models.DateTimeField(auto_now_add=True)
    return_reason = models.TextField(max_length=500, null=True, blank=True)
    is_authorized = models.BooleanField(default=False)
    authorized_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True)

    def authorize_return(self, user_id,*args, **kwargs):
        User = get_user_model()
        user = User.objects.get(id=user_id)
        if user.is_staff:
            if not self.is_authorized:
                # check if return is not already authorized
                sold_product = self.sold_product
                sale = sold_product.sale

                # update inventory
                sold_product.product.inventory += self.quantity_returned
                sold_product.product.save()

                # Update the SoldProduct instance
                sold_product.quantity -= self.quantity_returned
                models.Model.save(sold_product, *args, **kwargs)
                # sold_product.super().save()
                 
                # Update the Sale instance.
                sale.total_quantity_sold -= self.quantity_returned
                sale.sale_revenue -= sold_product.product.unit_price * self.quantity_returned
                sale.save()
                self.is_authorized = True
                self.authorized_by = user
                self.save()
            else:
                raise ValueError("Return has already been authorized.")
        else:
            raise PermissionError("Authorization required from admin.")
