from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
from selenium.webdriver.support.ui import Select
import os

signin_url = "https://www.moodys.com/account/sign-in?ReturnUrl=%2fmoodysmfra#/"

browser = webdriver.Chrome()
browser.get(signin_url)

user = os.getenv('MOODYS_USER')
password = os.getenv('MOODYS_PASSWORD')


#log in
username = '#\:r5\:'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, username)))
browser.find_element(By.CSS_SELECTOR, username).send_keys(user)

clickNext1 = '#\:r6\:'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, clickNext1)))
browser.find_element(By.CSS_SELECTOR, clickNext1).click()

passwordSelector = '#\:r8\:'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, passwordSelector)))
browser.find_element(By.CSS_SELECTOR, passwordSelector).send_keys(password)

clickNext2 = '#\:r9\:'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, clickNext2)))
browser.find_element(By.CSS_SELECTOR, clickNext2).click()

#make query
sectorSelector = '#ng-app > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div.tab-content > div:nth-child(2) > div > div > div:nth-child(1) > select'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, sectorSelector )))
selectSector = Select(browser.find_element(By.CSS_SELECTOR, sectorSelector))
time.sleep(1)
selectSector.select_by_visible_text('HealthCare')
time.sleep(1)
s1selector = '#ng-app > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div.tab-content > div:nth-child(4) > div > div > div.available-entities.left > div.widget-header > span.right > a.select-all-link'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, s1selector )))
browser.find_element(By.CSS_SELECTOR, s1selector).click()

s2selector = '#configureReportWiget > div.group > div.dataPointsContainer > div:nth-child(3) > div.widget-header > span.right > a.select-all-link'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, s2selector )))
browser.find_element(By.CSS_SELECTOR, s2selector).click()

yearsSelector = '#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > select'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, yearsSelector )))
browser.find_element(By.CSS_SELECTOR, yearsSelector).click()

unselectSelector = '#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li.checked > label > input'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, unselectSelector )))
browser.find_element(By.CSS_SELECTOR, unselectSelector).click()

selector2022 = '#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li:nth-child(3) > label > input'
selector2021 = '#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li:nth-child(4) > label > input'
selector2020 = '#reportPeriodAndStatistics > div.group > div > div.left.selectYearContainer > div > div.selectFilter > div.popUpSelectDiv > ul:nth-child(1) > li:nth-child(5) > label > input'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, selector2022)))
browser.find_element(By.CSS_SELECTOR, selector2022).click()
browser.find_element(By.CSS_SELECTOR, selector2021).click()
browser.find_element(By.CSS_SELECTOR, selector2020).click()

browser.find_element(By.CSS_SELECTOR, '#medianCheckbox').click()

browser.find_element(By.CSS_SELECTOR, '#ng-app > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div.page-bottom > span:nth-child(2)').click()
time.sleep(10)
browser.switch_to.window(browser.window_handles[1])
formatSelector = '#reportFormat'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, formatSelector )))
selectFormat = Select(browser.find_element(By.CSS_SELECTOR, formatSelector))
time.sleep(1)
selectFormat.select_by_visible_text('Vertical Layout')

exportSelector = '#ng-app > div > div.container > ul > li.controll-item.export > span'
WebDriverWait(browser,10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, exportSelector )))
browser.find_element(By.CSS_SELECTOR, exportSelector).click()
browser.close()