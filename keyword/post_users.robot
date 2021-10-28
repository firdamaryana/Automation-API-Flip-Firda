*** Settings ***
Documentation   Flip Technical Test
Resource        ${EXECDIR}/variable/post_users.robot

*** Variables ***
${params}           ${None}
${json_post_users}    ${EXECDIR}/json/post_users.json

*** Keywords ***
GENERAL - Create Users
    [Documentation]     Keyword generaly to create Users
    &{data_dict}=   Create Dictionary   name=valid  job=valid
    ${URI}=         Set Variable        api/users
    ${headers}=     Create Users - Define Headers
    ${jsonFile}=    Read JSON File From The Specified Path      ${json_post_users}
    ${payload}=     Create Users - Define Payload         ${jsonFile}     ${data_dict}
    Start agentsvc API Connection
    ${response}=    Send POST Request API   ${URI}      ${params}       ${payload}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     201
    ${id}=           Set Variable    ${response.json()['id']
    ${name}=         Set Variable    ${response.json()['name']
    ${job}=          Set Variable    ${response.json()['job']
    ${createdAt}=    Set Variable    ${response.json()['createdAt']
    &{result}=      Create Dictionary   id=${id}  email=${email }  first_name=${first_name}  last_name=${last_name}  avatar=${avatar}
    [Return]        ${result}

Create Users - Define Headers
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    [Return]                ${headers}

Generate Random String Alphabet X length
    [Arguments]             ${length}
    ${random}               Generate Random String        ${length}       [LETTERS]
    Log                     ${random}
    [return]                ${random}

Generate Valid Data For Create Users
    ${randomAlphabet}=      Generate Random String Alphabet X length        5
    ${name}=    Set Variable    Firda Flip ${randomAlphabet}
    ${job}=     Set Variable    Job Flip ${randomAlphabet}
    &{result}=      Create Dictionary   name=${name}      job=${job}
    Log                 ${result}
    [Return]            ${result}

Create Users - Define Payload
    [Arguments]     ${payload}     ${data_dict}
    ${valid_data}=  Generate Valid Data For Create Users
    ${exist_data}=  Get user existing data from database
    ${name}=    Run Keyword If  '${data_dict.name}'=='valid'    Set Variable    ${valid_data.name}
    ...                 ELSE IF         '${data_dict.name}'=='exist'  Set Variable    ${exist_data.name}
    ...                 ELSE IF         '${data_dict.name}'=='space'  Set Variable    ${SPACE}
    ...                 ELSE IF         '${data_dict.name}'=='blank'  Set Variable    ${EMPTY}
    ...                 ELSE    Convert Input To Correct Data Type     ${data_dict.name}
    ${job}=    Run Keyword If  '${data_dict.job}'=='valid'    Set Variable    ${valid_data.job}
    ...                 ELSE IF         '${data_dict.job}'=='exist'  Set Variable    ${exist_data.job}
    ...                 ELSE IF         '${data_dict.job}'=='space'  Set Variable    ${SPACE}
    ...                 ELSE IF         '${data_dict.job}'=='blank'  Set Variable    ${EMPTY}
    ...                 ELSE    Convert Input To Correct Data Type     ${data_dict.job}

    ${payload}=     Update or Delete Selected JSON Key      ${payload}      ${key_post_users_name}            ${name}
    ${payload}=     Update or Delete Selected JSON Key      ${payload}      ${key_post_users_job}             ${job}


    Set To Dictionary   ${data_dict}    name       ${name}
    Set To Dictionary   ${data_dict}    job         ${job}

    Log     ${payload}
    [Return]    ${payload}

Create Users - Compare Result After Process
    [Arguments]   ${data_dict}    ${response}
    # Compare with response json
    Run Keyword And Continue On Failure   Should Be Equal As Strings     ${data_dict.name}     ${response.json()['name']}
    Run Keyword And Continue On Failure   Should Be Equal As Strings     ${data_dict.job}      ${response.json()['job']}

#Ini hanya scenario jika terdapat table
Get user existing data from database
    [Arguments]     ${user_id}
    ${query}=   Set Variable    SELECT name,job FROM users
    ${query}=   Set Variable    ${query} WHERE is_deleted=0 AND is_active=1 ORDER BY RAND() LIMIT 1
    Start users DB Connection
    ${queryResult}=         Query           ${query}
    ${name}=        Set Variable            ${queryResult[0][0]}
    ${job}=         Set Variable            ${queryResult[0][1]}
    End DB Connection
    ${name}=        Set Variable    ${name}
    ${job}=         Set Variable    ${job}
    ${result}=          Create Dictionary       name=${name}    job=${job}
    Log                 ${result}
    [Return]            ${result}

#Ini hanya scenario jika terdapat table
Delete Users Based On Request Id
    [Arguments]     ${user_id}
    ${query}=   Set Variable    DELETE FROM users
    ${query}=   Set Variable    ${query} WHERE id='${user_id}'
    Start users DB Connection
    ${queryResult}=     Execute SQL String   ${query}
    End DB Connection