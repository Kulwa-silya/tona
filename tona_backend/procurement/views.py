from django.shortcuts import render
from django.db.models.aggregates import Count
from django.shortcuts import get_object_or_404
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.decorators import action, permission_classes
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework.permissions import AllowAny, DjangoModelPermissions, DjangoModelPermissionsOrAnonReadOnly, IsAdminUser, IsAuthenticated
from rest_framework.viewsets import ModelViewSet
from rest_framework import viewsets 
from rest_framework.response import Response
from rest_framework import status
from .serializers import *
from .models import *
from store.models import Product
from .filters import *
# Create your views here.


class SupplierViewSet(ModelViewSet):
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']

    filterset_class = SupplierFilter
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]

    permission_classes = [DjangoModelPermissions]

    queryset = Supplier.objects.all()
    serializer_class = SupplierSerializer


class PurchaseViewSet(ModelViewSet):
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']

    filterset_class = PurchaseFilter
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]

    permission_classes = [DjangoModelPermissions]

    queryset = Purchase.objects.all()
    serializer_class = PurchaseSerializer


    def destroy(self, request, *args, **kwargs):
        purchase = self.get_object()
        try:
            purchase.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except ValidationError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    def get_permissions(self):
        if self.request.method in ['PATCH', 'DELETE']:
            return [IsAdminUser()]
        return [IsAuthenticated()]


class AssociatedCostViewSet(ModelViewSet):
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']

    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    permission_classes = [DjangoModelPermissions]
    queryset = AssociatedCost.objects.all()
    serializer_class = AssociatedCostSerializer

    # def get_permissions(self):
    #     if self.request.method in ['PATCH', 'DELETE']:
    #         return [IsAdminUser()]
    #     return [IsAuthenticated()]


class PurchasedProductViewSet(ModelViewSet):
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']
    filterset_class = PurchasedProductFilter
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    permission_classes = [DjangoModelPermissions]
    queryset = PurchasedProduct.objects.all()
    serializer_class = PurchasedProductSerializer


class ReceiptViewSet(ModelViewSet):
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']

    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = ReceiptFilter

    permission_classes = [DjangoModelPermissions]
    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer


class DailyPurchaseTotalViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = DailyPurchaseTotal.objects.all()
    serializer_class = DailyPurchaseTotalSerializer