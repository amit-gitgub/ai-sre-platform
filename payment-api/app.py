from flask import Flask
from prometheus_client import Counter
from prometheus_client import generate_latest
from prometheus_client import CONTENT_TYPE_LATEST
import random
import os
import time

app = Flask(__name__)

payment_requests_total = Counter('payment_requests_total', 'Total payment requests')


@app.route("/")
def health():
    return {
        "status": "healthy",
        "hostname": os.uname().nodename
    }

@app.route("/payment")
def payment():
    payment_requests_total.inc()
    if random.randint(1,10) > 7:
        return {
            "status":"failed"
        },500

    return {
        "status":"success"
    }

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {
        'Content-Type' : CONTENT_TYPE_LATEST
    }

@app.route("/slow-payment")
def slow_payment():
    time.sleep(5)
    return{
        "status": "success"
    }

@app.route("/cpu")
def cpu():
    result = 0
    for i in range(1000000):
        result +=i
    return{"ststus" : "done"}

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )