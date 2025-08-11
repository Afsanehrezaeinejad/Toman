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


*** Test Cases ***
Successful Login With Email
    Login With Email    ${EMAIL}    ${PASSWORD}
    Verify User Is LoggedIn
UnSuccessful Login attempts with Email
    Login With Email    ${EMAIL}    dummy
    Verify Login Is Failed
