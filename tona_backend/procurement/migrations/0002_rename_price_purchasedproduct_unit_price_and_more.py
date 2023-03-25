# Generated by Django 4.1.3 on 2023-03-25 09:14

import django.core.validators
from django.db import migrations, models
import django.db.models.deletion
import store.validators


class Migration(migrations.Migration):

    dependencies = [
        ('procurement', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='purchasedproduct',
            old_name='price',
            new_name='unit_price',
        ),
        migrations.AddField(
            model_name='purchase',
            name='payment_method',
            field=models.CharField(choices=[('CA', 'cash'), ('CR', 'credit'), ('CH', 'check')], default='CA', max_length=255),
        ),
        migrations.AddField(
            model_name='purchasedproduct',
            name='quantity',
            field=models.IntegerField(default='1', validators=[django.core.validators.MinValueValidator(1)]),
        ),
        migrations.CreateModel(
            name='Receipt',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ImageField(upload_to='store/receipts', validators=[store.validators.validate_file_size])),
                ('purchase', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='receipt', to='procurement.purchase')),
            ],
        ),
    ]
