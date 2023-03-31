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
        fields = ['id','quantity','date','product','product_title','customer']



class SaleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sale
        fields = fields = ('__all__')