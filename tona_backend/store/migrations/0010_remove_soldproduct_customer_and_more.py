# Generated by Django 4.1.3 on 2023-03-30 14:52

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('store', '0009_remove_purchase_purchased_products_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='soldproduct',
            name='customer',
        ),
        migrations.RemoveField(
            model_name='soldproduct',
            name='product',
        ),
        migrations.DeleteModel(
            name='Sale',
        ),
        migrations.DeleteModel(
            name='SoldProduct',
        ),
    ]
