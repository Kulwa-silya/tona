from django.contrib import admin
from django.conf import settings
from django.core.validators import MinValueValidator
from django.core.exceptions import ValidationError
from django.http import JsonResponse
from django.db import models
from uuid import uuid4
from store.validators import validate_file_size
from datetime import date


class Promotion(models.Model):
    description = models.CharField(max_length=255)
    discount = models.FloatField()


class Collection(models.Model):
    title = models.CharField(max_length=255)
    featured_product = models.ForeignKey(
        'Product', on_delete=models.SET_NULL, null=True, related_name='+', blank=True)

    def __str__(self) -> str:
        return self.title

    class Meta:
        ordering = ['title']


class Product(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField(null=True, blank=True)
    unit_price = models.DecimalField(max_digits=9,
        decimal_places=2,
        validators=[MinValueValidator(1)])
    inventory = models.IntegerField(validators=[MinValueValidator(0)])
    last_update = models.DateTimeField(auto_now=True)
    collection = models.ForeignKey(
        Collection, on_delete=models.PROTECT, related_name='products')
    promotions = models.ForeignKey(Promotion, blank=True, null=True, on_delete=models.SET_NULL)

    def __str__(self) -> str:
        return self.title

    class Meta:
        ordering = ['title']


class ProductImage(models.Model):
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(
        upload_to='store/images',
        validators=[validate_file_size])


class Customer(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    street = models.CharField(max_length=255, null=True, blank=True)
    city = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f'{self.user.first_name} {self.user.last_name}'

    @admin.display(ordering='user__first_name')
    def first_name(self):
        return self.user.first_name

    @admin.display(ordering='user__last_name')
    def last_name(self):
        return self.user.last_name

    class Meta:
        ordering = ['user__first_name', 'user__last_name']
        permissions = [
            ('view_history', 'Can view history')
        ]


class Order(models.Model):
    PAYMENT_STATUS_PENDING = 'P'
    PAYMENT_STATUS_COMPLETE = 'C'
    PAYMENT_STATUS_CHOICES = [
        (PAYMENT_STATUS_PENDING, 'Pending'),
        (PAYMENT_STATUS_COMPLETE, 'Complete')
    ]

    placed_at = models.DateTimeField(auto_now_add=True)
    payment_status = models.CharField(
        max_length=1, choices=PAYMENT_STATUS_CHOICES, default=PAYMENT_STATUS_PENDING)
    customer = models.ForeignKey(Customer, on_delete=models.PROTECT)

    class Meta:
        permissions = [
            ('cancel_order', 'Can cancel order')
        ]


class OrderItem(models.Model):
    order = models.ForeignKey(
        Order, on_delete=models.PROTECT, related_name='items')
    product = models.ForeignKey(
        Product, on_delete=models.PROTECT, related_name='orderitems')
    quantity = models.PositiveSmallIntegerField()
    unit_price = models.DecimalField(max_digits=6, decimal_places=2)


class OrderDelivery(models.Model):
    DELIVERY_STATUS_UNASSIGNED = 'U'
    DELIVERY_STATUS_ASSIGNED = 'A'
    DELIVERY_STATUS_DELIVERED = 'D'

    DELIVERY_STATUS_CHOICES = [
    (DELIVERY_STATUS_UNASSIGNED , 'UNASSIGNED'),
    (DELIVERY_STATUS_ASSIGNED , 'ASSIGNED'),
    (DELIVERY_STATUS_DELIVERED , 'DELIVERED')
    ]

    order = models.ForeignKey(
        Order, on_delete=models.PROTECT, related_name='orders')
    delivery_person = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    status = models.CharField(max_length=1, choices=DELIVERY_STATUS_CHOICES, default=DELIVERY_STATUS_UNASSIGNED)


class Cart(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid4)
    created_at = models.DateTimeField(auto_now_add=True)


class CartItem(models.Model):
    cart = models.ForeignKey(
        Cart, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1)]
    )

    class Meta:
        unique_together = [['cart', 'product']]


class Review(models.Model):
    product = models.ForeignKey(
        Product, on_delete=models.CASCADE, related_name='reviews')
    name = models.CharField(max_length=255)
    description = models.TextField()
    date = models.DateField(auto_now_add=True)




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
        # tunatumia super kwa sababu self.save tumeshaicustomize na in calculations pia
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
