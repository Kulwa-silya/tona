from django.contrib.auth.password_validation import MinimumLengthValidator

class CustomMinimumLengthValidator(MinimumLengthValidator):
    def __init__(self, min_length=5):
        super().__init__(min_length=min_length)
