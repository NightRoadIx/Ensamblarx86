.586							; Procesador objetivo, usar instrucciones para máquinas de clase Pentium (x86 32 bits)
.model flat, stdcall					; Utilizar el modelo de memoria flat (plano), llamadas de convención stdcall, para usar win32
.stack 4096 						; Definir el stack (pila) de 4096 bytes (se reserva un espacio en memoria de ese tamaño)

extrn ExitProcess@4:proc				; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data							; Crear un segmento de datos cercano, las variables locales se especifican después
	x	DD	2, 4, 3				; Un arreglo con 3 datos
	sum	DD	0				; Una variable para guardar el valor de la suma

.code							; Indica el comienzo del segmento de código
	main:						; Etiqueta main
		nop					; No Operation
		push 0
		
		mov eax, 3				; Número de datos en el arreglo
		mov ebx, 0				; Aquí se guardarán los datos de la suma
		lea ecx, [x]				; ECX apuntará al elemento a ser sumado, por tanto se guarda su dirección
		
		top:			
			add ebx, [ecx]			; Sumar EBX más lo que este apuntando ECX
			add ecx, 4			; Incrementar ECX de acuerdo al valor de los datos que se están utilizando
			dec eax				; SE resta 1 al contador
			jnz top				; Probar que el contador no haya llegado a 0

		mov [sum], ebx				; Guardar el valor obtenido de la suma
			
		push 0					; La siguiente función requiere de un 0
		call ExitProcess@4			; Llamada a la función de la API ( exit(0) )
	end main					; fin de esta sección de código y del programa
