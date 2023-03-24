# Generated by Django 4.1.3 on 2023-03-23 14:53

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('store', '0005_rename_cost_amount_associatedcost_amount_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='soldproduct',
            name='unit_price',
        ),
        migrations.AlterField(
            model_name='sale',
            name='date',
            field=models.DateField(auto_now=True),
        ),
        migrations.AlterField(
            model_name='soldproduct',
            name='date',
            field=models.DateField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='soldproduct',
            name='quantity',
            field=models.IntegerField(validators=[django.core.validators.MinValueValidator(1)]),
        ),
    ]