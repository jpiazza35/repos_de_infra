# etl-organization-financial-data

## [Notion Link](https://www.notion.so/cliniciannexus/Organization-Financial-Data-1612458634194020bfbb43fe040c0fcc)

## Scraper
To run the scraper, first do `docker compose build`, then do `docker compose up`. The scraper downloads the Moodys_HC_AnalystAdjusted.xlsx file to a specified folder. We still need to upload that file to S3.


## How to run the job:
1) Go to Workflows in the Data Science/Engineering tab of databricks
2) Select 'Organization Financial Data'
3) Click 'Run now' in the top right corner

<img width="600" alt="Screenshot 2023-05-25 145434" src="https://github.com/clinician-nexus/etl-organization-financial-data/assets/128501874/39973867-a2f7-4ae5-b82e-059b1fec0443">

## How data gets updated:

1) Moody's website automatically scraped - MoodysCleaning.py
2) Uploaded into dbfs FileStore (overwrites old file in its place), where it is then accessed in _moodys_upload_
3) Upserted into _moodys_financial , moodys_OD , and moodys_ratio_ (all historic files)
4) Read into _moodys_cleaning_ where the three files are combined and upserted into _moodys_mfra_ which is a historic file 
5) ProPublica data uploaded into dbfs by Tim, converted to Delta table with inferred schema, then upserted into _propublica_financials_ (a historic file)
6) _propublica_financials_ and _moodys_mfra_ combined into _end_df_ (a temporary file) and upserted into _organization_financials_ which is the final product
## File descriptions:

### 1: MoodysCleaning.py
Scrapes Moody's website using Selenium

### 2: moodys_upload
Takes raw data from Moody's website, cleans names to make compatible with delta tables, upserts to 3 separate "raw" source_oriented files (moodys_financial, moodys_od, moodys_ratio)

### 3: moodys_cleaning
Cleans and combines the three raw delta tables, then upserts to moodys_mfra

### 4: update_propublica
Uploads ProPublica data given by Tim and makes new propublica_financials file

### 5: combine_all
Combines ProPublica and Moody's data using _moodys_propublica_org_financial_mapping_ , saves to domain_oriented organization_financials (**Note: this script is in R**)
