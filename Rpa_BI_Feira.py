from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import time
from dotenv import load_dotenv
import os

load_dotenv()

chrome_options = webdriver.ChromeOptions()

chrome_options.add_argument("--headless")

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

driver.get("https://app.powerbi.com/groups/me/datasets/01dd65a7-b6f5-4c71-9ec0-8b3d74e06258/details?experience=power-bi")
time.sleep(10)

# Login
campo_email = driver.find_element(By.XPATH, "//input[@placeholder='Enter email']")

driver.execute_script(f"arguments[0].value = '{os.getenv('EMAIL')}';", campo_email)

driver.find_element(By.XPATH, "/html/body/div/div[2]/div[2]/button").click()

time.sleep(7)

campo_senha = driver.find_element(By.XPATH, "//*[@id='i0118']")

driver.execute_script(f"arguments[0].value = '{os.getenv('SENHA')}';", campo_senha)

driver.find_element(By.XPATH, "/html/body/div/form[1]/div/div/div[2]/div[1]/div/div/div/div/div/div[3]/div/div[2]/div/div[5]/div/div/div/div").click()

time.sleep(4)

driver.find_element(By.XPATH, "/html/body/div/form/div/div/div[2]/div[1]/div/div/div/div/div/div[3]/div/div[2]/div/div[3]/div[2]/div/div/div[2]").click()

time.sleep(12)


elemento = driver.find_element(By.XPATH, '//*[@id="content"]/tri-shell/tri-item-renderer/tri-extension-page-outlet/div[2]/dataset-details-container/dataset-action-bar/action-bar/action-button[2]/button').click()
time.sleep(3)

elemento = driver.find_element(By.XPATH, '/html/body/div[2]/div[4]/div/div/div/span[1]').click()
time.sleep(2)

print("Funcionou!")