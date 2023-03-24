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
            if validated_data["user_type"] == "":
                user.save()
            return user


    def update(self, instance, validated_data):
        # handling form submitted  with no password update
        if validated_data['password'] == "Machafu2023":
            validated_data.pop('password')
        else:
            instance.set_password(validated_data['password'])
            validated_data.pop('password')

        user = User.objects.get(id = instance.id)
        if validated_data["user_type"] == 1:
            user.groups.set([1])
            user.save()
        if validated_data["user_type"] == 2:
            user.groups.set([2])
            user.save()
        if validated_data["user_type"] == "":
            user.save()
        return super().update(instance, validated_data)

class UserSerializer(UserSerializer):
    """
    displays current logged in user details
    """
    class Meta(UserSerializer.Meta):
        Model = User  
        fields = ['id', 'first_name','last_name','phone_number','user_type']  
