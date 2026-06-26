from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    return f"""
    <h1>Day 34 Docker Compose</h1>
    <h2>Flask + PostgreSQL + Redis</h2>
    <p>Database Host: {os.getenv("DB_HOST")}</p>
    <p>Redis Host: {os.getenv("REDIS_HOST")}</p>
    """

app.run(host="0.0.0.0", port=5000)