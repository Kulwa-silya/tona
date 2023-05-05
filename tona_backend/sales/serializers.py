from decimal import Decimal
from django.db import transaction
from rest_framework import serializers
from .models import *
from store.models import *
from tona_users.serializers import *

class SoldProductSerializer(serializers.ModelSerializer):
    product_title = serializers.ReadOnlyField(source='product.title') 
    original_price = serializers.ReadOnlyField(source='product.unit_price') 

    class Meta:
        model = SoldProduct
        fields = ['id','sale','quantity','product','product_title','original_price','discount','return_inwards_authorised']

    def to_internal_value(self, data):
        data = data.copy()  # Create a copy of the data dictionary
        return_reason = data.pop('return_reason', None)
        self.fields['return_reason'] = serializers.CharField(required=False)
        if return_reason is not None:
            data['return_reason'] = return_reason
        return super(SoldProductSerializer, self).to_internal_value(data)
    
    return_inwards_authorised = serializers.SerializerMethodField(
        method_name='return_status')
    
    def return_status(self, soldProduct:SoldProduct):
        unathorised_return_inwards_list = soldProduct.return_inwards.filter(is_authorized=False)
        if len(unathorised_return_inwards_list) > 0:
            unauthorised_return_id = unathorised_return_inwards_list[0].id
            return {"status":False, "unauthorised_return_id":unauthorised_return_id}
        else:
            return {"status":True, "unauthorised_return_id":None}


class SaleSerializer(serializers.ModelSerializer):
    date = serializers.DateTimeField(format='%A %Y-%m-%d %H:%M')
    class Meta:
        model = Sale
        fields = ['id','customer_name','phone_number', 'description', 'total_quantity_sold', 'date', 'sale_revenue']
        read_only_fields = ['total_quantity_sold', 'sale_revenue']
      

class DailySalesSerializer(serializers.ModelSerializer):
    class Meta:
        model = DailySales
        fields = ['id','date','total_sales_revenue_on_day','total_quantity_sold_on_day']

class ReturnInwardsSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReturnInwards
        fields = ['id','sold_product','date','quantity_returned','return_reason','is_authorized','authorized_by']