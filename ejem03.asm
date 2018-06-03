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
		
		; MANEJO BÁSICO DE LA ALU, OPERACIONES ARTIMÉTICO LÓGICAS (Y DESPLAZAMIENTO DE BITS)
		; [[ PONER MUCHA ATENCIÓN A LOS BITS DEL REGISTRO DE ESTADO ]]
		
		; OPERACIONES ARITMÉTICAS
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

		div ebx				; DIVidir el valor en el registro eax entre ebx

		; OPERACIONES LÓGICAS

		mov eax, 170			; Mover valor 170 al registro eax
		and eax, 15			; Hacer eax = eax AND 15

		mov eax, 170			; Mover valor 170 al registro eax
		or eax, 15			; Hacer eax = eax OR 15

		mov eax, 170			; Mover valor 170 al registro eax
		xor eax, 15			; Hacer eax = eax XOR 15

		mov eax, 170			; Mover valor 170 al registro eax
		not eax				; Hacer eax = negado(eax)

		; OPERACIONES DE DESPLAZAMIENTO DE BITS

		mov eax, 48			; Mover valor 48 al regisro eax
		shr eax, 3			; Desplazamiento de 3 bits a la derecha
						; shl desplazamiento de bits a la izquierda

		ror eax, 7			; Rotación de 7 bits a la derecha
						; rol rotación de bits a la izquierda

		push 0
		call ExitProcess@4		; Llamada a la función de la API
	end main
