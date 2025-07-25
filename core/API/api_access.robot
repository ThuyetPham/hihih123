*** Settings ***
Library       JSONLibrary
Library       RequestsLibrary
Resource       ../../config/Envi.robot
Documentation    API Access Keywords for KiotViet Integration

*** Keywords ***
Get BearerToken from API
    [Documentation]    Lấy Bearer Token từ KiotViet API
    [Timeout]    5 minutes
    [Return]    ${bearertoken}    ${resp.cookies}
    
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}
    ${headers1}=    Create Dictionary    Content-Type=application/json    retailer=${RETAILER_NAME}
    
    # Tạo session với timeout và retry
    Create Session    ali    https://api-man1.kiotviet.vn/api    headers=${headers1}    verify=True    timeout=30
    
    # Gọi API với error handling
    TRY
        ${resp}=    POST On Session    ali    /auth/salelogin    json=${credential}
        Log    API URL: https://api-man1.kiotviet.vn/api
        Log    Headers: ${headers1}
        Log    Response Status: ${resp.status_code}
        
        # Kiểm tra status code
        Should Be Equal As Strings    ${resp.status_code}    200    API call failed with status ${resp.status_code}
        
        # Log response
        Log    Response JSON: ${resp.json()}
        Log    Response Cookies: ${resp.cookies}
        
        # Lấy Bearer Token
        ${bearertoken}=    Get Value From Json    ${resp.json()}    $..BearerToken
        Log    Raw Bearer Token: ${bearertoken}
        
        # Xử lý Bearer Token
        ${bearertoken}=    Get From List    ${bearertoken}    0
        ${bearertoken}=    Catenate    Bearer    ${bearertoken}
        Log    Final Bearer Token: ${bearertoken}
        
    EXCEPT    AS    ${error}
        Log    Error calling API: ${error}
        Fail    Failed to get Bearer Token: ${error}
    END