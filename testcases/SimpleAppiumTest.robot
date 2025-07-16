*** Settings ***
Documentation     Test đơn giản để kiểm tra kết nối Appium
Library           AppiumLibrary
Variables         ../config/robot_variables.py

*** Test Cases ***
Kiểm tra kết nối Appium
    [Documentation]    Kiểm tra có thể kết nối Appium không
    Log    APP_PATH: ${ANDROID_APP_PATH}
    Log    DEVICE_NAME: ${ANDROID_DEVICE_NAME}
    Should Not Be Empty    ${ANDROID_APP_PATH}
    Should Not Be Empty    ${ANDROID_DEVICE_NAME}

Khởi động app đơn giản
    [Documentation]    Thử khởi động app
    [Setup]    Khởi động app
    [Teardown]    Đóng app
    Log    App đã được khởi động thành công

*** Keywords ***
Khởi động app
    [Documentation]    Khởi động app
    Log    PLATFORM_NAME: ${ANDROID_PLATFORM_NAME}
    Log    AUTOMATION_NAME: ${ANDROID_AUTOMATION_NAME}
    Log    DEVICE_NAME: ${ANDROID_DEVICE_NAME}
    Log    PLATFORM_VERSION: ${ANDROID_PLATFORM_VERSION}
    Log    APP_PATH: ${ANDROID_APP_PATH}
#    Open Application    http://127.0.0.1:4723    platformName=${ANDROID_PLATFORM_NAME}    automationName=${ANDROID_AUTOMATION_NAME}    deviceName=${ANDROID_DEVICE_NAME}    platformVersion=${ANDROID_PLATFORM_VERSION}    app=${ANDROID_APP_PATH}
    Open Application    http://127.0.0.1:4723
    ...    platformName=${ANDROID_PLATFORM_NAME}
    ...    platformVersion=${ANDROID_PLATFORM_VERSION}
    ...    deviceName=${ANDROID_DEVICE_NAME}
    ...    appPackage=${ANDROID_APP_PACKAGE}
    ...    appActivity=${ANDROID_APP_ACTIVITY}
    ...    automationName=${ANDROID_AUTOMATION_NAME}
    ...    noReset=true
Đóng app
    [Documentation]    Đóng app
    Close Application 