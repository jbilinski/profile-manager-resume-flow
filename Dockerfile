# Use the official Python image with a slim version of Debian Buster
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Set the DEBIAN_FRONTEND to noninteractive to prevent debconf warnings
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies for LaTeX to PDF conversion
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    libnss3 \
    libnspr4 \
    libdbus-1-3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libasound2 \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry

# Copy only the dependency files first for caching
COPY pyproject.toml poetry.lock ./

# Install Python dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Install Playwright
RUN playwright install \
    && playwright install-deps

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
CMD ["streamlit", "run", "web_app.py"]
