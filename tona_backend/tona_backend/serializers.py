from djoser.serializers import UserCreateSerializer as BaseUserCreateSerializer
from djoser.serializers import UserSerializer
from django.contrib.auth import get_user_model
from django.db import transaction

User = get_user_model()


class UserCreateSerializer(BaseUserCreateSerializer):
    class Meta(BaseUserCreateSerializer.Meta):
        Model = User
        fields = ['id', 'first_name','last_name','phone_number','password','user_type']

    def create(self, validated_data):
        with transaction.atomic():
            user = User.objects.create_user(**validated_data)
            if validated_data["user_type"] == 1:
                user.groups.set([1])
                user.save()
            if validated_data["user_type"] == 2:
                user.groups.set([2])
                user.save()
            else:
                user.save()
            return user

class UserSerializer(UserSerializer):
    """
    displays current logged in user details
    """
    class Meta(UserSerializer.Meta):
        Model = User  
        fields = ['id', 'first_name','last_name','phone_number','user_type']    