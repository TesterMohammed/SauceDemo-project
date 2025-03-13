*** Settings ***
Library   SeleniumLibrary
Library   Collections
*** Variables ***
${url}       https://www.saucedemo.com/
${browser}   Chrome
${username}   problem_user
${password}   secret_sauce
*** Keywords ***
login
    [Arguments]      ${username1}     ${password1}
    Open Browser   ${url}    ${browser}
    Maximize Browser Window
    Wait Until Element Is Visible    id=user-name
    Input Text    id=user-name    ${username1}
    Input Password    id=password    ${password1}
    Click Element    css=input[type="submit"]
    Sleep    1
*** Test Cases ***
verify login with invalid password and username
    login    hhhhh    fdgg545
    Page Should Contain    Epic sadface: Username and password do not match any user in this service
    [Teardown]   Close Browser
verify login with invalid password and valid username
    login    ${username}    5dfg5fg5
    Page Should Contain    Epic sadface: Username and password do not match any user in this service
    [Teardown]   Close Browser
verify login with valid password and invalid username
    login      sfdfgfdfnf    ${password}
    Page Should Contain    Epic sadface: Username and password do not match any user in this service
    [Teardown]   Close Browser
verify login with valid password and valid username
    login    ${username}    ${password}
    Page Should Contain    Products
verify filter Name (A to Z)
    Select From List By Label      css=.product_sort_container       Name (A to Z)
    Sleep    2
    ${products titless}=  Get WebElements    css=.inventory_item_name 
    ${products titles}=   Create List
    FOR    ${element}    IN    @{products titless}
        ${element text}=   Get Text    ${element}
        Append To List    ${products titles}    ${element text}
    END
    Log    ${products titles}
    ${sorted products titles}=  Evaluate   sorted(${products titles})
    Log    ${sorted products titles}
    Should Be Equal    ${products titles}    ${sorted products titles}
verify filter Name (Z to A)
    Select From List By Label      css=.product_sort_container       Name (Z to A)
    Sleep    2
    ${products titless}=  Get WebElements    css=.inventory_item_name 
    ${products titles}=   Create List
    FOR    ${element}    IN    @{products titless}
        ${element text}=   Get Text    ${element}
        Append To List    ${products titles}    ${element text}
    END
    Log    ${products titles}
    ${sorted products titles}=  Evaluate   (sorted(${products titles}))[::-1]
    Log    ${sorted products titles}
    Should Be Equal    ${products titles}    ${sorted products titles}
verify filter Price (low to high)
    Select From List By Label      css=.product_sort_container       Price (low to high)
    Sleep    2
    ${products elements}=  Get WebElements    css=.inventory_item_price 
    ${products prices}=   Create List
    FOR    ${element}    IN    @{products elements}
        ${element text}=   Get Text    ${element}
        ${product price}=  Evaluate    float("${element text}".split('$')[-1].strip())
        Append To List    ${products prices}    ${product price}
    END
    Log    ${products prices}
    ${sorted products prices}=  Evaluate   sorted(${products prices})
    Log    ${sorted products prices}
    Should Be Equal    ${products prices}    ${sorted products prices}
verify filter Price (high to low)
    Select From List By Label      css=.product_sort_container       Price (high to low)
    Sleep    2
    ${products elements}=  Get WebElements    css=.inventory_item_price 
    ${products prices}=   Create List
    FOR    ${element}    IN    @{products elements}
        ${element text}=   Get Text    ${element}
        ${product price}=  Evaluate    float("${element text}".split('$')[-1].strip())
        Append To List    ${products prices}    ${product price}
    END
    Log    ${products prices}
    ${sorted products prices}=  Evaluate   (sorted(${products prices}))[::-1]
    Log    ${sorted products prices}
    Should Be Equal    ${products prices}    ${sorted products prices}
verify products duplication
    ${products titless}=  Get WebElements    css=.inventory_item_name 
    ${products titles}=   Create List
    FOR    ${element}    IN    @{products titless}
        ${element text}=   Get Text    ${element}
        Append To List    ${products titles}    ${element text}
    END
    Log    ${products titles}
    ${set products titles}=  Remove Duplicates    ${products titles}
    Log    ${set products titles}
    ${products titles length}=  Get Length    ${products titles}
    ${set products titles length}=  Get Length    ${set products titles}
    ${status}=   Run Keyword And Return Status    Should Be Equal As Integers   ${products titles length}    ${set products titles length}
    Run Keyword If    ${status}==True  Log  Products are not duplicated  ELSE  Log   Products are duplicated
verify images duplication
    ${images}=  Get WebElements    css=img.inventory_item_img 
    ${images src}=   Create List
    FOR    ${element}    IN    @{images}
        ${element src}=   Get Element Attribute    ${element}    src
        Append To List    ${images src}    ${element src}
    END
    Log    ${images src}
    ${set images src}=  Remove Duplicates    ${images src}
    Log    ${set images src}
    ${images src length}=  Get Length    ${images src}
    ${set images src length}=  Get Length    ${set images src}
    Should Be Equal    ${images src length}    ${set images src length}
verify adding products
    ${Add to cart buttons}=   Get WebElements    xpath=//button[text()="Add to cart"]
    FOR    ${element}    IN    @{Add to cart buttons}
        Click Element    ${element}
        Sleep    1
    END
    ${cart products number}=  Get Text    css=.shopping_cart_badge
    ${cart products number int}=  Evaluate   int(${cart products number})
    ${Add to cart buttons length}=  Get Length    ${Add to cart buttons}
    ${pages source}=   Get Source
    Should Be Equal    ${Add to cart buttons length}    ${cart products number int}
    Should Not Contain   ${pages source}    Add to cart
verify deleting products
    ${Remove buttons}=   Get WebElements    xpath=//button[text()="Remove"]
    FOR    ${element}    IN    @{Remove buttons}
        Click Element    ${element}
        Sleep    1
    END
    ${pages source}=   Get Source
    Should Not Contain   ${pages source}    Remove
    Should Not Contain   ${pages source}    shopping_cart_badge
verify making order
    ${Add to cart buttons}=   Get WebElements    xpath=//button[text()="Add to cart"]
    ${first product}=   Set Variable   ${Add to cart buttons}[0]
    Click Element    ${first product}
    Sleep    1
    ${second product}=  Set Variable   ${Add to cart buttons}[1]
    Click Element    ${second product}
    Sleep    1
    Click Element    css=.shopping_cart_link
    Page Should Contain     Remove
    Click Button    checkout
    Wait Until Element Is Visible    first-name 
    Input Text    first-name    Mohamed
    Input Text    last-name     Dhaibia
    Input Text    postal-code   3050
    Click Element    continue
    Wait Until Page Contains    Finish
    ${products pricess}=  Get WebElements    css=.inventory_item_price 
    ${products prices}=   Create List
    FOR    ${element}    IN    @{products pricess}
        ${element text}=   Get Text    ${element}
        ${product price}=  Evaluate    float("${element text}".split('$')[-1].strip())
        Append To List    ${products prices}    ${product price}
    END
    ${Somme}=  Evaluate   sum(${products prices})
    Log   la somme des prix de produits dans la cart est=${Somme}
    ${subtotal text}=    Get Text    css=.summary_subtotal_label
    ${subtotal price}=   Evaluate    float("${subtotal text}".split('$')[-1].strip())
    Log   subtotal price = ${subtotal price}
    Should Be Equal    ${Somme}    ${subtotal price}
    ${Tax text}=    Get Text    css=.summary_tax_label
    ${Tax price}=   Evaluate    float("${Tax text}".split('$')[-1].strip())
    Log   tax price = ${Tax price}
    ${Total text}=    Get Text    css=.summary_total_label
    ${Total price}=   Evaluate    float("${Total text}".split('$')[-1].strip())
    ${somme Tax et subtotal price}=  Evaluate   float(f"{${Tax price} + ${subtotal price}:.2f}")
    Should Be Equal    ${Total price}     ${somme Tax et subtotal price}
    Click Button    finish
    Sleep    2
    Page Should Contain    Thank you for your order!
    [Teardown]   Close Browser
verify Reset App
    login    ${username}    ${password}
    Wait Until Page Contains    Products
    ${Add to cart buttons}=   Get WebElements    xpath=//button[text()="Add to cart"]
    ${first product}=   Set Variable  ${Add to cart buttons}[0]
    Click Element    ${first product}
    Sleep    1
    ${second product}=   Set Variable  ${Add to cart buttons}[1]
    Click Element    ${second product}
    Sleep    1  
    ${cart products number}=   Get Text    css=.shopping_cart_badge
    Log   le nombre de produits dans le cart est= ${cart products number}
    Click Button    react-burger-menu-btn
    Wait Until Element Is Visible    reset_sidebar_link
    Click Element    reset_sidebar_link
    Sleep    2
    ${pages source}=   Get Source
    Should Not Contain   ${pages source}    shopping_cart_badge
verify About feature
    Click Element    about_sidebar_link
    Wait Until Element Is Visible    css=.MuiTypography-root.MuiTypography-body1.css-1mz1i0z
    ${about text}=  Get Text    css=.MuiTypography-root.MuiTypography-body1.css-1mz1i0z
    log  ${about text}
    [Teardown]  Close Browser
verify logout feature
    login    ${username}    ${password}
    Page Should Contain    Products
    Click Button    react-burger-menu-btn
    Wait Until Element Is Visible    logout_sidebar_link
    Click Element    logout_sidebar_link
    Sleep    2
    Page Should Contain Element    css=.submit-button.btn_action
    [Teardown]   Close Browser



