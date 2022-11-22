from django.urls import path
from django.urls.conf import include
from rest_framework_nested import routers
from . import views

router = routers.DefaultRouter()
router.register('tona_users', views.TonaUserViewSet, basename='tona_users')

# URLConf
urlpatterns = router.urls
