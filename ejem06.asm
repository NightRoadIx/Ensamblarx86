.586								; Directiva de procesador, existen de varios tipos:

.model flat, stdcall				; Inicia el modelo de memoria del programa

.stack 4096							; Utilizado junto con .MODEL, permite definir el número de bytes para la pila (por defecto es de 1024)


extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)


.data								; Directiva de datos, todo lo que vaya después de esto es para indicar reserva de memoria
	var		DD	64
	var2	DD	128
	num1	DD	47
	num2	DD	22
	num3	DD	31
	
.code								; Directiva de código, todo lo que vaya después de esta directiva es código
	main:
		nop
		push 0
		
		mov eax, 170
		mov ebx, 15
		
		; OPERACIONES DE COMPARACIÓN
		; Estas operaciones afectan al registro de estado
		; IMPORTANTE RECORDAR LAS BANDERAS DEL SREG:
		; | Direction | UP |
		; | Interrupt | EI |
		; | Sign      | PL |
		; | Zero      | ZR |
		; | Auxiliary | AC |
		; | Parity    | PE |
		; | Carry     | CY |
		test eax, ebx				; Realiza la operación AND entre dos operandos, sin afectar ninguno

		cmp eax, ebx				; Realiza la comparación de ambos operandos efectuando la resta entre ellos

		; OPERACIONES DE SALTO
		; BUCLES

		; LOOP hace que el programa salte en la dirección especificada (por una etiqueta), utiliza registro ECX como contador
		; haciendo que DEC ECX cada iteración y mientras ECX sea distinto de 0
		mov ecx, 10					; Mover un valor de 10 a ECX
		comienzo:					; Etiqueta de marca
			loop comienzo			; Esto hará que el bucle se repita 10 veces

		; LOOPE/LOOPZ de la misma forma que LOOP revisa si ECX no es cero y además si ZR del SREG (EFLAGS) está en 0
		; de lo contrario no se moverá hacia la etiqueta
		mov ecx, 10
		;cmp eax, eax
		siguiente:
			loopz siguiente
		; La opción LOOPNE/LOOPNZ revisa que ECX no sea cero y que ZR sea 1

		; En caso de que se quiera hacer un salto cuando ECX sea cero se utiliza la instrucción JCXZ
		mov ecx, 5
		vuelta:
			loop vuelta
		nop						; En este punto ECX es cero
		jcxz saltito			; Salta a la etiqueta
		add eax, ebx			; Esta instrucción nunca se efectua

		saltito:				
			nop					; Aquí llega el PC (Contador de Programa)

		; SALTOS
		; SALTO INCONDICIONAL
		; JMP, este modifica el PC para "saltar" hacia la dirección indicada por una
		; etiqueta
		mov eax, 0
		mov ebx, eax
		mov ecx, 1

		salto20:
			add eax, 1
			add ebx, eax
			shl cx, 1
		;	jmp salto20


		; SALTOS CONDICIONALES
		; Hacen la prueba dependiendo de la CoMParación, revisando las banderas de SREG
		; Las siguientes hacen pruebas con números con signo
		; Instrucción		Descripción						Banderas			Condicional
		; JE / JZ			Salta si son iguales			ZR					=
		; JNE / JNZ			Salta si no son iguales			ZR					!=
		; JG / JNLE			Salta si es mayor				OV, PL, ZR			>
		; JGE / JNL			Salta si es mayor o igual		OV, PL				>=
		; JL / JNGE			Salta si es menor				OV, PL				<
		; JLE / JNG			Salta si es menor o igual		OV, PL, ZR			<=

		; Las siguientes hacen pruebas con números sin signo
		; Instrucción		Descripción						Banderas			Condicional
		; JA / JNBE			Salta si está por encima		CY, ZR				>
		; JAE / JNB			Salta si está por encima/igual	CY					>=
		; JB/ JNAE			Salta si está por debajo		CY					<
		; JBE / JNA			Salta si está por debjo/igual	CY, ZR				<=

		; Revisan directamente el valor de las banderas de SREG
		; Instrucción		Descripción
		; JC			Salta si CY = 1
		; JNC			Salta si CY = 0
		; JO			Salta si OV = 1
		; JNO			Salta si OV = 0
		; JP / JPE		Salta si PE = 1	(Paridad par)
		; JNP / JPO		Salta si PE = 0 (Paridad impar)
		; JS			Salta si PL = 1
		; JNS			Salta si PL = 0

		mov ecx, [num1]				; Mover de la memoria num1 al registro ECX
		cmp ecx, [num2]				; Compara num2 con el registro ECX
		jg revisa_tercer			; Si ECX es más grande, salta a la etiqueta REVISA_TERCER
		mov ecx, [num2]				; En caso de que ECX sea menor o igual a num2 esta instrucción se ejecuta

		revisa_tercer:
			cmp ecx, [num3]			; Compara ECX con num3 de la memoria
			jg final				; En caso de que ECX sea mayor a num3 salta a final
			mov ecx, [num3]			; En caso de que ECX sea menor o igual a num3 esta instrucción se ejecuta

		final:
			mov eax, ecx			; Mueve el resultado a eax

	; Finalmente la instrucción CALL se utiliza para hacer una llamada a un procedimiento
	; Cuando se realiza, se guarda en la pila el valor de IP en caso de un salto corto (dentro del mismo segmento de código)
	; o de CS e IP en caso de un salto lejano (cuando se sale del segmento de código)
	mov ebx, 100
	call resta						; Llamar al procedimiento resta

	nop
	nop
	nop

resta:
	sub eax, ebx					; Hacer operaciones durante el procedimiento 
	ret								; se requiere de la instrucción RET para volver de un procedimiento

		push 0
		call ExitProcess@4
	end main						; END también es una directiva para terminar con el bloque generado por la etiqueta