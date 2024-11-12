# Use the official Python image with a slim version of Debian Buster
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies for LaTeX to PDF conversion
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry

# Copy only the dependency files first for caching
COPY pyproject.toml poetry.lock ./

# Install Python dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Copy the rest of the application code
COPY . .

# Set environment variables if needed
# ENV API_KEY=your_api_key

# Command to run your application
# CMD ["python", "main.py", \
#      "--url", "JOB_POSTING_URL", \
#      "--master_data", "JSON_USER_MASTER_DATA", \
#      "--api_key", "YOUR_LLM_PROVIDER_API_KEY", \
#      "--downloads_dir", "DOWNLOAD_LOCATION_FOR_RESUME_CV", \
#      "--provider", "openai"]
CMD ["python", "web_app.py"]
