.586
.model flat, stdcall
.stack 4096
extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data
	res	DD	?			;
	
.code
	main:
		nop
		push 0
		
		; REGISTROS DE PROPÓSITO GENERAL EAX, EBX, ECX, EDX
		; Estos son registros de 32 bits, sin embargo se subdividen en registros de 8 y 16 bits
		; para contar con una mayor cantidad de registros
		; ES MUY IMPORTANTE OBSERVAR COMO SE MUEVEN LOS DATOS DE UN REGISTRO A OTRO
		; ¡PUES ES IMPOSIBLE HACER CABER UN VALOR DE 32 BITS EN UN REGISTRO DE 8 BITS!
		mov eax, 0			; Mover un 0 al registro EAX de 32 bits (limpiar todo el registro)
		mov al, 8			; Mover un valor de 8 bits a la parte "baja" del registro AX
		mov ah, 1			; Mover un valor de 8 bits a la parte "alta" del registro AX
		; En este momento el registro debe valer 0x0108
		mov ax, 1492		; Mover un valor de 16 bits al registro AX
		mov eax, 14000605	; Mover un valor de 32 bits al registro EAX
		
		; entonces simplemente los 4 registros disponibles de propósito general (EAX, EBX, ECX, EDX)
		; se subdividen en:
		; 
		;  EAX (32 bits)
		; ---------------------------------------
		; |                  |   AH    |   AL   |  (cada uno de 8 bits)
		; ---------------------------------------
		;		    AX (16 bits)
		
		; MANEJO BÁSICO DE LA ALU, OPERACIONES ARTIMÉTICO LÓGICAS (Y DESPLAZAMIENTO DE BITS)
		; [[ PONER MUCHA ATENCIÓN A LOS BITS DEL REGISTRO DE ESTADO ]]
		
		; ******* OPERACIONES ARITMÉTICAS *******
		mov eax, 1			; Cargar datos en registro eax (MOVer datos)
		mov ebx, 5			; Cargar datos en registro ebx

		inc eax				; INCrementar valor del registro eax en 1									
		dec ebx				; DECrementar valor del registro ebx en 1
						; INC operando, donde operando puede ser registro o valor en memoria
						; DEC operando

		add eax, ebx			; Suma de los datos que se encuentran en los registros eax, ebx									
		sub eax, ebx			; SUBstraer al valor del registro eax, el valor del registro ebx
						; ADD destino, fuente.	Pueden ser:
						; Registro a Registro			ADD reg, reg
						; Memoria a registro			ADD mem, reg
						; Registro a memoria			ADD reg, mem
						; Registro a dato constante		ADD reg, inmediato
		mov ecx, eax			; Mover el resultado del registro eax a la variable en memoria res
				
		mul ebx				; MULtiplicar el valor en el registro eax por ebx
		; La multiplicación se puede presentar en 3 casos
		; 1.- Multiplicar dos bytes
		; Se considera que uno de los multiplicandos está en el registro AL [Este es el registro principal de la ALU, el acumulador, es fijo]
		; El otro en algún registro de 8 bits (BL, BH, CL, CH, DL, DH e incluso AH)
		; Si se quiere multiplicar AL x BL se coloca:
		; mul bl
		; El resultado se guarda en AH:AL

		; 2.- Multiplicar dos words
		; Multiplicando en AX, mientras que el otro en cualquier registro de tamaño word (BX, CX, DX)
		; La operación es AX x BX = DX:AX 
		; mul bx

		; 3.- La operación realizada en el ejemplo, 2 palabras dobles
		; se hace: EAX x EBX = EDX:EAX

		mov ebx, 3
		div ebx			; DIVidir el valor en el registro eax entre ebx
		; Para la división hay igual 3 casos:
		; 1.- Dividir bytes
		; El dividendo es un word almacenado en AX y se divide por algún byte (por ejemplo BL)
		; AX / BL = AL		y el residuo queda en AH

		; 2.- Dividir words
		; El dividendo es una dword almacenada en los registros DX:AX y se divide por alguna word (por ejemplo BX)
		; DX:AX / BX = AX	y el residuo en DX

		; 3.- Dividir dwords (ejemplo)
		; El dividendo es una qword almacenada en EDX:EAX y el divisor es una dword (por ejemplo EBX)
		; EDX:EAX / EBX = EAX	y el residuo en EDX

		; ******* OPERACIONES LÓGICAS *******

		mov eax, 170		; Mover valor 170 al registro eax
		and eax, 15		; Hacer eax = eax AND 15
					; Recordar que la operación AND se efectua bit a bit sobre ambos operandos
					; Esto quiere decir:
					; 170 = 10101010b = 0xAA
					;  15 = 00001111b = 0x0F
					; -----------------------
					;  10 = 00001010b = 0x0A  (A esto se le conoce como "enmascaramiento")

		mov eax, 170		; Mover valor 170 al registro eax
		or eax, 15		; Hacer eax = eax OR 15
					; Recordar que la operación OR se efectua bit a bit sobre ambos operandos
					; Esto quiere decir:
					; 170 = 10101010b = 0xAA
					;  15 = 00001111b = 0x0F
					; -----------------------
					; 175 = 10101111b = 0xAF

		mov eax, 170		; Mover valor 170 al registro eax
		xor eax, 15		; Hacer eax = eax XOR 15
					; Recordar que la operación AND se efectua bit a bit sobre ambos operandos
					; Esto quiere decir:
					; 170 = 10101010b = 0xAA
					;  15 = 00001111b = 0x0F
					; -----------------------
					; 165 = 10100101b = 0xA5	

		mov eax, 170		; Mover valor 170 al registro eax
		not eax			; Hacer eax = negado(eax)

		; OPERACIONES DE DESPLAZAMIENTO DE BITS

		mov eax, 48		; Mover valor 48 al regisro eax
		shr eax, 3		; Desplazamiento de 3 bits a la derecha
					; shl desplazamiento de bits a la izquierda

		ror eax, 7		; Rotación de 7 bits a la derecha
					; rol rotación de bits a la izquierda

		push 0
		call ExitProcess@4	; Llamada a la función de la API
	end main
