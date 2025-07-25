*** Settings ***
Library           AppiumLibrary
Library           String
Resource         ../../config/Envi.robot
Resource         ../../core/API/api_pos_product.robot
Resource         Product_page.robot

*** Keywords ***
# ===== GIVEN KEYWORDS =====
lấy thông tin sản phẩm "${product_code}" từ API
    Get id product 123

có sản phẩm "${product_code}" trong danh sách đơn hàng
    Nhập Text An Toàn     ${product_search_field}     ${product_code}
    Click Element An Toàn    ${product_item_container}

sản phẩm có đơn vị tính hiện tại là "${unit}"
    Format String And Visible     ${unit_text_template}    ${unit}

# ===== WHEN KEYWORDS =====
tôi click vào cột đơn vị tính của sản phẩm "${product_code}"
   Format String And Click   ${product_unit_column_template}    ${product_code}

chọn đơn vị tính mới là "${new_unit}"
   Format String And Click    ${unit_text_template}    ${new_unit}

# ===== THEN KEYWORDS =====
đơn vị tính được thay đổi thành "${new_unit}"
    Format String And Visible    ${unit_text_template}    ${new_unit}

# giá sản phẩm được tính lại theo đơn vị "${unit}"
#     Format String And Visible    ${product_price}

