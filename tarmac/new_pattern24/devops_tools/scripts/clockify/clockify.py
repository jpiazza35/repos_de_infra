from requests.compat import urljoin
from datetime import timedelta
import requests
import json
import datetime
import sys
import getopt

# Generate api key at: https://app.clockify.me/user/settings#:~:text=personal%20API%20key.-,API%20key,-Generate
api_key = "---API KEY---"

if api_key == "":
    print("Missing API_KEY. Please generate one at: https://app.clockify.me/user/settings#:~:text=personal%20API%20key.-,API%20key,-Generate")
    sys.exit(2)
base_api = 'https://api.clockify.me/api/v1/'
headers = {'x-api-key': api_key}

def main(argv):

    project, tag, hours, billable, description = parseargs(argumentList=sys.argv[1:])

    today_date = datetime.datetime.now()
    start_date = today_date - timedelta(hours=hours) # + timedelta(days = 1)
    iso_start_date = start_date.isoformat()+'Z'

    end_date = today_date # + timedelta(days = 1)
    iso_end_date = end_date.isoformat()+'Z'

    # print(iso_start_date)
    # print(iso_end_date)

    user_id, workspace_id = getuserworkspaceid()
    # print(f"User id: {user_id}")
    # print(f"Workspace id: {workspace_id}")

    project_id = getprojectbyname(workspace_id=workspace_id, name=project)

    tag_id = gettagbyname(workspace_id=workspace_id, name=tag)

    addentry(workspace_id=workspace_id, iso_start_date=iso_start_date, iso_end_date=iso_end_date, project_id=project_id, tag_id=tag_id, billable=billable, description=description)

def parseargs(argumentList):
    # Options
    options = "p:t:h:b:d:"
    
    # Long options
    long_options = ["project=", "tag=", "hours=", "billable=", "description="]
    
    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
                
    except getopt.GetoptError as err:
        # output error, and return with an error code
        print (err)
        usage()
        sys.exit(2)

    project = ''
    tag = ''
    hours = 0
    billable = False
    description = ''
    # checking each argument
    for currentArgument, currentValue in arguments:
        if currentArgument in ("-p", "--project"):
            project = currentValue
                
        elif currentArgument in ("-t", "--tag"):
            tag = currentValue

        elif currentArgument in ("-h", "--hours"):
            hours = int(currentValue)

        elif currentArgument in ("-b", "--billable"):
            billable = currentValue

        elif currentArgument in ("-d", "--description"):
            description = currentValue

    return project, tag, hours, billable, description

def getuserworkspaceid():
    getuser_url = urljoin(base_api, 'user')

    r = requests.get(getuser_url, headers=headers)
    r_json = json.loads(r.content)
    user_id = r_json["id"]
    workspace_id = r_json["activeWorkspace"]
    return user_id, workspace_id

def getprojectbyname(workspace_id, name):
    getallprojects_url = urljoin(base_api, f'workspaces/{workspace_id}/projects?hydrated=true&name={name}')
    r = requests.get(getallprojects_url, headers=headers)
    r_json = json.loads(r.content)
    project_id = r_json[0]["id"]
    return project_id

def gettagbyname(workspace_id, name):
    getalltags_url = urljoin(base_api, f'workspaces/{workspace_id}/tags?name={name}')
    r = requests.get(getalltags_url, headers=headers)
    r_json = json.loads(r.content)
    tag_id = r_json[0]["id"]
    return tag_id

def addentry(workspace_id, iso_start_date, iso_end_date, project_id, tag_id, billable, description):
    addtime_url = urljoin(base_api, f'workspaces/{workspace_id}/time-entries')
    timedata = {
        "start": iso_start_date,
        "billable": billable,
        "description": description,
        "projectId": project_id,
        "end": iso_end_date,
        "tagIds": [
            tag_id
        ]
    }
    r = requests.post(addtime_url, json = timedata, headers=headers)
    if r.status_code == 201:
        print("Successfully logged time.")
    else:
        print(r.content)

def usage():
    print("Example Usage:")
    print(f"python3 clockify.py --project=PROJECT_NAME --tag=DevOps/Development/Design/etc --hours=8 --billable=True/False --description=EOD")

if __name__ == "__main__":
   main(sys.argv[1:])




