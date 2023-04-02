from django.contrib import admin, messages
from django.db.models.aggregates import Count
from django.db.models.query import QuerySet
from django.utils.html import format_html, urlencode
from django.urls import reverse
from . import models


# Register your models here.
@admin.register(models.SoldProduct)
class SoldProductAdmin(admin.ModelAdmin):
    list_display = ['product','quantity','sale']

@admin.register(models.Sale)
class SaleAdmin(admin.ModelAdmin):
    list_display = ['date','customer_name','total_quantity_sold','sale_revenue']


@admin.register(models.DailySales)
class DailySalesAdmin(admin.ModelAdmin):
    list_display = ['date','total_sales_revenue_on_day','total_quantity_sold_on_day']