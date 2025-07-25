*** Settings ***
Library       AppiumLibrary
Library       JSONLibrary
Library       OperatingSystem
Resource    ../core/API/api_access.robot
Resource    ../core/API/api_access_mobile.robot
Resource    ../core/Login/Login_action.robot


*** Keywords ***
Fill env
    log    ${env}
    ${DICT_API_URL}    Create Dictionary       ZONE6=https://auto6.kiotviet.vn/api
    ${DICT_RETAILER_NAME}    Create Dictionary      ZONE6=auto6
    ${DICT_BRANCH_ID}    Create Dictionary      ZONE6=172786
    ${DICT_LATESTBRANCH}    Create Dictionary     ZONE6=LatestBranch_366420_441968
    ${DICT_URL}    Create Dictionary        ZONE6=https://auto6.kiotviet.vn
    ${DICT_ADMIN}    Create Dictionary       ZONE6=admin
    ${DICT_PASSWORD}    Create Dictionary     ZONE6=Kiotviet12345678
    ${DICT_SALE_API_URL}    Create Dictionary    ZONE6=https://sale.kiotapi.com/api
    ${DICT_MOBILE_API_URL}    Create Dictionary      ZONE6=https://mobile.kiotapi.com
    ${DICT_BUNDLEID}    Create Dictionary     postouchp=net.citigo.kiotviet.touch
    ${DICT_ACTIVITY_NAME}    Create Dictionary     postouchp=net.citigo.kiotviet.ui.SplashScreenActivity
    ${DICT_PLATFORM_NAME}    Create Dictionary     postouchp=Android
    ${DICT_PLATFORM_VER}    Create Dictionary     postouchp=9.0
    ${DICT_AUTOMATION_NAME}       Create Dictionary    postouchp=UiAutomator2
    ${DICT_DEVICENAME}    Create Dictionary      postouchp=emulator-5554

    ${API_URL}    Get From Dictionary    ${DICT_API_URL}    ${env}
    ${BRANCH_ID}    Get From Dictionary    ${DICT_BRANCH_ID}    ${env}
    ${LATESTBRANCH}    Get From Dictionary    ${DICT_LATESTBRANCH}    ${env}
    ${URL}    Get From Dictionary    ${DICT_URL}    ${env}
    ${USER_ADMIN}    Get From Dictionary    ${DICT_ADMIN}    ${env}
    ${PASSWORD}    Get From Dictionary    ${DICT_PASSWORD}    ${env}
    ${RETAILER_NAME}    Get From Dictionary    ${DICT_RETAILER_NAME}    ${env}
    ${SALE_API_URL}    Get From Dictionary    ${DICT_SALE_API_URL}    ${env}
    ${MOBILE_API_URL}    Get From Dictionary    ${DICT_MOBILE_API_URL}    ${env}
    ${BUNDLE_ID}    Get From Dictionary    ${DICT_BUNDLEID}    ${screen}
    ${ACTIVITY_NAME}    Get From Dictionary    ${DICT_ACTIVITY_NAME}    ${screen}
    ${PLATFORM_NAME}     Get From Dictionary     ${DICT_PLATFORM_NAME}    ${screen}
    ${PLATFORM_VER}     Get From Dictionary     ${DICT_PLATFORM_VER}    ${screen}
    ${AUTOMATION_NAME}       Get From Dictionary    ${DICT_AUTOMATION_NAME}     ${screen}
    ${DEVICE}    Get From Dictionary    ${DICT_DEVICENAME}    ${device}
    Set Global Variable    \${PLATFORM_NAME}    ${PLATFORM_NAME}
    Set Global Variable    \${PLATFORM_VER}    ${PLATFORM_VER}
    Set Global Variable    \${DEVICE_NAME}    ${DEVICE}
    Set Global Variable    \${AUTOMATION_NAME}   ${AUTOMATION_NAME}
    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${BRANCH_ID}    ${BRANCH_ID}
    Set Global Variable    \${LATESTBRANCH}    ${LATESTBRANCH}
    Set Global Variable    \${URL}    ${URL}
    Set Global Variable    \${USER_NAME}    ${USER_ADMIN}
    Set Global Variable    \${PASSWORD}    ${PASSWORD}
    Set Global Variable    \${RETAILER_NAME}    ${RETAILER_NAME}
    Set Global Variable    \${SALE_API_URL}    ${SALE_API_URL}
    Set Global Variable    \${BUNDLE_ID}    ${BUNDLE_ID}
    Set Global Variable    \${ACTIVITY_NAME}    ${ACTIVITY_NAME}
    Set Global Variable    \${MOBILE_API_URL}    ${MOBILE_API_URL}


Init Test Environment
    Fill env
#    Test API Connection
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    ${token_value_mobile}    ${resp.cookies_mobile}    Get mobile BearerToken from API
    Set Global Variable    \${bearertoken_mobile}    ${token_value_mobile}
    Set Global Variable    \${resp.cookies_mobile}    ${resp.cookies_mobile}
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Append To Environment Variable    PATH    ${EXECDIR}${/}drivers

