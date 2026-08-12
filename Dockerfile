FROM python:3.11-slim

WORKDIR /app

COPY requirements-lock.txt .

RUN pip install --no-cache-dir --require-hashes --only-binary=:all: -r requirements-lock.txt \
    && useradd --create-home appuser

COPY main.py .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
