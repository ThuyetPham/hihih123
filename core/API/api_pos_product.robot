*** Settings ***
Library       JSONLibrary
Library       RequestsLibrary
Library       BuiltIn
*** Keywords ***
Get id product ${product_code}
    ${header}     create dictionary    Content-Type=application/json     Authorization=${bearertoken_mobile}      retailer=${RETAILER_NAME}
    ${section}     create session    pro    ${MOBILE_API_URL}    headers=${header}    verify=True
    ${res}   GET On Session    pro    /branchs/searchproduct    params=SearchKey=DVT04&WarehouseId=79
    ${json_path}     set variable    $..Data[?(@.Code=="DVT04")].Id

    ${hihi}    Get Value From Json    ${res.json()}    ${json_path}



Get info product
