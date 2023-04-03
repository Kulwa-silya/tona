from django_filters.rest_framework import FilterSet
from .models import SoldProduct, Sale

class SoldProductFilter(FilterSet):
  class Meta:
    model = SoldProduct
    # fields = ['customer', 'product']
    fields = {
      'product':['exact'],
      'quantity': ['exact','gte', 'lte'],
      'sale':['exact']
      }

class SaleFilter(FilterSet):
  class Meta:
    model = Sale
    fields = {
      'customer_name': ['exact'],
      'date': ['exact','gte', 'lte']
      } # greater than or equal and less than or equal so that both margin dates are included