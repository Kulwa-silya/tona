from django.contrib import admin, messages
from django.db.models.aggregates import Count
from django.db.models.query import QuerySet
from django.utils.html import format_html, urlencode
from django.urls import reverse
from . import models


# Register your models here.
@admin.register(models.SoldProduct)
class SoldProductAdmin(admin.ModelAdmin):
    list_display = ['product','quantity','date']

@admin.register(models.Sale)
class SaleAdmin(admin.ModelAdmin):
    list_display = ['date','total_amount']