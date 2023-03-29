from django.db import models
# from django.contrib import admin
from django.conf import settings
from django.db import models
# from datetime import date
from store.models import Product
from store.validators import validate_file_size
from django.core.validators import MinValueValidator


# Create your models here.
# procurement
class Supplier(models.Model):
    # kwani huyu ni user wa kwenye system au jina la supplier tu??
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True)
    address = models.CharField(max_length=255)

    def __str__(self) -> str:
        return str(self.user)



class PurchasedProduct(models.Model):
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name='productPurchased')
    date = models.DateField()
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.IntegerField(validators=[MinValueValidator(1)], default='1')
    supplier = models.ForeignKey(Supplier, related_name='supplier', on_delete=models.CASCADE)

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        # update inventory
        self.product.inventory += self.quantity
        self.product.save()

    def __str__(self) -> str:
        return str(self.product.title)



class Purchase(models.Model):
    PAYMENT_METHOD_CASH = 'CA'
    PAYMENT_METHOD_CREDIT = 'CR'
    PAYMENT_METHOD_CHECK = 'CH'

    PAYMENT_METHOD_CHOICES = [
        (PAYMENT_METHOD_CASH, 'cash'),
        (PAYMENT_METHOD_CREDIT, 'credit'),
        (PAYMENT_METHOD_CHECK, 'check'),

       ]
    
    date = models.DateField()
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_method = models.CharField(max_length=255, default=PAYMENT_METHOD_CASH, choices=PAYMENT_METHOD_CHOICES)
    purchased_products = models.ManyToManyField(PurchasedProduct, related_name='purchasedproduct')
    # include receipts
    def __str__(self) -> str:
        return str(self.id)
    
    

#single purchase can have more than one receipts
class Receipt(models.Model):
    purchase = models.ForeignKey(
        Purchase, on_delete=models.CASCADE, related_name='receipt')
    image = models.ImageField(
        upload_to='store/receipts',
        validators=[validate_file_size])
    


class AssociatedCost(models.Model):
    name = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    purchase = models.ForeignKey(Purchase, on_delete=models.CASCADE, related_name='purchase')

    def __str__(self) -> str:
        return self.name