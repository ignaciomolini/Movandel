@echo off
setlocal enabledelayedexpansion

:: 1. VERIFICAR QUE SEA ADMIN
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Por favor, ejecuta como ADMINISTRADOR.
    echo.
    pause
    exit /b
)

echo [+] Iniciando instalacion...

:: 2. CONFIGURAR RUTAS
set "folder=%SystemDrive%\Scripts"
if not exist "%folder%" mkdir "%folder%"
set "psFile=%folder%\Movandel.ps1"
set "vbsFile=%folder%\Invisible.vbs"

:: 3. CREAR EL SCRIPT POWERSHELL (VERIFICANDO QUE NO HAYA NADA ABIERTO ANTES DE COPIAR EL CONTENIDO EN LA CARPETA SUPERIOR)
echo param([string]$targetPath) > "%psFile%"
echo try { >> "%psFile%"
echo     if (Test-Path $targetPath) { >> "%psFile%"
echo         $parentPath = Split-Path -Path $targetPath -Parent >> "%psFile%"
echo         $items = Get-ChildItem -Path $targetPath -File >> "%psFile%"
echo         $ventanasAbiertas = Get-Process ^| Where-Object { $_.MainWindowTitle -ne "" } >> "%psFile%"
echo. >> "%psFile%"
echo         foreach ($item in $items) { >> "%psFile%"
echo             # --- PRUEBA 1: Escaneo de Ventanas (para Bloc de notas/Notepad++) --- >> "%psFile%"
echo             $tituloBuscado = $ventanasAbiertas ^| Where-Object { $_.MainWindowTitle -like "*$($item.Name)*" } >> "%psFile%"
echo             if ($tituloBuscado) { >> "%psFile%"
echo                 throw "El archivo '$($item.Name)' parece estar abierto en la ventana: '$($tituloBuscado[0].MainWindowTitle)'. Guardalo y cerralo." >> "%psFile%"
echo             } >> "%psFile%"
echo. >> "%psFile%"
echo             # --- PRUEBA 2: Bloqueo de Hardware (para Office/VLC/etc) --- >> "%psFile%"
echo             try { >> "%psFile%"
echo                 $fileStream = [System.IO.File]::Open($item.FullName, 'Open', 'Write', 'None') >> "%psFile%"
echo                 $fileStream.Close() >> "%psFile%"
echo             } catch { >> "%psFile%"
echo                 throw "El archivo '$($item.Name)' esta bloqueado por otro proceso del sistema." >> "%psFile%"
echo             } >> "%psFile%"
echo         } >> "%psFile%"
echo. >> "%psFile%"
echo         # --- ACCION FINAL: Mover y Borrar --- >> "%psFile%"
echo         Get-ChildItem -Path $targetPath ^| Move-Item -Destination $parentPath -Force -ErrorAction Stop >> "%psFile%"
echo         Remove-Item -Path $targetPath -Force -ErrorAction Stop >> "%psFile%"
echo         [System.Media.SystemSounds]::Asterisk.Play() >> "%psFile%"
echo     } >> "%psFile%"
echo } catch { >> "%psFile%"
echo     $wshell = New-Object -ComObject Wscript.Shell >> "%psFile%"
echo     $wshell.Popup("ACCION CANCELADA: " + $_.Exception.Message, 0, "Seguridad de Archivos", 48) >> "%psFile%"
echo } >> "%psFile%"

echo [+] Archivo PowerShell generado en: %psFile%

:: 4. CREAR EL VBSCRIPT (PARA EVITAR QUE PARPADEE LA CONSOLA)
:: Esta version usa chr(34) para asegurar que las comillas lleguen perfectas a PowerShell
echo Set WshShell = CreateObject("WScript.Shell") > "%vbsFile%"
echo target = WScript.Arguments(0) >> "%vbsFile%"
echo quote = Chr(34) >> "%vbsFile%"
echo cmd = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File " ^& quote ^& "%psFile%" ^& quote ^& " " ^& quote ^& target ^& quote >> "%vbsFile%"
echo WshShell.Run cmd, 0, False >> "%vbsFile%"

:: 5. REGISTRO DE WINDOWS (LO AGREGAMOS AL CLICK DERECHO SOBRE UNA CARPETA)
set "escapedVBS=%folder:\=\\%\\Invisible.vbs"

reg add "HKEY_CLASSES_ROOT\Directory\shell\ExtraerContenido" /ve /t REG_SZ /d "Extraer contenido y borrar carpeta" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\shell\ExtraerContenido" /v "Icon" /t REG_SZ /d "shell32.dll,259" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\shell\ExtraerContenido\command" /ve /t REG_SZ /d "wscript.exe \"%folder%\Invisible.vbs\" \"%%1\"" /f >nul

echo.
echo [OK] Instalacion completa! 
echo Probalo haciendo clic derecho en una carpeta.
echo.
pause