*** Settings ***
Documentation     Test đơn giản để kiểm tra kết nối Appium
Library           AppiumLibrary
Variables         ../config/robot_variables.py

*** Test Cases ***
Kiểm tra kết nối Appium
    [Documentation]    Kiểm tra có thể kết nối Appium không
    [Tags]       thuyet123
    log     ${env}
    Log    APP_PATH: ${ANDROID_APP_PATH}
    Log    DEVICE_NAME: ${ANDROID_DEVICE_NAME}
    Should Not Be Empty    ${ANDROID_APP_PATH}
    Should Not Be Empty    ${ANDROID_DEVICE_NAME}
