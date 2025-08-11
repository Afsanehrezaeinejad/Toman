*** Settings ***
Library    SeleniumLibrary    timeout=10s    implicit_wait=0.2s

*** Variables ***
${BROWSER}           chrome
*** Keywords ***
Open Clean Browser
    [Arguments]    ${url}
    Open Browser    ${url}    ${BROWSER}    arguments=--headless=new --window-size=1280,800
    Set Selenium Speed    0s

Close Browser If Open
    Run Keyword And Ignore Error    Close All Browsers
