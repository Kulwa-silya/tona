from django.db import models
from django.core.validators import MinValueValidator
from datetime import date
from store.models import *

# Create your models here.
class SoldProduct(models.Model):
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name='productSold')
    quantity = models.IntegerField(validators=[MinValueValidator(1)])
    date = models.DateField(auto_now_add=True)
    # unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    customer = models.ForeignKey(Customer, blank=True,null=True, 
                                 related_name='customer', on_delete=models.CASCADE)

    def __str__(self) -> str:
        return f"{self.product.title}"

    def save(self, *args, **kwargs):
        if self.product.inventory >= self.quantity:
            # save the soldProduct instance first
            super().save(*args, **kwargs)
            # update inventory
            self.product.inventory -= self.quantity
            self.product.save()

            # update sales
            sales = Sale.objects.get_or_create(date=date.today())[0]
            sales.sold_products.add(self)
            sales.total_amount += self.quantity
            sales.calculate_total_income()
            sales.save()
        else:
            raise ValueError("Not enough inventory to fulfill this request.") 
    
    def delete(self, *args, **kwargs):
        # re-update inventory to reinstate to original state
        print("hapa tumepita")
        self.product.inventory += self.quantity
        self.product.save()

        # re-update sale
        sales = Sale.objects.get(date=self.date)
        sales.total_amount -= self.quantity
        sales.calc_income_onDelete(self.quantity * self.product.unit_price)
        sales.save()
        # delete the soldProduct instance
        super().delete(*args, **kwargs)

    def update_sold_product(self,instance,validated_data,*args, **kwargs):
        old_quantity = self.quantity
        new_quantity = validated_data.get('quantity') # This helps to ensure that the quantity field is not accidentally set to None or any other invalid value.
        
        if old_quantity != new_quantity:
            quantity_diff = abs(old_quantity - new_quantity)
            if old_quantity > new_quantity:
                # quantity has decreased
                self.product.inventory += quantity_diff
                self.product.save()

                sales = Sale.objects.get(date=self.date)
                sales.total_amount -= quantity_diff
                sales.total_income -= quantity_diff * self.product.unit_price
                sales.save()
            else:
                # quantity has increased
                if self.product.inventory >= quantity_diff:
                    self.product.inventory -= quantity_diff
                    self.product.save()

                    sales =  Sale.objects.get(date=self.date)
                    sales.total_amount += quantity_diff
                    sales.total_income += quantity_diff * self.product.unit_price                  
                    sales.save()
                else:
                    raise ValueError("Not enough inventory to fulfill this request.")    
        # update other fields
        self.quantity = new_quantity
        self.product = validated_data.get('product', self.product)
        self.date = validated_data.get('date', self.date)
        self.customer = validated_data.get('customer', self.customer)
        # tunatumia super kwa sababu self.save tumeshaicustomize na ina calculations pia
        super().save(*args, **kwargs)
        return self

class Sale(models.Model):
    date = models.DateField(default=date.today)
    total_amount = models.IntegerField(default=0)
    sold_products = models.ManyToManyField('SoldProduct', related_name='sales')
    total_income = models.DecimalField(max_digits=9, decimal_places=2, default=0)

    def __str__(self) -> str:
        return f"Sales for {self.date}"
    
    def calculate_total_income(self):
        total_income = 0
        for sold_product in self.sold_products.all():
            total_income += sold_product.quantity * sold_product.product.unit_price
        self.total_income = total_income
        self.save()

    def calc_income_onDelete(self, income):
        self.total_income -= income
        self.save
