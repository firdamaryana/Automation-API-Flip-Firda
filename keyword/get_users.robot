*** Settings ***
Documentation   Flip technical test

*** Keywords ***
Get Users - Define Headers
    &{headers}=     Create Dictionary   Accept=application/json     Content-Type=application/json
    Log     ${headers}
    Set Global Variable     ${headers}
    [Return]    ${headers}

Get Users - Define Query Parameters
    [Arguments]     ${data_dict}
    ${valid_data}=  Generate Valid Data For Get Users
    ${page}=    Run Keyword If  '${data_dict.page}'=='valid'    Set Variable    ${valid_data.page}
    ...         ELSE IF         '${data_dict.page}'=='space'  Set Variable    ${SPACE}
    ...         ELSE IF         '${data_dict.page}'=='blank'  Set Variable    ${EMPTY}
    ...         ELSE    Set Variable     ${data_dict.page}

    Set To Dictionary   ${data_dict}    page            ${page}

    &{param}=   Create Dictionary
    Run Keyword If      '${page}'!='none'       Set To Dictionary   ${param}    page        ${page}
    [Return]    ${param}

Generate Valid Data For Get Users
    ${page}=    Random Int  min=1   max=2
    &{result}=  Create Dictionary   page=${page}
    [Return]    ${result}

Get Users - Compare Result After Process
    [Arguments]     ${data_dict}    ${response}
    #Compare with response json
        Run Keyword And Continue On Failure   Should Be Equal As Integers     ${data_dict.page}     ${response.json()['page']}
