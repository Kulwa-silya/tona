from django_filters.rest_framework import DjangoFilterBackend
import jwt
# from django.contrib.auth.mixins import UserPassesTestMixin
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework.permissions import AllowAny, DjangoModelPermissions, DjangoModelPermissionsOrAnonReadOnly, IsAdminUser, IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from rest_framework import status
from .filters import SoldProductFilter, SaleFilter, DailySalesFilter
from .models import *


from .serializers import *
# Create your views here.


class SoldProductViewSet(ModelViewSet):
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']

    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = SoldProductFilter
    search_fields = ['product', 'customer']
    queryset = SoldProduct.objects.prefetch_related('product').all()
    serializer_class = SoldProductSerializer

    def get_permissions(self):
        if self.request.method in ['PATCH', 'DELETE']:
            return [IsAdminUser()]
        return [IsAuthenticated()]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Create a SoldProduct instance based on the serializer data
        sold_product = SoldProduct(**serializer.validated_data)

        # Call the save method to handle the sale
        try:
            sold_product.save()
        except ValueError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

        # Serialize the saved SoldProduct instance and return it in the response
        response_serializer = self.get_serializer(sold_product)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)
    
    def destroy(self, request, *args, **kwargs):
        sold_product = self.get_object()
        sold_product.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
    def partial_update(self, request, *args, **kwargs):
        # Get the SoldProduct instance to be updated
        instance = self.get_object()

        # Serialize the request data and validate it
        serializer = self.get_serializer(instance, data=request.data ,partial=True)
        serializer.is_valid(raise_exception=True)

        print('data from user',serializer.validated_data)
        # Call the update method to update the instance
        try:
            instance.update_sold_product(self,validated_data=serializer.validated_data)
        except ValueError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

        # Serialize the updated SoldProduct instance and return it in the response
        response_serializer = self.get_serializer(instance)
        # print("response_serializer", response_serializer.data)
        return Response(response_serializer.data)
 
class SaleViewSet(ModelViewSet):
    http_method_names = ['get','post', 'patch', 'delete', 'head', 'options']

    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = SaleFilter
    search_fields = ['date', 'customer_name','description','phone_number']

    queryset = Sale.objects.prefetch_related('sold_products').all()
    serializer_class = SaleSerializer

    def destroy(self, request, *args, **kwargs):
        sale = self.get_object()
        try:
            sale.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except ValidationError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    def get_permissions(self):
        if self.request.method in ['PATCH', 'DELETE']:
            return [IsAdminUser()]
        return [IsAuthenticated()]
    

class DailySalesViewSet(ModelViewSet):
    http_method_names = ['get','head', 'options']
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = DailySalesFilter
    search_fields = ['date']
    queryset = DailySales.objects.all()
    serializer_class = DailySalesSerializer

class ReturnInwardsViewSet(ModelViewSet):
    http_method_names = ['get','patch','head', 'options']
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    search_fields = ['date','return_reason']
    queryset = ReturnInwards.objects.prefetch_related('sold_product').all()
    serializer_class = ReturnInwardsSerializer

    def partial_update(self, request, *args, **kwargs):
        # Get the ReturnInwards instance to be updated
        instance = self.get_object()

        TOKEN = request.META.get('HTTP_AUTHORIZATION', None).split()[-1]
        TOKEN_DICT = jwt.decode(TOKEN, options={"verify_signature": False})


        # Serialize the request data and validate it
        serializer = self.get_serializer(instance, data=request.data ,partial=True)
        serializer.is_valid(raise_exception=True)

        print(type(TOKEN_DICT['user_id']))
        print('data from user',serializer.validated_data)
        # Call the update method to update the instance
        try:
            instance.authorize_return(user_id=TOKEN_DICT['user_id'])
        except ValueError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        except PermissionError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

        # Serialize the updated ReturnInwards instance and return it in the response
        response_serializer = self.get_serializer(instance)
        # print("response_serializer", response_serializer.data)
        return Response(response_serializer.data)