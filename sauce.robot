*** Settings ***
Library   SeleniumLibrary
Library   Collections
*** Variables ***
${url}       https://www.saucedemo.com/
${browser}   Chrome
${username}   standard_user
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
    ${products pricess}=  Get WebElements    css=.inventory_item_price 
    ${products prices}=   Create List
    FOR    ${element}    IN    @{products pricess}
        ${element text}=   Get Text    ${element}
        ${product price}=  Evaluate    float(${element text}.split('$')[-1].strip())
        Append To List    ${products prices}    ${product price}
    END
    Log    ${products prices}
    ${sorted products prices}=  Evaluate   sorted(${products prices})
    Log    ${sorted products prices}
    Should Be Equal    ${products prices}    ${sorted products prices}
verify filter Price (high to low)
    Select From List By Label      css=.product_sort_container       Price (high to low)
    Sleep    2
    ${products pricess}=  Get WebElements    css=.inventory_item_price 
    ${products prices}=   Create List
    FOR    ${element}    IN    @{products pricess}
        ${element text}=   Get Text    ${element}
        ${product price}=  Evaluate    float(${element text}.split('$')[-1].strip())
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
        Append To List    ${products tis}    ${element text}
    END
    Log    ${products titles}
    ${set products titles}=  Remove Duplicates    ${products titles}
    Log    ${set products titles}
    ${products titles length}=  Get Length    ${products titles}
    ${set products titles length}=  Get Length    ${set products titles}
    ${status}=   Run Keyword And Return Status    Should Be Equal As Integers   ${products titles length}    ${set products titles length}
    Run Keyword If    ${status}==True  Log  Products are not duplicated  ELSE  Log   Products are duplicated
