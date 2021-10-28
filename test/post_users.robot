*** Settings ***
Documentation   Flip Technical Test
Resource        ${EXECDIR}/keyword/post_users.robot
Library         DataDriver  ${EXECDIR}/csv/post_users.csv
Library         RequestsLibrary
Library         ${EXECDIR}/library/csvLibrary.py
Library         JSONLibrary
Library         String
Default Tags    flip
Test Teardown   API.End API Connection
Test Template   Create Users

*** Variables ***
${Base_Url}           https://reqres.in/
${json_post_users}    ${EXECDIR}/json/post_users.json
${params}             ${None}

*** Keywords ***
Create Users
      [Arguments]       ${test_number}   ${test_type}    ${name}   ${job}  ${expected_http_status_code}    ${test_desc}
        &{data_dict}=   Create Dictionary    test_type=${test_type}  test_number=${test_number}  name=${name}    job=${job}
        ...             expected_http_status_code=${expected_http_status_code}
        ${URI}=         Set Variable        ${Base_Url}/api/users
        ${headers}=     Create Users - Define Headers
        ${jsonFile}=    Read JSON File From The Specified Path      ${json_post_users}
        ${payload}=     Create Users - Define Payload        ${jsonFile}  ${data_dict}
        create session  Post_users  ${Base_Url}
        ${response}=    Send POST Request API   ${URI}      ${params}       ${payload}
        Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
        Run Keyword If    '${data_dict.test_type}'=='P'      Create Users - Compare Result After Process    ${data_dict}    ${response}
        Run Keyword If    '${response.status_code}'=='201'   Delete Users Based On Request Id    ${response.json()['id']}
      API.End API Connection

*** Test Cases ***
Create Users-${test_desc}  ${test_number}  ${name}   ${job}  ${expected_http_status_code}