# this script gets the serverspec JSON test report
# reformats the JSON structure to match Zabbix LLD type
# writes a new JSON to /home/ec2-user/new-b.json

import json
testreportdir="/home/ec2-user/kafkaExample/tests/spec/Reports/"
with open(testreportdir+"test_report.json") as b:
    b = json.load(b)

for example in b["examples"]:

    example["{#test}"] = example["full_description"]
    del example["full_description"]

    example["{#test_result}"] = example["status"]
    del example["status"]

    del example["id"]
    del example["description"]
    del example["file_path"]
    del example["line_number"]
    del example["run_time"]
    del example["pending_message"]
    example.pop('exception', None)

b["data"] = b["examples"]
del b["examples"]
del b["version"]
del b["summary_line"]
del b["summary"]

with open(testreportdir+"reformatted_test_results.json", "w") as new_b:
    json.dump(b, new_b, indent=1, separators=(',', ': '))
