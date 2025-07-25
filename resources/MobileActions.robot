*** Settings ***
Library           AppiumLibrary
Library           BuiltIn
Library           Collections
Library           String

*** Variables ***
${DEFAULT_TIMEOUT}    20s
${SHORT_TIMEOUT}      10s
${LONG_TIMEOUT}       30s

*** Keywords ***
# ===== WAIT FUNCTIONS =====
Chờ Element Xuất Hiện
    [Documentation]    Chờ element xuất hiện với timeout mặc định
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Log    Element ${locator} đã xuất hiện

Chờ Element Biến Mất
    [Documentation]    Chờ element biến mất với timeout mặc định
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Page Does Not Contain Element    ${locator}    ${timeout}
    Log    Element ${locator} đã biến mất

Chờ Element Có Thể Click
    [Documentation]    Chờ element có thể click được
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Element Should Be Enabled    ${locator}
    Log    Element ${locator} đã có thể click

# ===== CLICK FUNCTIONS =====
Click Element An Toàn
    [Documentation]    Click element với việc chờ element xuất hiện trước
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Click Element    ${locator}
    Log    Đã click element: ${locator}

Click Element Nếu Có
    [Documentation]    Click element nếu element tồn tại, không báo lỗi nếu không tìm thấy
    [Arguments]    ${locator}    ${timeout}=${SHORT_TIMEOUT}
    ${status}=    Run Keyword And Return Status    Click Element An Toàn    ${locator}    ${timeout}
    Run Keyword If    ${status}    Log    Đã click element: ${locator}
    Run Keyword Unless    ${status}    Log    Element ${locator} không tìm thấy để click

Click Text
    [Documentation]    Click vào text
    [Arguments]    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Click Element    xpath=//*[@text="${text}"]
    Log    Đã click text: ${text}

Click Text An Toàn
    [Documentation]    Click text với việc chờ element xuất hiện trước
    [Arguments]    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    xpath=//*[@text="${text}"]    ${timeout}
    Click Text    ${text}
    Log    Đã click text an toàn: ${text}

# ===== INPUT FUNCTIONS =====
Nhập Text An Toàn
    [Documentation]    Nhập text vào element với việc chờ element xuất hiện trước
    [Arguments]    ${locator}    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Input Text    ${locator}    ${text}
    Log    Đã nhập text '${text}' vào element: ${locator}

Xóa Text Và Nhập
    [Documentation]    Xóa text cũ và nhập text mới
    [Arguments]    ${locator}    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Clear Text    ${locator}
    Input Text    ${locator}    ${text}
    Log    Đã xóa và nhập text '${text}' vào element: ${locator}

Nhập Text Từng Ký Tự
    [Documentation]    Nhập text từng ký tự một (hữu ích cho một số trường hợp đặc biệt)
    [Arguments]    ${locator}    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Clear Text    ${locator}
    FOR    ${char}    IN    @{text}
        Input Text    ${locator}    ${char}
        Sleep    0.1s
    END
    Log    Đã nhập text từng ký tự '${text}' vào element: ${locator}

# ===== VERIFICATION FUNCTIONS =====
Kiểm Tra Element Tồn Tại
    [Documentation]    Kiểm tra element có tồn tại không
    [Arguments]    ${locator}    ${timeout}=${SHORT_TIMEOUT}
    ${exists}=    Run Keyword And Return Status    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    [Return]    ${exists}

Kiểm Tra Text Tồn Tại
    [Documentation]    Kiểm tra text có tồn tại không
    [Arguments]    ${text}    ${timeout}=${SHORT_TIMEOUT}
    ${exists}=    Run Keyword And Return Status    Chờ Element Xuất Hiện    xpath=//*[@text="${text}"]    ${timeout}
    [Return]    ${exists}

Lấy Text Của Element
    [Documentation]    Lấy text của element
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    ${text}=    Get Text    ${locator}
    Log    Text của element ${locator}: ${text}
    [Return]    ${text}

Kiểm Tra Text Của Element
    [Documentation]    Kiểm tra text của element có đúng không
    [Arguments]    ${locator}    ${expected_text}    ${timeout}=${DEFAULT_TIMEOUT}
    ${actual_text}=    Lấy Text Của Element    ${locator}    ${timeout}
    Should Be Equal    ${actual_text}    ${expected_text}
    Log    Text của element ${locator} khớp với mong đợi: ${expected_text}

# ===== SCROLL FUNCTIONS =====
Scroll Đến Element
    [Documentation]    Scroll đến element
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    # Sử dụng swipe để scroll đến element
    Swipe Lên
    ${exists}=    Kiểm Tra Element Tồn Tại    ${locator}    ${timeout}
    Run Keyword Unless    ${exists}    Swipe Xuống
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Log    Đã scroll đến element: ${locator}

Scroll Đến Text
    [Documentation]    Scroll đến text
    [Arguments]    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    # Sử dụng swipe để scroll đến text
    Swipe Lên
    ${exists}=    Kiểm Tra Text Tồn Tại    ${text}    ${timeout}
    Run Keyword Unless    ${exists}    Swipe Xuống
    Chờ Element Xuất Hiện    xpath=//*[@text="${text}"]    ${timeout}
    Log    Đã scroll đến text: ${text}

# ===== SWIPE FUNCTIONS =====
Swipe Lên
    [Documentation]    Swipe lên trên màn hình
    [Arguments]    ${duration}=1000
    # Sử dụng tọa độ cố định thay vì Get Window Size
    Swipe    500    1500    500    500    ${duration}
    Log    Đã swipe lên

Swipe Xuống
    [Documentation]    Swipe xuống dưới màn hình
    [Arguments]    ${duration}=1000
    # Sử dụng tọa độ cố định thay vì Get Window Size
    Swipe    500    500    500    1500    ${duration}
    Log    Đã swipe xuống

Swipe Trái
    [Documentation]    Swipe sang trái
    [Arguments]    ${duration}=1000
    # Sử dụng tọa độ cố định thay vì Get Window Size
    Swipe    1000    1000    200    1000    ${duration}
    Log    Đã swipe trái

Swipe Phải
    [Documentation]    Swipe sang phải
    [Arguments]    ${duration}=1000
    # Sử dụng tọa độ cố định thay vì Get Window Size
    Swipe    200    1000    1000    1000    ${duration}
    Log    Đã swipe phải

# ===== TAP FUNCTIONS =====
Tap Element
    [Documentation]    Tap vào element
    [Arguments]    ${locator}    ${duration}=100    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Tap    ${locator}    ${duration}
    Log    Đã tap element: ${locator}

Long Press Element
    [Documentation]    Long press element
    [Arguments]    ${locator}    ${duration}=2000    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Long Press    ${locator}    ${duration}
    Log    Đã long press element: ${locator}

# ===== UTILITY FUNCTIONS =====
Chụp Screenshot
    [Documentation]    Chụp screenshot với tên file tùy chỉnh
    [Arguments]    ${filename}=${EMPTY}
    ${timestamp}=    Get Time    epoch
    ${screenshot_name}=    Set Variable If    '${filename}' == '${EMPTY}'    screenshot_${timestamp}.png    ${filename}
    Capture Page Screenshot    ${screenshot_name}
    Log    Đã chụp screenshot: ${screenshot_name}

Chờ Loading Hoàn Thành
    [Documentation]    Chờ loading indicator biến mất
    [Arguments]    ${loading_locator}=id=loading_indicator    ${timeout}=${LONG_TIMEOUT}
    ${status}=    Run Keyword And Return Status    Chờ Element Biến Mất    ${loading_locator}    ${timeout}
    Run Keyword If    ${status}    Log    Loading đã hoàn thành
    Run Keyword Unless    ${status}    Log    Không tìm thấy loading indicator hoặc loading chưa hoàn thành

Ẩn Bàn Phím
    [Documentation]    Ẩn bàn phím nếu đang hiển thị
    ${status}=    Run Keyword And Return Status    Hide Keyboard
    Run Keyword If    ${status}    Log    Đã ẩn bàn phím
    Run Keyword Unless    ${status}    Log    Bàn phím không hiển thị hoặc không thể ẩn

Quay Lại
    [Documentation]    Quay lại màn hình trước
    Go Back
    Log    Đã quay lại màn hình trước

# ===== CONDITIONAL FUNCTIONS =====
Click Nếu Element Tồn Tại
    [Documentation]    Click element nếu element tồn tại
    [Arguments]    ${locator}    ${timeout}=${SHORT_TIMEOUT}
    ${exists}=    Kiểm Tra Element Tồn Tại    ${locator}    ${timeout}
    Run Keyword If    ${exists}    Click Element An Toàn    ${locator}
    [Return]    ${exists}

Nhập Text Nếu Element Tồn Tại
    [Documentation]    Nhập text nếu element tồn tại
    [Arguments]    ${locator}    ${text}    ${timeout}=${SHORT_TIMEOUT}
    ${exists}=    Kiểm Tra Element Tồn Tại    ${locator}    ${timeout}
    Run Keyword If    ${exists}    Nhập Text An Toàn    ${locator}    ${text}
    [Return]    ${exists}

# ===== RETRY FUNCTIONS =====
Click Element Với Retry
    [Documentation]    Click element với retry nếu thất bại
    [Arguments]    ${locator}    ${max_attempts}=3    ${timeout}=${DEFAULT_TIMEOUT}
    FOR    ${attempt}    IN RANGE    1    ${max_attempts} + 1
        ${status}=    Run Keyword And Return Status    Click Element An Toàn    ${locator}    ${timeout}
        Run Keyword If    ${status}    Exit For Loop
        Run Keyword Unless    ${status}    Log    Lần thử ${attempt}: Click element ${locator} thất bại
        Run Keyword If    ${attempt} < ${max_attempts}    Sleep    1s
    END
    Should Be True    ${status}    Không thể click element ${locator} sau ${max_attempts} lần thử

Nhập Text Với Retry
    [Documentation]    Nhập text với retry nếu thất bại
    [Arguments]    ${locator}    ${text}    ${max_attempts}=3    ${timeout}=${DEFAULT_TIMEOUT}
    FOR    ${attempt}    IN RANGE    1    ${max_attempts} + 1
        ${status}=    Run Keyword And Return Status    Nhập Text An Toàn    ${locator}    ${text}    ${timeout}
        Run Keyword If    ${status}    Exit For Loop
        Run Keyword Unless    ${status}    Log    Lần thử ${attempt}: Nhập text vào ${locator} thất bại
        Run Keyword If    ${attempt} < ${max_attempts}    Sleep    1s
    END
    Should Be True    ${status}    Không thể nhập text vào element ${locator} sau ${max_attempts} lần thử

# ===== FORMAT STRING FUNCTIONS =====
Format XPath Locator
    [Documentation]    Format XPath locator với tham số
    [Arguments]    ${template}    ${param1}    ${param2}=${EMPTY}    ${param3}=${EMPTY}
    ${locator}=    Format String    ${template}    ${param1}    ${param2}    ${param3}
    [Return]    ${locator}

Format Text Locator
    [Documentation]    Format locator cho text element
    [Arguments]    ${text}
    ${locator}=    Format String    xpath=//*[@text='{0}']    ${text}
    [Return]    ${locator}

Format ID Locator
    [Documentation]    Format locator cho ID element
    [Arguments]    ${id_template}    ${param1}    ${param2}=${EMPTY}
    ${locator}=    Format String    id={0}    ${id_template}
    [Return]    ${locator}

Format Class Locator
    [Documentation]    Format locator cho class element
    [Arguments]    ${class_name}    ${index}=1
    ${locator}=    Format String    xpath=//*[@class='{0}'][{1}]    ${class_name}    ${index}
    [Return]    ${locator}

# ===== WAIT AND CLICK FUNCTIONS =====
Chờ Và Click Element
    [Documentation]    Chờ element xuất hiện rồi click
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Click Element    ${locator}
    Log    Đã chờ và click element: ${locator}

Chờ Và Click Text
    [Documentation]    Chờ text xuất hiện rồi click
    [Arguments]    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    ${text_locator}=    Format Text Locator    ${text}
    Chờ Và Click Element    ${text_locator}    ${timeout}
    Log    Đã chờ và click text: ${text}

Chờ Và Click Element Có Thể Click
    [Documentation]    Chờ element có thể click được rồi click
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Có Thể Click    ${locator}    ${timeout}
    Click Element    ${locator}
    Log    Đã chờ và click element có thể click: ${locator}

Chờ Và Click Element Với Retry
    [Documentation]    Chờ và click element với retry
    [Arguments]    ${locator}    ${max_attempts}=3    ${timeout}=${DEFAULT_TIMEOUT}
    FOR    ${attempt}    IN RANGE    1    ${max_attempts} + 1
        ${status}=    Run Keyword And Return Status    Chờ Và Click Element    ${locator}    ${timeout}
        Run Keyword If    ${status}    Exit For Loop
        Run Keyword Unless    ${status}    Log    Lần thử ${attempt}: Chờ và click element ${locator} thất bại
        Run Keyword If    ${attempt} < ${max_attempts}    Sleep    2s
    END
    Should Be True    ${status}    Không thể chờ và click element ${locator} sau ${max_attempts} lần thử

# ===== WAIT AND INPUT FUNCTIONS =====
Chờ Và Nhập Text
    [Documentation]    Chờ element xuất hiện rồi nhập text
    [Arguments]    ${locator}    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Input Text    ${locator}    ${text}
    Log    Đã chờ và nhập text '${text}' vào element: ${locator}

Chờ Và Nhập Text An Toàn
    [Documentation]    Chờ element xuất hiện rồi nhập text an toàn
    [Arguments]    ${locator}    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Clear Text    ${locator}
    Input Text    ${locator}    ${text}
    Log    Đã chờ và nhập text an toàn '${text}' vào element: ${locator}

Chờ Và Nhập Text Từng Ký Tự
    [Documentation]    Chờ element xuất hiện rồi nhập text từng ký tự
    [Arguments]    ${locator}    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Chờ Element Xuất Hiện    ${locator}    ${timeout}
    Clear Text    ${locator}
    FOR    ${char}    IN    @{text}
        Input Text    ${locator}    ${char}
        Sleep    0.1s
    END
    Log    Đã chờ và nhập text từng ký tự '${text}' vào element: ${locator}

Chờ Và Nhập Text Với Retry
    [Documentation]    Chờ và nhập text với retry
    [Arguments]    ${locator}    ${text}    ${max_attempts}=3    ${timeout}=${DEFAULT_TIMEOUT}
    FOR    ${attempt}    IN RANGE    1    ${max_attempts} + 1
        ${status}=    Run Keyword And Return Status    Chờ Và Nhập Text    ${locator}    ${text}    ${timeout}
        Run Keyword If    ${status}    Exit For Loop
        Run Keyword Unless    ${status}    Log    Lần thử ${attempt}: Chờ và nhập text vào ${locator} thất bại
        Run Keyword If    ${attempt} < ${max_attempts}    Sleep    2s
    END
    Should Be True    ${status}    Không thể chờ và nhập text vào element ${locator} sau ${max_attempts} lần thử 

# ===== FORMAT STRING FUNCTIONS =====
Format String And Click
    [Arguments]    ${template}    ${param1}
    ${locator}=    Format String    ${template}    ${param1}
    Click Element An Toàn    $locator

Format String And Visible
    [Arguments]    ${template}    ${param1}
    ${locator}=    Format String    ${template}    ${param1}
    Element Should Be Visible    ${locator}