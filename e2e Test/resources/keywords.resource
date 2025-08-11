*** Settings ***
Library    SeleniumLibrary
Resource   ./locators.resource
*** Keywords ***
Login With Email
    [Arguments]    ${email}    ${password}
    Wait Until Element Is Visible    ${PROFILE_BTN}           10s
    Click Element                    ${PROFILE_BTN}
    Wait Until Element Is Visible    ${LOGIN_REGISTER_BTN}     10s
    Input Text                       ${USERNAME_INPUT}         ${email}
    Click Element                    ${LOGIN_REGISTER_BTN}
    Wait Until Page Contains         رمز عبور را وارد کنید    10s
    Input Text                       ${PASSWORD_INPUT}         ${password}
    Click Button                     ${SUBMIT_BTN}
Verify Login Is Failed
    Wait Until Page Contains    اطلاعات کاربری نادرست است
    Click Button    xpath=//*[text()="باشه"]
    ${PASSWORD_VALUE}=    Get Value    ${PASSWORD_INPUT}
    Should Not Be Empty    ${PASSWORD_VALUE}    # Based on current system behaviour: password field is not cleared after failed login
    Element Should Be Enabled    ${SUBMIT_BTN}


Switch To Next Tab
    Wait Until Keyword Succeeds    10x    500ms    Switch Window    NEW

Wait Until URL Is Shipping
    Wait Until Keyword Succeeds    10x    500ms    Location Should Be    https://www.digikala.com/checkout/shipping/

Verify User Is LoggedIn
    Wait Until Page Contains Element    ${DIGIKALA_LOGO}     10s
    Wait Until Page Does Not Contain Element    ${LOGIN_REGISTER_BTN}    20s
    Element Should Be Visible                   ${PROFILE_BTN2}

Add To Cart
    Click Element    ${SEARCH_BUTTON}
    Input Text    ${SEARCH_INPUT}    دوربین عکاسی
    Press Keys    ${SEARCH_INPUT}   ENTER
    Wait Until Element Is Visible    ${PRODUCT_CARD_INDEX_1}    20s
    Scroll Element Into View         ${PRODUCT_BY_TITLE}
    Click Element    ${PRODUCT_BY_TITLE}
    Switch To Next Tab
    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}
    Click Element    ${ADD_TO_CART_BTN}
    Wait Until Page Contains    این کالا به سبد خرید اضافه شد!
    Wait Until Page Does Not Contain    برو به سبد خرید


Proceed To Checkout
    Click Element    ${GO_TO_CART_LINK}
    Wait Until Element Is Visible    ${GO_TO_SHIPPING_LINK}
    ${PRODUCT_LABEL}=     Get Text  ${PRODUCT_BY_TITLE}
    Page Should Contain    ${PRODUCT_LABEL}
    Click Element    ${GO_TO_SHIPPING_LINK} 
    Wait Until URL Is Shipping