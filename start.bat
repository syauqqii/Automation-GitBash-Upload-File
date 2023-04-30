:main_script
@echo off
cls
title GitBash File Upload by github@syauqqii
mode con: cols=120 lines=30
reg add "HKEY_CURRENT_USER\Console" /v FaceName /t REG_SZ /d "Consolas" /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Console" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1

:: ----------------- Set Username & Email ----------------- 
:: set /a username_github=username_github
:: set /a email_github=email@domain.extension

:: ----------------- Header Script Batch File Automation ----------------- 
color 0F
echo.
echo [#] [ GitBash File Upload ] 
echo.

:: ----------------- Proses inisialisasi variabel -----------------
set /p "filepath=  [>] Masukkan path file: (ex: D:\laravel-portofolio) "
echo.
if not exist %filepath% (
	echo [^>] File path tidak dapat ditemukan, tekan [ENTER] untuk input ulang
	pause > nul
	goto main_script
)

set drive=%filepath:~0,1%
cd /%drive% %filepath%

if not defined username_github (
	set /p username_github= [^>] Masukkan username GitHub: 
)

if not defined email_github (
	set /p email_github= [^>] Masukkan alamat email yang terdaftar di GitHub: 
)

:: Input & Cek apakah user mengisi pesan commit atau tidak
set /p message= [^>] Masukkan pesan commit: 
if "%message%"=="" (
	set message=Upload File via GitBash
)

set /p repository= [^>] Masukkan nama repositori di GitHub: 

set /p branch= [^>] Masukkan nama branch: 
if "%branch%"=="" (
	set branch=main
)

echo.
:repo_git
set /p type_rep= [^>] Repository Baru/Lama: (1. Baru, 2. Lama) 
if %type_rep% EQU 1 (
	goto lanjut
) else if %type_rep% EQU 2 (
	goto lama
) else (
	goto repo_git
)

:lama
:: Pengecekan koneksi internet
set /a nReconnect=0
:connect_github
ping google.com -n 1 > nul
if errorlevel 1 (
	set /a nReconnect+=1
	echo [^>] Tidak ada koneksi internet, tekan [ENTER] untuk reconnect
	pause > nul 
	goto connect_github
)

if %nReconnect% GTR 1 (
	echo.
)

echo. 
echo [^>] Proses upload file ke [https://github.com/%username_github%/%repository%]
echo [^>] Proses memerlukan beberapa waktu, harap bersabar
echo. 

git fetch origin >nul 2>&1
git merge origin/%branch% >nul 2>&1
git pull origin %branch% --allow-unrelated-histories >nul 2>&1
git add . >nul 2>&1 
git commit -m "%message%" >nul 2>&1
git push origin %branch% >nul 2>&1
goto selesai

:lanjut
:: Pengecekan koneksi internet
set /a nReconnect=0
:connect_github
ping google.com -n 1 > nul
if errorlevel 1 (
	set /a nReconnect+=1
	echo [^>] Tidak ada koneksi internet, tekan [ENTER] untuk reconnect
	pause > nul 
	goto connect_github
)

if %nReconnect% GTR 1 (
	echo.
)

echo. 
echo [^>] Proses upload file ke [https://github.com/%username_github%/%repository%]
echo [^>] Proses memerlukan beberapa waktu, harap bersabar
echo. 

:: ----------------- Proses Upload ke GitHub ----------------- 
git config --global user.name "%username_github%" >nul 2>&1
git config --global user.email "%email_github%" >nul 2>&1
git init >nul 2>&1
git add . >nul 2>&1
git commit -m "%message%" >nul 2>&1
git branch -M %branch% >nul 2>&1
git remote add origin https://github.com/%username_github%/%repository%.git >nul 2>&1
git push -u origin %branch% >nul 2>&1

:selesai
:: ----------------- Program Telah Selesai -----------------
echo [^>] OK proses upload telah selesai, tekan [ENTER] untuk keluar
pause > nul
echo.
exit