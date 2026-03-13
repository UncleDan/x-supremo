@echo off
:: ============================================================
::  X-Supremo - Script di Inizializzazione
::  winPenPack X-Launcher portable structure
::
::  POSIZIONE: WinPenPack\Bin\Supremo\INIZIALIZZA.bat
::
::  Crea un nuovo profilo Supremo sulla chiavetta partendo
::  dal template X-Supremo-Default.ini
::  Puo' essere eseguito piu' volte per creare profili diversi.
::
::  Struttura WinPenPack risultante:
::
::  <unita>:\WinPenPack\
::  ├── XDrive\
::  │   ├── X-Supremo-Default.exe      ← X-Launcher.exe (template)
::  │   ├── X-Supremo-Default.ini      ← INI template
::  │   ├── X-Supremo-AziendaRossi.exe ← generato da INIZIALIZZA
::  │   ├── X-Supremo-AziendaRossi.ini ← generato da INIZIALIZZA
::  │   ├── X-Supremo-ClienteXYZ.exe   ← altro profilo
::  │   └── X-Supremo-ClienteXYZ.ini
::  ├── Bin\Supremo\
::  │   ├── Supremo.exe
::  │   └── INIZIALIZZA.bat            ← questo file
::  ├── User\Supremo\
::  │   ├── AziendaRossi\settings.dat
::  │   └── ClienteXYZ\settings.dat
::  └── Backup\Supremo\
::      ├── AziendaRossi\settings.bak1 ... bak5
::      └── ClienteXYZ\settings.bak1 ... bak5
::
::  Eseguire come Amministratore.
:: ============================================================

setlocal enabledelayedexpansion
cls

echo.
echo  ============================================================
echo    X-Supremo :: Inizializzazione Nuovo Profilo
echo    winPenPack X-Launcher
echo  ============================================================
echo.

:: ============================================================
:: Ricava percorsi automaticamente dalla posizione dello script
:: Script in: WinPenPack\Bin\Supremo\  → risale 2 livelli
:: ============================================================
set BIN_SUPREMO=%~dp0
if "%BIN_SUPREMO:~-1%"=="\" set BIN_SUPREMO=%BIN_SUPREMO:~0,-1%
for %%P in ("%BIN_SUPREMO%\..") do set BIN_DIR=%%~fP
for %%P in ("%BIN_DIR%\..") do set WPP=%%~fP

set CHIAVETTA=%~d0
set XDRIVE=%WPP%\XDrive
set USER_SUPREMO=%WPP%\User\Supremo
set BACKUP_SUPREMO=%WPP%\Backup\Supremo
set SUPREMO_EXE=%BIN_SUPREMO%\Supremo.exe
set TEMPLATE_INI=%XDRIVE%\X-Supremo-Default.ini
set TEMPLATE_EXE=%XDRIVE%\X-Supremo-Default.exe
set SETTINGS_PC=C:\ProgramData\SupremoRemoteDesktop\settings.dat
set SETTINGS_DIR=C:\ProgramData\SupremoRemoteDesktop

echo  Percorsi rilevati:
echo    Chiavetta  : %CHIAVETTA%
echo    WinPenPack : %WPP%
echo.

:: ============================================================
:: Verifica prerequisiti strutturali
:: ============================================================
echo  Verifica struttura WinPenPack...

set ERRORI=0
if not exist "%WPP%\"          ( echo  [MANCANTE] %WPP%\             & set ERRORI=1 )
if not exist "%XDRIVE%\"       ( echo  [MANCANTE] %XDRIVE%\          & set ERRORI=1 )
if not exist "%BIN_SUPREMO%\"  ( echo  [MANCANTE] %BIN_SUPREMO%\     & set ERRORI=1 )
if not exist "%SUPREMO_EXE%"   ( echo  [MANCANTE] Bin\Supremo\Supremo.exe & set ERRORI=1 )
if not exist "%TEMPLATE_INI%"  ( echo  [MANCANTE] XDrive\X-Supremo-Default.ini & set ERRORI=1 )
if not exist "%TEMPLATE_EXE%"  ( echo  [MANCANTE] XDrive\X-Supremo-Default.exe & set ERRORI=1 )

if "%ERRORI%"=="1" (
    echo.
    echo  [ERRORE] Struttura incompleta. Verifica la chiavetta.
    pause & exit /b 1
)
echo  Struttura OK  [OK]
echo.

:: ============================================================
:: Raccolta dati profilo
:: ============================================================

:: ── Nome profilo ─────────────────────────────────────────────
echo  Inserisci il nome del nuovo profilo.
echo  Diventa il nome del launcher, delle cartelle User e Backup.
echo  Usa solo lettere, numeri e trattini (no spazi).
echo  Esempi: AziendaRossi, ClienteXYZ, Lavoro-2
echo.
set /p NOMEPROFILO="  Nome profilo: "
if "%NOMEPROFILO%"=="" (
    echo  [ERRORE] Il nome non puo' essere vuoto.
    pause & exit /b 1
)
:: Sostituisci spazi con trattini per sicurezza
set NOMEPROFILO=%NOMEPROFILO: =-%

:: Verifica che il profilo non esista gia'
set NUOVO_INI=%XDRIVE%\X-Supremo-%NOMEPROFILO%.ini
if exist "%NUOVO_INI%" (
    echo.
    echo  [ATTENZIONE] Il profilo "%NOMEPROFILO%" esiste gia'.
    echo  Vuoi sovrascriverlo? Tutti i dati del profilo verranno persi.
    set /p SOVRASCRIVI="  Sovrascrivere? (S/N): "
    if /i not "!SOVRASCRIVI!"=="S" (
        echo  Operazione annullata.
        pause & exit /b 1
    )
)

:: ── Licenza ──────────────────────────────────────────────────
echo.
echo  Inserisci il codice licenza Supremo per questo profilo.
echo  (formato: XXXXX-XXXXX-XXXXX-XXXXX)
echo.
set /p LICENZA="  Licenza: "
if "%LICENZA%"=="" (
    echo  [ERRORE] La licenza non puo' essere vuota.
    pause & exit /b 1
)

:: ── Nome computer ────────────────────────────────────────────
echo.
echo  Inserisci il nome computer visualizzato in Supremo Console.
echo  (max 50 caratteri, es. Tecnico-AziendaRossi)
echo.
set /p NOMEPC="  Nome computer: "
if "%NOMEPC%"=="" (
    echo  [ERRORE] Il nome computer non puo' essere vuoto.
    pause & exit /b 1
)

:: Percorsi specifici per questo profilo
set NUOVO_EXE=%XDRIVE%\X-Supremo-%NOMEPROFILO%.exe
set USER_PROFILO=%USER_SUPREMO%\%NOMEPROFILO%
set BACKUP_PROFILO=%BACKUP_SUPREMO%\%NOMEPROFILO%
set USER_DAT=%USER_PROFILO%\settings.dat

:: ── Riepilogo e conferma ─────────────────────────────────────
echo.
echo  ── Riepilogo ────────────────────────────────────────────
echo    Nome profilo : %NOMEPROFILO%
echo    Licenza      : %LICENZA%
echo    Nome PC      : %NOMEPC%
echo    Launcher     : XDrive\X-Supremo-%NOMEPROFILO%.exe
echo    INI          : XDrive\X-Supremo-%NOMEPROFILO%.ini
echo    User         : User\Supremo\%NOMEPROFILO%\
echo    Backup       : Backup\Supremo\%NOMEPROFILO%\
echo  ─────────────────────────────────────────────────────────
echo.
set /p CONFERMA="  Confermi? (S/N): "
if /i not "%CONFERMA%"=="S" (
    echo  Operazione annullata.
    pause & exit /b 1
)
echo.

:: ============================================================
:: Creazione profilo
:: ============================================================

:: ── Crea cartelle User e Backup per il profilo ───────────────
echo  Creazione cartelle profilo...
if not exist "%USER_SUPREMO%\"   mkdir "%USER_SUPREMO%"
if not exist "%BACKUP_SUPREMO%\" mkdir "%BACKUP_SUPREMO%"
if not exist "%USER_PROFILO%\"   mkdir "%USER_PROFILO%"
if not exist "%BACKUP_PROFILO%\" mkdir "%BACKUP_PROFILO%"
echo  Cartelle create.  [OK]

:: ── Copia template INI e sostituisce ##NOMEPROFILO## ─────────
echo  Generazione INI dal template...
set INI_TMP=%XDRIVE%\X-Supremo-%NOMEPROFILO%_tmp.ini
(for /f "usebackq delims=" %%R in ("%TEMPLATE_INI%") do (
    set "RIGA=%%R"
    set "RIGA=!RIGA:##NOMEPROFILO##=%NOMEPROFILO%!"
    echo !RIGA!
)) > "%INI_TMP%"
move /Y "%INI_TMP%" "%NUOVO_INI%" >nul
echo  XDrive\X-Supremo-%NOMEPROFILO%.ini  [OK]

:: ── Copia X-Launcher.exe rinominato col nome del profilo ─────
echo  Copia launcher...
copy /Y "%TEMPLATE_EXE%" "%NUOVO_EXE%" >nul
if errorlevel 1 (
    echo  [ERRORE] Impossibile copiare il launcher.
    pause & exit /b 1
)
echo  XDrive\X-Supremo-%NOMEPROFILO%.exe  [OK]
echo.

:: ── 1. Chiudi Supremo ────────────────────────────────────────
echo  [1/5] Chiusura Supremo...
taskkill /IM Supremo.exe /F >nul 2>&1
timeout /t 2 >nul

:: ── 2. Attiva licenza ────────────────────────────────────────
echo  [2/5] Attivazione licenza...
echo %LICENZA% | "%SUPREMO_EXE%" -set-license
timeout /t 2 >nul

:: ── 3. Impostazioni ──────────────────────────────────────────
echo  [3/5] Impostazioni profilo...
"%SUPREMO_EXE%" -set-computer-name "%NOMEPC%"
"%SUPREMO_EXE%" -request-user-authorization 1
"%SUPREMO_EXE%" -display-request-for 30
"%SUPREMO_EXE%" -allow-after-request-timeout 0
"%SUPREMO_EXE%" /set-language it
timeout /t 2 >nul

:: ── 4. Login manuale Console ─────────────────────────────────
echo.
echo  [4/5] AZIONE MANUALE RICHIESTA:
echo  ─────────────────────────────────────────────────────────
echo   Supremo sta per avviarsi.
echo.
echo   1. Vai su Tools ^> Options ^> Console
echo   2. Accedi con le credenziali dell'account "%NOMEPROFILO%"
echo   3. Verifica che la rubrica clienti sia visibile
echo   4. Chiudi Supremo dalla tray  (tasto destro ^> Esci)
echo   5. Torna qui e premi un tasto per salvare il profilo
echo  ─────────────────────────────────────────────────────────
echo.
start /wait "" "%SUPREMO_EXE%"

:: ── 5. Salva settings.dat sulla chiavetta ────────────────────
echo  [5/5] Salvataggio profilo sulla chiavetta...

if not exist "%SETTINGS_PC%" (
    echo.
    echo  [ERRORE] settings.dat non trovato in %SETTINGS_DIR%\
    echo  Assicurati di aver chiuso Supremo dalla tray.
    echo.
    pause & exit /b 1
)

copy /Y "%SETTINGS_PC%" "%USER_DAT%" >nul
if errorlevel 1 (
    echo  [ERRORE] Impossibile salvare il profilo sulla chiavetta.
    pause & exit /b 1
)

:: ── Pulizia dal PC ───────────────────────────────────────────
del /F /Q "%SETTINGS_PC%" >nul 2>&1

echo.
echo  ============================================================
echo    Profilo "%NOMEPROFILO%" creato con successo!
echo.
echo    Launcher : XDrive\X-Supremo-%NOMEPROFILO%.exe
echo    User     : User\Supremo\%NOMEPROFILO%\settings.dat
echo    Backup   : Backup\Supremo\%NOMEPROFILO%\ (5 slot)
echo    PC pulito: nessuna traccia lasciata.
echo  ============================================================
echo.
echo  Vuoi creare un altro profilo?
set /p ALTRO="  (S/N): "
if /i "%ALTRO%"=="S" (
    cls
    goto :RICOMINCIA
)

goto :FINE

:RICOMINCIA
:: Rilancia la parte di raccolta dati senza rileggere i percorsi
echo.
echo  ============================================================
echo    X-Supremo :: Inizializzazione Nuovo Profilo
echo    winPenPack X-Launcher
echo  ============================================================
echo.
echo  Chiavetta  : %CHIAVETTA%
echo  WinPenPack : %WPP%
echo.
goto :RACCOLTA_DATI_SALTO

:: Etichetta per il secondo giro (salta la verifica struttura)
:RACCOLTA_DATI_SALTO

echo  Inserisci il nome del nuovo profilo.
echo  Diventa il nome del launcher, delle cartelle User e Backup.
echo  Usa solo lettere, numeri e trattini (no spazi).
echo.
set /p NOMEPROFILO="  Nome profilo: "
if "%NOMEPROFILO%"=="" ( echo  [ERRORE] Nome vuoto. & pause & exit /b 1 )
set NOMEPROFILO=%NOMEPROFILO: =-%

set NUOVO_INI=%XDRIVE%\X-Supremo-%NOMEPROFILO%.ini
if exist "%NUOVO_INI%" (
    echo.
    echo  [ATTENZIONE] Il profilo "%NOMEPROFILO%" esiste gia'.
    set /p SOVRASCRIVI="  Sovrascrivere? (S/N): "
    if /i not "!SOVRASCRIVI!"=="S" ( echo  Annullato. & pause & exit /b 1 )
)

echo.
echo  Inserisci il codice licenza (formato: XXXXX-XXXXX-XXXXX-XXXXX)
set /p LICENZA="  Licenza: "
if "%LICENZA%"=="" ( echo  [ERRORE] Licenza vuota. & pause & exit /b 1 )

echo.
echo  Inserisci il nome computer (max 50 caratteri)
set /p NOMEPC="  Nome computer: "
if "%NOMEPC%"=="" ( echo  [ERRORE] Nome vuoto. & pause & exit /b 1 )

set NUOVO_EXE=%XDRIVE%\X-Supremo-%NOMEPROFILO%.exe
set USER_PROFILO=%USER_SUPREMO%\%NOMEPROFILO%
set BACKUP_PROFILO=%BACKUP_SUPREMO%\%NOMEPROFILO%
set USER_DAT=%USER_PROFILO%\settings.dat

echo.
echo  ── Riepilogo ────────────────────────────────────────────
echo    Nome profilo : %NOMEPROFILO%
echo    Licenza      : %LICENZA%
echo    Nome PC      : %NOMEPC%
echo    Launcher     : XDrive\X-Supremo-%NOMEPROFILO%.exe
echo    User         : User\Supremo\%NOMEPROFILO%\
echo    Backup       : Backup\Supremo\%NOMEPROFILO%\
echo  ─────────────────────────────────────────────────────────
echo.
set /p CONFERMA="  Confermi? (S/N): "
if /i not "%CONFERMA%"=="S" ( echo  Annullato. & pause & exit /b 1 )
echo.

if not exist "%USER_PROFILO%\"   mkdir "%USER_PROFILO%"
if not exist "%BACKUP_PROFILO%\" mkdir "%BACKUP_PROFILO%"

set INI_TMP=%XDRIVE%\X-Supremo-%NOMEPROFILO%_tmp.ini
(for /f "usebackq delims=" %%R in ("%TEMPLATE_INI%") do (
    set "RIGA=%%R"
    set "RIGA=!RIGA:##NOMEPROFILO##=%NOMEPROFILO%!"
    echo !RIGA!
)) > "%INI_TMP%"
move /Y "%INI_TMP%" "%NUOVO_INI%" >nul
echo  XDrive\X-Supremo-%NOMEPROFILO%.ini  [OK]

copy /Y "%TEMPLATE_EXE%" "%NUOVO_EXE%" >nul
echo  XDrive\X-Supremo-%NOMEPROFILO%.exe  [OK]
echo.

echo  [1/5] Chiusura Supremo...
taskkill /IM Supremo.exe /F >nul 2>&1
timeout /t 2 >nul

echo  [2/5] Attivazione licenza...
echo %LICENZA% | "%SUPREMO_EXE%" -set-license
timeout /t 2 >nul

echo  [3/5] Impostazioni profilo...
"%SUPREMO_EXE%" -set-computer-name "%NOMEPC%"
"%SUPREMO_EXE%" -request-user-authorization 1
"%SUPREMO_EXE%" -display-request-for 30
"%SUPREMO_EXE%" -allow-after-request-timeout 0
"%SUPREMO_EXE%" /set-language it
timeout /t 2 >nul

echo.
echo  [4/5] AZIONE MANUALE RICHIESTA:
echo  ─────────────────────────────────────────────────────────
echo   1. Vai su Tools ^> Options ^> Console
echo   2. Accedi con le credenziali account "%NOMEPROFILO%"
echo   3. Verifica rubrica, poi chiudi dalla tray ^> Esci
echo   4. Premi un tasto per salvare
echo  ─────────────────────────────────────────────────────────
echo.
start /wait "" "%SUPREMO_EXE%"

echo  [5/5] Salvataggio profilo...
if not exist "%SETTINGS_PC%" (
    echo  [ERRORE] settings.dat non trovato. Chiudi Supremo dalla tray.
    pause & exit /b 1
)
copy /Y "%SETTINGS_PC%" "%USER_DAT%" >nul
del /F /Q "%SETTINGS_PC%" >nul 2>&1

echo.
echo  ============================================================
echo    Profilo "%NOMEPROFILO%" creato con successo!
echo    PC pulito: nessuna traccia lasciata.
echo  ============================================================
echo.
set /p ALTRO="  Creare un altro profilo? (S/N): "
if /i "%ALTRO%"=="S" ( cls & goto :RACCOLTA_DATI_SALTO )

:FINE
echo.
echo  ============================================================
echo    Tutti i profili sono stati creati.
echo  ============================================================
echo.
pause
endlocal
exit /b 0
