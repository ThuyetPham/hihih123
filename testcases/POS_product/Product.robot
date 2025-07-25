*** Settings ***
Library           AppiumLibrary
Resource         ../../config/Envi.robot
Resource         ../../core/POS_product/Product_action.robot

Suite Setup       Init Test Environment
#Suite Teardown    Close Application

#Test Setup        Login to Pos
#Test Teardown     Capture Page Screenshot

*** Variables ***
${product_code}        DVTM01
${current_unit}        cái
${new_unit}           hộp tự gen
${expected_message}    Thay đổi đơn vị tính thành công


*** Test Cases ***
KR2-96517-001: Thay đổi đơn vị tính sản phẩm
    [Documentation]     Click chuyển đổi đơn vị tính
    [Tags]    Product
    log     hihi
    Given lấy thông tin sản phẩm "${product_code}" từ API
#    And có sản phẩm "${product_code}" trong danh sách đơn hàng
#    And sản phẩm có đơn vị tính hiện tại là "${current_unit}"
#    When tôi click vào cột đơn vị tính của sản phẩm "${product_code}"
#    And chọn đơn vị tính mới là "${new_unit}"
#    Then đơn vị tính được thay đổi thành "${new_unit}"
#    And validate giá sản phẩm thay đổi chính xác theo API
##    And giá sản phẩm được tính lại theo đơn vị "${new_unit}"
##    And tổng tiền đơn hàng được cập nhật chính xác
##    And hiển thị thông báo "${expected_message}"


