@echo off
REM rotate_fixed_logs.bat - rotate MySQL log file that has a fixed name

REM Argument 1: log filename

if not "%1" == "" goto ROTATE
@echo Usage: rotate_fixed_logs logname
goto DONE

:ROTATE
set logname=%1
erase %logname%.7
rename %logname%.6 %logname%.7
rename %logname%.5 %logname%.6
rename %logname%.4 %logname%.5
rename %logname%.3 %logname%.4
rename %logname%.2 %logname%.3
rename %logname%.1 %logname%.2
rename %logname% %logname%.1
mysqladmin flush-logs
:DONE
