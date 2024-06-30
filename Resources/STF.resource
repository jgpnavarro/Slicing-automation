*** Variables ***
#STF
${stf_base_url}      http://${public_IP_STF}:7100/api/v1
${stf_user_auth}     Bearer ${user_auth_from_STF}

#Capabilites
${PLATFORM_NAME}     Android
${APP_PACKAGE}       org.zwanoo.android.speedtest
${APP_ACTIVITY}      com.ookla.mobile4.screens.main.MainActivity
${AUTOMATION_NAME}   UIAutomator2
     

#Variables dependientes de cada test
${APPIUM_SERVER}     http://127.0.0.1:${APPIUM_PORT}
${APPIUM_PORT}  
${APPIUM_OUTPUT}



*** Settings ***
Documentation       This resource file contains the necessary keywords to set up the appium server,
...                 the STF and the connection between them via adb & also the teardown of all elements.
...                 The resource file is referenced and used in the SpeedTestApp.robot test suite.

Library             Process
Library             OpenStf   ${stf_base_url}    ${stf_user_auth}
Library             AppiumLibrary
Library             OperatingSystem
Library             pabot.PabotLib

Resource            SpeedApp.resource

*** Keywords ***
Reserve terminal
    [Arguments]                ${stf_device_serial}
    Add a device to a user     ${stf_device_serial}
    Remote Connect a device    ${stf_device_serial}
    # TODO: Comprobar que se activa bien el remoteconnect

Release terminal
    [Arguments]                   ${stf_device_serial}
    Remote Disconnect a device    ${stf_device_serial}
    Delete User Device            ${stf_device_serial}


Connect adb
    [Arguments]                         ${remote_url}
    Set Global Variable                 ${remote_url}
    Run Process       adb     connect   ${remote_url}


Start adb server
    #Start ADB
    Run Process       adb     start-server

Start Appium
    Start Process     appium  
    ...  --log-level  debug
    ...  --log  ${APPIUM_OUTPUT}
    ...  --allow-insecure  adb_shell,chromedriver_autodownload
    ...  --address  127.0.0.1  --port  ${APPIUM_PORT}
    Sleep  10                  # Wait until appium is available


Kill adb
    Run Process       adb      kill-server

Stop Appium Server    
    # And all node apps
    run process      pkill      node

Setup Test
    [Arguments]         ${stf_device_serial}

    Start adb server
    Reserve terminal    ${stf_device_serial}
    ${device_info}=     Get User Device  ${stf_device_serial}

    Connect adb         ${device_info}[device][remoteConnectUrl]

    Start Appium

    # Connect to the Appium server (ignore the name)
    Open Application  ${APPIUM_SERVER}
    ...  automationName=${AUTOMATION_NAME}
    ...  platformName=${PLATFORM_NAME}  
    ...  deviceName=${stf_device_serial}
    ...  udid=${remote_url}
    ...  appPackage=${APP_PACKAGE}  
    ...  appActivity=${APP_ACTIVITY}
    #NO hace falta especificar el {PLATFORM_VERSION}

Teardown Test
    [Arguments]          ${used_stf_device_serial}

    Sleep  50

    Run Only Once        Check For Conexion Error Before Teardown

    Stop Appium Server

    Kill adb

    Release terminal     ${used_stf_device_serial}

    
Check For Conexion Error Before Teardown
    [Documentation]    Checks if there is a problem with the conexion with one of the devices while runnind the SpeedTest
    ...                If conexion is lost in only one of the devices, it waits 90 seconds befores teardown servers
    ${status}    ${element}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${conexion_error_dialog}    timeout=2s
    Run Keyword If    '${status}' == 'PASS'
    ...    Error Wait and Log
    ...    ELSE
    ...    Log    Conexion in BOTH devices seems fine
    
Error Wait and Log
    Run Process    echo    THIS DEVICES HAS CONEXION ISSUES. TEARDOWN IN 90 SECONDS
    Sleep          90