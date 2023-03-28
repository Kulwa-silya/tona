from rest_framework import serializers
from .models import *
from tona_users.serializers import *

class SupplierSerializer(serializers.ModelSerializer):
    class Meta:
        model = Supplier
        fields = ('__all__')

class PurchasedProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = PurchasedProduct
        fields = fields = ('__all__')

class PurchaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Purchase
        fields = fields = ('__all__')

class AssociatedCostSerializer(serializers.ModelSerializer):
    class Meta:
        model = AssociatedCost
        fields = fields = ('__all__')

