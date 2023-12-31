@echo off

echo oss-install_debug...

rem Example calls:
rem > install.cmd               # Install all dlls in the directory of the executable to be debugged
rem > install.cmd flow2d3d      # Install only project flow2d3d (and its dependencies)

rem 0. defaults:
set project=

rem  The next statement is needed in order for the set commands to work inside the if statement
setlocal enabledelayedexpansion

if [%1] EQU [] (
    rem Install all engines.

    set project=install_all
    echo Source          : all engines
) else (
    rem Install the package/engine specified by the first argument.

    set project=%1
    echo Source          : package/engine !project!
)

rem Change to directory tree where this batch file resides (necessary when oss-install.cmd is called from outside of oss/trunk/src)
cd %~dp0\..\..

call :!project!

goto end

rem  Actual install "routines"

rem ============================================================
rem === if the command before a call to handle_error returns ===
rem === an error, the script will return with an error       ===
rem ============================================================
:handle_error
    if NOT %ErrorLevel% EQU 0 (
        set globalErrorLevel=%ErrorLevel%
    )
    rem go back to call site
goto :endproc

rem =============================================================
rem === copyFile takes two arguments: the name of the file to ===
rem === copy to the destiny directory                         ===
rem ===                                                       ===
rem === NOTE: errors will be reported and the script will     ===
rem === with an error code after executing the rest of its    ===
rem === statements                                            ===
rem =============================================================
:copyFile
    set fileName=%~1
    set dest=%~2
    rem
    rem "echo f |" is (only) needed when dest does not exist
    rem and does not harm in other cases
    rem
    echo f | xcopy "%fileName%" %dest% /F /Y
    if NOT !ErrorLevel! EQU 0 (
        echo ERROR: while copying "!fileName!" to "!dest!"
    )
    call :handle_error
goto :endproc

rem =============================================================
rem === copyNetcdf copy the appropriate netcdf.dll            ===
rem =============================================================
:copyNetcdf
    call :copyFile "third_party_open\netcdf\netCDF 4.6.1\bin\*" !dest_bin!
goto :endproc


rem ===============
rem === INSTALL_ALL
rem ===============
:install_all
    echo "    WARNING: DISABLED: oss-install_debug_x64.cmd::install_all . . ."
goto :endproc



rem ==========================
rem === INSTALL_D_HYDRO
rem ==========================
:d_hydro
    echo "installing d_hydro . . ."
    set dest_bin="engines_gpl\d_hydro\bin\x64\Debug"

    if not exist !dest_bin!     mkdir !dest_bin!

goto :endproc



rem ==========================
rem === INSTALL_DIMR
rem ==========================
:dimr
    echo "WARNING: DISABLED: oss-install_debug_x64::dimr . . ."
goto :endproc



rem ====================
rem === INSTALL_FLOW2D3D
rem ====================
:flow2d3d
    echo "installing flow2d3d . . ."

    set dest_bin="engines_gpl\d_hydro\bin\x64\Debug"

    if not exist !dest_bin!     mkdir !dest_bin!

    copy engines_gpl\flow2d3d\bin\x64\Debug\flow2d3d.dll                                     !dest_bin!
    copy engines_gpl\flow2d3d\bin\x64\Debug\flow2d3d_sp.dll                                  !dest_bin!
       rem One of these two dlls will not exist and cause an ErrorLevel=1. Reset it.
    set ErrorLevel=0
    copy third_party_open\DelftOnline\lib\x64\Debug\DelftOnline.dll                          !dest_bin!
    copy third_party_open\pthreads\bin\x64\*.dll                                             !dest_bin!

    copy third_party_open\expat\x64\x64\Debug\libexpat.dll                                   !dest_bin!
    copy utils_lgpl\delftonline\lib\x64\Debug\dynamic\delftonline.dll                        !dest_bin!
    call :copyNetcdf

    set dest_bin="engines_gpl\dimr\bin\x64\Debug"

    if not exist !dest_bin!     mkdir !dest_bin!

    copy engines_gpl\flow2d3d\bin\x64\Debug\flow2d3d.dll                                     !dest_bin!
    copy engines_gpl\flow2d3d\bin\x64\Debug\flow2d3d_sp.dll                                  !dest_bin!
       rem One of these two dlls will not exist and cause an ErrorLevel=1. Reset it.
    set ErrorLevel=0
    copy third_party_open\DelftOnline\lib\x64\Debug\DelftOnline.dll                          !dest_bin!
    copy third_party_open\pthreads\bin\x64\*.dll                                             !dest_bin!

    copy third_party_open\expat\x64\x64\Debug\libexpat.dll                                   !dest_bin!
    copy utils_lgpl\delftonline\lib\x64\Debug\dynamic\delftonline.dll                        !dest_bin!
    call :copyNetcdf
goto :endproc



rem ===========================
rem === INSTALL_FLOW2D3D_OPENDA
rem ===========================
:flow2d3d_openda
    echo " WARNING: DISABLED: oss-install_debug_x64::flow2d3d_openda . . ."
goto :endproc



rem ===================
rem === INSTALL_DELWAQ1
rem ===================
:delwaq1
    echo "installing delwaq1 . . ."
    echo "... nothing to be done"
goto :endproc



rem ===================
rem === INSTALL_DELWAQ2
rem ===================
:delwaq2
    echo "installing delwaq2 . . ."
    echo "... nothing to be done"
goto :endproc



rem ======================
rem === INSTALL_DELWAQ_DLL
rem ======================
:delwaq_dll
    echo "installing delwaq dll . . ."
    echo "... nothing to be done"
goto :endproc



rem ==============================
rem === INSTALL_DELWAQ2_OPENDA_LIB
rem ==============================
:delwaq2_openda_lib
    echo "installing delwaq2_openda_lib . . ."
    echo "... nothing to be done"
goto :endproc



rem ================================
rem === INSTALL_WAQ_PLUGIN_WASTELOAD
rem ================================
:waq_plugin_wasteload
    echo "installing waq_plugin_wasteload . . ."
    echo "... nothing to be done"
goto :endproc



rem ================
rem === INSTALL_WAVE
rem ================
:wave
    echo " WARNING: DISABLED: oss-install_debug_x64::wave . . ."
goto :endproc



rem ==========================
rem === INSTALL_PLUGIN_CULVERT
rem ==========================
:plugin_culvert
    echo "installing plugin_culvert . . ."

    set dest_bin="engines_gpl\d_hydro\bin\x64\Debug"

    if not exist !dest_bin!     mkdir !dest_bin!

    copy plugins_lgpl\plugin_culvert\bin\x64\Debug\plugin_culvert.dll                        !dest_bin!
goto :endproc



rem ====================================
rem === INSTALL_PLUGIN_DELFTFLOW_TRAFORM
rem ====================================
:plugin_delftflow_traform
    echo "installing plugin_delftflow_traform . . ."

    set dest_bin="engines_gpl\d_hydro\bin\x64\Debug"

    if not exist !dest_bin!     mkdir !dest_bin!

    copy plugins_lgpl\plugin_delftflow_traform\bin\x64\Debug\plugin_delftflow_traform.dll    !dest_bin!
goto :endproc



rem ==================
rem === INSTALL_DATSEL
rem ==================
:datsel
    echo "installing datsel . . ."
    echo "... nothing to be done"
goto :endproc



rem ==================
rem === INSTALL_KUBINT
rem ==================
:kubint
    echo "installing kubint . . ."
    echo "... nothing to be done"
goto :endproc



rem ================
rem === INSTALL_LINT
rem ================
:lint
    echo "installing lint . . ."
    echo "... nothing to be done"
goto :endproc



rem ====================
rem === INSTALL_MORMERGE
rem ====================
:mormerge
    echo "installing mormerge . . ."
    echo "... nothing to be done"
goto :endproc


rem ====================
rem === INSTALL_WAQMERGE
rem ====================
:waqmerge
    echo "installing waqmerge . . ."
    echo "... nothing to be done"
goto :endproc

rem ====================
rem === INSTALL_DDCOUPLE
rem ====================
:ddcouple
    echo "installing ddcouple . . ."
    echo "... nothing to be done"
goto :endproc


rem ====================
rem === INSTALL_AGRHYD
rem ====================
:agrhyd
    echo "installing agrhyd. . ."
    echo "... nothing to be done"
goto :endproc

rem ====================
rem === INSTALL_MAPTONETCDF
rem ====================
:maptonetcdf
    echo "installing maptonetcdf. . ."
    echo "... nothing to be done"
goto :endproc



rem ==============
rem === INSTALL_VS
rem ==============
:vs
    echo "installing vs . . ."
    echo "... nothing to be done"
goto :endproc






:end
if NOT %ErrorLevel% EQU 0 (
    rem
    rem Only jump to :end when the script is completely finished
    rem
    exit /B %ErrorLevel%
)

:endproc
   rem
   rem No exit here
   rem Otherwise the script exits directly at the first missing artefact
