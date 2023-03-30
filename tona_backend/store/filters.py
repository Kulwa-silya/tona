from django_filters.rest_framework import FilterSet
from .models import Product, SoldProduct, Sale

class ProductFilter(FilterSet):
  class Meta:
    model = Product
    fields = {
      'collection_id': ['exact'],
      'unit_price': ['gt', 'lt']
    }

class SoldProductFilter(FilterSet):
  class Meta:
    model = SoldProduct
    # fields = ['customer', 'product']
    fields = {
      'customer': ['exact'],
      'product':['exact'],
      'date': ['exact','gte', 'lte']
      }

class SaleFilter(FilterSet):
  class Meta:
    model = Sale
    fields = {'date': ['exact','gte', 'lte']} # greater than or equal and less than or equal so that both margin dates are included