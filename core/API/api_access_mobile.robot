*** Settings ***
Library       JSONLibrary
Library       RequestsLibrary
Resource       ../../config/Envi.robot
Documentation    Mobile API Access Keywords for KiotViet Integration

*** Keywords ***
Get mobile BearerToken from API
    [Documentation]    Lấy Bearer Token từ KiotViet Mobile API
    [Timeout]    5 minutes
    [Return]    ${bearertoken_mobile}    ${resp.cookies}
    
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}    UseTokenCookie=true    provider=credentials
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}    DeviceId=140096b2-4f9a-4528-80fa-c8517b78608d
    
    # Tạo session với timeout và retry
    Create Session    ali    ${MOBILE_API_URL}    headers=${headers1}    verify=True    timeout=30
    
    # Gọi API với error handling
    TRY
        ${resp}=    POST On Session    ali    /auth/credentials    json=${credential}
        Log    Mobile API URL: ${MOBILE_API_URL}
        Log    Headers: ${headers1}
        Log    Response Status: ${resp.status_code}
        
        # Kiểm tra status code
        Should Be Equal As Strings    ${resp.status_code}    200    Mobile API call failed with status ${resp.status_code}
        
        # Log response
        Log    Response JSON: ${resp.json()}
        Log    Response Cookies: ${resp.cookies}
        
        # Lấy Bearer Token
        ${bearertoken_mobile}=    Get Value From Json    ${resp.json()}    $..BearerToken
        Log    Raw Mobile Bearer Token: ${bearertoken_mobile}
        
        # Xử lý Bearer Token
        ${bearertoken_mobile}=    Get From List    ${bearertoken_mobile}    0
        ${bearertoken_mobile}=    Catenate    Bearer    ${bearertoken_mobile}
        Log    Final Mobile Bearer Token: ${bearertoken_mobile}
        
    EXCEPT    AS    ${error}
        Log    Error calling Mobile API: ${error}
        Fail    Failed to get Mobile Bearer Token: ${error}
    END
