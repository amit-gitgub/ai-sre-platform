from flask import Flask, request, jsonify
from kubernetes import client, config
from rca_engine import analyse_incident
import json, os, uuid


app = Flask(__name__)

config.load_kube_config()
v1 = client.CoreV1Api()

@app.route("/alerts" , methods=["POST"])
def alerts():
    data = request.json
    incident_id = str(uuid.uuid4())
    pods = v1.list_namespaced_pod(
        namespace="ai-sre"
    )

    pods_name = []
    pods_logs = {}
    for pod in pods.items:
        pod_name = pod.metadata.name
        pods_name.append(pod_name)
        
        pod_log = v1.read_namespaced_pod_log(
            name=pod_name,
            namespace="ai-sre",
            tail_lines = 20,
            pretty = True
            
        )
        pods_logs[pod_name] = pod_log
    print(data)
    print(type(data))
    
    incident = {
        "incident_id": incident_id,
        "alert": str(data),
        "pods_name": pods_name,
        "logs": pods_logs

    }

    rca_result= analyse_incident(incident)
    incident["rca"] = rca_result
    

    #print(incident)
    os.makedirs(
        name="incidents",
        exist_ok=True
    )
    file_name = f"incidents/{incident_id}.json"

    with open(
        file_name, "w"
    ) as file:
        json.dump(
            incident,
            file,
            indent=4
        )

    print(f"Incidents Saved : {file_name}")

    return jsonify(
        {"status": "received",
         "incident_id": incident_id}

    )



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)