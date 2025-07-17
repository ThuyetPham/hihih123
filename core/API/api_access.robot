*** Settings ***
Library       JSONLibrary
*** Keywords ***
Get BearerToken from API
    [Timeout]    5 minutes
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}
    ${headers1}=    Create Dictionary    Content-Type=application/json    retailer=${RETAILER_NAME}
    Create Session    ali   ${SALE_API_URL}   headers=${headers1}    verify=True
    ${resp}=    Post Request    ali    /auth/salelogin    data=${credential}
    Log     ${SALE_API_URL}
    Log     ${headers1}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.json()}
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Return From Keyword    ${bearertoken}    ${resp.cookies}