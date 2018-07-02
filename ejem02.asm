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
	arr		DD	100 DUP(1)	; Declarar 100 valores de 4-bytes iniciando en la locación arr, todos iniciados a 1
	; double_word arr[100] = {1,1,1,...,1};
	
.code						; Indica el comienzo del segmento de código
	main:					; Etiqueta main
		nop				; No Operation
		push 0				; RAMEND (último elemento de memoria)
		
		mov eax, 0FFh			; Mover un número a un registro
						; move EAX, 255
		mov edx, -25			; Mover un número negativo, observar que se
						; almacena en complemento a 2, pero utilizando los 32 bits
		mov edx, 0
		mov dl, -25			; Lo mismo pero para 8 bits

		lea esi, [var]			; Cargar la dirección Efectiva de la variable (probar ebx, var)
		lea ecx, [eax]			; Esto funciona como mov (probar ecx, eax)
						; LEA puede sustituirse mediante MOV ESI, OFFSET var

		mov dl, [var]			; En cambio, mov va a mover el valor en el espacio en memoria
						; MUCHO CUIDADO, LOS ESPACIOS EN MEMORIA DEBE REFERIRSE CON LOS CORCHETES PARA OBTENER SU VALOR

		mov [var2], 020h		; Mover el valor 020H a la variable var2 (se mueven los contenidos)
		mov EBX, EAX			; Mover el valor de registro EAX al registro EBX
		mov dh, 66			; Mover el valor de 66 al registro dh

		mov edi, offset var2		; Mover la dirección de la variable var2 al registro EDI
						; RECORDAR, LAS DIRECCIONES DE MEMORIA SON VALORES DE 32 BITS
		mov [edi+1], dh			; Mover al valor de la dirección apuntada por EDI+1, el valor del registro DH
						; Aquí se coloco un valor de 10 en un inicio
						; Este EDI+1 no modifica el valor del registro EDI! =D

		mov [edi+2], dx			; Aquí se refiere a el valor apuntado por el registro EDI+2
						; Que no es otro más que el valor reservado en memoria como 'X' de tipo word
		

		mov byte ptr [var], 5		; Almacenar el valor de 5 en un byte en la locación var
						; Al utilizar [] quiere decir que no se quiere la locación del identificador, sino su valor

		add [Z], 1			; Se pueden hacer operaciones directamente en memoria, refiriendose por ejemplo al arreglo de datos
						; o también llamado vector
		add [Z+4], 2			; Y moverse sobre el arreglo dependiendo del tamaño de la variable
		add [Z+8], 3			
						; MUCHO CUIDADO CON ESTO, YA QUE SINO SE RECORRE DEPENDIENDO DEL TAMAÑO DE LA VARIABLE
						; SE TERMINA RECORRIENDO DE 8 EN 8 BITS Y NO SE HACEN LAS OPERACIONES CORRECTAS SI SE TRATA
						; DE UNA RESERVA DE MEMORIA DE MAYOR TAMAÑO


		; ******* MANEJO DE LA PILA *******

		mov eax, 012345678h		; Mober un número grande al registro EAX
		
		push ax				; Enviar eax a la pila
		nop
		push [Y]			; Enviar el valor de la variable Y a la pila
						; La pila solo soporta enviar valores de 32 bits de memoria hacia ella
						; A diferencia de los registros que pueden "apilarse" valores de 16 o 32 bits
		nop
		pop edi				; Obtener el valor que se encuentra en el pila y vaciarlo al registro EDI
		
		nop
		pop dx				; POP también puede almacenar valores ya sea en registros (8, 16 o 32 bits)
						; y en memoria
				
		push 0
		call ExitProcess@4		; Llamada a la función de la API
	end main				; fin de esta sección de código y del programa
