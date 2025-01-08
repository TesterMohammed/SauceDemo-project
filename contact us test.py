from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.alert import Alert
import time
driver=webdriver.Chrome()
def verify_contact():
    try:
        driver.maximize_window()
        driver.get("https://www.automationexercise.com/contact_us")
        WebDriverWait(driver,10).until(EC.presence_of_element_located((By.CSS_SELECTOR,".title.text-center")))
        driver.find_element(By.NAME,"name").send_keys("Mohamed Dhaibia")
        driver.find_element(By.NAME,"email").send_keys("hfft52h@gmail.com")
        driver.find_element(By.NAME,"subject").send_keys("demande de facture")
        driver.find_element(By.NAME,"message").send_keys("je suis votre client et je demande de télécharger ma facture de commande de mon produits")
        driver.find_element(By.NAME,"upload_file").send_keys("C://Users//dell//Desktop//candidature pour un post.txt")
        time.sleep(2)
        driver.find_element(By.NAME,"submit").click()
        time.sleep(2)
        print( Alert(driver).text)
        Alert(driver).accept()
        time.sleep(2)
        assert "Success! Your details have been submitted successfully." in driver.page_source,"Le message de contact n'est pas envoyé"
        print("Le message de contact est bien envoyé")
    except Exception as e:
        print("le message d'erreur dans verify_contact est: ",e)
try:
    verify_contact()
finally:
    driver.quit()