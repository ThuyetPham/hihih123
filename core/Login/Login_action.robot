*** Settings ***
Library     AppiumLibrary
Resource    ../../config/Envi.robot
Resource    ../../resources/MobileActions.robot

*** Variables ***
# Locators cho KiotViet Touch app
${textbox_retailername_pos}    id=net.citigo.kiotviet.touch:id/tvShop
${textbox_username_pos}        id=net.citigo.kiotviet.touch:id/tvUsername
${textbox_pass_pos}            id=net.citigo.kiotviet.touch:id/textPassword
${button_login_pos}            id=net.citigo.kiotviet.touch:id/buttonLogin

*** Keywords ***
Login To POS
    [Documentation]    Đăng nhập vào KiotViet Touch POS
    log    ${PLATFORM_NAME}
    log     ${remote}
    log     ${AUTOMATION_NAME}
    # Mở ứng dụng
    Open Application    ${remote}    
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VER}    
    ...    deviceName=${DEVICE_NAME}    
    ...    appPackage=${BUNDLE_ID}    
    ...    appActivity=${ACTIVITY_NAME}    
    ...    automationName=${AUTOMATION_NAME}    
    ...    noReset=false
    
    # Đăng nhập
    Nhập Text An Toàn    ${textbox_retailername_pos}    ${RETAILER_NAME}
    Nhập Text An Toàn    ${textbox_username_pos}    ${USER_NAME}
    Nhập Text An Toàn    ${textbox_pass_pos}    ${PASSWORD}
    
    # Click đăng nhập
    Click Element An Toàn    ${button_login_pos}
    
    # Chờ đăng nhập thành công
#    Chờ Element Xuất Hiện    id=net.citigo.kiotviet.touch:id/dashboard

Launch POS Application
    [Documentation]    Mở ứng dụng KiotViet Touch POS
    Open Application    ${remote}    
    ...    platformName=${PLATFORM_NAME}    
    ...    platformVersion=${PLATFORM_VER}    
    ...    deviceName=${DEVICE_NAME}    
    ...    appPackage=${BUNDLE_ID}    
    ...    appActivity=${ACTIVITY_NAME}    
    ...    automationName=${AUTOMATION_NAME}    
    ...    noReset=true

Close POS Application
    [Documentation]    Đóng ứng dụng KiotViet Touch POS
    Close Application

Login To POS With Retry
    [Documentation]    Đăng nhập với retry mechanism
    [Arguments]    ${retailer_name}    ${user_name}    ${password}    ${max_attempts}=3
    
    FOR    ${attempt}    IN RANGE    1    ${max_attempts} + 1
        ${status}=    Run Keyword And Return Status    
        ...    Login To POS    ${retailer_name}    ${user_name}    ${password}
        
        Run Keyword If    ${status}    Exit For Loop
        
        Run Keyword Unless    ${status}    Log    Lần thử ${attempt}: Đăng nhập thất bại
        Run Keyword If    ${attempt} < ${max_attempts}    Sleep    2s
    END
    
    Should Be True    ${status}    Không thể đăng nhập sau ${max_attempts} lần thử

