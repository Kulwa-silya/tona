# Generated by Django 4.1.3 on 2023-01-03 17:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tona_users', '0004_rename_query_params_useractivity_user_group'),
    ]

    operations = [
        migrations.AlterField(
            model_name='useractivity',
            name='user_group',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]
