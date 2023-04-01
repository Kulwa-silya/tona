from decimal import Decimal
from django.db import transaction
from rest_framework import serializers
from .models import *
from store.models import *
from tona_users.serializers import *

class SoldProductSerializer(serializers.ModelSerializer):
    product_title = serializers.ReadOnlyField(source='product.title') 
    # customer = CustomerSerializer()
    class Meta:
        model = SoldProduct
        fields = ['id','sale','quantity','product','product_title','discount']



class SaleSerializer(serializers.ModelSerializer):
    date = serializers.DateTimeField(format='%A %Y-%m-%d %H:%M', read_only=True)
    class Meta:
        model = Sale
        fields = ['id','customer_name', 'total_quantity_bought', 'date', 'sale_revenue']
        read_only_fields = ['total_quantity_bought', 'sale_revenue']
        # read_only_fields = ['total_quantity_bought']