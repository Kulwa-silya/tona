from django.db import models
# from django.contrib import admin
from django.conf import settings
from django.db import models
# from datetime import date
from store.models import Product


# Create your models here.
# procurement
class Supplier(models.Model):
    # kwani huyu ni user wa kwenye system au jina la supplier tu??
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True)
    address = models.CharField(max_length=255)



class PurchasedProduct(models.Model):
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name='productPurchased')
    date = models.DateField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    supplier = models.ForeignKey(Supplier, related_name='supplier', on_delete=models.CASCADE)


class Purchase(models.Model):
    date = models.DateField()
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    purchased_products = models.ManyToManyField(PurchasedProduct, related_name='purchasedproduct')
    # include receipts


class AssociatedCost(models.Model):
    name = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    purchase = models.ForeignKey(Purchase, on_delete=models.CASCADE, related_name='purchase')