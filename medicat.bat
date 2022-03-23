@echo OFF & setlocal enabledelayedexpansion
cd /d %~dp0
title Εγκαταστάτης Medicat  [ΑΡΧΗ]
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)
:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
cd /d "%~dp0"
set ver=3006
set maindir=%CD%
set format=Y
goto wgetextract
:wgetafter
if exist "%CD%\wget.exe" (goto curver) else (goto curlwget)
REM == CHECK FOR UPDATE FIRST. DO NOT PASS GO. DO NOT COLLECT $200
:curlwget
echo.Το WGET δεν βρεθηκε χρησιμοποιητε διαφορετικη μεθοδος
curl -O -s http://cdn.medicatusb.com/files/install/wget.exe
:curver
wget "http://cdn.medicatusb.com/files/install/curver.ini" -O ./curver.ini -q
set /p remver= < curver.ini
del curver.ini /Q
if "%ver%" == "%remver%" (goto pwrshl) else (goto updateprogram)
:updateprogram
cls
echo.Μια καινουργια εκδοση του προγραματος υπαρχει. Το προγραμμα θα επανακινηθη.
wget "http://url.medicatusb.com/installerupdate" -O ./MEDICAT_NEW.bat -q
wget "http://cdn.medicatusb.com/files/install/update.bat" -O ./update.bat -q
start cmd /k update.bat
goto exit







:start
set installertext=[31mM[32mE[33mD[34mI[35mC[36mA[31mT[32m I[33mN[34mS[35mT[36mA[31mL[32mL[33mE[34mR[0m
reg add HKEY_CURRENT_USER\Software\Medicat\Installer /v version /t  REG_SZ /d  %ver% /f
if exist "%CD%\MEDICAT_NEW.EXE" (goto renameprogram) else (call:ascii)
pause
mode con:cols=64 lines=18
cls && goto:startup
REM -- WARN FOR ANTIVIRUS AND CHECK FOR UPDATE TO PROGRAM
:startup
title Εγκαταστάτης Medicat [ANTIVIRUS]
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII           ΛΌΓΩ ΤΩΝ ΣΥΣΚΕΥΑΣΜΈΝΩΝ ΑΡΧΕΊΩΝ ΣΕ ΑΥΤΌ ΤΟ   IIII
echo.IIIIΠΡΌΓΡΑΜΜΑ ΤΟ ANTIVIRUS ΠΡΈΠΕΙ ΝΑ ΕΊΝΑΙ ΑΠΕΝΕΡΓΟΠΟΙΗΜΈΝΟIIII
echo.IIII                                                       IIII
echo.IIII  ΒΕΒΑΙΩΘΕΊΤΕ ΌΤΙ ΤΟ ANTIVIRUS ΕΊΝΑΙ ΑΠΕΝΕΡΓΟΠΟΙΗΜΈΝΟ  IIII
echo.IIII ΠΡΙΝ ΣΥΝΕΧΊΣΕΤΕ ΝΑ ΧΡΗΣΙΜΟΠΟΙΕΊΤΕ ΑΥΤΌ ΤΟ ΠΡΌΓΡΑΜΜA   IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.                          Πατήστε οποιοδήποτε πλήκτρο για να παρακάμψετε αυτή την προειδοποίηση.&& pause >nul
:checkupdateprogram
title Εγκαταστάτης Medicat [FILECHECK]
ECHO.ΛΉΨΗ ΤΩΝ ΑΠΑΙΤΟΎΜΕΝΩΝ ΑΡΧΕΊΩΝ ΑΠΌ ΤΟ ΔΙΑΚΟΜΙΣΤΉ.
:cont
wget "http://cdn.medicatusb.com/files/install/motd.txt" -O ./motd.txt -q
wget "http://cdn.medicatusb.com/files/install/ver.ini" -O ./ver.ini -q
wget "http://cdn.medicatusb.com/files/install/LICENSE.txt" -O ./LICENSE.txt -q
set /p ver= < ver.ini
DEL ver.ini /Q
REM -- EXTRACT THE 7Z FILES BECAUSE THAT SHIT IS IMPORTANT
:7z
REM -- CHECK IF 64BIT
if defined ProgramFiles(x86) (goto 7z64) else (goto 7z32)
:7z32
wget "http://cdn.medicatusb.com/files/install/7z/32.exe" -O ./7z.exe -q
wget "http://cdn.medicatusb.com/files/install/7z/32.dll" -O ./7z.dll -q
goto 7ze
:7z64
wget "http://cdn.medicatusb.com/files/install/7z/64.exe" -O ./7z.exe -q
wget "http://cdn.medicatusb.com/files/install/7z/64.dll" -O ./7z.dll -q
goto 7ze
:7ze
CALL 7z.bat
DEL 7z.bat /Q
cls

:menu
REM -- THE MAIN MENU, THE HOLY GRAIL.
title Εγκαταστάτης Medicat [%ver%]
mode con:cols=100 lines=30
type LICENSE.txt
echo.
echo.Πατήστε οποιοδήποτε πλήκτρο για να συνεχίσετε (x2)
pause > nul
pause > nul
:menu2
mode con:cols=64 lines=20
type motd.txt
echo.
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                   %installertext%                   IIII
echo.IIII                                                       IIII
echo.IIII          I:        [91mI[0mNSTALL MEDICAT                    IIII
echo.IIII                                                       IIII
echo.IIII          F:     [91mF[0mormatting Drive: [%format%]                 IIII
echo.IIII                                                       IIII
echo.IIII          A:         [91mA[0mUTORUN PATCH                     IIII
echo.IIII                                                       IIII
echo.IIII          S:             [91mS[0mite                          IIII
echo.IIII                                                       IIII
echo.IIII             VERSION %ver% BY MON5TERMATT.             IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II           
choice /C:IFAS /N /M "Choose an option: I,F,A,S"
if errorlevel 4 cls && goto medicatsite
if errorlevel 3 cls && set goto=exit && goto autorun
if errorlevel 2 cls && goto formatswitch
if errorlevel 1 cls && goto check5
:formatswitch
if "%format%" == "Y" (goto fs2) else (echo.>nul)
if "%format%" == "N" (goto fs3) else (goto menu2)
:fs2
set format=N
goto menu2
:fs3
set format=Y
goto menu2
:check5
set goto=askdownload
goto updateventoy

REM -- GO TO END OF FILE FOR MOST EXTRACTIONS

REM -- WHEN DONE EXTRACTING VENTOY, TYPE LICENCE AND CONTINUE

:askdownload
if exist "%CD%\MediCat.USB.v21.12.7z" (goto warnventoy) else (goto dlcheck2)
:dlcheck2
if exist "%CD%\*.001" (goto warnventoy) else (goto dlcheck3)
:dlcheck3
cls
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII         ΔΕΝ ΜΠΌΡΕΣΕ ΝΑ ΒΡΕΙ ΤΟ(Α) ΑΡΧΕΊΟ(Α) MEDICAT.  IIII
echo.IIII              ΤΑ ΈΧΕΤΕ ΚΑΤΕΒΆΣΕΙ?                      IIII
echo.IIII                                                       IIII
echo.IIII            (ΕΙΤΕ *.001 ή το κύριο .7z)                IIII
echo.IIII                                                       IIII
echo.IIII           ΘΑ ΘΈΛΑΤΕ ΝΑ ΤΑ ΚΑΤΕΒΆΣΕΤΕ?                 IIII
echo.IIII                       ( Y / N )                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
choice /C:YN /N /M "Y/N"
if errorlevel 2 cls && goto warnventoy
if errorlevel 1 cls && goto bigboi



REM -- PROMPT USER TO INSTALL VENTOY TO THE USB DRIVE. VENTOY STILL NEEDS TO BE THERE EVEN IF USER ALREADY HAS IT.

:warnventoy
title Εγκαταστάτης Medicat [VENTOYCHECK]

cd .\INSTRUCTIONS\Ventoy2Disk\
start Ventoy2Disk.exe
cd %maindir%
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII            ΑΥΤΌ ΤΟ ΠΡΌΓΡΑΜΜΑ ΑΠΑΙΤΕΊ ΑΠΌ ΕΣΆΣ ΝΑ      IIII
echo.IIII            ΈΧΕΤΕ ΕΓΚΑΤΑΣΤΉΣΕΙ ΤΟ VENTOY ΣΤΗΝ          IIII
echo.IIII            ΜΟΝΆΔΑ USB ΠΟΥ ΘΑ ΠΡΟΣΘΈΣΕΤΕ ΤΟ            IIII
echo.IIII            MEDICAT USB. ΠΑΡΑΚΑΛΩ ΚΑΝΤΕ ΤΟ             IIII
echo.IIII            ΠΡΙΝ ΕΠΙΧΕΙΡΉΣΕΤΕ ΝΑ ΕΚΤΕΛΈΣΕΤΕ ΤΟ         IIII
echo.IIII                   SCRIPT  ΕΓΚΑΤΑΣΤΑΣΗΣ                IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.                          Πατήστε οποιοδήποτε πλήκτρο για να συνεχίσετε.&& pause >nul

REM -- INSTALLER

:install1

if exist "%CD%\*.001" (goto warnhash) else (goto install2)
REM -- IF DOWNLOADED IN PARTS, ASK USER IF THEY WANT TO DOWNLOAD THE HASH CHECKER (FIXER.EXE)

:warnhash
title Εγκαταστάτης Medicat [HASHCHECK]
cls
if exist "%CD%\*.001" (echo..001 Exists) else (goto gdriveerror)
if exist "%CD%\*.002" (echo..002 Exists) else (goto gdriveerror)
if exist "%CD%\*.003" (echo..003 Exists) else (goto gdriveerror)
if exist "%CD%\*.004" (echo..004 Exists) else (goto gdriveerror)
if exist "%CD%\*.005" (echo..005 Exists) else (goto gdriveerror)
if exist "%CD%\*.006" (echo..006 Exists) else (goto gdriveerror)
timeout 2 >nul
cls
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII     All Drive Files Exist (HASHES NOT CHECKED)        IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII   IT LOOKS LIKE YOU DOWNLOADED MEDICAT IN PARTS.      IIII
echo.IIII WOULD YOU LIKE TO MAKE SURE THEY DOWNLOADED PROPERLY? IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
choice /C:YN /N /M "Y/N"
if errorlevel 2 cls && goto install2
if errorlevel 1 cls && goto hasher

:gdriveerror
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                  DRIVE FILES MISSING                  IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII   IT LOOKS LIKE YOU DOWNLOADED MEDICAT IN PARTS.      IIII
echo.IIII              WE COULDNT FIND ONE OF THEM              IIII
echo.IIII              DID YOU DOWNLOAD ALL SIX??               IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.
echo.
pause
goto bigboi

:install2
title Εγκαταστάτης Medicat [CHOOSEINSTALL]
mode con:cols=100 lines=15
echo.We now need to find out what drive you will be installing to.
REM - FOLDER PROMPT STARTS
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
REM - AND ENDS
set drivepath=%folder:~0,1%
IF "%drivepath%" == "C" GOTO IMPORTANTDRIVE
if "%format%" == "Y" (goto formatdrive) else (goto installversion)
:formatdrive
Echo.Προειδοποίηση αυτό θα επαναδιατυπώσει ολόκληρο το %drivepath%: δισκο!
ECHO.Θα σας ζητηθεί να πατήσετε enter μερικές φορές.
pause
format %drivepath%: /FS:NTFS /x /q /V:Medicat
goto installversion

:error
echo.δεν επιλέχθηκε τίποτα, δοκιμάστε ξανά
timeout 5
goto install2
:importantdrive
mode con:cols=64 lines=18
echo.[101mII-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                   IMPORTANT WARNING                   IIII
echo.IIII                                                       IIII
echo.IIII       IT LOOKS LIKE YOU SELECTED THE C DRIVE          IIII
echo.IIII        THIS MAY CAUSE IRREPARABLE DAMAGE TO           IIII
echo.IIII               YOUR COMPUTER SYSTEM..                  IIII
echo.IIII           THE PROGRAM WILL NOW ASK AGAIN              IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.                          Πατήστε οποιοδήποτε πλήκτρο για να συνεχίσετε.[0m&& pause >nul
goto install2

REM -- CHECK WHICH VERSION USER DOWNLOADED

:installversion
title Εγκαταστάτης Medicat [INSTALL!!!]
if exist "%CD%\MediCat.USB.v21.12.7z" (goto install4) else (goto installversion2)
:installversion2
if exist "%CD%\MediCat.USB.v%ver%.zip.001" (goto install5) else (goto installerror)

:installerror
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII        Ο ΕΓΚΑΤΑΣΤΆΤΗΣ ΔΕΝ ΜΠΌΡΕΣΕ ΝΑ ΒΡΕΙ ΤΟ MEDICAT  IIII
echo.IIII ΠΑΡΑΚΑΛΟΥΜΕ ΝΑ ΕΠΙΛΕΞΕΤΕ ΧΕΙΡΟΚΙΝΗΤΑ ΤΟ ΑΡΧΕΙΟ .7z!   IIII
echo.IIII                                                       IIII
echo.IIIIΠΑΤΉΣΤΕ ΟΠΟΙΟΔΉΠΟΤΕ ΠΛΉΚΤΡΟ ΓΙΑ ΝΑ ΑΝΟΊΞΕΤΕ ΤΗΝ ΠΡΟΤΡΟΠΉ ΑΡΧΕΊΟΥ!IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
pause> nul

set dialog="about:<input type=file id=FILE><script>FILE.click();new ActiveXObject
set dialog=%dialog%('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);
set dialog=%dialog%close();resizeTo(0,0);</script>"

for /f "tokens=* delims=" %%p in ('mshta.exe %dialog%') do set "file=%%p"
mode con:cols=100 lines=15
goto install6


REM -- ACTUALLY EXTRACT/INSTALL

:install4
set file="MediCat.USB.v21.12.7z"
7z x -O%drivepath%: %file% -r -aoa
goto finishup

:install5
set file="MediCat.USB.v%ver%.zip.001"
7z x -O%drivepath%: %file% -r -aoa
goto finishup

:install6
7z x -O%drivepath%: "%file%" -r -aoa
goto finishup


REM -- FILE CLEANUP

:finishup
del motd.txt /q
del 7z.exe /Q
del 7z.dll /Q
set goto=deletefiles
goto autorun2


:autorun
mode con:cols=100 lines=15
echo.Παρακαλούμε επιλέξτε το Medicat Drive σας
REM - FOLDER PROMPT STARTS
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
REM - AND ENDS
set drivepath=%folder:~0,1%


:autorun2
wget "http://cdn.medicatusb.com/files/install/autorun.ico" -O %drivepath%:/autorun.ico -q
wget "http://cdn.medicatusb.com/files/hasher/Validate_Files.exe" -O %drivepath%:/Validate_Files.exe -q
cd /d %drivepath%:
start "%drivepath%:/Validate_Files.exe" "%drivepath%:/Validate_Files.exe"
goto %goto%




:deletefiles
cd /d %maindir%
echo.Θέλετε να διαγράψετε τα κατεβασμένα αρχεία?
echo.(everything in the folder you ran this from)
echo.(%maindir%)
choice /C:YN /N /M "Y/N"
if errorlevel 2 cls && exit
if errorlevel 1 cls && goto deleter

:deleter
cls
Set _folder="%~dp0"
Attrib +R %0
PUSHD %_folder%
If %errorlevel% NEQ 0 goto:eof
ECHO Διαγράψτε όλα τα περιεχόμενα του φακέλου: %_folder% ?
choice /C:YN /N /M "Y/N"
if errorlevel 2 cls && exit
if errorlevel 1 cls && goto YYEESS
:YYEESS
Del /f /q /s /a:-R %_folder% >NUL
:: Delete the folders
For /d %%G in (%_folder%\*) do RD /s /q "%%G"
Attrib -R %0
Popd
exit


:hasher
wget "http://cdn.medicatusb.com/files/hasher/Google_Drive_Validate_Files.exe" -O ./Google_Drive_Validate_Files.exe -q
start Google_Drive_Validate_Files.exe
goto install2


:medicatsite
start https://medicatusb.com
goto menu2

:updateventoy
wget "http://cdn.medicatusb.com/files/install/ventoy.bat" -O ./ventoy.bat -q
cls
call ventoy.bat
cls
goto %goto%


:exit
exit


:bigboi
cls
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII      ΘΑ ΘΈΛΑΤΕ ΝΑ ΧΡΗΣΙΜΟΠΟΙΉΣΕΤΕ ΤΟ TORRENT          IIII
echo.IIII    ΓΙΑ ΝΑ ΚΑΤΕΒΆΣΕΤΕ ΤΗΝ ΤΕΛΕΥΤΑΊΑ ΈΚΔΟΣΗ?            IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                         Y / N                         IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
choice /C:YN /N /M "Y/N"
if errorlevel 2 cls && goto drivedown
if errorlevel 1 cls && goto tordown
:drivedown
cls
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII           ΘΑ ΘΈΛΑΤΕ ΝΑ ΧΡΗΣΙΜΟΠΟΙΉΣΕΤΕ ΤΟ TORRENT     IIII
echo.IIII            ΓΙΑ ΝΑ ΚΑΤΕΒΆΣΕΤΕ ΤΗΝ ΤΕΛΕΥΤΑΊΑ ΈΚΔΟΣΗ?    IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII           OK ΧΡΗΣΙΜΟΠΟΙΏΝΤΑΣ ΤΟ GOOGLE DRIVE ΑΝΤΊ     IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
wget "http://cdn.medicatusb.com/files/install/download/drive.bat" -O ./downloader.bat -q
call drive.bat
del drive.bat /Q
goto warnventoy

:tordown
wget "http://cdn.medicatusb.com/files/install/download/tor.bat" -O ./tor.bat -q
call tor.bat
del tor.bat /Q
goto warnventoy

:renameprogram
wget "http://cdn.medicatusb.com/files/install/update.bat" -O ./update.bat -q
start cmd /k update.bat
exit



REM == RUNS AT START.
:CHECK4ERRORS
:pwrshl
if exist "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" (goto winvercheck0) else (goto pwrshlerr)
:pwrshlerr
mode con:cols=64 lines=18
title Εγκαταστάτης Medicat [ERROR]
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                 ΑΥΤΌ ΤΟ ΠΡΌΓΡΑΜΜΑ ΑΠΑΙΤΕΊ             IIII
echo.IIII              POWERSHELL ΝΑ ΕΙΝΑΙ ΕΓΚΑΤΆΣΤΗΜΕΝΟ.       IIII
echo.IIII                                                       IIII
echo.IIIIΠΑΡΑΚΑΛΟΎΜΕ ΕΓΚΑΤΑΣΤΉΣΤΕ ΤΟ POWERSHELL ΣΤΟ ΛΕΙΤΟΥΡΓΙΚΌ ΣΑΣ ΣΎΣΤΗΜΑIIII
echo.IIII                 ΚΑΙ ΞΑΝΑΠΡΟΣΠΑΘΉΣΤΕ. ΕΥΧΑΡΙΣΤΙΕΣ.     IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.Εάν πιστεύετε ότι ΕΙΝΑΙ εγκατεστημένο και θέλετε να παρακάμψετε αυτή την προειδοποίηση,
Set /P _num=type "OK": || Set _num=NothingChosen
If "%_num%"=="NothingChosen" exit
If /i "%_num%"=="ok" goto winvercheck0
:error
goto exit
REM == CHECK IF USER IS RUNNING SUPPORTED OS. OTHERWISE WARN.
:winvercheck0
for /f "tokens=2 delims=," %%i in ('wmic os get caption^,version /format:csv') do set os=%%i
set os=%os:~0,20%
if "%os%" == "Microsoft Windows 8" (goto start) else (goto winvercheck1)
:winvercheck1
if "%os%" == "Microsoft Windows 10" (goto start) else (goto winvercheck2)
:winvercheck2
if "%os%" == "Microsoft Windows 11" (goto start) else (goto backupcheck)
:backupcheck
for /f "tokens=4-5 delims=. " %%i in ('ver') do set os2=%%i.%%j
if "%os2%" == "10.0" goto start
goto winvererror





:winvererror
mode con:cols=64 lines=18
title Εγκαταστάτης Medicat [UNSUPPORTED]
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                  [91m%os%[0m                   IIII
echo.IIII                   Δεν υποστιριζεται πια.              IIII
echo.IIII                                                       IIII
echo.IIII            Παρακαλουμε ενημερωσετε σε Windows 10/11   IIII
echo.IIII                                                       IIII
echo.IIII[91m Versions Insider Μπορω να εχουν αφτο το θεμα[0mIIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
Set /P _num=To Bypass This Warning Type "I AGREE": || Set _num=NothingChosen
If "%_num%"=="NothingChosen" exit
If /i "%_num%"=="I AGREE" goto start
:error
goto exit




:ascii
mode con:cols=100 lines=55
echo.@@   @@  @@@@@@  @@       @@@@    @@@@   @@   @@  @@@@@@          @@@@@@   @@@@                 
echo.@@   @@  @@      @@      @@  @@  @@  @@  @@@ @@@  @@                @@    @@  @@                
echo.@@ @ @@  @@@@    @@      @@      @@  @@  @@ @ @@  @@@@              @@    @@  @@                
echo.@@@@@@@  @@      @@      @@  @@  @@  @@  @@   @@  @@                @@    @@  @@                
echo. @@ @@   @@@@@@  @@@@@@   @@@@    @@@@   @@   @@  @@@@@@            @@     @@@@                 
echo.                                                                                                
echo.        @@@@@@  @@  @@  @@@@@@          @@   @@  @@@@@@  @@@@@   @@@@@@   @@@@    @@@@   @@@@@@ 
echo.          @@    @@  @@  @@              @@@ @@@  @@      @@  @@    @@    @@  @@  @@  @@    @@   
echo.          @@    @@@@@@  @@@@            @@ @ @@  @@@@    @@  @@    @@    @@      @@@@@@    @@   
echo.          @@    @@  @@  @@              @@   @@  @@      @@  @@    @@    @@  @@  @@  @@    @@   
echo.          @@    @@  @@  @@@@@@          @@   @@  @@@@@@  @@@@@   @@@@@@   @@@@   @@  @@    @@   
echo.                                                                                                
echo.                @@@@@@  @@  @@   @@@@   @@@@@@   @@@@   @@      @@      @@@@@@  @@@@@           
echo.                  @@    @@@ @@  @@        @@    @@  @@  @@      @@      @@      @@  @@          
echo.                  @@    @@ @@@   @@@@     @@    @@@@@@  @@      @@      @@@@    @@@@@           
echo.                  @@    @@  @@      @@    @@    @@  @@  @@      @@      @@      @@  @@          
echo.                @@@@@@  @@  @@   @@@@     @@    @@  @@  @@@@@@  @@@@@@  @@@@@@  @@  @@          
echo.																								
echo.  .........                                                              .........  
echo.  ................                     ......                     ................  
echo.  .....................       ........................       .....................  
echo.  .... ................. .................................  ................. ...   
echo.   ... [101m0@@@00ooo[0m....................................................[101mooo00@@@0[0m ...   
echo.   ... [101mo@@@@@@@@@0o[0m..............................................[101mo@@@@@@@@@@o[0m ...   
echo.    ....[101m0@@@@@@0o[0m..................................................[101mo@@@@@@@0[0m....    
echo.    ... [101mo@@@@@o[0m......................................................[101m0@@@@@o[0m ...    
echo.     ....[101m0@@0[0m.........................................................[101mo@@@0[0m....     
echo.     ... [101m.@0[0m............................................................[101m0@[0m.....     
echo.      ... [101mo[0m..............................................................[101mo[0m ...      
echo.       ... .............................................................  ...       
echo.        .. .............................................................. ..        
echo.          ...........[42mo0o.....ooo[0m....................[42mooo.....o0o[0m...........          
echo.          .........[42mo00o[40m       [42mo00o[0m.......oo.......[42mo000[40m       [42mo00o[0m.........          
echo.         .........[42mo00o[40m         [42m000o[0m......00......[42mo00o[40m         [42m000o[0m........          
echo.         ..........[42mo00[40m         [42m000o[0m ....0@@0.....[42m000o[40m         [42m00o[0m.........          
echo.  ...oooooooooo.....[42mo0o[40m       [42mo00o[0m.....0@@@@0.....[42mo00o[40m       [42mo0o[0m.....oooooooooo...  
echo.  ........ooooooooo...[42mooo...oooo[0m.....o0@@@@@@0o.....[42moooo...ooo[0m..oooooooooo......o.  
echo.       ...........oo................o0@@@@@@@@@o...............ooo...........       
echo.       ..ooooooooooo..............o0@@@@@@@@@@@@0o..............ooooooooooo..       
echo..oooooooooooooooooooo..........oo0@@@@@@@@@@@@@@@@0oo..........ooooooooooooooooooo..
echo....      ...................oo0@@@@@@@@@@@@@@@@@@@@@@0oo...................     ....
echo.          ..ooooooooooooo00@@@@@oo@@@@@@0oo0@@@@@0oo@@@@@00ooooooooooooo..          
echo.        .oooo.o00000@@@@@@@@@@@@@ooooooo000oooooo.o@@@@@@@@@@@@@0000o..oooo.        
echo.      ooo.  .0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0oo0@@@@@@@@@@@@@@@@@@@o. ..oo.      
echo.              .oo0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0oo.              
echo.                  .oo0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0oo.                  
echo.                      ..ooo000@@@@@@@@@@@@@@@@@@@@@@@@000ooo..                      
echo.                              ....oooooooooooooooo....                              
echo.Κοδικοποιημενο απο MON5TERMATT με την βοηθεια των AAA3A, Daan Breur, Jayro, και πολλων αλλων. Ευχαριστουμε!
echo.Ελληνικη Μετφραση απο Yolomic#8395
exit/b







REM REQUIRED FILES FOR EXTRACTION

:wgetextract
echo.[30m
@set "0=%~f0" &powershell -nop -c $f=[IO.File]::ReadAllText($env:0)-split':bat2file\:.*';iex($f[1]); X(1) &echo.[0m &goto wgetafter
