# Movandel 

Permite mover instantáneamente todos los archivos de una carpeta al directorio superior ("subirlos" un nivel) y eliminar la carpeta original vacía, todo en un solo paso y de forma 100% invisible.

## Características

**Integración Nativa:** Acceso directo desde el clic derecho en cualquier carpeta.  
**Ejecución Invisible:** Gracias a un puente en VBScript, no verás parpadeos de ventanas negras de consola.  
**Doble Verificación de Seguridad:**  
**Escaneo de Ventanas:** Detecta si archivos están abiertos en el Bloc de Notas o editores similares mediante el título de la ventana.  
**Bloqueo de Hardware:** Verifica si programas como Office, VLC o Photoshop tienen archivos "secuestrados".  
**Acción Atómica:** Si un solo archivo está en uso, el proceso se cancela automáticamente para evitar que los archivos queden esparcidos.  
**Feedback Auditivo:** Sonido de sistema al completar la tarea con éxito.  

## Instalación
Descargá el archivo Instalar.bat.  
Hacé clic derecho sobre él y seleccioná "Ejecutar como administrador".  
Esto es necesario para que el script pueda crear la carpeta en C:\Scripts y modificar el Registro de Windows.  
Una vez finalizado, verás un mensaje de confirmación.  

## Cómo funciona
El sistema se compone de tres piezas que trabajan en conjunto:  
Movandel.ps1 (PowerShell): Contiene la lógica inteligente de detección de errores, movimiento de archivos y eliminación.  
Invisible.vbs (VBScript): Actúa como intermediario para lanzar PowerShell de forma oculta  
Registro de Windows: Crea la entrada en HKEY_CLASSES_ROOT\Directory\shell para habilitar el menú.  

## Requisitos  
Sistema Operativo: Windows 10 o Windows 11.  
Permisos: Se requieren privilegios de administrador para la instalación inicial.  

## Desinstalación  
Si deseás quitar la herramienta, podés borrar la carpeta C:\Scripts y eliminar la llave ExtraerContenido en el Editor del Registro (regedit) de la siguiente manera:  
Presionar Win + R, escribir regedit y darle a Enter. Luego navegar hasta HKEY_CLASSES_ROOT\Directory\shell\ y borrar la carpeta llamada ExtraerContenido.  
