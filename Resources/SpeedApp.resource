*** Variables ***
#ScreenShot filename
${SCREENSHOT_FILE}

#Appium variables
${PLATFORM_NAME}     Android
${APP_PACKAGE}       com.android.settings
${APP_ACTIVITY}      com.android.settings.Settings
${AUTOMATION_NAME}   UIAutomator2

#Botón de siguiente
${next_button_id}        org.zwanoo.android.speedtest:id/welcome_message_next_button 

#Botón de continuar
${continue_button_id}    org.zwanoo.android.speedtest:id/permissions_continue_button 

#Grant-dialog de localizacion
${grant_dialog_localizacion}                         com.android.permissioncontroller:id/grant_dialog

#Botónes de permisos de ubicación
${permission_while_using_button_localizacion}        com.android.permissioncontroller:id/permission_allow_foreground_only_button
${permission_only_one_time_button_localizacion}      com.android.permissioncontroller:id/permission_allow_one_time_button
${permission_deny_button_localizacion}               com.android.permissioncontroller:id/permission_deny_button

#Grant-dialog de llamadas
${grant_dialog_llamadas}                             com.android.permissioncontroller:id/grant_dialog

#Botones de permisos de llamada
${permission_allow_llamadas}                         com.android.permissioncontroller:id/permission_allow_button
${permission_deny_button_llamadas}                   com.android.permissioncontroller:id/permission_deny_button

#Botones de permisos de cobertura global
${permission_allow_cobertura}                        org.zwanoo.android.speedtest:id/enable_bg_sampling_allow_button
${permission_deny_cobertura}                         org.zwanoo.android.speedtest:id/enable_bg_sampling_do_not_allow_button

#Banner de cookies
${cookies_banner}                                    org.zwanoo.android.speedtest:id/banner_layout

#Botones de cookies
${permission_allow_cookies}                          org.zwanoo.android.speedtest:id/btn_accept_cookies
${permission_deny_all_cookies}                       org.zwanoo.android.speedtest:id/btn_reject_cookies
${more_options_cookies}                              org.zwanoo.android.speedtest:id/cookies_setting_button

#Go_button para lanzar el speedTest   
${go_button}                                         org.zwanoo.android.speedtest:id/go_button

#Dialog de error de conexión
${conexion_error_dialog}                             org.zwanoo.android.speedtest:id/ookla_dialog_message

#Survey View
${survey_view}                                       org.zwanoo.android.speedtest:id/surveyView
#Marcador de velocidad(Mbps)
${speed_locator}                                     org.zwanoo.android.speedtest:id/ookla_speedtest_speed_display_reading
${speed_xpath}                                       //android.widget.TextView[@resource-id="org.zwanoo.android.speedtest:id/ookla_speedtest_speed_display_reading"]

#Resultado detallado
${detailed_result_button}                            org.zwanoo.android.speedtest:id/suite_completed_feedback_assembly_detailed_result  
${detailed_result_menu_xpath}                        org.zwanoo.android.speedtest:id/ookla_speedtest_result_detail_content               
${detailed_result_close_button}                      org.zwanoo.android.speedtest:id/side_menu_close_button   

#Botón de cerrar speedtest
${close_icon_button}                                 org.zwanoo.android.speedtest:id/closeIcon                                           


*** Settings ***
Documentation       This Resource contains keywords that use STF and Appium to perform a conexion speed test
...                 able to measure the  differentent throughputs.  

Library    OperatingSystem
Library    AppiumLibrary

Resource   STF.resource


*** Keywords ***
Click Next Button
    Wait Until Page Contains     ${next_button_id}
    Click Element                ${next_button_id}  

Click Continue Button
    Wait Until Page Contains     ${continue_button_id}
    Click Element                ${continue_button_id}
Click Location Permission Button    
    Wait Until Page Contains     ${permission_while_using_button_localizacion} 
    Wait Until Page Contains     ${permission_only_one_time_button_localizacion}
    Wait Until Page Contains     ${permission_deny_button_llamadas}
    Click Element                ${permission_only_one_time_button_localizacion}

Click Calling Permission Button
    Wait Until Page Contains    ${grant_dialog_llamadas}
    Click Element               ${permission_deny_button_llamadas}

Click Global Covering Button    
    Wait Until Page Contains    ${permission_deny_cobertura}
    Click Element               ${permission_deny_cobertura}

Click Cookies Button        
    [Documentation]    Checks for the presence of the cookies banner and clicks it if present.
    ...                if not, it checks whether the go button is present or no to determine if cookies are already set
    ...                and logs appropriate messages for different scenarios.
    
    Sleep            1
    Run Keyword And Ignore Error    Click Element    ${permission_deny_all_cookies}

Check For Go Button
    [Documentation]    Checks if go_button appears, so Keyword Click Cookies Button, can determine whether cookies
    ...                are already configured or not
    ${status}    ${element}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${go_button}    timeout=2s
    Run Keyword If    '${status}' == 'PASS'
    ...    Log    Go button is visible, cookies are already set.
    ...    ELSE
    ...    Run Process  echo   Unable to find the cookies banner or the go button, check for potential issues in the app.

Click Go Button
    Wait Until Page Contains    ${go_button}
    Click Element               ${go_button}
    Sleep                       5
    Check For Conexion Error

Check For Conexion Error
    [Documentation]    Checks if the conexion error dialog appears, and logs a result
    ${status}    ${element}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${conexion_error_dialog}    timeout=5s
    Run Keyword If    '${status}' == 'PASS'
    ...    Log    There are conexion problems
    ...    ELSE
    ...    Check For Speed Reading    
    
Check For Speed Reading
    [Documentation]    Checks if the conexion test is running correctly
    ${status}    ${element}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${speed_locator}    timeout=45s
    Run Keyword If    '${status}' == 'PASS'
    ...    Log    SpeedTest is running fine

Click Detailed Results Button
     Wait Until Page Contains    ${detailed_result_button}          timeout=120
     Click Element               ${detailed_result_button}

Capture Results Screenshot
     Wait Until Page Contains    ${detailed_result_menu_xpath}      timeout=40
     Capture Page Screenshot     filename=${SCREENSHOT_FILE}
     Run Keyword And Ignore Error     Click Element               ${detailed_result_close_button}
    
Click Close Icon button          #deja la app lista para volver a lanzar el test
     Wait Until Page Contains    ${close_icon_button}               timeout=40
     Click Element               ${close_icon_button}
      

#TEST SUITE DE EJECUCIÓN#
Execute Speed Test
    Run Keyword And Ignore Error    Click Next Button
    Run Keyword And Ignore Error    Click Continue Button
    Run Keyword And Ignore Error    Click Location Permission Button    
    Run Keyword And Ignore Error    Click Calling Permission Button
    Run Keyword And Ignore Error    Click Global Covering Button    
    Click Cookies Button        
    Click Go Button
    Run Keyword And Ignore Error    Click Detailed Results Button
    Capture Results Screenshot
    Run Keyword And Ignore Error    Click Close Icon button         

    