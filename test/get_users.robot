*** Settings ***
Documentation   Flip Technical Test
Resource        ${EXECDIR}/keyword/get_users.robot
Library         DataDriver  ${EXECDIR}/csv/get_users.csv
Library         RequestsLibrary
Library         ${EXECDIR}/library/csvLibrary.py
Library         JSONLibrary
Library         String
Default Tags    flip
Test Teardown   API.End API Connection
Test Template   Get Users

*** Variables ***
${Base_Url}=        https://reqres.in/

*** Keywords ***
Get Users
      [Arguments]       ${test_number}   ${test_type}    ${page}   ${expected_http_status_code}    ${test_desc}
        &{data_dict}=   Create Dictionary    test_type=${test_type}  test_number=${test_number}  page=${page}
        ...             expected_http_status_code=${expected_http_status_code}
        ${URI}=         Set Variable        ${Base_Url}/api/users
        ${headers}=     Get Users - Define Headers
        ${params}=      Get Request Pickup - Define Parameters From CSV     ${data_dict}
        create session  Get_users  ${Base_Url}
        ${response}=    Send GET Request API   ${URI}      ${params}
        Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
        Run Keyword If    '${response.status_code}'=='200'      Get Users - Compare Result After Process    ${data_dict}    ${response}
        API.End API Connection

*** Test Cases ***
Get Users-${test_desc}  ${test_number}  ${page}   ${expected_http_status_code}