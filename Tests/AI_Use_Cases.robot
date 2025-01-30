*** Settings ***
Documentation       Opportunity CRUD operations test suite
Resource            ../Resources/common.resource
Test Setup          Setup Browser
Test Teardown       Close All Browser Sessions

*** Variables ***
${output_dir}       ${CURDIR}/../../output
${log_file}         log-${TODAY}.txt

*** Keywords ***
Create Opportunity Record
    [Arguments]    ${opp_data}
    [Documentation]    Creates an opportunity with provided dictionary data
    ...                Expected dictionary keys:
    ...                name, stage, close_date, amount, type, 
    ...                lead_source, next_step, description, probability
    
    TRY
        LaunchApp    Sales
        ClickText    Opportunities
        ClickText    New
        
        TypeText     Opportunity Name     ${opp_data}[name]
        PickList     Stage               ${opp_data}[stage]
        TypeText     Close Date          ${opp_data}[close_date]
        TypeText     Amount              ${opp_data}[amount]
        PickList     Type                ${opp_data}[type]
        PickList     Lead Source         ${opp_data}[lead_source]
        TypeText     Next Step           ${opp_data}[next_step]
        TypeText     Description         ${opp_data}[description]
        TypeText     Probability         ${opp_data}[probability]
        
        ClickText    Save
    EXCEPT    AS    ${error}
        Append To File    ${output_dir}/${log_file}    
        ...    Error creating opportunity: ${error}
        Fail    Opportunity creation failed: ${error}
    END

Verify Opportunity Record
    [Arguments]    ${opp_data}
    [Documentation]    Verifies opportunity fields match provided dictionary data
    
    TRY
        VerifyText     ${opp_data}[name]
        VerifyField    Stage               ${opp_data}[stage]
        VerifyField    Amount              $${opp_data}[amount]
        VerifyField    Close Date          ${opp_data}[close_date]
    EXCEPT    AS    ${error}
        Append To File    ${output_dir}/${log_file}    
        ...    Error verifying opportunity: ${error}
        Fail    Opportunity verification failed: ${error}
    END

Update Opportunity Record
    [Arguments]    ${opp_name}    ${updated_data}
    [Documentation]    Updates an opportunity with provided dictionary data
    ...                Expected dictionary keys for updates:
    ...                stage, amount, next_step
    
    TRY
        LaunchApp    Sales
        ClickText    Opportunities
        TypeText     Search this list...    ${opp_name}
        ClickText    ${opp_name}
        ClickText    Edit
        
        PickList     Stage        ${updated_data}[stage]
        TypeText     Amount       ${updated_data}[amount]
        TypeText     Next Step    ${updated_data}[next_step]
        
        ClickText    Save
    EXCEPT    AS    ${error}
        Append To File    ${output_dir}/${log_file}    
        ...    Error updating opportunity: ${error}
        Fail    Opportunity update failed: ${error}
    END

Delete Opportunity Record
    [Arguments]    ${opp_name}
    [Documentation]    Deletes the specified opportunity
    
    TRY
        LaunchApp    Sales
        ClickText    Opportunities
        TypeText     Search this list...    ${opp_name}
        ClickText    ${opp_name}
        ClickText    Delete
        UseModal     on
        ClickText    Delete
        UseModal     off
    EXCEPT    AS    ${error}
        Append To File    ${output_dir}/${log_file}    
        ...    Error deleting opportunity: ${error}
        Fail    Opportunity deletion failed: ${error}
    END

*** Test Cases ***
Create And Verify New Opportunity
    [Documentation]    Creates and verifies a new opportunity with all standard fields
    [Tags]    opportunity    create    smoke
    
    ${opp_data}=    Create Dictionary
    ...    name=Test Automation Opportunity
    ...    stage=Prospecting
    ...    close_date=12/31/2025
    ...    amount=10000
    ...    type=New Customer
    ...    lead_source=Web
    ...    next_step=Initial Contact
    ...    description=This is a test opportunity created by CRT
    ...    probability=10
    
    Create Opportunity Record    ${opp_data}
    Verify Opportunity Record    ${opp_data}

Edit And Verify Opportunity
    [Documentation]    Edits and verifies changes to an existing opportunity
    [Tags]    opportunity    edit    smoke
    
    ${updated_data}=    Create Dictionary
    ...    stage=Qualification
    ...    amount=20000
    ...    next_step=Follow-up Meeting
    
    Update Opportunity Record    Test Automation Opportunity    ${updated_data}
    
    # Verify the updates
    VerifyField    Stage        Qualification
    VerifyField    Amount       $20,000.00
    VerifyField    Next Step    Follow-up Meeting

Delete And Verify Opportunity
    [Documentation]    Deletes an opportunity and verifies deletion
    [Tags]    opportunity    delete    smoke
    
    Delete Opportunity Record    Test Automation Opportunity
    TypeText    Search this list...    Test Automation Opportunity
    VerifyText    No items to display    timeout=5