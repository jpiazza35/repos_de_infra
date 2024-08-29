import logging
import os
import time
from datetime import datetime
from os import listdir
from tempfile import TemporaryDirectory

from pydantic import BaseSettings
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.wait import WebDriverWait

from moodys.scraping.utils import selenium_driver

import boto3

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel('DEBUG')

class EnvironmentVariables(BaseSettings):
    signin_url: str = "https://www.moodys.com/account/sign-in?ReturnUrl=%2fmoodysmfra#/"
    bucket: str
    moodys_user: str
    moodys_password: str
    default_timeout: int = 60


def download_moodys_dataset(browser: webdriver, settings: EnvironmentVariables):
    """
    Logs into moodys website & download Moodys_HC_AnalystAdjusted.xlsx
    """


    browser.get(settings.signin_url)
    timeout = settings.default_timeout

    # log in
    username = "#\:r5\:"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, username))
    )
    browser.find_element(By.CSS_SELECTOR, username).send_keys(settings.moodys_user)

    clickNext1 = "#\:r6\:"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, clickNext1))
    )
    browser.find_element(By.CSS_SELECTOR, clickNext1).click()

    passwordSelector = "#\:r8\:"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, passwordSelector))
    )
    browser.find_element(By.CSS_SELECTOR, passwordSelector).send_keys(
        settings.moodys_password
    )

    clickNext2 = "#\:r9\:"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, clickNext2))
    )
    browser.find_element(By.CSS_SELECTOR, clickNext2).click()

    # make query
    sectorSelector = "#ng-app > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div.tab-content > div:nth-child(2) > div > div > div:nth-child(1) > select"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, sectorSelector))
    )
    selectSector = Select(browser.find_element(By.CSS_SELECTOR, sectorSelector))
    time.sleep(1)
    selectSector.select_by_visible_text("HealthCare")
    time.sleep(1)
    s1selector = "#ng-app > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div.tab-content > div:nth-child(4) > div > div > div.available-entities.left > div.widget-header > span.right > a.select-all-link"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, s1selector))
    )
    browser.find_element(By.CSS_SELECTOR, s1selector).click()

    s2selector = "#configureReportWiget > div.group > div.dataPointsContainer > div:nth-child(3) > div.widget-header > span.right > a.select-all-link"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, s2selector))
    )
    browser.find_element(By.CSS_SELECTOR, s2selector).click()

    yearsSelector = "#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > select"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, yearsSelector))
    )
    browser.find_element(By.CSS_SELECTOR, yearsSelector).click()

    unselectSelector = "#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li.checked > label > input"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, unselectSelector))
    )
    browser.find_element(By.CSS_SELECTOR, unselectSelector).click()

    selector2022 = "#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li:nth-child(3) > label > input"
    selector2021 = "#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li:nth-child(4) > label > input"
    selector2020 = "#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li:nth-child(5) > label > input"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, selector2022))
    )
    browser.find_element(By.CSS_SELECTOR, selector2022).click()
    browser.find_element(By.CSS_SELECTOR, selector2021).click()
    browser.find_element(By.CSS_SELECTOR, selector2020).click()

    browser.find_element(By.CSS_SELECTOR, "#medianCheckbox").click()

    browser.find_element(
        By.CSS_SELECTOR,
        "#ng-app > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div.page-bottom > span:nth-child(2)",
    ).click()
    time.sleep(20)
    browser.switch_to.window(browser.window_handles[1])
    formatSelector = "#reportFormat"
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, formatSelector))
    )
    selectFormat = Select(browser.find_element(By.CSS_SELECTOR, formatSelector))
    time.sleep(1)
    selectFormat.select_by_visible_text("Vertical Layout")

    exportSelector = (
        "#ng-app > div > div.container > ul > li.controll-item.export > span"
    )
    WebDriverWait(browser, timeout).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, exportSelector))
    )
    browser.find_element(By.CSS_SELECTOR, exportSelector).click()
    logger.info("Starting download.")
    time.sleep(20)  # Give time for the download to complete
    browser.close()
    logger.info("Selenium scraping complete.")


def upload_file(bucket: str, dir: str, file: str):
    # file_name = "Moodys_HC_AnalystAdjusted.xlsx"
    date_string = datetime.now().strftime("%Y-%m-%d")
    file_key = f"{date_string}/{file}"
    file_path = f"{dir}/{file}"
    with open(file_path, 'rb') as f:
        s3 = boto3.resource('s3')
        s3.Bucket(bucket).put_object(Key=file_key, Body=f)
        logger.info("Uploaded to s3.")



def scrape_and_upload():
    environment = EnvironmentVariables()
    logger.debug(environment.dict())

    logger.info(f"Beginning web scraping of {environment.signin_url}")

    with TemporaryDirectory() as temp_dir:
        driver = selenium_driver(
            download_directory=temp_dir,
        )
        download_moodys_dataset(browser=driver, settings=environment)
        dir_contents = os.listdir(temp_dir)
        logger.info(f"Contents of temporary directory: {dir_contents}")
        file = dir_contents[0]
        upload_file(bucket=environment.bucket, dir=temp_dir, file=file)


if __name__ == "__main__":
    scrape_and_upload()

    # uploads to s3
