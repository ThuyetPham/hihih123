*** Settings ***
Documentation     Common Resources cho Mobile Automation
...               Chứa các keywords và variables chung

Library           AppiumLibrary
Library           keywords/MobileKeywords.py
Library           keywords/LoginKeywords.py

*** Variables ***
# Appium Configuration
${APPIUM_HOST}           127.0.0.1
${APPIUM_PORT}           4723
${APPIUM_PATH}           /wd/hub

# Android Configuration
${ANDROID_PLATFORM_NAME}    Android
${ANDROID_AUTOMATION_NAME}  UiAutomator2
${ANDROID_DEVICE_NAME}      Android Emulator
${ANDROID_PLATFORM_VERSION} 11.0
${ANDROID_APP_PATH}         ${EXECDIR}/apps/sample-app.apk

# iOS Configuration
${IOS_PLATFORM_NAME}        iOS
${IOS_AUTOMATION_NAME}      XCUITest
${IOS_DEVICE_NAME}          iPhone Simulator
${IOS_PLATFORM_VERSION}     15.0
${IOS_APP_PATH}             ${EXECDIR}/apps/sample-app.app

# Test Data
${VALID_USERNAME}           testuser
${VALID_PASSWORD}           testpass
${INVALID_USERNAME}         invaliduser
${INVALID_PASSWORD}         invalidpass

# Timeouts
${IMPLICIT_TIMEOUT}         10s
${EXPLICIT_TIMEOUT}         20s
${PAGE_LOAD_TIMEOUT}        30s

# Screenshot
${SCREENSHOT_DIR}           screenshots

*** Keywords ***
Khởi động ứng dụng mobile
    [Documentation]    Khởi động ứng dụng mobile
    [Arguments]    ${platform}=android    ${device_name}=${EMPTY}    ${app_path}=${EMPTY}
    
    ${capabilities}=    Create Dictionary
    ...    platformName=${ANDROID_PLATFORM_NAME}
    ...    automationName=${ANDROID_AUTOMATION_NAME}
    ...    deviceName=${device_name}
    ...    platformVersion=${ANDROID_PLATFORM_VERSION}
    ...    app=${app_path}
    ...    noReset=${FALSE}
    ...    fullReset=${TRUE}
    
    Open Application    http://${APPIUM_HOST}:${APPIUM_PORT}${APPIUM_PATH}    &{capabilities}
    Set Implicit Wait Timeout    ${IMPLICIT_TIMEOUT}

Đóng ứng dụng mobile
    [Documentation]    Đóng ứng dụng mobile
    Close Application

Chụp screenshot
    [Documentation]    Chụp screenshot
    [Arguments]    ${filename}=${EMPTY}
    
    ${timestamp}=    Get Time    epoch
    ${screenshot_name}=    Set Variable If    '${filename}' == '${EMPTY}'    screenshot_${timestamp}.png    ${filename}
    
    Capture Page Screenshot    ${screenshot_name}
    Log    Đã chụp screenshot: ${screenshot_name}

Chờ element xuất hiện
    [Documentation]    Chờ element xuất hiện
    [Arguments]    ${locator}    ${timeout}=${EXPLICIT_TIMEOUT}
    
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Log    Element ${locator} đã xuất hiện

Chờ element biến mất
    [Documentation]    Chờ element biến mất
    [Arguments]    ${locator}    ${timeout}=${EXPLICIT_TIMEOUT}
    
    Wait Until Element Is Not Visible    ${locator}    ${timeout}
    Log    Element ${locator} đã biến mất

Click element
    [Documentation]    Click vào element
    [Arguments]    ${locator}    ${timeout}=${EXPLICIT_TIMEOUT}
    
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Click Element    ${locator}
    Log    Đã click element: ${locator}

Nhập text
    [Documentation]    Nhập text vào element
    [Arguments]    ${locator}    ${text}    ${timeout}=${EXPLICIT_TIMEOUT}
    
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Input Text    ${locator}    ${text}
    Log    Đã nhập text '${text}' vào element: ${locator}

Lấy text của element
    [Documentation]    Lấy text của element
    [Arguments]    ${locator}    ${timeout}=${EXPLICIT_TIMEOUT}
    
    Wait Until Element Is Visible    ${locator}    ${timeout}
    ${text}=    Get Text    ${locator}
    Log    Text của element ${locator}: ${text}
    [Return]    ${text}

Kiểm tra element hiển thị
    [Documentation]    Kiểm tra element có hiển thị không
    [Arguments]    ${locator}
    
    Element Should Be Visible    ${locator}
    Log    Element ${locator} đang hiển thị

Kiểm tra element không hiển thị
    [Documentation]    Kiểm tra element không hiển thị
    [Arguments]    ${locator}
    
    Element Should Not Be Visible    ${locator}
    Log    Element ${locator} không hiển thị

Kiểm tra element enabled
    [Documentation]    Kiểm tra element có enabled không
    [Arguments]    ${locator}
    
    Element Should Be Enabled    ${locator}
    Log    Element ${locator} đang enabled

Kiểm tra element disabled
    [Documentation]    Kiểm tra element có disabled không
    [Arguments]    ${locator}
    
    Element Should Be Disabled    ${locator}
    Log    Element ${locator} đang disabled

Kiểm tra text của element
    [Documentation]    Kiểm tra text của element
    [Arguments]    ${locator}    ${expected_text}
    
    ${actual_text}=    Get Text    ${locator}
    Should Be Equal    ${actual_text}    ${expected_text}
    Log    Text của element ${locator} khớp với mong đợi: ${expected_text}

Kiểm tra text chứa
    [Documentation]    Kiểm tra text của element có chứa text mong đợi
    [Arguments]    ${locator}    ${expected_text}
    
    ${actual_text}=    Get Text    ${locator}
    Should Contain    ${actual_text}    ${expected_text}
    Log    Text của element ${locator} chứa: ${expected_text}

Swipe lên
    [Documentation]    Swipe lên trên
    [Arguments]    ${duration}=1000
    
    ${size}=    Get Window Size
    ${start_x}=    Evaluate    ${size}[width] // 2
    ${start_y}=    Evaluate    int(${size}[height] * 0.8)
    ${end_x}=    Set Variable    ${start_x}
    ${end_y}=    Evaluate    int(${size}[height] * 0.2)
    
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${duration}
    Log    Đã swipe lên

Swipe xuống
    [Documentation]    Swipe xuống dưới
    [Arguments]    ${duration}=1000
    
    ${size}=    Get Window Size
    ${start_x}=    Evaluate    ${size}[width] // 2
    ${start_y}=    Evaluate    int(${size}[height] * 0.2)
    ${end_x}=    Set Variable    ${start_x}
    ${end_y}=    Evaluate    int(${size}[height] * 0.8)
    
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${duration}
    Log    Đã swipe xuống

Swipe trái
    [Documentation]    Swipe sang trái
    [Arguments]    ${duration}=1000
    
    ${size}=    Get Window Size
    ${start_x}=    Evaluate    int(${size}[width] * 0.8)
    ${start_y}=    Evaluate    ${size}[height] // 2
    ${end_x}=    Evaluate    int(${size}[width] * 0.2)
    ${end_y}=    Set Variable    ${start_y}
    
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${duration}
    Log    Đã swipe trái

Swipe phải
    [Documentation]    Swipe sang phải
    [Arguments]    ${duration}=1000
    
    ${size}=    Get Window Size
    ${start_x}=    Evaluate    int(${size}[width] * 0.2)
    ${start_y}=    Evaluate    ${size}[height] // 2
    ${end_x}=    Evaluate    int(${size}[width] * 0.8)
    ${end_y}=    Set Variable    ${start_y}
    
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${duration}
    Log    Đã swipe phải

Ẩn bàn phím
    [Documentation]    Ẩn bàn phím
    Hide Keyboard
    Log    Đã ẩn bàn phím

Quay lại
    [Documentation]    Quay lại màn hình trước
    Go Back
    Log    Đã quay lại màn hình trước

Chờ page load
    [Documentation]    Chờ page load xong
    [Arguments]    ${timeout}=${PAGE_LOAD_TIMEOUT}
    
    Sleep    2s
    Log    Đã chờ page load ${timeout}

Scroll đến element
    [Documentation]    Scroll đến element
    [Arguments]    ${locator}
    
    Scroll To Element    ${locator}
    Log    Đã scroll đến element: ${locator}

Scroll đến text
    [Documentation]    Scroll đến text
    [Arguments]    ${text}
    
    Scroll To Text    ${text}
    Log    Đã scroll đến text: ${text}

Tap element
    [Documentation]    Tap vào element
    [Arguments]    ${locator}    ${duration}=100
    
    Wait Until Element Is Visible    ${locator}
    Tap    ${locator}    ${duration}
    Log    Đã tap element: ${locator}

Long press element
    [Documentation]    Long press element
    [Arguments]    ${locator}    ${duration}=2000
    
    Wait Until Element Is Visible    ${locator}
    Long Press    ${locator}    ${duration}
    Log    Đã long press element: ${locator}

Xóa text
    [Documentation]    Xóa text của element
    [Arguments]    ${locator}
    
    Wait Until Element Is Visible    ${locator}
    Clear Text    ${locator}
    Log    Đã xóa text của element: ${locator}

Kiểm tra element tồn tại
    [Documentation]    Kiểm tra element có tồn tại không
    [Arguments]    ${locator}
    
    ${exists}=    Run Keyword And Return Status    Element Should Be Visible    ${locator}
    [Return]    ${exists}

Chờ và click element
    [Documentation]    Chờ element xuất hiện và click
    [Arguments]    ${locator}    ${timeout}=${EXPLICIT_TIMEOUT}
    
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Wait Until Element Is Enabled    ${locator}    ${timeout}
    Click Element    ${locator}
    Log    Đã chờ và click element: ${locator}

Chờ và nhập text
    [Documentation]    Chờ element xuất hiện và nhập text
    [Arguments]    ${locator}    ${text}    ${timeout}=${EXPLICIT_TIMEOUT}
    
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Input Text    ${locator}    ${text}
    Log    Đã chờ và nhập text '${text}' vào element: ${locator}

Kiểm tra element có text
    [Documentation]    Kiểm tra element có text không
    [Arguments]    ${locator}    ${expected_text}
    
    Wait Until Element Is Visible    ${locator}
    ${actual_text}=    Get Text    ${locator}
    Should Be Equal    ${actual_text}    ${expected_text}
    Log    Element ${locator} có text: ${expected_text}

Kiểm tra element chứa text
    [Documentation]    Kiểm tra element có chứa text không
    [Arguments]    ${locator}    ${expected_text}
    
    Wait Until Element Is Visible    ${locator}
    ${actual_text}=    Get Text    ${locator}
    Should Contain    ${actual_text}    ${expected_text}
    Log    Element ${locator} chứa text: ${expected_text} 