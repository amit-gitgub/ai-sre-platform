import requests
print("Script started")
for i in range(10):
    response = requests.get("http://localhost:5000/payment")
    print(response.status_code)
    print(response)

