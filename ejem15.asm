; Los programas de Windows realizan la parte pesada del trabajo de programación a través de funciones API para sus GUI.
; Esto beneficia a los usuarios ya los programadores, a los usuarios por que no tienen porque aprender como navegar por una GUI en cada programa
; y a los programadores por que tienen disponibles las rutinas GUI ya probadas y listas para ser utilizadas.
; Lo único malo de esto es que la complejidad para la programación aumenta al tener que seguir una "receta" estricta 
; pero esto puede superarse al utilizar una programación modular o con el paradigma de la POO.
.686										; 
.model flat,stdcall 						; 
option casemap:none 						; 

; Llamado a las "funciones"/procedimientos disponibles en user32 y kernel32
include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
includelib \masm32\lib\user32.lib
include \masm32\include\kernel32.inc 
includelib \masm32\lib\kernel32.lib

; Esta es una declaración de función para ensamblador
; Nombre_Función PROTO [nombre_parámetro]:Tipo_Dato
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

; Sección de datos
.DATA
	ClassName db "SimpleWinClass",0        ; El nombre de la ventana a crear
	AppName db "Our First Window",0        ; Los datos que aparecerán en la ventana

; Sección de datos sin iniciar
.DATA?
	; Los tipos de datos HINSTANCE y LPSTRson nuevos nombres para DWORD, localizados en windows.inc
	hInstance HINSTANCE ?        			; Identificador de instancia del programa
	CommandLine LPSTR ?						; Línea de comando del programa

; Sección del código
.CODE
	start: 
		invoke GetModuleHandle, NULL		; Obtener el identificador de instancia del programa 
                                            ; En Win32, hmodule==hinstance mov hInstance,eax 

		mov hInstance,eax 
		invoke GetCommandLine				; Obtener la línea de comando. No es necesario llamar a esta función
											; Si el programa no procesa la línea de comando

		mov CommandLine,eax 
		invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT		; Llamar a la función principal
		invoke ExitProcess, eax                           				; Salir del programa. El código de salida es retornado de EAX desde WinMain

	WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
		LOCAL wc:WNDCLASSEX				; Crear variables locales en la pila
		LOCAL msg:MSG 					; WNDCLASSEX, SG, HWND se localizan en windows.inc
		LOCAL hwnd:HWND

		; Estas líneas involucran el concepto de clase de ventana, la cual no es más que un plano o especificación
		; de una ventana; va a definir varias características importantes de la ventana, como ícono, color, etc.
		; Se crea una ventana a partir de una clase de ventana, tal como en los lenguajes orientados a objetos.
		; Si se desea crear una ventana con las mismas características, lo ideal es guardarlas y consultarlas cuando sea necesario
		; Este esquema ahorrará mucha memoria al evitar la duplicación de información. 
		; Solo hay que recordar que Windows fue diseñado cuando los chips de memoria no sobrepasaban el 1MB de memoria
		; El punto es que al definir la propia ventana, se debe de llenar las características deseadas en una estructura 
		; WNDCLASS o WNDCLASSEX y llamar a RegisterClass o RegisterClassEx antes de que puedas crear la ventana. 
		; Solo debe registrar la clase de ventana una vez para cada tipo de ventana desde la que desee crearla.
		
		; Llenar los valores de los miembros de la variable wc
		mov   wc.cbSize,SIZEOF WNDCLASSEX
		mov   wc.style, CS_HREDRAW or CS_VREDRAW 
		mov   wc.lpfnWndProc, OFFSET WndProc 
		mov   wc.cbClsExtra,NULL 
		mov   wc.cbWndExtra,NULL 
		push  hInstance 
		pop   wc.hInstance 
		mov   wc.hbrBackground,COLOR_WINDOW+2		; COLOR_GRAYTEXT / COLOR_BTNSHADOW / COLOR_WINDOWFRAME ...
		mov   wc.lpszMenuName,NULL 
		mov   wc.lpszClassName,OFFSET ClassName 
		invoke LoadIcon,NULL,IDI_APPLICATION 	; IDI_EXCLAMATION / IDI_ASTERISK / IDI_ERROR / IDI_HAND / IDI_INFORMATION / IDI_QUESTION / IDI_SHIELD / IDI_WARNING / IDI_WINLOGO
		mov   wc.hIcon,eax 
		mov   wc.hIconSm,eax 
		invoke LoadCursor,NULL,IDC_ARROW	; IDC_APPSTARTING / IDC_CROSS / IDC_HAND / IDC_HELP / IDC_IBEAM / IDC_NO / IDC_WAIT
		mov   wc.hCursor,eax 
		invoke RegisterClassEx, addr wc                     ; Registrar la clase ventana
		invoke CreateWindowEx,NULL,\						; Crear la ventana
            ADDR ClassName,\ 
            ADDR AppName,\ 
            WS_OVERLAPPEDWINDOW,\ 
            CW_USEDEFAULT,\ 
            CW_USEDEFAULT,\ 
            CW_USEDEFAULT,\ 
            CW_USEDEFAULT,\ 
            NULL,\ 
            NULL,\ 
            hInst,\ 
            NULL 
			mov   hwnd,eax 
			invoke ShowWindow, hwnd,CmdShow					; Desplegar la venatana en el escritorio
			invoke UpdateWindow, hwnd						; actualizar el área del cliente

    .WHILE TRUE												; Entrar al loop del mensaje
                invoke GetMessage, ADDR msg,NULL,0,0		; Obtener los mensajes de Windows, esto es "conectarla" al mundo exterior
															; Durante este punto Windows puede darle el control a otros programas, formando
															; el esquema multitareas cooperativas de Win16
                .BREAK .IF (!eax) 							; GetMessage regresa FALSE si el mensaje WM_QUIT es recibido
                invoke TranslateMessage, ADDR msg			; Esto recibe la información del teclado en formato ASCII
                invoke DispatchMessage, ADDR msg			; DispatchMessage envía los datos del mensaje al proecedimiento de ventana responsable
															; por la ventana específica a la cual va dirigido el mensaje
   .ENDW 
    ; Cuando el ciclo termina, el código de salida se almacena en wParam de le estructura MSG
    mov     eax,msg.wParam									; Regresar el código de salida en EAX
    ret 
WinMain endp

; Esto es en donde reside la "inteligencia" de los programas
; El código que responde a cada mensaje de Windows está en el procedimiento de ventana. 
; El código debe chequear el mensaje de Windows para ver si hay un mensaje que sea de interés. 
; Si lo es, se hace algo que se desee en respuesta a ese mensaje y luego se regresa cero en eax. 
; Si no es así, debe llamarse a DefWindowProc, pasando todos los parámetros recibidos para su procesamiento por defecto. 
; DefWindowProc es una función de la API que procesa los mensajes en los que tu programa no está interesado
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
    .IF uMsg==WM_DESTROY									; si el usuario cierra la ventana, es el único mensaje que se debe responder
        invoke PostQuitMessage,NULL							; Detener la aplicación
    .ELSE 
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam		; Esta es una función de la API que procesa todos los mensajes
															; no relevantes para el programa en curso
        ret 
    .ENDIF 
    xor eax,eax 
    ret 
WndProc endp

end start
