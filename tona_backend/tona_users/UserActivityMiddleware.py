from .models import UserActivity
from django.utils import timezone

class UserActivityMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Code to be executed for each request before
        # the view (and later middleware) are called.

        # Log the user's activity
        print(request.META.get('HTTP_AUTHORIZATION', None))
        if request.user.is_authenticated:
            user_activity = UserActivity(
                user=request.user,
                path=request.path,
                method=request.method,
                form_data=request.POST,
                query_params=request.GET,
                timestamp=timezone.now()
            )
            user_activity.save()

        response = self.get_response(request)

        # Code to be executed for each request/response after
        # the view is called.

        return response
