*** Settings ***
Documentation     Test cases cho chức năng đăng nhập
...               Sử dụng Gherkin syntax cho BDD

Library           AppiumLibrary
Library           ../keywords/MobileKeywords.py
Library           ../keywords/LoginKeywords.py
#Variables         ../config/robot_variables.py

Suite Setup       Khởi động ứng dụng mobile
Suite Teardown    Đóng ứng dụng mobile

Test Setup        Mở màn hình đăng nhập
Test Teardown     Chụp screenshot nếu test fail

*** Variables ***
${VALID_USERNAME}     testuser
${VALID_PASSWORD}     testpass
${INVALID_USERNAME}   invaliduser
${INVALID_PASSWORD}   invalidpass
${EMPTY_USERNAME}     ${EMPTY}
${EMPTY_PASSWORD}     ${EMPTY}

*** Test Cases ***
Đăng nhập thành công với thông tin hợp lệ
    [Documentation]    Kiểm tra đăng nhập thành công với username và password hợp lệ
    [Tags]    smoke    login    positive
    [Template]    Đăng nhập thành công
    
    # username    password
    ${VALID_USERNAME}    ${VALID_PASSWORD}
    admin    admin123
    user1    password1

Đăng nhập thất bại với thông tin không hợp lệ
    [Documentation]    Kiểm tra đăng nhập thất bại với username và password không hợp lệ
    [Tags]    regression    login    negative
    [Template]    Đăng nhập thất bại
    
    # username    password    expected_error
    ${INVALID_USERNAME}    ${INVALID_PASSWORD}    Tên đăng nhập hoặc mật khẩu không đúng
    ${VALID_USERNAME}    ${INVALID_PASSWORD}    Mật khẩu không đúng
    ${INVALID_USERNAME}    ${VALID_PASSWORD}    Tên đăng nhập không tồn tại

Đăng nhập thất bại với thông tin trống
    [Documentation]    Kiểm tra đăng nhập thất bại khi không nhập thông tin
    [Tags]    regression    login    negative    validation
    [Template]    Đăng nhập thất bại với thông tin trống
    
    # username    password    expected_error
    ${EMPTY_USERNAME}    ${VALID_PASSWORD}    Vui lòng nhập tên đăng nhập
    ${VALID_USERNAME}    ${EMPTY_PASSWORD}    Vui lòng nhập mật khẩu
    ${EMPTY_USERNAME}    ${EMPTY_PASSWORD}    Vui lòng nhập tên đăng nhập và mật khẩu

Kiểm tra giao diện màn hình đăng nhập
    [Documentation]    Kiểm tra các element trên màn hình đăng nhập
    [Tags]    smoke    login    ui
    Given Tôi đang ở màn hình đăng nhập
    Then Tôi thấy trường nhập tên đăng nhập
    And Tôi thấy trường nhập mật khẩu
    And Tôi thấy nút đăng nhập
    And Tôi thấy link quên mật khẩu
    And Tôi thấy link đăng ký

Kiểm tra validation khi nhập sai định dạng
    [Documentation]    Kiểm tra validation khi nhập sai định dạng
    [Tags]    regression    login    validation
    [Template]    Kiểm tra validation định dạng
    
    # username    password    expected_error
    test@user    ${VALID_PASSWORD}    Tên đăng nhập không được chứa ký tự đặc biệt
    ${VALID_USERNAME}    123    Mật khẩu phải có ít nhất 6 ký tự
    a    ${VALID_PASSWORD}    Tên đăng nhập phải có ít nhất 3 ký tự

Kiểm tra chức năng ẩn/hiện mật khẩu
    [Documentation]    Kiểm tra chức năng ẩn/hiện mật khẩu
    [Tags]    regression    login    ui
    Given Tôi đang ở màn hình đăng nhập
    When Tôi nhập mật khẩu "${VALID_PASSWORD}"
    And Tôi click nút hiển thị mật khẩu
    Then Tôi thấy mật khẩu được hiển thị
    When Tôi click nút ẩn mật khẩu
    Then Tôi thấy mật khẩu được ẩn

Kiểm tra chức năng "Ghi nhớ đăng nhập"
    [Documentation]    Kiểm tra chức năng ghi nhớ đăng nhập
    [Tags]    regression    login    feature
    Given Tôi đang ở màn hình đăng nhập
    When Tôi nhập tên đăng nhập "${VALID_USERNAME}"
    And Tôi nhập mật khẩu "${VALID_PASSWORD}"
    And Tôi tích vào checkbox "Ghi nhớ đăng nhập"
    And Tôi click nút đăng nhập
    Then Tôi thấy đăng nhập thành công
    When Tôi đóng và mở lại ứng dụng
    Then Tôi thấy đã được đăng nhập sẵn

*** Keywords ***
Khởi động ứng dụng mobile
    [Documentation]    Khởi động ứng dụng mobile
    log     ${ANDROID_DEVICE_NAME}
    Open Application    http://127.0.0.1:4723
    ...    platformName=${ANDROID_PLATFORM_NAME}
    ...    platformVersion=${ANDROID_PLATFORM_VERSION}
    ...    deviceName=${ANDROID_DEVICE_NAME}
    ...    appPackage=${ANDROID_APP_PACKAGE}
    ...    appActivity=${ANDROID_APP_ACTIVITY}
    ...    automationName=${ANDROID_AUTOMATION_NAME}
    ...    noReset=true

Đóng ứng dụng mobile
    [Documentation]    Đóng ứng dụng mobile
    Close Mobile Application

Mở màn hình đăng nhập
    [Documentation]    Mở màn hình đăng nhập
    Wait For Page Load
    Element Should Be Visible    id=com.example.app:id/username_field

Chụp screenshot nếu test fail
    [Documentation]    Chụp screenshot nếu test fail
    Run Keyword If Test Failed    Take Screenshot

Đăng nhập thành công
    [Arguments]    ${username}    ${password}
    [Documentation]    Template keyword cho đăng nhập thành công
    Given Tôi đang ở màn hình đăng nhập
    When Tôi nhập tên đăng nhập "${username}"
    And Tôi nhập mật khẩu "${password}"
    And Tôi click nút đăng nhập
    Then Tôi thấy đăng nhập thành công

Đăng nhập thất bại
    [Arguments]    ${username}    ${password}    ${expected_error}
    [Documentation]    Template keyword cho đăng nhập thất bại
    Given Tôi đang ở màn hình đăng nhập
    When Tôi nhập tên đăng nhập "${username}"
    And Tôi nhập mật khẩu "${password}"
    And Tôi click nút đăng nhập
    Then Tôi thấy thông báo lỗi "${expected_error}"

Đăng nhập thất bại với thông tin trống
    [Arguments]    ${username}    ${password}    ${expected_error}
    [Documentation]    Template keyword cho đăng nhập thất bại với thông tin trống
    Given Tôi đang ở màn hình đăng nhập
    When Tôi nhập tên đăng nhập "${username}"
    And Tôi nhập mật khẩu "${password}"
    And Tôi click nút đăng nhập
    Then Tôi thấy thông báo lỗi "${expected_error}"

Kiểm tra validation định dạng
    [Arguments]    ${username}    ${password}    ${expected_error}
    [Documentation]    Template keyword cho kiểm tra validation
    Given Tôi đang ở màn hình đăng nhập
    When Tôi nhập tên đăng nhập "${username}"
    And Tôi nhập mật khẩu "${password}"
    Then Tôi thấy thông báo lỗi "${expected_error}"

Tôi đang ở màn hình đăng nhập
    [Documentation]    Kiểm tra đang ở màn hình đăng nhập
    Element Should Be Visible    id=net.citigo.kiotviet.manager:id/tvUsername
    Element Should Be Visible    id=net.citigo.kiotviet.manager:id/textPassword
    Element Should Be Visible    id=net.citigo.kiotviet.manager:id/buttonLogin

Tôi thấy trường nhập tên đăng nhập
    [Documentation]    Kiểm tra trường nhập tên đăng nhập
    Element Should Be Visible    id=net.citigo.kiotviet.manager:id/tvUsername

Tôi thấy trường nhập mật khẩu
    [Documentation]    Kiểm tra trường nhập mật khẩu
    Element Should Be Visible    id=net.citigo.kiotviet.manager:id/textPassword

Tôi thấy nút đăng nhập
    [Documentation]    Kiểm tra nút đăng nhập
    Element Should Be Visible    id=com.example.app:id/login_button
    Element Should Be Enabled    id=com.example.app:id/login_button

Tôi thấy link quên mật khẩu
    [Documentation]    Kiểm tra link quên mật khẩu
    Element Should Be Visible    id=com.example.app:id/forgot_password_link

Tôi thấy link đăng ký
    [Documentation]    Kiểm tra link đăng ký
    Element Should Be Visible    id=com.example.app:id/register_link

Tôi nhập tên đăng nhập "${username}"
    [Documentation]    Nhập tên đăng nhập
    Input Text    id=com.example.app:id/username_field    ${username}

Tôi nhập mật khẩu "${password}"
    [Documentation]    Nhập mật khẩu
    Input Text    id=com.example.app:id/password_field    ${password}

Tôi click nút đăng nhập
    [Documentation]    Click nút đăng nhập
    Click Element    id=com.example.app:id/login_button
    Wait For Loading To Complete

Tôi thấy đăng nhập thành công
    [Documentation]    Kiểm tra đăng nhập thành công
    Wait For Element Not Visible    id=com.example.app:id/login_button
    Element Should Be Visible    id=com.example.app:id/dashboard

Tôi thấy thông báo lỗi "${expected_error}"
    [Documentation]    Kiểm tra thông báo lỗi
    Wait For Element Visible    id=com.example.app:id/error_message
    Element Text Should Contain    id=com.example.app:id/error_message    ${expected_error}

Tôi click nút hiển thị mật khẩu
    [Documentation]    Click nút hiển thị mật khẩu
    Click Element    id=com.example.app:id/show_password_button

Tôi thấy mật khẩu được hiển thị
    [Documentation]    Kiểm tra mật khẩu được hiển thị
    Element Should Be Visible    id=com.example.app:id/password_visible_icon

Tôi click nút ẩn mật khẩu
    [Documentation]    Click nút ẩn mật khẩu
    Click Element    id=com.example.app:id/hide_password_button

Tôi thấy mật khẩu được ẩn
    [Documentation]    Kiểm tra mật khẩu được ẩn
    Element Should Not Be Visible    id=com.example.app:id/password_visible_icon

Tôi tích vào checkbox "${checkbox_text}"
    [Documentation]    Tích vào checkbox
    Click Element    xpath=//android.widget.CheckBox[@text="${checkbox_text}"]

Tôi đóng và mở lại ứng dụng
    [Documentation]    Đóng và mở lại ứng dụng
    Close Mobile Application
    Start Mobile Application    android    ${ANDROID_DEVICE_NAME}    ${ANDROID_APP_PATH}

Tôi thấy đã được đăng nhập sẵn
    [Documentation]    Kiểm tra đã được đăng nhập sẵn
    Element Should Be Visible    id=com.example.app:id/dashboard
    Element Should Not Be Visible    id=com.example.app:id/login_button

Wait For Loading To Complete
    [Documentation]    Chờ loading hoàn thành
    Wait For Element Not Visible    id=com.example.app:id/loading_indicator    10s 