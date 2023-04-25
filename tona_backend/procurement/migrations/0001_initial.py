# Generated by Django 4.1.3 on 2023-04-20 07:48

from django.conf import settings
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion
import store.validators


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ("store", "0010_remove_soldproduct_customer_and_more"),
    ]

    operations = [
        migrations.CreateModel(
            name="Purchase",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("date", models.DateField()),
                ("total_amount", models.DecimalField(decimal_places=2, max_digits=10)),
                (
                    "payment_method",
                    models.CharField(
                        choices=[("CA", "cash"), ("CR", "credit"), ("CH", "check")],
                        default="CA",
                        max_length=255,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Supplier",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("address", models.CharField(max_length=255)),
                (
                    "user",
                    models.OneToOneField(
                        null=True,
                        on_delete=django.db.models.deletion.CASCADE,
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Receipt",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "image",
                    models.ImageField(
                        upload_to="store/receipts",
                        validators=[store.validators.validate_file_size],
                    ),
                ),
                (
                    "purchase",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="receipt",
                        to="procurement.purchase",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="PurchasedProduct",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("date", models.DateField()),
                ("unit_price", models.DecimalField(decimal_places=2, max_digits=10)),
                (
                    "quantity",
                    models.IntegerField(
                        default="1",
                        validators=[django.core.validators.MinValueValidator(1)],
                    ),
                ),
                (
                    "product",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="productPurchased",
                        to="store.product",
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="purchase",
            name="purchased_products",
            field=models.ManyToManyField(
                related_name="purchasedproduct", to="procurement.purchasedproduct"
            ),
        ),
        migrations.AddField(
            model_name="purchase",
            name="supplier",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="supplier",
                to="procurement.supplier",
            ),
        ),
        migrations.CreateModel(
            name="AssociatedCost",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=255)),
                ("amount", models.DecimalField(decimal_places=2, max_digits=10)),
                (
                    "purchase",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="purchase",
                        to="procurement.purchase",
                    ),
                ),
            ],
        ),
    ]
