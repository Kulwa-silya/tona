from django.urls import path
from django.urls.conf import include
from rest_framework_nested import routers
from . import views

router = routers.DefaultRouter()
router.register('supplier', views.SupplierViewSet, basename='supplier')
router.register('purchase', views.PurchaseViewSet, basename='purchase')
router.register('purchasedproduct', views.PurchasedProductViewSet, basename='purchasedproduct')
router.register('receipt', views.ReceiptViewSet, basename='receipt')
router.register('associatedcost', views.AssociatedCostViewSet, basename='associatedcost')
router.register('dailypurchases', views.DailyPurchaseTotalViewSet, basename='dailypurchases')

urlpatterns = router.urls