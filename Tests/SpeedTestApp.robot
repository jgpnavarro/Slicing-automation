*** Variables ***
${APPIUM_PORT}           
${APPIUM_SERVER}      http://127.0.0.1:${APPIUM_PORT}   
${APPIUM_OUTPUT}         

${stf_device_serial}

${ScreenShot_filename}    

*** Settings ***
Documentation       This test suite contains tests that use STF and Appium to perform a conexion speed test
...                 able to measure the  differentent throughputs.  

Library    OperatingSystem

Resource    ../Resources/STF.resource
Resource    ../Resources/SpeedApp.resource

Suite Setup            Setup Test     ${stf_device_serial}
Suite Teardown         Teardown Test  ${stf_device_serial}

*** Test Cases ***
Execute SpeedTest    
    Execute Speed Test






