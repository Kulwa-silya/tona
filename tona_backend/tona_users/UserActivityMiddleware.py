from .models import UserActivity
from django.utils import timezone
from django.contrib.auth import get_user_model

import jwt

class UserActivityMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Code to be executed for each request before the view (and later middleware) are called.
        if request.META.get('HTTP_AUTHORIZATION', None):
        
            TOKEN = request.META.get('HTTP_AUTHORIZATION', None).split()[-1]
            TOKEN_DICT = jwt.decode(TOKEN, options={"verify_signature": False})

            User = get_user_model()
            user = User.objects.get(id=TOKEN_DICT['user_id'])

            # check whether user has group, if not set to none 
            user_group = user.groups.first() if user.groups.exists() else None
            if user_group is None:
                # Handle the case where the user's groups attribute is empty simply return the response.
                return self.get_response(request)
            tracked_groups = ['sales','deliver']

            # clean querydict post data
            data = {k: v for k, v in request.POST.dict().items() if k != 'csrfmiddlewaretoken'}

            # Log the user's activity
            if TOKEN_DICT['token_type'] == 'access' and request.method != 'GET' and any(g == user_group.name for g in tracked_groups):
                user_activity = UserActivity(
                    user= user,
                    user_group = user_group,
                    path=request.path,
                    method=request.method,
                    form_data=data,
                    timestamp=timezone.now()
                )
                user_activity.save()

        response = self.get_response(request)

        # Code to be executed for each request/response after
        # the view is called.

        return response
