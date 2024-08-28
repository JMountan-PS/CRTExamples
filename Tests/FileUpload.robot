*** Settings ***
Library        QForce
Library        QWeb
Library        QVision

*** Test Cases ***
Uploading File to Account Record


    Home
    LaunchApp    Accounts


    ClickText     Upload    anchor=Attachments #Click The upload button
    QVision.ClickText        suite             #Click suite in Linux filepath
    QVision.ClickText        Data
    QVision.DoubleClick        Upload.csv



    Log Variables              level=WARN
    UploadFile      Attachments    ${EXECDIR}/../Data/Upload.csv  