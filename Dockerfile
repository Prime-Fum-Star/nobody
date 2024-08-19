FROM python:3.10.8-slim-buster

# Install system dependencies
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-dev ffmpeg aria2 python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the application files
COPY . /app/
WORKDIR /app/

# Create a virtual environment
RUN python3 -m venv venv

# Activate the virtual environment and install dependencies
RUN . /app/venv/bin/activate && pip install --no-cache-dir --upgrade -r Installer

# Set environment variable to use the virtual environment's Python and pip
ENV PATH="/app/venv/bin:$PATH"

# Run the application
CMD gunicorn app:app & python3 modules/main.py
