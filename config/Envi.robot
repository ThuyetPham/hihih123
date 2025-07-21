*** Settings ***
Library       AppiumLibrary
Library       JSONLibrary
Library       OperatingSystem
Resource    mobile_variables.txt
Resource    ../core/API/api_access.robot
Resource    ../core/API/api_access_mobile.robot
Resource    ../core/Login/Login_action.robot


*** Keywords ***
Init Test Environment
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    ${token_value_mobile}    ${resp.cookies_mobile}    Get mobile BearerToken from API
    Set Global Variable    \${bearertoken_mobile}    ${token_value_mobile}
    Set Global Variable    \${resp.cookies_mobile}    ${resp.cookies_mobile}
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Append To Environment Variable    PATH    ${EXECDIR}${/}drivers

