import json
import os
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


def analyze_with_ai(incident):
    prompt = f"""
You are a Senior Site Reliability Engineer.

Analyze the Kubernetes incident below.

Incident:
{json.dumps(incident, indent=2)}

Return ONLY a valid JSON object.

Do not include:
- Markdown
- Triple backticks
- Explanations
- Introductory text

The JSON schema is:

{{
  "root_cause": "<string>",
  "confidence": "<low|medium|high>",
  "recommendation": [
    "<recommendation1>",
    "<recommendation2>"
  ]
}}
"""
    try:
        response = client.responses.create(
            model="gpt-5",
            input=prompt
        )

        output = response.output_text.strip()
        return json.loads(output)
    except Exception as e:
        return {
            "root_cause": "AI analysis failed",
            "confidence": "low",
            "recommendation": [str(e)]
        }