from django.db import models
# from django.contrib import admin
from django.conf import settings
from django.db import models
# from datetime import date
from store.models import Product
from store.validators import validate_file_size
from django.core.validators import MinValueValidator
from phonenumber_field.modelfields import PhoneNumberField
from decimal import Decimal
from django.db.models import Sum
# Create your models here.
# procurement
from datetime import date

class DailyPurchaseTotal(models.Model):
    date = models.DateField(default=date.today, unique=True)
    total_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    @classmethod
    def recalculate_total(cls, purchase_date):
        total_cost = Decimal(Purchase.objects.filter(date=purchase_date).aggregate(Sum('total_amount'))['total_amount__sum'] or 0)
        daily_total, created = cls.objects.get_or_create(date=purchase_date)
        daily_total.total_cost = total_cost
        daily_total.save()
        return daily_total


class Supplier(models.Model):
    # kwani huyu ni user wa kwenye system au jina la supplier tu??
    full_name = models.CharField(max_length=255)
    phone_number = PhoneNumberField(
        verbose_name="phone number")
    address = models.CharField(max_length=255)

    def __str__(self):
        return self.full_name


class PurchasedProduct(models.Model):
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name='productPurchased')
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.IntegerField(
        validators=[MinValueValidator(1)], default='1')

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
    total_amount = models.DecimalField(
        max_digits=10, decimal_places=2, blank=True, default=0)
    payment_method = models.CharField(
        max_length=255, default=PAYMENT_METHOD_CASH, choices=PAYMENT_METHOD_CHOICES)
    purchased_products = models.ManyToManyField(
        PurchasedProduct, related_name='purchase')
    supplier = models.ForeignKey(Supplier, related_name='purchase', on_delete=models.CASCADE)

    # include receipts

    def __str__(self) -> str:
        return str(self.id)

        return total_amount
    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        DailyPurchaseTotal.recalculate_total(self.date)


# single purchase can have more than one receipts
class Receipt(models.Model):
    purchase = models.ForeignKey(
        Purchase, on_delete=models.CASCADE, related_name='receipt')
    image = models.ImageField(
        upload_to='store/receipts',
        validators=[validate_file_size])


class AssociatedCost(models.Model):
    name = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    purchase = models.ForeignKey(
        Purchase, on_delete=models.CASCADE, related_name='purchase')

    def __str__(self) -> str:
        return self.name
