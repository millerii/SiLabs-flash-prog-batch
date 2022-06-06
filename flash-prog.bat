@echo off
REM ******************** Olli Lehtonen 2019 **********************
REM **Flash Programming Utility (SiliconLabs) must be installed **
REM **                Unique bootloader -files:                 **
REM **              "BL_hex_location"\'snr_begin'               **
REM **          "ProgID" must match the debug-adapter           **
REM **************************************************************

mode con: cols=47 lines=19
chcp 65001
cls

REM Define constant variables (change if necessary)
REM --------------------------------
set ProgID=EC3004B918D
set ProgSoft="C:\SiLabs\MCU\Utilities\FLASH Programming\Static Programmers\Command-Line\FlashUtilCL.exe"
set BL_hex_location=C:\bootloaders\V1_02
REM --------------------------------

set /p snr_begin=First half of serial number:
set /p snr_end=Second half of serial number:
set snr=%snr_begin%%snr_end%
echo.

:start
set BL_hex=%BL_hex_location%\%snr_begin%\BL_%snr%.hex
echo Serial number to be programmed:
echo ****[93m BL_%snr%.hex [0m****
echo.

:enter
set input=
echo [35mPress Enter to start programming[0m
set /p input=
if not '%input%'=='' goto enter

:start_flash
echo Erasing flas...[33m
call %ProgSoft% flasheraseusb "%ProgID%" 0
echo.
if %errorlevel% neq 0 (goto error)

echo [0mFlashing bootloader...[33m
call %ProgSoft% downloadusb -R "%BL_hex%" "%ProgID%" 0 0
echo.[0m
if %errorlevel% neq 0 (goto error)

:next_snr
set /a snr=%snr%+1
echo.

echo Serial number of next board [93m%snr%[35m
pause
echo.[0m
cls
goto start

:error
echo.
echo !!! Programming error !!!
set input=
echo [31;47mEnter[0m - Try same again
echo [31;47m"n"[0m  - Skip to the next board
set /p input=">> "
if '%input%'=='' (goto start_flash
 ) else if '%input%'=='n' (goto next_snr)
