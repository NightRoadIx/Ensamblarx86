.586
.model flat, stdcall
.stack 4096
extrn ExitProcess@4:proc

.data
	res	DD	?
	
.code
	main:
		nop
		push 0
		
		mov eax, 0
		mov ebx, 0
		mov ecx, 0
		mov edx, 0

		; 2° PARTE DEL MANEJO DE LA ALU, OPERACIONES ARITMÉTICAS Y LÓGICAS
		
		; Operaciones aritméticas
		; Cargar los valores
		mov ax, 34952
		mov bx, 15
		mov cx, 61440
		mov dx, 6
		
		; Sumar bx:ax más dx:cx (suma con acarreo)
		add cx, ax
		adc dx, bx

		; La resta con acarreo se lleva a cabo con la intrucción "sbb"
		
		; Suma de números en BCD
		mov ax, 38h			; decimal empaquetado "38"
		mov bx, 45h			; decimal empaquetado "45"
		add ax, bx			; Se realiza la suma
		; Al utilizar la instrucción daa, realiza la corrección "empaquetando" en BCD el resultado de una suma
		; Observa las banderas del registro de estado AF (ajuste) y CF (acarreo)
		daa
		
		; La corrección para el "empaquetado" BCD de una resta se realiza con la
		; instrucción "das"
		
		; La operacion "neg" niega el operando o hace 0 - operando y lo guarda en el mismo
		mov eax, 15
		neg eax				; ?

		; Operación "imul" para multiplicación, esta puede utilizar 2 operandos...
		mov eax, 8
		mov ebx, 3
		imul eax, ebx		; eax = eax * ebx
		; ... o 3 operandos
		mov eax, 8
		mov ebx, 3
		imul eax, ebx, 5	; eax = ebx * 25
		
		; Operación "idiv" realiza la división del número de 64 bits edx:eax, entre el registro utilizado como operando
		; el cociente se deja guardado en eax y el residuo en edx		
		; Por tanto si se desea dividir 25 / 3
		mov edx, 0		; Se carga un 0 en la parte "alta" del registro de 64 bits formado por edx:eax
		mov eax, 25		; Se carga el 25 en la parte "baja" del registro, ahora hay un valor de 0:25, el dividendo
		mov ebx, 3		; Se carga el 3 en el registro ebx que funcionará como el divisor
		idiv ebx		; Se hace la operación (edx:eax) / ebx
		
		; Operaciones de rotación de bits
		; RCL Rotar bits a la izquierda, pero tomando en cuenta la bandera CF de acarreo del registro de estado
		mov ebx, 240
		; Por ejemplo las instrucciones
		mov eax, 15
		neg eax	
		; colocan en 1 el bit de acarreo
		; al hacer la rotación considerando el bit de acarreo
		rcl ebx, 3
		
		; La rotación a la derecha se realiza con la instrucción RCR
		
		push 0
		call ExitProcess@4
	end main	
