@echo off
echo [INFO] Shutting down virtual machine gracefully.
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "UbuntuLocal" acpipowerbutton
REM !!! ВНИМАНИЕ !!! "UbuntuLocal" заменить на название вашей ВМ 
REM !!! АTTENTION !!!"UbuntuLocal" replace with the name of your VM
if %errorlevel% equ 0 (
    echo [OK] Shutdown signal sent.
    echo [INFO] The VM will shut down gracefully, may take a few seconds.
) else (
    echo [ERROR] Failed to send shutdown signal.
    echo [ERROR] Please check if VM name is correct and VirtualBox is installed.
    pause
)
