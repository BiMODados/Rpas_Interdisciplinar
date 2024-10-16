from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
from dotenv import load_dotenv
import os

# Carregar variáveis de ambiente
load_dotenv()

# Configurações do ChromeDriver (headless)
chrome_options = webdriver.ChromeOptions()

# Inicializar o driver
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

# Acessar o URL do Power BI
driver.get("https://app.powerbi.com/groups/me/datasets/01779d62-f86c-4644-96d9-2622477a4b39/details?experience=power-bi")

# Esperar até que o campo de e-mail esteja presente
campo_email = WebDriverWait(driver, 20).until(
    EC.presence_of_element_located((By.XPATH, "//input[@placeholder='Enter email']"))
)
driver.execute_script(f"arguments[0].value = '{os.getenv('EMAIL')}';", campo_email)

# Clicar no botão de enviar email
botao_enviar_email = WebDriverWait(driver, 20).until(
    EC.element_to_be_clickable((By.XPATH, "/html/body/div/div[2]/div[2]/button"))
)
botao_enviar_email.click()

# Esperar até que o campo de senha esteja presente
campo_senha = WebDriverWait(driver, 20).until(
    EC.presence_of_element_located((By.XPATH, "/html/body/div/form[1]/div/div/div[2]/div[1]/div/div/div/div/div/div[3]/div/div[2]/div/div[3]/div/div[2]/input"))
)
driver.execute_script(f"arguments[0].value = '{os.getenv('SENHA')}';", campo_senha)

# Clicar no botão para submeter a senha
botao_submeter_senha = WebDriverWait(driver, 20).until(
    EC.element_to_be_clickable((By.XPATH, "/html/body/div/form[1]/div/div/div[2]/div[1]/div/div/div/div/div/div[3]/div/div[2]/div/div[5]/div/div/div/div"))
)
botao_submeter_senha.click()

# Clicar no botão "Sim" ou equivalente após o login
botao_sim = WebDriverWait(driver, 20).until(
    EC.element_to_be_clickable((By.XPATH, "/html/body/div/form/div/div/div[2]/div[1]/div/div/div/div/div/div[3]/div/div[2]/div/div[3]/div[2]/div/div/div[2]"))
)
botao_sim.click()

# Esperar o carregamento da próxima página
WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, '/html/body/div[1]/root/mat-sidenav-container/mat-sidenav-content/tri-shell-panel-outlet/tri-item-renderer-panel/tri-extension-panel-outlet/mat-sidenav-container/mat-sidenav-content/div/div/div[1]/tri-shell/tri-item-renderer/tri-extension-page-outlet/div[2]/dataset-details-container/dataset-action-bar/action-bar/action-button[2]/button/span')))

# Clicar no elemento desejado
elemento = WebDriverWait(driver, 20).until(
    EC.element_to_be_clickable((By.XPATH, '/html/body/div[1]/root/mat-sidenav-container/mat-sidenav-content/tri-shell-panel-outlet/tri-item-renderer-panel/tri-extension-panel-outlet/mat-sidenav-container/mat-sidenav-content/div/div/div[1]/tri-shell/tri-item-renderer/tri-extension-page-outlet/div[2]/dataset-details-container/dataset-action-bar/action-bar/action-button[2]/button/span'))
)
elemento.click()

# Esperar até que um novo elemento esteja presente (um popup, por exemplo)
elemento = driver.find_element(By.XPATH, '/html/body/div[2]/div[4]/div/div/div/span[1]/button').click()
time.sleep(2)

# Fechar o navegador
driver.close()

print("Funcionou!")
