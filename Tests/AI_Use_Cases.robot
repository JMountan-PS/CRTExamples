*** Settings ***
Resource    ../Resources/common.resource
Test Setup    Setup Browser
Test Teardown    Close All Browser Sessions

*** Test Cases ***
Create Opportunity
    Home