*** Settings ***
Resource    ../resources/browser.resource
Resource    ../resources/locators.resource
Resource    ../resources/keywords.resource
Test Setup     Open Clean Browser    ${BASE_URL}
Test Teardown  Close Browser

*** Variables ***
# Pass these credentials at run time
${EMAIL}                  ${EMPTY}
${PASSWORD}               ${EMPTY}

*** Keywords ***

*** Test Cases ***
Add Product to Cart and Checkout
    Login With Email    ${EMAIL}    ${PASSWORD}
    Add To Cart
    Proceed To Checkout
