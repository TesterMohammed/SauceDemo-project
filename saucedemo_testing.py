from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support import expected_conditions as EC
import time
driver=webdriver.Chrome()
def login(username,password):
    try:
        driver.maximize_window()
        driver.get("https://www.saucedemo.com/v1/")
        username1=WebDriverWait(driver,10).until(EC.presence_of_element_located((By.NAME,"user-name")))
        password1=driver.find_element(By.NAME,"password")
        username1.send_keys(username)
        password1.send_keys(password)
        login_button=driver.find_element(By.ID,"login-button")
        login_button.click()
        time.sleep(2)
    except Exception as e:
        print("l'erreur",e)
def login_invalidusername_invalidpasword():
    try:
        login("hhhh","dddd")
        assert "Epic sadface: Username and password do not match any user in this service" in driver.page_source,"le massage d'erreur ne s'affiche pas"
        print("le massage d'erreur s'affiche et l'utilisateur ne se connecte pas")
    except Exception as e:
        print("l'erreur dans login_invalidusername_invalidpasword",e)
def login_validusername_invalidpasword():
    try:
        login("standard_user","uuuuuuuu")
        assert "Epic sadface: Username and password do not match any user in this service" in driver.page_source,"le massage d'erreur ne s'affiche pas"
        print("le massage d'erreur s'affiche et l'utilisateur ne se connecte pas")
    except Exception as e:
        print("l'erreur dans login_validusername_invalidpasword",e)
def login_invalidusername_validpasword():
    try:
        login("hhhh","secret_sauce")
        assert "Epic sadface: Username and password do not match any user in this service" in driver.page_source,"le massage d'erreur ne s'affiche pas"
        print("le massage d'erreur s'affiche et l'utilisateur ne se connecte pas")
    except Exception as e:
        print("l'erreur dans login_invalidusername_validpasword",e)
def login_valid_identity():
    try:
        login("standard_user","secret_sauce")
        assert "Products" in driver.page_source,"probleme d'access au platforme"
        print("l'utilisateur se connecte avec succès")
    except Exception as e:
        print("l'erreur dans login_valid_identity",e)
def filter_A_to_Z():
    try:
        sort_list=driver.find_element(By.CSS_SELECTOR,".product_sort_container")
        select=Select(sort_list)
        select.select_by_visible_text("Name (A to Z)")
        titre_produits=WebDriverWait(driver,10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR,".inventory_item_name")))
        titres_textes=[]
        for titre in titre_produits:
            titres_textes.append(titre.text)
        print("les titres de produits sont",titres_textes)
        assert titres_textes==sorted(titres_textes),"le filtre A to Z ne fonctionne pas correctement"
        print("le filtre A to Z fonctionne correctement")
    except Exception as e:
        print("l'erreur dans filter_A_to_Z",e)
def filter_Z_to_A():
    try:
        sort_list=driver.find_element(By.CSS_SELECTOR,".product_sort_container")
        select=Select(sort_list)
        select.select_by_visible_text("Name (Z to A)")
        titre_produits=WebDriverWait(driver,10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR,".inventory_item_name")))
        titres_textes=[]
        for titre in titre_produits:
            titres_textes.append(titre.text)
        print("les titres de produits sont",titres_textes)
        assert titres_textes==(sorted(titres_textes))[::-1],"le filtre Z to A ne fonctionne pas correctement"
        print("le filtre Z to A fonctionne correctement")
    except Exception as e:
        print("l'erreur dans filter_Z_to_A",e)
def filter_Price_low_to_high():
    try:
        sort_list=driver.find_element(By.CSS_SELECTOR,".product_sort_container")
        select=Select(sort_list)
        select.select_by_visible_text("Price (low to high)")
        prices_produits=WebDriverWait(driver,10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR,".inventory_item_price")))
        prices=[]
        for price in prices_produits:
            prices.append((price.text)[1:])
        print("les prices de produits sont",prices)
        assert prices==sorted(prices),"le filtre Price (low to high) ne fonctionne pas correctement"
        print("le filtre Price (low to high) fonctionne correctement")
    except Exception as e:
        print("l'erreur dans filter_Price_low_to_high",e)
def filter_Price_high_to_low():
    try:
        sort_list=driver.find_element(By.CSS_SELECTOR,".product_sort_container")
        select=Select(sort_list)
        select.select_by_visible_text("Price (high to low)")
        prices_produits=WebDriverWait(driver,10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR,".inventory_item_price")))
        prices=[]
        for price in prices_produits:
            prices.append((price.text)[1:])
        print("les prices de produits sont",prices)
        assert prices==(sorted(prices))[::-1],"le filtre Price ( high to low) ne fonctionne pas correctement"
        print("le filtre Price ( high to low) fonctionne correctement")
    except Exception as e:
        print("l'erreur dans filter_Price_high_to_low",e)
def verify_products_duplication():
    try:
        titre_produits=WebDriverWait(driver,10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR,".inventory_item_name")))
        titres_textes=[]
        for titre in titre_produits:
            titres_textes.append(titre.text)
        print("les titres de produits sont",titres_textes)
        print("les titres après set",set(titres_textes))
        assert len(titres_textes)==len((set(titres_textes))),"les produits sont dupliqués"
        print("les produits ne sont pas dupliqués")
    except Exception as e:
        print("l'erreur dans verify_products_duplication",e)
def verify_images_duplication():
    try:
        images_produits=WebDriverWait(driver,10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR,"img.inventory_item_img")))
        images_src=[]
        for img in images_produits:
            images_src.append(img.get_attribute("src"))
        print("les src sont",images_src)
        print("les src après set",set(images_src))
        assert len(images_src)==len((set(images_src))),"les images de produits sont dupliqués"
        print("les images de produits ne sont pas dupliqués")
    except Exception as e:
        print("l'erreur dans verify_images_duplication",e)
def verify_add_products():
    try:
        Add_to_cart_buttons=driver.find_elements(By.XPATH,"//button[text()='ADD TO CART']")
        for button in Add_to_cart_buttons:
            button.click()
            time.sleep(1)
        panier=driver.find_element(By.CSS_SELECTOR,".fa-layers-counter shopping_cart_badge")
        assert "ADD TO CART" not in driver.page_source and "REMOVE" in driver.page_source and int(panier.text)==len(Add_to_cart_buttons),"il y'a un problème d'ajout des produits"
        print("Tous les produits sont ajoutés avec succès") 
    except Exception as e:
        print("l'erreur dans verify_add_products",e)
def verify_remove_products():
    try:
        Remove_buttons=driver.find_elements(By.XPATH,"//button[text()='REMOVE']")
        for button in Remove_buttons:
            button.click()
            time.sleep(1)
        panier=driver.find_element(By.CSS_SELECTOR,".fa-layers-counter shopping_cart_badge")
        assert "REMOVE" not in driver.page_source and "ADD TO CART" in driver.page_source and panier not in driver.page_source,"il y'a un problème de suppression des produits"
        print("Tous les produits sont supprimés avec succès")
    except Exception as e:
        print("l'erreur dans verify_remove_products",e)
def verify_making_products_order():
    try:
       Add_to_cart_buttons=driver.find_elements(By.XPATH,"//button[text()='ADD TO CART']")
       Add_to_cart_buttons[0].click()
       time.sleep(1)
       Add_to_cart_buttons[1]
       time.sleep(1)
       panier=driver.find_element(By.CSS_SELECTOR,"svg[data-icon='shopping-cart']")
       panier.click()
       time.sleep(2)
       if "REMOVE" in driver.page_source:
           driver.find_element(By.CSS_SELECTOR,".btn_action checkout_button").click()
       else:
           print("le panier est vide")
       first_name=WebDriverWait(driver,10).until(EC.presence_of_element_located((By.ID,"first-name")))
       first_name.send_keys("Mohamed")
       last_name=driver.find_element(By.ID,"last-name")
       last_name.send_keys("Dhaibia")
       postal_code=driver.find_element(By.ID,"postal-code")
       postal_code.send_keys("3050")
       driver.find_element(By.CSS_SELECTOR,"input[value='CONTINUE']").click()
       #verifier la somme des prix de produits à commander
       prices_produits=WebDriverWait(driver,10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR,".inventory_item_price")))
       prices=[]
       for price in prices_produits:
          prices.append(float((price.text)[1:]))
       print("les prices de produits sont",prices)
       item_total=driver.find_element(By.CLASS_NAME,"summary_subtotal_label")
       assert sum(prices)==float((item_total.text)[1:]),"la somme des prix des produits n'est pas correctes"
       print("la somme des prix de produits est correcte")
       tax=driver.find_element(By.CLASS_NAME,"summary_tax_label")
       Total=driver.find_element(By.CLASS_NAME,"summary_total_label")
       assert float((Total.text)[1:])==float((item_total.text)[1:]) + float((tax.text)[1:]),"le prix total avec tax n'est pas correcte"
       print("le prix total avec tax est correcte")
       driver.find_element(By.XPATH,"//a[text()='FINISH']").click() 
       time.sleep(2)
       assert "Your order has been dispatched, and will arrive just as fast as the pony can get there!" in driver.page_source,"la commande des produits n'est pas placée correctement"
       print("la commande des produits est bien placée")
    except Exception as e:
        print("l'erreur dans verify_making_products_order",e) 
def verify_App_Reset():
    try:
        bar_menu=driver.find_element(By.CSS_SELECTOR,".bm-burger-button")
        bar_menu.click()
        WebDriverWait(driver,10).until(EC.presence_of_element_located((By.ID,"inventory_sidebar_link"))).click()
        WebDriverWait(driver,10).until(EC.presence_of_element_located((By.XPATH,"//div[text()='Products']")))
        Add_to_cart_buttons=driver.find_elements(By.XPATH,"//button[text()='ADD TO CART']")
        Add_to_cart_buttons[0].click()
        time.sleep(1)
        Add_to_cart_buttons[1]
        time.sleep(1)
        bar_menu=driver.find_element(By.CSS_SELECTOR,".bm-burger-button")
        bar_menu.click()
        WebDriverWait(driver,10).until(EC.presence_of_element_located((By.ID,"reset_sidebar_link"))).click()
        panier=driver.find_element(By.CSS_SELECTOR,".fa-layers-counter shopping_cart_badge")
        assert panier not in driver.page_source,"la fonction App Reset ne fonctionnalité pas correctement"
        print("La fonctionnalité App Reset fonctionne correctement")
    except Exception as e:
        print("l'erreur dans verify_App_Reset",e)
def About_test():
    try:
        driver.find_element(By.ID,"about_sidebar_link").click()
        time.sleep(3)
        assert "The world relies on your code. Test on thousands of different device, browser, and OS configurations–anywhere, any time." in driver.page_source,"il y'a problème dans la page About"
        print("la fonction about est affichée avec les informations necessaires")
    except Exception as e:
        print("l'erreur dans About_test",e)  
def verify_logout():
    try:
        login_valid_identity()
        driver.find_element(By.CSS_SELECTOR,".bm-burger-button").click()
        WebDriverWait(driver,10).until(EC.presence_of_element_located((By.ID,"logout_sidebar_link"))).click()
        time.sleep(2)
        assert "Username" in driver.page_source,"il y'a un problème de deconnection du platforme"
        print("l'utilisateur se déconnecte avec succès")
    except Exception as e:
        print("l'erreur dans verify_logout",e)
try:
    login_invalidusername_invalidpasword()
    login_validusername_invalidpasword()
    login_invalidusername_validpasword()
    login_valid_identity()
    filter_A_to_Z()
    filter_Z_to_A()
    filter_Price_low_to_high()
    filter_Price_high_to_low()
    verify_products_duplication()
    verify_images_duplication()
    verify_add_products()
    verify_remove_products()
    verify_making_products_order()
    verify_App_Reset()
    About_test() 
    verify_logout() 
finally:
    driver.quit()