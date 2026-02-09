import json
import datetime

def handler(event, context):
    path = event.get("rawPath", "/")
    now = datetime.datetime.utcnow().isoformat() + "Z"

    if path == "/status":
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "ai_enabled": True,
                "kill_switch_active": False,
                "guardrails_active": True,
                "environment": "dev",
                "last_updated_utc": now
            })
        }

    if path == "/audit":
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "audit": [
                    {
                        "event_time": now,
                        "actor": "harry-local-cli",
                        "action": "AI ENABLED",
                        "source_ip": event.get("requestContext", {})
                                       .get("http", {})
                                       .get("sourceIp", "unknown")
                    }
                ],
                "last_updated_utc": now
            })
        }

    return {
        "statusCode": 404,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"message": "Not Found"})
    }
