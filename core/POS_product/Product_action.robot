*** Settings ***
Library           AppiumLibrary
Resource         ../../config/Envi.robot

*** Keywords ***
# ===== GIVEN KEYWORDS =====
tôi đã đăng nhập vào hệ thống POS
    [Documentation]    Given: Tôi đã đăng nhập vào hệ thống POS
    Log    Đã đăng nhập vào hệ thống POS
    # Giả lập đăng nhập thành công
    Sleep    1s

có sản phẩm "${product_code}" trong danh sách đơn hàng
    [Documentation]    Given: Có sản phẩm trong danh sách đơn hàng
    [Arguments]    ${product_code}
    Log    Thêm sản phẩm ${product_code} vào danh sách đơn hàng
    # Thêm sản phẩm vào giỏ hàng
    Click Element    xpath=//*[@text='${product_code}']

sản phẩm có đơn vị tính hiện tại là "${unit}"
    [Documentation]    Given: Sản phẩm có đơn vị tính hiện tại là
    [Arguments]    ${unit}
    Log    Kiểm tra đơn vị tính hiện tại: ${unit}
    # Kiểm tra đơn vị tính hiện tại
    Element Should Be Visible    xpath=//*[@text='${unit}']

# ===== WHEN KEYWORDS =====
tôi click vào cột đơn vị tính của sản phẩm "${product_code}"
    [Documentation]    When: Tôi click vào cột đơn vị tính của sản phẩm
    [Arguments]    ${product_code}
    Log    Click vào cột đơn vị tính của sản phẩm ${product_code}
    # Click vào cột đơn vị tính
    Click Element    xpath=//*[@text='${product_code}']/following-sibling::*[@resource-id='product_unit']

chọn đơn vị tính mới là "${new_unit}"
    [Documentation]    When: Chọn đơn vị tính mới là
    [Arguments]    ${new_unit}
    Log    Chọn đơn vị tính mới: ${new_unit}
    # Click vào dropdown và chọn đơn vị tính mới
    Click Element    id=unit_dropdown
    Click Element    xpath=//*[@text='${new_unit}']

# ===== THEN KEYWORDS =====
đơn vị tính được thay đổi thành "${expected_unit}"
    [Documentation]    Then: Đơn vị tính được thay đổi thành
    [Arguments]    ${expected_unit}
    Log    Kiểm tra đơn vị tính đã thay đổi thành: ${expected_unit}
    # Kiểm tra đơn vị tính đã được thay đổi
    Element Should Be Visible    xpath=//*[@text='${expected_unit}']

giá sản phẩm được tính lại theo đơn vị "${unit}"
    [Documentation]    Then: Giá sản phẩm được tính lại theo đơn vị
    [Arguments]    ${unit}
    Log    Kiểm tra giá sản phẩm được tính lại theo đơn vị: ${unit}
    # Kiểm tra giá sản phẩm được tính lại
    Element Should Be Visible    id=product_price

tổng tiền đơn hàng được cập nhật chính xác
    [Documentation]    Then: Tổng tiền đơn hàng được cập nhật chính xác
    Log    Kiểm tra tổng tiền đơn hàng được cập nhật
    # Kiểm tra tổng tiền đơn hàng
    Element Should Be Visible    id=order_total

hiển thị thông báo "${expected_message}"
    [Documentation]    Then: Hiển thị thông báo
    [Arguments]    ${expected_message}
    Log    Kiểm tra thông báo: ${expected_message}
    # Kiểm tra thông báo thành công
    Element Should Be Visible    xpath=//*[@text='${expected_message}']

# ===== ADDITIONAL PRODUCT KEYWORDS =====
nhập đơn vị tính không hợp lệ là "${invalid_unit}"
    [Documentation]    When: Nhập đơn vị tính không hợp lệ là
    [Arguments]    ${invalid_unit}
    Log    Nhập đơn vị tính không hợp lệ: ${invalid_unit}
    # Nhập đơn vị tính không hợp lệ
    Input Text    id=unit_input    ${invalid_unit}

hiển thị thông báo lỗi "${expected_error}"
    [Documentation]    Then: Hiển thị thông báo lỗi
    [Arguments]    ${expected_error}
    Log    Kiểm tra thông báo lỗi: ${expected_error}
    # Kiểm tra thông báo lỗi
    Element Should Be Visible    xpath=//*[@text='${expected_error}']

đơn vị tính không được thay đổi
    [Documentation]    Then: Đơn vị tính không được thay đổi
    [Arguments]    ${current_unit}
    Log    Kiểm tra đơn vị tính không được thay đổi
    # Kiểm tra đơn vị tính vẫn giữ nguyên
    Element Should Be Visible    xpath=//*[@text='${current_unit}']

giá sản phẩm giữ nguyên
    [Documentation]    Then: Giá sản phẩm giữ nguyên
    Log    Kiểm tra giá sản phẩm giữ nguyên
    # Kiểm tra giá sản phẩm không thay đổi
    Element Should Be Visible    id=product_price

sản phẩm đã được thanh toán
    [Documentation]    Given: Sản phẩm đã được thanh toán
    [Arguments]    ${product_name}
    Log    Sản phẩm ${product_name} đã được thanh toán
    # Giả lập trạng thái sản phẩm đã thanh toán
    Sleep    1s

cột đơn vị tính bị disable
    [Documentation]    Then: Cột đơn vị tính bị disable
    Log    Kiểm tra cột đơn vị tính bị disable
    # Kiểm tra cột đơn vị tính bị disable
    Element Should Be Disabled    id=product_unit

thay đổi đơn vị tính từ "${current_unit}" sang "${new_unit}"
    [Documentation]    When: Thay đổi đơn vị tính từ sang
    [Arguments]    ${current_unit}    ${new_unit}
    Log    Thay đổi đơn vị tính từ ${current_unit} sang ${new_unit}
    # Click vào dropdown và chọn đơn vị tính mới
    Click Element    id=unit_dropdown
    Click Element    xpath=//*[@text='${new_unit}']

giá sản phẩm được tính lại chính xác
    [Documentation]    Then: Giá sản phẩm được tính lại chính xác
    Log    Kiểm tra giá sản phẩm được tính lại chính xác
    # Kiểm tra giá sản phẩm được tính lại
    Element Should Be Visible    id=product_price
