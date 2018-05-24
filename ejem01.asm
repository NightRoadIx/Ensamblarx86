.586						; Procesador objetivo
.model flat, stdcall				; Modelo de memoria plano, llamadas convencionales o estándar

.stack 4096					; Sección de la pila

extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data						; Sección de datos

.data ?						; Sección de datos sin iniciar

.const						; Sección de constantes

.code						; Sección del código
	main:					; Etiqueta que define un segmento del código del programa
		nop				; Sin operación
		push 0				; Empujar un 0 a la pila

		; Ingresar un número directo al registro (por representación decimal, hexadecimal, binario)
		; decimal, se coloca el número tal cual
		; move 10 to register eax
		mov eax, 10
		; binaria, el número se coloca con una 'b' al final
		mov ebx, 10010101b
		; hexadecimal, el número se coloca con una 'h' al final
		mov ecx, 72h
		
		mov edx, eax			; Mover datos entre registros
		add eax, ebx			; Sumar los valores en los registros eax = eax + ebx

		push 0				; Mandar un 0 a la pila (argumento utilizado por el proceso siguiente)
		call ExitProcess@4		; Llamada a la función de la API

	end main				; Terminar la etiqueta del segmento de código del programa
