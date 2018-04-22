.586								; Procesador objetivo, usar instrucciones para máquinas de clase Pentium (x86 32 bits)
.model flat, stdcall				; Utilizar el modelo de memoria flat (plano), llamadas de convención stdcall, para usar win32
.stack 4096 						; Definir el stack (pila) de 4096 bytes (se reserva un espacio en memoria de ese tamaño)

extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data								; Crear un segmento de datos cercano, las variables locales se especifican después
	msg1	DB	"Hola a todos$"		; Guardar cadenas de caracteres
	msg2	DB	"Hola a mundos$"
	msg3	DB	"Iguales$"
	x		DD	0

.code								; Indica el comienzo del segmento de código
	main:							; Etiqueta main
		nop							; No Operation
		push 0
		
		mov eax, 0					; Cargar un 0 al registro EAX
		mov esi, 0					; Cargar un 0 al registro ESI
		mov edi, offset msg1		; Conocer la dirección donde se almacenan las cadenas

		comienzo:
			mov esi, x				; Mover el valor de x al registro ESI (recordar Registro Source Index)
			mov al, msg2[si]		; Mover el elemento de la memoria en el punto SI a la parte baja del registro AX
									; Aquí cabe recordar EAX (32 bits), AX (16 bits) y por último AH y AL (8 bits)
			cmp msg1[si], al		; Se compara caracter por caracter
			jne fin					; En caso de que no sean iguales, saltará a fin

			cmp msg1[si], "$"		; Compara para saber si ya se llegó al final de las cadenas
			jz final				; Si es así, entonces salta a final
			inc x					; En otro caso incrementa el contador
			loop comienzo			; Hacer loop a comienzo

		final:						; En caso de que se llegue al caracter final '$'
			mov edx, offset msg3	; Dejar apuntando al registro EDX la cadena msg3 (que quiere decir que son iguales)

		fin:
			nop						; Ir aquí cuando o se termine el programa por que no se halló coincidencias en la cadena
									; o porque se llegó al fin de la cadena

		push 0						; La siguiente función requiere de un 0
		call ExitProcess@4			; Llamada a la función de la API ( exit(0) )
	end main						; fin de esta sección de código y del programa