from django.urls import path
from django.urls.conf import include
from rest_framework_nested import routers
from . import views

router = routers.DefaultRouter()
router.register('soldproduct',views.SoldProductViewSet,basename='soldproduct')
router.register('sale', views.SaleViewSet, basename='sale')
router.register('dailysales', views.DailySalesViewSet, basename='dailysales')
router.register('return_inwards', views.ReturnInwardsViewSet, basename='return_inwards')

urlpatterns = router.urls 