from django.db.models.signals import post_save
from django.dispatch import receiver
from sales.models import Sale, DailySales

@receiver(post_save, sender=Sale)
def update_dailysales(sender, instance, **kwargs):
    # get the date for the current Sale instance
    sale_date = instance.date.date()

    # get or create the Dailysales instance for this date
    dailysales, created = DailySales.objects.get_or_create(date=sale_date)

    # update the Dailysales instance with the new sale_revenue value
    dailysales.calc_total_sales_revenue_on_day()
    # dailysales.save()