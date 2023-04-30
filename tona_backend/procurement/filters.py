from django_filters.rest_framework import FilterSet
from .models import Supplier, Purchase, PurchasedProduct, Receipt


class PurchasedProductFilter(FilterSet):
    class Meta:
        model = PurchasedProduct
        fields = {
            'quantity': ['exact', 'gt', 'lt'],
            'unit_price': ['gt', 'lt']

        }


class SupplierFilter(FilterSet):
    class Meta:
        model = Supplier
        fields = ['full_name', 'phone_number', 'address']


class PurchaseFilter(FilterSet):
    class Meta:
        model = Purchase
        fields = ['date', 'total_amount', 'payment_method', 'supplier']


class ReceiptFilter(FilterSet):
    class Meta:
        model = Receipt
        fields = ['purchase']
