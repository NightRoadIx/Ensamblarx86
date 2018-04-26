.586								; Procesador objetivo, usar instrucciones para máquinas de clase Pentium (x86 32 bits)
.model flat, stdcall				; Utilizar el modelo de memoria flat (plano), llamadas de convención stdcall, para usar win32
.stack 4096 						; Definir el stack (pila) de 4096 bytes (se reserva un espacio en memoria de ese tamaño)

extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data								; Crear un segmento de datos cercano, las variables locales se especifican después
	flotar	DD	3.75
	var1	DD	123.45				; Precisión sencilla
	var2	DQ	123.45				; Precisión doble

	a		DQ	4.56
	b		DQ	7.89
	ang		DQ	1.5
	d	DQ	1.0

.code								; Indica el comienzo del segmento de código
	main:							; Etiqueta main
		nop							; No Operation
		push 0

		lea esi, flotar				; Obtener la dirección donde se guardan los datos

		; La instrucciones de punto flotante
		; Los procesadores originales de la familia x86 tienen un coprocesador matemático que se encarga de realizar el manejo de las
		; operaciones de punto flotante (este es el FPU Floating Point Unit), los cuales son chips que se conocen como x87
		; En la actualidad este procesador se encuentra dentro del mismo CPU, aunque aún se le sigue conociendo como x87
		; por lo que a los registros asociados se les llama la "pila del x87" y a sus instrucciones la "lista de instrucciones x87"

		; La FPU tiene 8 registros ST0 a ST7, dispuestos en forma de pila (esto es, los datos ingresan a ST0 y se van "apilando" hasta llegar
		; a ST7 y se obtienen de la misma forma)
		; A pesar de que se puede manejar precisión sencilla (32 bits) y precisión doble (64 bits), los registros de esta pila, para evitar 
		; errores, son de 80 bits.

		; Además cuenta con los registros de propósito especial:
		; Registro de estado, el cual indica el estado actual de la FPU, las banderas son:
		;	Pin		Nombre			Características
		;	0		IE				Operación inválida
		;	1		DE				Operación no normalizada
		;	2		ZE				División entre 0
		;	3		OE				Desbordamiento hacia arriba
		;	4		UE				Desbordamiento hacia abajo
		;	5		PE				Precisión
		;	6		SF				Falla en la pila
		;	7		ES				Estado de los errores
		;	8		C0				
		;	9		C1				Código de condiciones
		;	10		C2
		;	11		TOP
		;	12		TOP				Apuntador de la pila
		;	13		TOP
		;	14		C3
		;	15		B				FPU ocupada
		;
		; Registro de control
		; Registro tag word (etiqueta de palabra)
		; Registro apuntador de última instrucción
		; Registro apuntador del último dato (operando)
		; Registro de opcode

		finit						; Iniciar la FPU revisando condiciones de error

		fld [var1]					; Cargar en la pila de la FPU el valor de los datos guardados en memoria en var1
		fld [var2]					; Cargar en la pila de la FPU el valor de los datos guardados en memoria en var2

		fsqrt						; Obtener la raíz cuadrada del dato en ST0 y almacenarlo ahí mismo

		; Otro ejemplo, la ley de cosenos:  d^2 = a^2 + b^2 - cos(ang)*2*a*b
		fld [a]						; Cargar en pila a
		fmul st(0), st(0)			; st0 = a^2

		fld [b]						; Cargar en pila b
		fmul st(0), st(0)			; st0 = b^2

		fadd st(1), st(0)			; st1 = a^2 + b^2

		fld [ang]
		fcos						; st0 = cos(ang)
		
		fmul [a]					; st0 = a * cos(ang)
		fmul [b]					; st0 = b * a * cos(ang)
		fadd st(0), st(0)			; st0 = b * a * cos(ang) + b * a * cos(ang) = 2 * b * a * cos(ang)

		fsubp st(1), st(0)			; st1 = st1 - st0 =  (a^2 + b^2) - (2 * b * a * cos(ang))
									; y hacer POP st0

		fsqrt						; Obtener la raíz cuadrada de st0 que será c

		fst [d]						; almacenar en memoria el valor del registro

		; Lista de instrucciones básicas del FPU
		; ARTIMÉTICAS
		; FADD			Suma de punto flotante
		; FUSB			Resta de punto flotante
		; FMUL			Multiplicación de punto flotante
		; FDIV			División de punto flotante
		; FRNDINT		Redondear a un entero
		; FABS			Valor absoluto
		; FCHS			Cambiar el signo
		; FSQRT			Raíz cuadrada
		; FSIN			Obtener el seno
		; FCOS			Obtener el coseno
		; FPTAN			Obtener la tangente (los ángulos deben de enviarse en radianes)

		; CONTROL
		; FFREE			Liberar el registro de punto flotante
		; FINIT			Iniciar la FPU después de revisar las condiciones de errores
		; FNINIT		Iniciar la FPU sin revisar las condiciones de errores
		; FNOP			FPU No Operation

		; TRANSFERENCIA DE DATOS
		; FLD			Cargar un valor de punto flotante (en registros de FPU)
		; FST			Almacenar (en memoria) un valor de punto flotante
		; FSTP			Almacenar (en memoria) un valor de punto flotante y hacerle POP de los registros ST
		; FLDPI			Cargar el valor de PI en los registros

		; * MOVIMIENTO CONDICIONADO
		; FCMOVB		Mover si es menor CF = 1
		; FCMOVNB		Mover si no es menor CF = 0
		; FCMOVE		Mover si es igual ZF = 1
		; FCMOVNE		Mover si no es igual ZF = 0
		; FCMOVBE		Mover si es menor o igual CF = 1 ó ZF = 1
		; FCMOVNBE		Mover si no es menor ni igual CF = 0 ó ZF = 0

		; COMPARACIÓN
		; FCOM			Comparar números de punto flotante

		; El código de comparación se guarda en los bits 

		; Para hacer saltos o ramificaciones, se debe movilizar el registro de estado de la FPU hacia los registros del x86
		; para ello se puede utilizar las instrucciones:
		; 1.- FSTSW AX para mover el registro de estado al registro AX
		; 2.- SAHF copia los 8 bits superiores del registro AX en el registro EFLAGS
		; 3.- O tambiénse puede con la instrucción TEST, comparar el contenido del registro AX con una constante y modificará
		; la bandera ZF de EFLAGS. Las constantes son las siguientes:
		; ST(0) > Operando fuente		Constante 4500H		Utilizar JZ
		; ST(0) < Operando fuente		Constante 0100H		Utilizar JNZ
		; ST(0) = Operando fuente		Constante 4000H		Utilizar JNZ

		; O con el nuevo mecanismo, puede utilizarse directamente la instrucción FCOMI, lo cual moverá de forma automática
		; los bits de comparación a EFLAGS
		fcomi st(0), st(1)

		push 0						; La siguiente función requiere de un 0
		call ExitProcess@4			; Llamada a la función de la API ( exit(0) )

	end main						; fin de esta sección de código y del programa
