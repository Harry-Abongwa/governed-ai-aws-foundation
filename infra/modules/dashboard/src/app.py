import json
import os
from datetime import datetime, timezone

PROJECT = os.getenv("PROJECT", "governed-ai-foundation")
ENV = os.getenv("ENV", "dev")

def log(event_type, payload):
    print(json.dumps({
        "ts": datetime.now(timezone.utc).isoformat(),
        "project": PROJECT,
        "env": ENV,
        "event_type": event_type,
        "payload": payload
    }))

def response(body, status=200):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
            "Access-Control-Allow-Headers": "*"
        },
        "body": json.dumps(body)
    }

def governance_block():
    return {
        "policy_enforcement": {
            "iam_guardrails": True,
            "network_restricted": True,
            "data_exfil_blocked": True
        },
        "risk_posture": {
            "model_access": "restricted",
            "internet_egress": "controlled",
            "human_override_required": True
        },
        "controls": {
            "kill_switch_present": True,
            "budget_enforced": True,
            "audit_logging": True
        }
    }

def audit_log(action, source_ip, details=None):
    event = {
        "event_time": datetime.now(timezone.utc).isoformat(),
        "actor": "api-user",
        "action": action,
        "source_ip": source_ip,
        "details": details or {}
    }
    emit_metric("AuditRead"); log("AUDIT_EVENT", event)
    return event

def handler(event, context):
    route = event.get("requestContext", {}).get("routeKey", "")
    source_ip = event.get("requestContext", {}).get("http", {}).get("sourceIp", "unknown")

    if route == "GET /status":
        emit_metric("StatusRead"); log("STATUS_READ", source_ip)

        return response({
            "project": PROJECT,
            "environment": ENV,
            "ai_enabled": True,
            "kill_switch_active": False,
            "guardrails_active": True,
            "governance": governance_block(),
            "last_updated_utc": datetime.now(timezone.utc).isoformat()
        })

    if route == "GET /governance":
        emit_metric("GovernanceRead"); log("GOVERNANCE_READ", source_ip)

        return response({
            "governance": governance_block(),
            "checked_at": datetime.now(timezone.utc).isoformat()
        })



    # AUDIT PANEL
    if route == "GET /audit":
        emit_metric("AuditRead")
        event = {
            "event_time": datetime.now(timezone.utc).isoformat(),
            "actor": "api-user",
            "action": "AUDIT_READ",
            "source_ip": source_ip
        }
        log("AUDIT_EVENT", event)
        return response({
            "audit": [event],
            "count": 1
        })

    log("DEFAULT_ROUTE", {"route": route, "source_ip": source_ip})
    return response({
        "service": "governed-ai-dashboard",
        "routes": ["/status", "/governance", "/audit"]
    })


def emit_metric(name, value=1, unit="Count"):
    print(json.dumps({
        "_aws": {
            "Timestamp": int(datetime.now(timezone.utc).timestamp() * 1000),
            "CloudWatchMetrics": [{
                "Namespace": "GovernedAI",
                "Dimensions": [["Project", "Environment"]],
                "Metrics": [{
                    "Name": name,
                    "Unit": unit
                }]
            }]
        },
        "Project": PROJECT,
        "Environment": ENV,
        name: value
    }))
