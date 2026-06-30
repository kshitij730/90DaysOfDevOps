# Stage 1
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Stage 2
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /usr/local /usr/local

COPY . .

RUN useradd -m flaskuser

USER flaskuser

EXPOSE 5000

CMD ["python","app.py"]
