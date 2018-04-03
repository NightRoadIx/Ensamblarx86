.586						; Procesador objetivo, usar instrucciones para máquinas de clase Pentium
; .386 .486  -- 16 bits
.model flat, stdcall				; Utilizar el modelo de memoria flat (plano), llamadas de convención stdcall, para usar win32
; directiva plana, llamadas estándar (win32)
.stack 4096 					; Definir el stack (pila) de 4096 bytes
extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data						; Crear un segmento de datos cercano, las variables locales se especifican después
	var		DB	64		; Declarar un byte, referido como una locación var, conteniendo el valor 64
	; byte var = 64;   {{8 bits}}
	var2	DB	?			; Declarar un byte sin iniciar, referido como locación var2
	; byte var2;
			DB	10		; Declarar un byte sin etiqueta, que contiene el valor 10. Su locación es var2+1
	; byte = 10;
	X		DW	?		; Declarar un valor de 2-bytes (palabra) sin iniciar, referida como X
	; word X;   {{16 bits}}
	Y		DD	30000		; Declarar un valor de 4-bytes, referido como locación Y, iniciado a 30000
	; double_word Y = 30000;	{{32 bits}}
	Z		DD	1, 2, 3		; Declarar 3 valores de 4-bytes, iniciados en 1, 2 y 3. El valor de la locación Z+8 es 3
	; double_word Z[] = {1, 2, 3};
	arr		DD	100, (0)	; Declarar 100 valores de 4-bytes iniciando en la locación arr, todos iniciados a 0
	; double_word arr[100] = {0,0,0,...,0};
	
.code						; Indica el comienzo del segmento de código
	main:					; Etiqueta main
		nop				; No Operation
		push 0				; RAMEND (último elemento de memoria)
		
		mov EAX, 0FFh			; Mover un número a un registro
		; move EAX, 255		
		mov [var2], 020h		 Mover el valor 020H a la variable var2
		mov EBX, EAX
		; mov Rd, Rs
		; var2 = 020h;
		mov byte ptr [var], 5		; Almacenar el valor de 5 en un byte en la locación var
						; Al utilizar [] quiere decir que no se quiere la locación del identificador, sino su valor
		
		push eax			; Enviar eax a la pila
		nop
		pop edi				; Obtener el valor que se encuentra en el pila y vaciarlo al registro EDI
		
		; Load Effective Address
		lea ebx, [var]			; Cargar la dirección Efectiva de la variable (probar ebx, var)
		lea ecx, [eax]			; Esto funciona como mov (probar ecx, eax)

		
		push 0
		call ExitProcess@4		; Llamada a la función de la API
	end main				; fin de esta sección de código y del programa
