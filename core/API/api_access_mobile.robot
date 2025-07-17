*** Settings ***
Library       JSONLibrary
*** Keywords ***
Get mobile BearerToken from API
    [Timeout]    5 minutes
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}    UseTokenCookie=true     provider=credentials
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}     DeviceId=140096b2-4f9a-4528-80fa-c8517b78608d
    Create Session    ali    ${MOBILE_API_URL}    headers=${headers1}    verify=True
    ${resp}=    Post Request    ali    /auth/credentials    data=${credential}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.json()}
    Log    ${resp.cookies}
    ${bearertoken_mobile}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken_mobile}
    ${bearertoken_mobile}=    Evaluate    ${bearertoken_mobile}[0] if ${bearertoken_mobile} else 0    modules=random, sys
    ${bearertoken_mobile}=    Catenate    Bearer    ${bearertoken_mobile}
    Log    ${bearertoken_mobile}
    Return From Keyword    ${bearertoken_mobile}    ${resp.cookies}
