from django.contrib.auth import get_user_model
from rest_framework import viewsets, status
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response
from tona_users.serializers import UserSerializer

class UserViewSet(viewsets.ModelViewSet):
    http_method_names = ['delete']

    queryset = get_user_model().objects.all()
    permission_classes = (IsAdminUser,)
    serializer_class = UserSerializer
    

    def destroy(self, request, *args, **kwargs):
        print("called")
        user = self.get_object()
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
