*** Settings ***

Documentation        New test suite
# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library              QForce
Library              QImage
Library              OperatingSystem
Suite Setup          Open Browser                about:blank    chrome
Suite Teardown       Close All Browsers

*** Test Cases ***


Image Verification
    [Tags]            QImage
    GoTo             https://www.timeanddate.com/timer/
    ${FirstImage}=   LogScreenshot

    Log Variables    level=WARN

    ClickText        Start
    Sleep            20s
    ClickText        Pause


    ${SecondImage}=   LogScreenshot

    CompareImages    ${FirstImage}    ${SecondImage}    tolerance=0.6