; En general los programas ensamblador bajo MASM consisten en módulos hechos de segmentos
; Los segmentos lógicos contienen los tres componentes de un programa: código, datos y la pila
; MASM los organiza automáticamente, por lo que ocupan segmentos físicos de memoria en el tiempo de ejecución
; (REcordar los registros de segmento CD,DS, SS, los cuales contienen segmentos de memoria física o segmentos lógicos) * [modos de manejo de memoria]
; 

.586								; Directiva de procesador, existen de varios tipos:
									; .386, .386P para procesadores 80386 sin y con Privilegios (Modo Protegido) 8 y 16 bits
									; .486, .486P, procesadores 80486, 16 bits
									; .586, .586P, procesadores 80586, 32 bits
									; .686, .676P, procesadores 80686, 32 y 64 bits
									; .MMX, para habilitar el uso de instrucciones MMX (instrucciones de datos múltiples)

.model flat, stdcall				; Inicia el modelo de memoria del programa
									; Sintaxis .MODEL modelomemoria [[, tipolang]] [[, opciónpila]]
									; modelomemoria --> Parámetro requerido que determina el tamaño del código y los punteros de datos
									;	para 32 bits solo existe FLAT (16 bits soportaba TINY, SMALL, COMPACT, MEDIUM, LARGE, HUGE, FLAT)
									; langtype --> Parámetro opcional que establece las convenciones de llamada y nomenclatura para procedimientos y símbolos públicos
									;	C, STDCALL para 32 bits (16 bits soportaba C, BASIC, FORTRAN, PASCAL, SYSCALL, STDCALL)
									; stackoption --> No se utiliza si el modelomemoria es FLAT
									;	(16 bits soportaba NEARSTACK, FARSTACK)

.stack 4096							; Utilizado junto con .MODEL, permite definir el número de bytes para la pila (por defecto es de 1024)


extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)


.data								; Directiva de datos, todo lo que vaya después de esto es para indicar reserva de memoria
									; El segmento de datos puede ocupar hasta 512 MB utilizado el .MODEL FLAT (antiguamente solo era 64 KB en DOS)
									; Se puede utilizar también .DATA? para variables sin iniciar
	var		DD	64
	TABLA	DD	1, 2, 3, 4, 5

.data?
	var2	DD	?

.const								; Utilizado para definir datos constantes, como cadenas y números de punto flotante que requieran guardarse en memoria
	msg_txt db "Hola a todos menos al Mundo",0
	
.code								; Directiva de código, todo lo que vaya después de esta directiva es código
	main:
		nop
		push 0
		
		; INSTRUCCIONES DE TRANSFERENCIA DE DATOS
		mov eax, 0FFh				; MOV realiza la transferencia de datos del operando de origen al destino (del mismo tamaño) [MOV bx, eax]
									; MOV va a admitir todos los modos de direccionamiento,
									; MOV registro, constante (Direccionamiento directo)
									; MOV registro, registro (Direccionamiento de registro)									
		mov ebx, eax
									; MOV memoria, registro	(Direccionamiento directo) {{OJO si se usa una dirección directa de memoria, no se puede recibir}}
									; MOV registro, memoria	
		mov var2, eax
		mov ecx, var
		mov edx, [010h]
									; MOV registro, [registro base] + k (Direccionamiento por registro base)
		mov eax, [ebp] + 1			; Almacena en EAX el contenido de la posición de memoria que resulte de sumar k al contenido
									; de EBP (dentro del segmento de pila)
		mov [ebp], ecx				; Almacena en la direcciona apuntada por EBP el contenido del registro ECX
		
		mov ebx, offset var			; Obtener la dirección en donde se encuentra la variable var
		mov edx, offset TABLA
		
									; Direccionamiento indexado
		mov ecx, TABLA[edi] + 1		; Almacena en ECX el contenido de la posición de memoria apuntada por el resultado de sumarle
									; a TABLA, el contenido del registro EDI + k
				
		mov eax, 16
		mov ebx, 8
		xchg eax, ebx				; XCHG realiza el intercambio entre los valores de los operandos

		
		; Operaciones con la pila
		; PUSH y POP, realizan las operaciones de apilado y desapilado en la pila del procesador
		push eax					; Coloca el valor del registro eax en la pila
		nop
		pop edi						; Mueve el contenido de la pila (el último elemento) hacia el registro EDI
		
		pushf						; Apila el valor del registro de estado EFLAGS
		popf						; Desapila el registro de estado 

		push 0
		call ExitProcess@4
	end main						; END también es una directiva para terminar con el bloque generado por la etiqueta