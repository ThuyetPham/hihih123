*** Settings ***
Documentation     Test đơn giản để kiểm tra kết nối Appium
Library           AppiumLibrary
Resource         ../config/Envi.robot


*** Test Cases ***
Kiểm tra kết nối Appium
    [Documentation]    Kiểm tra có thể kết nối Appium không
    [Tags]       thuyet123
    log     ${env}
    Init Test Environment