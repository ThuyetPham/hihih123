*** Settings ***
Library           String

*** Variables ***
# ===== PRODUCT SEARCH ELEMENTS =====
${product_search_field}    id=net.citigo.kiotviet.touch:id/edt_tool_search
${product_item_container}    id=net.citigo.kiotviet.touch:id/rlItem

# ===== PRODUCT UNIT ELEMENTS =====
${product_unit_column_template}    xpath=//*[@text='{0}']/following-sibling::*[@resource-id='net.citigo.kiotviet.touch:id/tvProductUnit']
${unit_text_template}    xpath=//*[@text='{0}']
${unit_dropdown}    id=unit_dropdown
${unit_input_field}    id=unit_input
${product_unit_disabled}    id=product_unit

# ===== PRODUCT PRICE ELEMENTS =====
${product_price}    id=product_price

# ===== ORDER TOTAL ELEMENTS =====
${order_total}    id=order_total

# ===== MESSAGE ELEMENTS =====
${message_text_template}    xpath=//*[@text='{0}']
