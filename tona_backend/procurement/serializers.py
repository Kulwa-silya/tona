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
        fields =  ('__all__')

class PurchaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Purchase
        fields = ('__all__')

class AssociatedCostSerializer(serializers.ModelSerializer):
    class Meta:
        model = AssociatedCost
        fields = ('__all__')



class ReceiptSerializer(serializers.ModelSerializer):
    class Meta:
        model = Receipt
        fields = ('__all__')