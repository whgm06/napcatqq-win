@echo off
title NapCat v4.18.42 Windows 部署工具
setlocal EnableDelayedExpansion
cd /d "%~dp0"

REM ==========================================================
REM  napcatqq-win 部署工具
REM  NapCat v4.18.42 + QQ 9.9.33（仅实测该版本组合可用）
REM  https://github.com/whgm06/napcatqq-win
REM ==========================================================

set "NAPCATDIR=%~dp0NapCat.Shell"
set "NAPCATZIP=%~dp0NapCat.Shell.zip"
set "QLBAT=%~dp0NapCat.Shell\quickLogin.bat"
set "ICOFILE=%~dp0NapCat.Shell\static\favicon.ico"

:Menu
cls
echo.
echo  ==========================================================
echo    NapCat v4.18.42  +  QQ 9.9.33  Windows 部署工具
echo  ==========================================================
echo    脚本目录：!CD!
echo.
echo    [1] 一键安装    下载 QQ 与 NapCat，解压到 NapCat.Shell 目录
echo    [2] 创建快捷方式  设置 QQ 号快速登录，桌面创建 NapcatQQ 快捷方式
echo    [Q] 退出
echo.
set "SEL="
set /p "SEL=请输入选择后回车: "
if /i "!SEL!"=="1" goto :Install
if /i "!SEL!"=="2" goto :Shortcut
if /i "!SEL!"=="Q" goto :Quit
goto :Menu

REM ============================================================
:Install
cls
echo.
echo  ==================== 一键安装 ====================
echo.

REM ---------- 检测 Windows 架构 ----------
if defined PROCESSOR_ARCHITEW6432 (
    set "ARCH=%PROCESSOR_ARCHITEW6432%"
) else (
    set "ARCH=%PROCESSOR_ARCHITECTURE%"
)
set "QQARCH="
if /i "!ARCH!"=="AMD64" set "QQARCH=x64"
if /i "!ARCH!"=="x86"   set "QQARCH=x86"
if /i "!ARCH!"=="ARM64" set "QQARCH=arm64"
if not defined QQARCH (
    echo [错误] 无法识别的 Windows 架构：!ARCH!
    goto :InstallEnd
)
echo [1/5] 系统架构：!ARCH!  →  下载 QQ !QQARCH! 版
echo.

set "QQFILE=QQ_9.9.33_260813_!QQARCH!_01.exe"
set "QQURL1=https://qqdl.gtimg.cn/qqfile/QQNT/9.9.33/release/497e2f1f/QQ_9.9.33_260813_!QQARCH!_01.exe"
set "QQURL2=http://v4.gh-proxy.org/https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_!QQARCH!_01.exe"
set "QQURL3=https://github.com/Rodert/qq-versions/releases/download/qq-packages-20260813-1d08f1d4/QQ_9.9.33_260813_!QQARCH!_01.exe"

REM ---------- 下载 QQ 安装包 ----------
echo [2/5] 准备 QQ 9.9.33 安装包：!QQFILE!
call :EnsureFile "!QQFILE!" MZ "!QQURL1!" "!QQURL2!" "!QQURL3!"
if errorlevel 1 (
    echo.
    echo [错误] QQ 安装包下载失败。请手动下载下面任一链接，
    echo        保存到脚本所在目录后重新运行：
    echo    !QQURL1!
    echo    !QQURL2!
    echo    !QQURL3!
    goto :InstallEnd
)
echo.

REM ---------- 下载 NapCat ----------
echo [3/5] 准备 NapCat v4.18.42 主程序：NapCat.Shell.zip
echo     优先从本项目仓库下载，失败依次回退备用源。
call :EnsureFile "!NAPCATZIP!" PK ^
    "http://v4.gh-proxy.org/https://raw.githubusercontent.com/whgm06/napcatqq-win/main/NapCat.Shell.zip" ^
    "https://raw.githubusercontent.com/whgm06/napcatqq-win/main/NapCat.Shell.zip" ^
    "http://v4.gh-proxy.org/https://github.com/XingYunStar/NapCatQQ/releases/download/v4.18.42/NapCat.Shell.zip" ^
    "https://github.com/XingYunStar/NapCatQQ/releases/download/v4.18.42/NapCat.Shell.zip"
if errorlevel 1 (
    echo.
    echo [错误] NapCat.Shell.zip 下载失败。请手动下载下面任一链接，
    echo        保存为脚本所在目录下的 NapCat.Shell.zip 后重新运行：
    echo    http://v4.gh-proxy.org/https://raw.githubusercontent.com/whgm06/napcatqq-win/main/NapCat.Shell.zip
    echo    https://raw.githubusercontent.com/whgm06/napcatqq-win/main/NapCat.Shell.zip
    echo    http://v4.gh-proxy.org/https://github.com/XingYunStar/NapCatQQ/releases/download/v4.18.42/NapCat.Shell.zip
    echo    https://github.com/XingYunStar/NapCatQQ/releases/download/v4.18.42/NapCat.Shell.zip
    goto :InstallEnd
)
echo.

REM ---------- 解压 NapCat 到当前目录的 NapCat.Shell ----------
echo [4/5] 解压 NapCat 到：!NAPCATDIR!
set "REXTRACT=N"
if exist "!QLBAT!" (
    echo     检测到 NapCat.Shell 目录已存在。
    set "ANS="
    set /p "ANS=输入 Y 并回车覆盖重新解压（其他键回车跳过解压）: "
    if /i "!ANS!"=="Y" set "REXTRACT=Y"
)
if "!REXTRACT!"=="Y" (
    powershell -NoProfile -Command "Expand-Archive -LiteralPath '!NAPCATZIP!' -DestinationPath '!NAPCATDIR!' -Force"
) else (
    if not exist "!QLBAT!" (
        powershell -NoProfile -Command "Expand-Archive -LiteralPath '!NAPCATZIP!' -DestinationPath '!NAPCATDIR!' -Force"
    ) else (
        echo     跳过解压，沿用已有 NapCat.Shell 目录。
    )
)
if not exist "!QLBAT!" (
    echo [错误] 解压后未找到 quickLogin.bat，请手动将 NapCat.Shell.zip
    echo        解压到脚本所在目录的 NapCat.Shell 文件夹。
    goto :InstallEnd
)
echo     解压完成：launcher.bat / quickLogin.bat 等已位于 NapCat.Shell 目录。
echo.

REM ---------- 提示安装 QQ ----------
echo [5/5] 安装 QQ
echo  ----------------------------------------------------------
echo   双击运行下载好的 QQ 安装包即可安装：
echo     !CD!\!QQFILE!
echo   （已安装过 QQ 9.9.33 可跳过本步）
echo  ----------------------------------------------------------
set "ANS="
set /p "ANS=输入 Y 并回车直接启动 QQ 安装程序（其他键回车跳过）: "
if /i "!ANS!"=="Y" (
    echo 正在启动 QQ 安装程序，请在安装向导中完成安装...
    start "" "!QQFILE!"
)
echo.
echo  ==================== 一键安装完成 ====================
echo   下一步：
echo     首次使用：双击 NapCat.Shell\launcher.bat 扫码登录（需管理员权限）。
echo     已登录过：回到菜单选 [2] 创建快捷方式，实现免扫码快速登录。
echo  ====================================================
:InstallEnd
echo.
set "HOLD="
set /p "HOLD=按回车键返回菜单... "
goto :Menu

REM ============================================================
:Shortcut
cls
echo.
echo  ==================== 创建快捷方式 ====================
echo.
if not exist "!QLBAT!" (
    echo [错误] 未找到 !QLBAT!
    echo        请先在菜单选 [1] 完成一键安装（下载并解压 NapCat）。
    goto :ShortcutEnd
)

set "QQNUM="
set /p "QQNUM=请输入要快速登录的 QQ 号: "
if not defined QQNUM (
    echo [错误] QQ 号不能为空。
    goto :ShortcutEnd
)
echo !QQNUM!| findstr /r "^[0-9][0-9]*$" >nul || (
    echo [错误] QQ 号必须是纯数字，当前输入：!QQNUM!
    goto :ShortcutEnd
)

echo.
echo [1/2] 生成快速登录脚本：NapCat.Shell\quickLogin.bat（QQ 号 !QQNUM!）
> "!QLBAT!" echo @echo off
>>"!QLBAT!" echo REM NapCat quick login - generated by install.bat
>>"!QLBAT!" echo REM QQ: !QQNUM!
>>"!QLBAT!" echo REM If launch fails on your system, replace "launcher.bat" below with:
>>"!QLBAT!" echo REM   launcher-win10.bat        for Windows 10
>>"!QLBAT!" echo REM   launcher-user.bat         run without admin
>>"!QLBAT!" echo REM   launcher-win10-user.bat   Windows 10 without admin
>>"!QLBAT!" echo cd /d "%%~dp0"
>>"!QLBAT!" echo launcher.bat !QQNUM!
>>"!QLBAT!" echo pause
findstr /c:"launcher.bat !QQNUM!" "!QLBAT!" >nul || (
    echo [错误] quickLogin.bat 写入失败。
    goto :ShortcutEnd
)
echo     完成。

echo.
echo [2/2] 创建桌面快捷方式 NapcatQQ（图标使用 NapCat.Shell\static\favicon.ico）
set "ICOARG="
if exist "!ICOFILE!" set "ICOARG=!ICOFILE!"
powershell -NoProfile -Command "$d=[Environment]::GetFolderPath('Desktop'); $w=New-Object -ComObject WScript.Shell; $p=[IO.Path]::Combine($d,'NapcatQQ.lnk'); $l=$w.CreateShortcut($p); $l.TargetPath='!QLBAT!'; $l.WorkingDirectory='!NAPCATDIR!'; $l.Description='NapCat QQ quick login'; $l.WindowStyle=1; if ('!ICOARG!' -ne '') { $l.IconLocation='!ICOARG!' }; $l.Save(); if (Test-Path -LiteralPath $p) { Write-Host 'OK' } else { exit 1 }"
if errorlevel 1 (
    echo [错误] 桌面快捷方式创建失败，请手动为 quickLogin.bat 创建快捷方式。
    goto :ShortcutEnd
)
echo     完成：桌面 NapcatQQ 快捷方式已创建。
echo  ----------------------------------------------------------
echo   提示：快速登录依赖本机 QQ 已有过登录记录。
echo   首次使用请先双击 NapCat.Shell\launcher.bat 扫码登录一次。
echo  ----------------------------------------------------------

set "ANS="
set /p "ANS=输入 Y 并回车立即启动测试（其他键回车跳过）: "
if /i "!ANS!"=="Y" (
    echo 正在启动 NapCat...
    start "" "!QLBAT!"
)

echo.
echo  ==================== 快捷方式创建完成 ====================
:ShortcutEnd
echo.
set "HOLD="
set /p "HOLD=按回车键返回菜单... "
goto :Menu

REM ============================================================
:Quit
endlocal
exit /b 0

REM ============================================================
REM 子程序：确保文件存在且有效，否则按 URL 顺序依次尝试下载
REM 用法: call :EnsureFile 文件名 MZ或PK URL1 URL2 ...
:EnsureFile
set "EF_OUT=%~1"
set "EF_MAGIC=%~2"
shift
shift
if exist "!EF_OUT!" (
    call :ValidFile "!EF_OUT!" "!EF_MAGIC!"
    if not errorlevel 1 (
        echo     已存在 !EF_OUT!，校验通过，跳过下载
        exit /b 0
    )
    echo     已存在 !EF_OUT!，但校验未通过，将重新下载
)
:EF_Loop
if "%~1"=="" (
    echo     所有下载链接均失败
    exit /b 1
)
echo     正在下载：%~1
call :FetchOne "!EF_OUT!" "!EF_MAGIC!" "%~1"
if not errorlevel 1 (
    echo     下载完成：!EF_OUT!
    exit /b 0
)
echo     该链接失败，尝试下一个备用链接...
shift
goto :EF_Loop

REM ============================================================
REM 子程序：从单个 URL 下载并校验文件头，成功后写入目标文件
:FetchOne
set "FO_OUT=%~1"
set "FO_MAGIC=%~2"
set "FO_URL=%~3"
set "FO_B0=0"
set "FO_B1=0"
if /i "!FO_MAGIC!"=="MZ" ( set "FO_B0=77" & set "FO_B1=90" )
if /i "!FO_MAGIC!"=="PK" ( set "FO_B0=80" & set "FO_B1=75" )
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; $t=Join-Path $env:TEMP 'napcat_dl.tmp'; try { [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '!FO_URL!' -OutFile $t -UseBasicParsing -TimeoutSec 1800 } catch { exit 2 }; if ((Get-Item -LiteralPath $t).Length -lt 1048576) { exit 3 }; $fs=[IO.File]::OpenRead($t); $b=New-Object byte[] 2; $null=$fs.Read($b,0,2); $fs.Close(); if ($b[0] -ne !FO_B0! -or $b[1] -ne !FO_B1!) { Remove-Item -LiteralPath $t -Force; exit 4 }; Move-Item -LiteralPath $t -Destination '!FO_OUT!' -Force; exit 0"
exit /b %ERRORLEVEL%

REM ============================================================
REM 子程序：校验本地文件大小与文件头
:ValidFile
set "VF_OUT=%~1"
set "VF_MAGIC=%~2"
set "VF_B0=0"
set "VF_B1=0"
if /i "!VF_MAGIC!"=="MZ" ( set "VF_B0=77" & set "VF_B1=90" )
if /i "!VF_MAGIC!"=="PK" ( set "VF_B0=80" & set "VF_B1=75" )
if not exist "!VF_OUT!" exit /b 1
powershell -NoProfile -Command "if ((Get-Item -LiteralPath '!VF_OUT!').Length -lt 1048576) { exit 1 }; $fs=[IO.File]::OpenRead('!VF_OUT!'); $b=New-Object byte[] 2; $null=$fs.Read($b,0,2); $fs.Close(); if ($b[0] -ne !VF_B0! -or $b[1] -ne !VF_B1!) { exit 1 }; exit 0"
exit /b %ERRORLEVEL%
