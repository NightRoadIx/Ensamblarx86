.586						; Procesador objetivo, usar instrucciones para máquinas de clase Pentium (x86 32 bits)
.model flat, stdcall				; Utilizar el modelo de memoria flat (plano), llamadas de convención stdcall, para usar win32
.stack 4096 					; Definir el stack (pila) de 4096 bytes (se reserva un espacio en memoria de ese tamaño)

extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)
extrn MessageBoxA@16:proc			; Son salida del proceso y una ventana de mensaje

.data						; Crear un segmento de datos cercano, las variables locales se especifican después
msg_txt db "Hola a Todos",0			; Aquí se define como byte el mensaje de texto (string) y un 0
msg_caption db "Programa Prueba",0		; Aquí se define como byte el título del mensaje (string) y un 0

.code						; Indica el comienzo del segmento de código
	main:					; Etiqueta main
		nop				; No Operation
		
		push 32				; Enviar a la pila que tipo de botones se utilizan  {uType}
						; Esto se calcula como la suma de las constantes para botones, íconos, botón default y modalidad
						; 	[BOTONES]   vbOKOnly (0), vbOKCancel(1), vbAbortRetryIgnore (2), vbYesNoCancel(3), vbYesNo (4), vbRetryCancel (5)
						;	[ICONOS]    vbCritical (16),vbQuestion (32),vbExclamation (48), vbInformation (64)
						;	[DEFAULT]   vbDefaultButton1 (0),vbDefaultButton2 (256),vbDefaultButton3 (512),vbDefaultButton4(768)
						;	[MODALIDAD] vbApplicationModal, vbSystemModal
		lea eax, msg_caption		; Cargar dirección efectiva destino, fuente, el mensaje al registro de propósito general EAX
		push eax			; Mover el contenido del registro EAX a la pila {lpCaption}
		lea eax, msg_txt		; Cargar el registro EAX con el mensaje
		push eax			; Mover a la pila {lpText}
		push 0				; Enviar un cero a la pila, {hWnd}
						; en este punto la pila esta cargada con los valores (hWnd, lpText, lpCaption, k)
						; esto indica que el proceso MessageBoxA recibe como parámetros (hWnd, lpText, lpCaption, k)
		call MessageBoxA@16		; Llamada a la función de la API
		
		push 0				; La siguiente función requiere de un 0
		call ExitProcess@4		; Llamada a la función de la API ( exit(0) )
	end main				; fin de esta sección de código y del programa
