# Generated by Django 4.1.3 on 2023-04-20 08:02

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ("procurement", "0001_initial"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="purchase",
            name="supplier",
        ),
        migrations.AddField(
            model_name="purchasedproduct",
            name="supplier",
            field=models.ForeignKey(
                default=1,
                on_delete=django.db.models.deletion.CASCADE,
                related_name="supplier",
                to="procurement.supplier",
            ),
        ),
        migrations.AlterField(
            model_name="purchasedproduct",
            name="date",
            field=models.DateField(null=True),
        ),
    ]