# views.py

from django.shortcuts import render

def FIRSTPAGE(request):
    return render(request, 'slms/templates/firstpage.html')  # Ensure it's 'firstpage.html' and not 'staff/firstpage.html'
