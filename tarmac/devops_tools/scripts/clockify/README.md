This script can enter your hours for the day in clockify.

Prerequisites are your own user's api key. Can be generated here:
https://app.clockify.me/user/settings#:~:text=personal%20API%20key.-,API%20key,-Generate

After you have generated the key replace the placeholder ---API KEY---

Example usage:

```bash
python3 clockify.py --project=Granicus --tag=DevOps --hours=8 --billable=True --description="EOD"

# or

python3 clockify.py -p Granicus -t DevOps -h 8 -b True -d "EOD"
```

Note:
Project name should match the project name in Clockify
Tag is the type of work: DevOps/Development/Design/etc...