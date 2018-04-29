.mmx					; Modo MMX
.model flat				; Modelo plano

.data
	var		DQ	0AA421600BFEBFBFFh
	var1	DD	06855FDEFh
	var2	DQ  0E1000000A7h
	var2a	DQ	04500000063h
	var3	DQ	0810088000900900h
	var3a	DQ	0100000001h
	var4	DQ	06011081000980926h
	var5	DQ	0C000h
	var5a	DQ	6
	var6	DQ	0300C00h

.code					; Código

main:	
	mov eax, 1			; Mover al registro EAX un valor de 1 para conocer información de la CPU
	cpuid				; CPUID regresa modelo, familia, información paso a paso de la CPU en registro EAX
						; Información adicional en el registro EBX
						; Información de funciones adicionales en los registros ECX y EDX
						; el bit 23 del registro EDX indica si la tecnología MMX de Intel es soportada por el procesador
	nop
	nop

	emms				; Un reinicio requerido de la FPU antes de cualquier instrucción MMX o inverso hacia instrucciones del FPU
						; Todas las instrucciones MMX requieren de 2 operandos excepto EMMS, donde el destino siempre será un registro MMX
						; y la fuente puede ser memoria, registro u otro registro MMX (excepto las operaciones de movimiento)
						; EEMS restaura el estado de los registros para que puedan ser usados por la FPU, pues cada vez que se ejecuta una 
						; instrucción MMX se marcan todos los registros como con un resultado numérico válido, cuando para su uso por la FPU 
						; han de ser marcados como vacíos (que es exactamente lo que hace FFREE)

	mov eax, 0ffffh		; Mover un valor al registro EAX de 64 bits
	movq mm0, var		; Copiar una palabra cuádruple (64 bits) almacenada en memoria al registro MM0
	movd mm1, var1		; Copiar una palabra doble (32 bits) almancenada en memoria al registro MM1


	movq mm2, var2		; Mover una palabra al sregistro
	packuswb mm2, var2a	; Empaquetar sin saturación de signo, empaqueta y satura 4 palabras consigno del operando fuente y 4 palabras del operador
						; destino en 8 bytes sin signo almacenados en el registro destino
	movq mm3, var3
	packsswb mm3, var3a	; Empaquetar con saturación valores con signo
						; Para empaquetar con saturación, valores sin signo

	paddb mm3, mm2		; Sumar los paquetes con signo (en este caso paquetes de bytes). Si el resultado queda fuera de
						; rango se trunca a la parte baja (ignorando los bits de acarreo)
						; las instrucciones de suma pueden ser:
						; PADDB, PADDW, PADDD, para bytes, words y doble word con signo empaquetadas y truncando el resultado
						; PADDSB, PADDSW, para bytes y words empaquetadas con signo y saturando el resultado
						; PADDUSB, PADDUSW, para bytes y words empaquetadas sin signo y saturando el resultado

						; Para la resta se tiene
						; PSUBB, PSUBBW, PSUBD, con signo, truncando el resultado
						; PSUBSB, PSUBSW, con signo, saturando el resultado
						; PSUBUSB, PSUBUSW, sin signo, saturando el resultado

						; Para la multiplicación
						; PMULHW, PMULLW, Multiplica las cuatro palabras del operando origen con las cuatro del operando destino, 
						; resultando en cuatro dwords. La parte alta o baja respectivamente de cada dword es almacenada en los paquetes 
						; correspondientes del destino. Son operaciones con signo


	; Operaciones lógicas
	movq mm4, var4
	pand mm4, mm2		; Hacer AND empaquetado entre ambos registros
						; PANDN, aplica una operación AND y NOT
						; POR, aplica la operación OR
						; PXOR, aplica la operación XOR

	; Operaciones de desplazamiento
	; PSLL, desplazamiento a la izquierda, ya sea para words, dwords o qwords, del número de veces que indique el operando fuente
	; Si el valor especificado es mayor de 15 (words), 31 (dwords) o 63 (qwords), entonces el destino se pone todo a cero
	; PSLLW, PSLLD, PSLLQ
	movq mm5, var5
	pslld mm5, var5a
	; El desplazamiento a la derecha se hace con PSRLW, PSRLD, PSRLQ

	; Operaciones de comparación
	; Comparación para igual, se realiza con la instrucción PCMPEQ, y funciona para datos empaquetados en bytes, words y dwords
	; PCMPEQB, PCMPEQW, PCMPEQD
	; Dejando en el operador de destino, 1 para cuando se cumpla la condición y 0 cuando no se cumpla
	movq mm6, var6
	pcmpeqw mm6, mm5
	; La otra instrucción de comparación es PCMPGT, revisar si es mayor que, y funciona de la misma forma que PCMPEQ

	emms				; Fin del uso de las instrucciones MMX

	end main