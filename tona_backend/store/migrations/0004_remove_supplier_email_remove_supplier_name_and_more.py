# Generated by Django 4.1.3 on 2023-01-26 16:36

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ("store", "0003_supplier_soldproduct_sale_purchasedproduct_purchase_and_more"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="supplier",
            name="email",
        ),
        migrations.RemoveField(
            model_name="supplier",
            name="name",
        ),
        migrations.RemoveField(
            model_name="supplier",
            name="phone",
        ),
        migrations.AddField(
            model_name="supplier",
            name="user",
            field=models.OneToOneField(
                null=True,
                on_delete=django.db.models.deletion.CASCADE,
                to=settings.AUTH_USER_MODEL,
            ),
        ),
    ]
