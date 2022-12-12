from djoser.serializers import UserCreateSerializer as BaseUserCreateSerializer
from djoser.serializers import UserSerializer as BaseUserSerializer
from django.contrib.auth.models import Group, User
from rest_framework import serializers

class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = ['name']

class UserCreateSerializer(BaseUserCreateSerializer):
    groups = GroupSerializer(many=True)

    class Meta(BaseUserCreateSerializer.Meta):
        fields = ['id', 'username', 'password', 'email', 'first_name', 'last_name', 'groups']

    def create(self, validated_data):
        groups_data = validated_data.pop('groups')
        user = User.objects.create(**validated_data)
        for group_data in groups_data:
            group = Group.objects.get(name=group_data['name'])
            # user.groups.add(group)
            user.groups.set([group])
            user.save()
        return user


class UserSerializer(BaseUserSerializer):
    class Meta(BaseUserSerializer.Meta):
        fields = ['__all__']