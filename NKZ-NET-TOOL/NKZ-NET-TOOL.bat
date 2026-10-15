
@echo off
setlocal EnableExtensions
title NKZ NET TOOL
color 0D
mode con cols=76 lines=30

:INTRO
cls
echo.
echo ================================================================
echo                         NKZ NET TOOL
echo                    NETWORK DIAGNOSTIC PANEL
echo ================================================================
echo.
echo Inicializando o sistema...
timeout /t 1 /nobreak >nul
echo [######------------------------] 20%%
timeout /t 1 /nobreak >nul
echo [############------------------] 40%%
timeout /t 1 /nobreak >nul
echo [##################------------] 60%%
timeout /t 1 /nobreak >nul
echo [########################------] 80%%
timeout /t 1 /nobreak >nul
echo [##############################] 100%%
timeout /t 1 /nobreak >nul

:MENU
cls
echo ================================================================
echo                         NKZ NET TOOL
echo ================================================================
echo.
echo  [01] Consultar IP local e IPv6
echo  [02] Gateway, DNS e adaptadores
echo  [03] Testar conexao com a internet
echo  [04] Testar latencia (PING)
echo  [05] Configuracao de rede e tabela ARP
echo  [06] Conexoes de rede ativas
echo  [07] Portas e processos associados
echo  [08] Limpar cache DNS
echo  [09] Renovar endereco IP via DHCP
echo  [10] Gerenciador de Tarefas / Conexoes de Rede
echo  [11] Salvar relatorio de diagnostico
echo  [12] Atualizar e voltar ao menu
echo  [00] Sair
echo.
echo ================================================================
set "op="
set /p "op=NKZ@NET-TOOL ^> "

if "%op%"=="01" goto IP
if "%op%"=="1" goto IP
if "%op%"=="02" goto GATEWAY
if "%op%"=="2" goto GATEWAY
if "%op%"=="03" goto INTERNET
if "%op%"=="3" goto INTERNET
if "%op%"=="04" goto PINGTEST
if "%op%"=="4" goto PINGTEST
if "%op%"=="05" goto CONFIG
if "%op%"=="5" goto CONFIG
if "%op%"=="06" goto CONNECTIONS
if "%op%"=="6" goto CONNECTIONS
if "%op%"=="07" goto PORTS
if "%op%"=="7" goto PORTS
if "%op%"=="08" goto FLUSHDNS
if "%op%"=="8" goto FLUSHDNS
if "%op%"=="09" goto RENEW
if "%op%"=="9" goto RENEW
if "%op%"=="10" goto TOOLS
if "%op%"=="11" goto REPORT
if "%op%"=="12" goto REFRESH
if "%op%"=="00" goto EXIT
if "%op%"=="0" goto EXIT

echo.
echo Opcao invalida.
pause
goto MENU

:IP
cls
echo ===== IP LOCAL E IPV6 =====
ipconfig | findstr /i /c:"IPv4" /c:"IPv6"
echo.
pause
goto MENU

:GATEWAY
cls
echo ===== GATEWAY, DNS E ADAPTADORES =====
ipconfig /all
echo.
pause
goto MENU

:INTERNET
cls
echo ===== TESTE DE INTERNET =====
echo.
echo Testando conexao com 1.1.1.1...
ping -n 2 -w 2500 1.1.1.1
echo.
echo Testando resolucao de dominio...
ping -n 2 -w 2500 example.com
echo.
pause
goto MENU

:PINGTEST
cls
echo ===== TESTE DE LATENCIA =====
set "host="
set /p "host=Digite um dominio ou IP: "
if not defined host goto MENU
echo.
ping -n 4 -w 2500 "%host%"
echo.
pause
goto MENU

:CONFIG
cls
echo ===== CONFIGURACAO DE REDE =====
ipconfig /all
echo.
echo ===== TABELA ARP =====
arp -a
echo.
pause
goto MENU

:CONNECTIONS
cls
echo ===== CONEXOES ATIVAS =====
netstat -ano
echo.
echo A ultima coluna mostra o PID do processo.
pause
goto MENU

:PORTS
cls
echo ===== PORTAS E PROCESSOS =====
echo.
netstat -ano
echo.
echo ===== PROCESSOS EM EXECUCAO =====
tasklist
echo.
echo Compare o PID do netstat com o PID do tasklist.
pause
goto MENU

:FLUSHDNS
cls
echo ===== LIMPAR CACHE DNS =====
echo Esta acao limpa o cache DNS local.
set "confirm="
set /p "confirm=Digite S para confirmar ou N para cancelar: "
if /i not "%confirm%"=="S" goto MENU
ipconfig /flushdns
echo.
pause
goto MENU

:RENEW
cls
echo ===== RENOVAR IP VIA DHCP =====
echo A conexao pode ser interrompida temporariamente.
set "confirm="
set /p "confirm=Digite S para confirmar ou N para cancelar: "
if /i not "%confirm%"=="S" goto MENU
ipconfig /release
echo.
ipconfig /renew
echo.
pause
goto MENU

:TOOLS
cls
echo ===== FERRAMENTAS DO WINDOWS =====
echo.
echo [1] Gerenciador de Tarefas
echo [2] Conexoes de Rede
echo [3] Abrir os dois
echo [0] Voltar
echo.
set "tool="
set /p "tool=Escolha: "

if "%tool%"=="1" start "" taskmgr
if "%tool%"=="2" start "" ncpa.cpl
if "%tool%"=="3" (
    start "" taskmgr
    start "" ncpa.cpl
)
goto MENU

:REPORT
cls
echo ===== RELATORIO DE DIAGNOSTICO =====
set "report=%USERPROFILE%\NKZ-NET-TOOL-RELATORIO.txt"

echo Gerando relatorio...
echo NKZ NET TOOL - RELATORIO > "%report%"
echo Data: %DATE% %TIME% >> "%report%"
echo Computador: %COMPUTERNAME% >> "%report%"
echo. >> "%report%"
echo ===== CONFIGURACAO DE REDE ===== >> "%report%"
ipconfig /all >> "%report%" 2>&1
echo. >> "%report%"
echo ===== CONEXOES ATIVAS ===== >> "%report%"
netstat -ano >> "%report%" 2>&1
echo. >> "%report%"
echo ===== PROCESSOS ===== >> "%report%"
tasklist >> "%report%" 2>&1

if exist "%report%" (
    echo.
    echo Relatorio salvo em:
    echo %report%
    echo.
    set "openreport="
    set /p "openreport=Abrir o relatorio? (S/N): "
    if /i "%openreport%"=="S" start "" notepad "%report%"
) else (
    echo Nao foi possivel salvar o relatorio.
)
echo.
pause
goto MENU

:REFRESH
cls
echo Atualizando painel...
timeout /t 1 /nobreak >nul
goto MENU

:EXIT
cls
echo Encerrando NKZ NET TOOL...
timeout /t 1 /nobreak >nul
exit /b
