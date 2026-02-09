import time
import boto3
import json

logs = boto3.client("logs")

LOG_GROUP = "/aws/lambda/governed-ai-foundation-dev-dashboard-api"

QUERY = """
fields @timestamp, event_type, payload
| filter event_type = "AUDIT_EVENT"
| sort @timestamp desc
| limit 20
"""

def fetch_audit_events():
    q = logs.start_query(
        logGroupName=LOG_GROUP,
        startTime=int(time.time()) - 3600,
        endTime=int(time.time()),
        queryString=QUERY
    )

    query_id = q["queryId"]

    for _ in range(10):
        r = logs.get_query_results(queryId=query_id)
        if r["status"] == "Complete":
            events = []
            for row in r["results"]:
                obj = {}
                for field in row:
                    if field["field"] == "payload":
                        obj.update(json.loads(field["value"]))
                if obj:
                    events.append(obj)
            return events
        time.sleep(0.5)

    return []
