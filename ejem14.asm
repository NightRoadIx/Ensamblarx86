.686
.model flat, stdcall
option casemap:none							; Esto hace que se ignoren las letras mayúsculas/minúsculas

; Aquí es absolutamente necesario tener instalado el SDK del MASM32 para poder ejecutar
; las funciones de la API win32 con las MACROS
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib kernel32.lib
include \masm32\include\user32.inc
includelib user32.lib

.data
; Datos a utilizar
MsgCaption      db "Lenguaje ensamblador",0
MsgBoxText      db "El ensamblador con Win32 es más que perfecto!",0

.code
start:
	; Se invoca (INVOKE) a la "función" o procedimiento de la API Win32 
	; MessageBox con todos sus parámetros
	invoke MessageBox, NULL,addr MsgBoxText, addr MsgCaption, MB_OK
	; Se hace lo mismo con el procedimiento ExitProcess
	invoke ExitProcess,NULL
end start
