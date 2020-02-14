@rem COLOR [background][foreground]
@rem 0 = Black   8 = Gray
@rem 1 = Blue    9 = Light Blue
@rem 2 = Green   A = Light Green
@rem 3 = Aqua    B = Light Aqua
@rem 4 = Red     C = Light Red
@rem 5 = Purple  D = Light Purple
@rem 6 = Yellow  E = Light Yellow
@rem 7 = White   F = Bright White
@COLOR F0

:: BUILD Script for PIC18 targets

:: %1 = project_path
:: %2 = file_name (.ld)
:: %3 = target_name
:: %4 = compiler_path
:: %5 = prog_tool

@echo Running script = %0
@echo Working dir = %1
@echo File name = %2
@echo Target name = %3
@echo ...

@rem %~d0 = Drive in full name
@rem %~p0 = Path in full name
@rem %~n0 = Name without extension
@rem %~dp0 = Drive + Path in full name
@rem %~nx0 = Name + extension

@if exist  HTC\objrmdir HTC\obj /s /q
@if exist  HTC\binrmdir HTC\bin /s /q
@if not exist HTC\obj mkdir HTC\obj
@if not exist HTC\bin mkdir HTC\bin
@if not exist HTC\lib mkdir HTC\lib

@rem EXE_PATH from where the ldmicro.exe and *.bat are run
@SET EXE_PATH=%~dp0

@SET LIB_PATH=%EXE_PATH%\LIBRARIES_FOR\PIC18

if not exist HTC\lib\UsrLib.c copy %LIB_PATH%\*.* HTC\lib
dir HTC\lib\*.c

SET PCC_PATH=%ProgramFiles%\HI-TECH Software\PICC\9.81
SET PICKIT_PATH=%ProgramFiles%\Microchip\MPLAB IDE\Programmer Utilities\PICkit3
PATH %PCC_PATH%\BIN;%PICKIT_PATH%;%PATH%

@rem Compile libraries
:: %4\picc18.exe --pass1 UsrLib.c -q --chip=%3 -P -I%1 -I%1\HTC\lib --runtime=default --opt=default -g --asmlist --OBJDIR=HTC\obj
FOR %%F in (HTC\lib\*.c) do  picc18.exe --pass1 %%F -q --chip=%3 -P -I%1 -I%1\HTC\lib --runtime=default --opt=default -g --asmlist --OBJDIR=HTC\obj

@rem Compile main file
:: %4\picc18.exe --pass1 %2.c -q --chip=%3 -P --runtime=default -I%1\HTC\lib --opt=default -g --asmlist --OBJDIR=HTC\obj
picc18.exe --pass1 %~nx2.c -q --chip=%3 -P --runtime=default -I%1\HTC\lib --opt=default -g --asmlist --OBJDIR=HTC\obj

@rem Link object files
:: %4\picc18.exe -oHTC\bin\%2.cof -mHTC\bin\%2.map --summary=default --output=default HTC\obj\*.p1 --chip=%3 -P --runtime=default --opt=default -g --asmlist --OBJDIR=HTC\obj --OUTDIR=HTC\bin
picc18.exe -oHTC\bin\%2.cof -mHTC\bin\%2.map --summary=default --output=default HTC\obj\*.p1 --chip=%3 -P --runtime=default --opt=default -g --asmlist --OBJDIR=HTC\obj --OUTDIR=HTC\bin

@echo ...
@pause
