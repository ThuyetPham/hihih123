*** Settings ***
Library           AppiumLibrary
Resource         ../config/Envi.robot

Suite Setup       Init Test Environment
Suite Teardown    Close Application

Test Setup        Login to Pos
Test Teardown     Capture Page Screenshot


*** Test Cases ***
Kiểm tra kết nối Appium
    [Documentation]    Kiểm tra có thể kết nối Appium không
    [Tags]       thuyet123
     log     ${env}