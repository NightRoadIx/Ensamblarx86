.586								; Procesador objetivo, usar instrucciones para máquinas de clase Pentium (x86 32 bits)
.model flat, stdcall				; Utilizar el modelo de memoria flat (plano), llamadas de convención stdcall, para usar win32
.stack 4096 						; Definir el stack (pila) de 4096 bytes (se reserva un espacio en memoria de ese tamaño)

extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data								; Crear un segmento de datos cercano, las variables locales se especifican después
	valor	DD	3

.code								; Indica el comienzo del segmento de código
	main:							; Etiqueta main
		nop							; No Operation
		push 0

		mov eax, 0
		mov ebx, 0

		mov ebx, [valor]
		call proc_fact

		push 0						; La siguiente función requiere de un 0
		call ExitProcess@4			; Llamada a la función de la API ( exit(0) )

		proc_fact:					; Procesar el factorial
			cmp bl, 1				
			jg calculo
			mov ax, 1
			ret

		calculo:
			dec bl
			call proc_fact
			inc bl
			mul bl					
			ret

	end main						; fin de esta sección de código y del programa