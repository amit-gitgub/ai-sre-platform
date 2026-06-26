import json
import os, uuid
from flask import Flask, request, jsonify
from ai_rca import analyze_with_ai


def analyse_incident(incident):
    logs = str(incident.get("alert", "")).lower()
    
    if "timeout" in logs:
        return {
        "root_cause" : "Backend timeout",
        "recommendation" : "Check downsteam service latency",
        "confidence" :"high"
        }
    elif "oomkilled" in logs:
        return {
        "root_cause" : "Memory exhaustion",
        "recommendation" : ["Increase pod memery","check for memory leaks"],
        "confidence" :"high"
        }
    elif "connection refused" in logs:
        return {
        "root_cause" : "Dependency service unavailable",
        "recommendation" : ["verify service status", "check kubernetes service endpoint"],
        "confidence" :"high"
        }
    
    print("No rule matched, now using the AI for RCA")
    
    return analyze_with_ai(incident)

