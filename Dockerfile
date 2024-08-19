
FROM python:3.10.8-slim-buster

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-dev ffmpeg aria2 python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up the application
COPY . /app/
WORKDIR /app/

# Create and activate a virtual environment
RUN python3 -m venv /app/venv

# Install Python dependencies in the virtual environment
RUN /app/venv/bin/pip install --no-cache-dir --upgrade -r Installer

# Set environment variables for the virtual environment
ENV PATH="/app/venv/bin:$PATH"

# Run the application using gunicorn and Python script
CMD gunicorn app:app & python3 modules/main.py
