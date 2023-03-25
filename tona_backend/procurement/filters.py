# from django_filters.rest_framework import FilterSet
# from .models import Supplier, Purchase, PurchasedProduct

# class ProductFilter(FilterSet):
#   class Meta:
#     model = PurchasedProduct
#     fields = {
#       'collection_id': ['exact'],
#       'unit_price': ['gt', 'lt']
#     }

# class SoldProductFilter(FilterSet):
#   class Meta:
#     model = SoldProduct
#     fields = ['customer', 'product']