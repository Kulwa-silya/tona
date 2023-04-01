from django.db import models
from django.core.validators import MinValueValidator
from datetime import date
from phonenumber_field.modelfields import PhoneNumberField
from store.models import *

# Create your models here.
class Sale(models.Model):
    customer_name = models.CharField(max_length=255,blank=True,null=True)
    # phone_number = PhoneNumberField(verbose_name="phone number", unique=True)
    date = models.DateTimeField(auto_now_add=True)
    # date = models.DateField(default=date.today)
    total_quantity_bought = models.IntegerField(default=0)
    sale_revenue = models.DecimalField(max_digits=9, decimal_places=2, default=0)


    def __str__(self) -> str:
        return f"Sale to {self.customer_name} for {self.date.strftime('%A %Y-%m-%d %H:%M')}"
    
    def calculate_sale_revenue(self):
        sale_revenue = 0
        for sold_product in self.sold_products.all():
            sale_revenue += sold_product.quantity * sold_product.product.unit_price
        self.sale_revenue = sale_revenue
        self.save()

    def calc_rev_onDelete(self, income):
        self.sale_revenue -= income
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
        return f"{self.product.title}"

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
            sale.total_quantity_bought += self.quantity
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
        sale.total_quantity_bought -= self.quantity
        sale.calc_rev_onDelete(self.quantity * self.product.unit_price)
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
                # quantity or discount has decreased
                self.product.inventory += quantity_diff
                self.product.save()

                sale = self.sale
                sale.total_quantity_bought -= quantity_diff

                new_discount_amount = ((self.product.unit_price * new_discount) / 100)
                old_discount_amount = ((self.product.unit_price * old_discount) / 100)
                # revenue without the old price and and old quantity
                sale.sale_revenue -= ((self.product.unit_price - old_discount_amount) * old_quantity)
                # revenue_difference = abs(sale.sale_revenue - (self.product.unit_price - discount_amount) * new_quantity) ##this is the old method
                sale.sale_revenue += ((self.product.unit_price - new_discount_amount) * new_quantity)
                sale.save()
            else:
                # quantity or discount has increased
                if self.product.inventory >= quantity_diff:
                    self.product.inventory -= quantity_diff
                    self.product.save()

                    sale = self.sale
                    sale.total_quantity_bought += quantity_diff

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


