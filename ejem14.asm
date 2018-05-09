; A partir de los procesadores 80386, los programas Win32 que Windows corre van a hacerlo en un espacio de memoria virtual
; Este espacio ya no es los 64 kB de los segmentos, sino 4 GB, sin embargo es importante mencionar que esto no significa que
; cada programa va a tener disponible 4GB de espacio físico, sino que a cada programa se le asigna un espacio de 4GB
; de los que puede tomar de forma aleatoria en ese intervalo
; A diferencia de win16, donde cualquier programa podía ver o escribir sobre los segmentos de otro, Windows se encarga de
; hacer que el programa win32 este "solo" en su espacio de memoria
; De ahí entonces que ya no es necesario apuntar a un Segmento de memoria (con el consecuente uso del registro) sino que
; se puede seleccionar cualquier espacio dentro de esos 4GB, por lo que el único modelo disponible es el FLAT

; La otra regla importante a recordar en Win32 es que Windows utiliza los regitros ESI, EDI, EBP y EBX internamente
; por lo que sus valores pueden cambiar constantemente, por lo que si se van a utilizar, es necesario restaurarlos
; a su valor anterior una vez que se terminen de utilizar y se regrese el control a Windows

; SET DE INSTRUCCIONES X86
.686
; MODELO DE DATOS (solo está disponible FLAT)
.model flat, stdcall
option casemap:none							; Esto hace que se ignoren las letras mayúsculas/minúsculas

; INCLUSIÓN DE LIBRERÍAS
; Aquí es absolutamente necesario tener instalado el SDK del MASM32 para poder ejecutar
; las funciones de la API win32 con las MACROS
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib kernel32.lib
include \masm32\include\user32.inc
includelib user32.lib

; SECCIÓN DE DATOS INICIADOS
.data
MsgCaption      db "Lenguaje ensamblador",0
MsgBoxText      db "El ensamblador con Win32 es más que perfecto!",0

; SECCIÓN DE DATOS SIN INICIAR
.data?

; SECCIÓN DE DATOS CONSTANTES
.const

; SECCION DE CÓDIGO
.code
start:	; ETIQUETA PRINCIPAL
	; Se invoca (INVOKE) a la "función" o procedimiento de la API Win32 
	; MessageBox con todos sus parámetros
	invoke MessageBox, NULL,addr MsgBoxText, addr MsgCaption, MB_OK
	; Se hace lo mismo con el procedimiento ExitProcess
	invoke ExitProcess,NULL
end start ; FIN DE LA ETIQUETA PRINCIPAL
