from rest_framework import serializers
from .models import *
from tona_users.serializers import *


class SupplierSerializer(serializers.ModelSerializer):
    # user_id = serializers.IntegerField(read_only=True)
    # user = UserSerializer()

    class Meta:
        model = Supplier
        fields = ('__all__')
        # fields = ['id', 'address',  'user']


class PurchasedProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = PurchasedProduct
        fields = ('__all__')


class PurchaseSerializer(serializers.ModelSerializer):
    # total_amount = serializers.IntegerField(read_only=True)
    supplier = SupplierSerializer()
    purchased_products = PurchasedProductSerializer(many=True)

    class Meta:
        model = Purchase
        fields = ['id', 'date', 'total_amount',
                  'payment_method', 'supplier', 'purchased_products']

    def create(self, validated_data):
        # Remove/Pop supplier and purchased_products_data from dict called validated_data
        supplier_data = validated_data.pop('supplier')
        purchased_products_data = validated_data.pop(
            'purchased_products')
        # create purchase object
        purchase = Purchase.objects.create(**validated_data)
        # # create supplier instance / object
        supplier = Supplier.objects.create(
            full_name=supplier_data['full_name'], address=supplier_data['address'], phone_number=supplier_data['phone_number'])
        # for data in supplier_data:
        #     # create purchased product instance
        #     supplier = Supplier.objects.create(
        #         full_name=data['full_name'], address=data['address'], phone_number=data['phone_number'])
        #     print("supplier", supplier)

        # assign supplier instance to the purchase instance
        purchase.supplier = supplier
        # create purchase instance
        print('my data==>', purchased_products_data)

        total_amount = []

        for product_data in purchased_products_data:
            print('mimi ni bidhaa', product_data,
                  'bei yangu ni ', product_data['unit_price'], 'ila jumla yetu ni ')
            # add price of each product in total_amount list
            total_amount.append(
                product_data['unit_price']*product_data['quantity'])
            # create purchased product instance
            purchased_product = PurchasedProduct.objects.create(
                unit_price=product_data['unit_price'], quantity=product_data['quantity'], product=product_data['product'])
            purchase.purchased_products.add(purchased_product)
        # assign total amount to the given purchase
        purchase.total_amount = sum(total_amount)
        print('jumla ni', total_amount)

        purchase.save()
        print("purchase", purchase)
        return purchase


class AssociatedCostSerializer(serializers.ModelSerializer):
    class Meta:
        model = AssociatedCost
        fields = ('__all__')


class ReceiptSerializer(serializers.ModelSerializer):
    class Meta:
        model = Receipt
        fields = ('__all__')
