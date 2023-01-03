from django.contrib import admin
from .models import *
# Register your models here.
admin.site.register(UserAccount)
@admin.register(UserActivity)
class UserActivityAdmin(admin.ModelAdmin):
    list_display = ('user','user_group','method','timestamp')
    list_filter = ('user', 'method', 'timestamp')
    search_fields = ('user__username', 'path', 'table')
    date_hierarchy = 'timestamp'