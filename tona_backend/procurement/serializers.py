from rest_framework import serializers
from .models import *
from tona_users.serializers import *


class SupplierSerializer(serializers.ModelSerializer):
    # user_id = serializers.IntegerField(read_only=True)
    user = UserSerializer()

    class Meta:
        model = Supplier
        # fields = ('__all__')
        fields = ['id', 'address',  'user']


class PurchasedProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = PurchasedProduct
        fields = ('__all__')


class PurchaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Purchase
        fields = ('__all__')

    def create(self, validated_data):
        purchased_products_data = validated_data.pop('purchased_products')
        purchase = Purchase.objects.create(**validated_data)
        print('my data==>', purchased_products_data)
        total_amount = []

        for product_data in purchased_products_data:
            print('mimi ni bidhaa', product_data,
                  'bei yangu ni ', product_data.unit_price, 'ila jumla yetu ni ')
            # add price of each product in list
            total_amount.append(product_data.unit_price*product_data.quantity)
            purchased_product = PurchasedProduct.objects.get(
                id=product_data.id)
            # assign total amount to the given purchase
            purchase.total_amount = sum(total_amount)
            purchase.purchased_products.add(purchased_product)

        return purchase


class AssociatedCostSerializer(serializers.ModelSerializer):
    class Meta:
        model = AssociatedCost
        fields = ('__all__')


class ReceiptSerializer(serializers.ModelSerializer):
    class Meta:
        model = Receipt
        fields = ('__all__')
