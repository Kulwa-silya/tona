from django.urls import path
from .views import some_view

urlpatterns = [
    path('generate-pdf/', some_view, name='generate-pdf'),
]
