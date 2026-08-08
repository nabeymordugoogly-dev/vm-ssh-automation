@echo off

:check_running
echo [INFO] Checking if virtual machine is already running...
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo "UbuntuLocal" | findstr /C:"State: running" /C:"State: paused" > nul
REM !!! ВНИМАНИЕ !!! "UbuntuLocal" заменить на название вашей ВМ 
REM !!! АTTENTION !!!"UbuntuLocal" replace with the name of your VM
if %errorlevel% equ 0 (
    echo [OK] Virtual machine is already running.
    goto ssh_connect
)

echo [INFO] Starting virtual machine in background mode...
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "UbuntuLocal" --type headless 2>nul
REM !!! ВНИМАНИЕ !!! "UbuntuLocal" заменить на название вашей ВМ 
REM !!! АTTENTION !!!"UbuntuLocal" replace with the name of your VM
if %errorlevel% equ 0 (
    echo [OK] Virtual machine started successfully.
    goto ssh_connect
) else (
    echo [INFO] Virtual machine may be starting or in a locked state.
    echo [INFO] Attempting to connect to SSH anyway...
    goto ssh_connect
)

:ssh_connect
echo [INFO] Waiting for SSH service to become available...
echo [INFO] This may take a few moments...

set /a attempts=0
:wait_loop
set /a attempts+=1

if %attempts% gtr 30 (
    echo.
    echo [ERROR] ============================================================
    echo [ERROR] Timeout: SSH service did not become available within 60 seconds.
    echo [ERROR] ============================================================
    echo [ERROR] Please check the following:
    echo [ERROR]   1. Is the virtual machine running?
    echo [ERROR]      Run: "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list runningvms
    echo [ERROR]   2. Is SSH server installed on the VM?
    echo [ERROR]      Connect manually: ssh myserver
    echo [ERROR]   3. Is the VM reachable?
    echo [ERROR]      Run: ping 192.168.1.122
    echo [ERROR] ============================================================
    echo.
    pause
    exit /b 1
)

ssh -q -o ConnectTimeout=1 myserver exit 2>nul
if %errorlevel% neq 0 (
    timeout /t 2 /nobreak > nul
    goto wait_loop
)

echo [OK] SSH is ready!
echo [INFO] Establishing connection...
ssh myserver
