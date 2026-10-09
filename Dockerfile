# Python base image
FROM python:3.11-slim

# ffmpeg is needed by pydub for audio files
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# No sound card in a container; stop pygame from crashing if it initializes audio
ENV SDL_AUDIODRIVER=dummy
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first so Docker can cache this layer
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application files
COPY . .

# Flask application port
EXPOSE 5000

# Run the Flask app (python app.py so auto_load_data() runs)
CMD ["python", "app.py"]