# Generated by Django 4.1.3 on 2022-12-21 04:38

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('store', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='product',
            name='promotions',
        ),
    ]
