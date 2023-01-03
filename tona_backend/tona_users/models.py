from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.contrib.auth import get_user_model

from phonenumber_field.modelfields import PhoneNumberField
# Create your models here.

class UserManager(BaseUserManager):
    def create_user(self,first_name,last_name,phone_number,user_type,password=None):
        """
        create and saves new normal user with given credentials
        """
        if not phone_number:
            raise ValueError("User must have phone number")
            
        user = self.model(first_name=first_name,
                          last_name=last_name,
                          phone_number=phone_number,
                          user_type=user_type)
        user.set_password(password)
        user.save()

        return user

    def create_superuser(self,first_name,last_name,phone_number,password):
        """
        create and saves new super user with given credentials
        """
        user = self.create_user(first_name,last_name,phone_number,password)
        user.is_superuser = True
        user.is_staff = True
        user.save()

class UserAccount(AbstractBaseUser,PermissionsMixin):

    USER_TYPES = ((1,"Sales"),(2,"Delivery"))
    first_name = models.CharField(verbose_name="first name" , max_length=100)
    last_name = models.CharField(verbose_name="last name", max_length=100)
    
    phone_number = PhoneNumberField(verbose_name="phone number", unique=True)
    user_type = models.IntegerField(choices=USER_TYPES,null=True,blank=True)

    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = "phone_number"
    REQUIRED_FIELDS = ["first_name","last_name"]

    def get_full_name(self):
        return f"{self.first_name} {self.last_name}"
    
    def get_short_name(self):
        return self.first_name

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

User = get_user_model()

class UserActivity(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    user_group = models.CharField(max_length=255,blank=True,null=True)
    path = models.CharField(max_length=255)
    method = models.CharField(max_length=10)
    form_data = models.TextField(blank=True, null=True)
    table = models.CharField(max_length=255,blank=True,null=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    