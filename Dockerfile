# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY . /app/

# Expose port 8000 to access the Django app
EXPOSE 8000

# Set environment variable for Django
ENV PYTHONUNBUFFERED 1

# Run Django development server (for local development)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
