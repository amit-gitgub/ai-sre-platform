from flask import Flask
import random
import os
import time

app = Flask(__name__)

@app.route("/")
def health():
    return {
        "status": "healthy",
        "hostname": os.uname().nodename
    }

@app.route("/payment")
def payment():

    if random.randint(1,10) > 7:
        return {
            "status":"failed"
        },500

    return {
        "status":"success"
    }

@app.route("/slow-payment")
def slow_payment():
    time.sleep(5)
    return{
        "status": "success"
    }


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )