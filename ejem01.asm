.586						; Procesador objetivo
.model flat, stdcall				; Modelo de memoria plano, llamadas convencionales o estándar

.stack 4096					; Sección de la pila

extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data						; Sección de datos

.code						; Sección del código
	main:					; Etiqueta que define un segmento del código del programa
		nop				; Sin operación
		push 0				; Empujar un 0 a la pila

		mov eax, 72h			; Ingresar un número directo al registro (decimal, hexadecimal, binario)
		mov ebx, eax			; Mover datos entre registros
		add eax, ebx			; Sumar los valores en los registros

		mov eax, [40100H]		; Mover los datos en la dirección 0x40100 al registro eax

		push 0				; Mandar un 0 a la pila (argumento utilizado por el proceso siguiente)
		call ExitProcess@4		; Llamada a la función de la API

	end main				; Terminar la etiqueta
