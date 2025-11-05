# Use Python 3.9 as the base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire 'staffleave/slms' directory into '/app' inside the container
COPY staffleave/slms /app/slms

# Expose port 8000 to access the Django app
EXPOSE 8000

# Set environment variable for Django
ENV PYTHONUNBUFFERED 1

# Run Django development server, pointing to the correct path for manage.py
CMD ["python", "/app/slms/manage.py", "runserver", "0.0.0.0:8000"]
