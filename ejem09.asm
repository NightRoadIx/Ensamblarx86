.586								; Procesador objetivo, usar instrucciones para máquinas de clase Pentium (x86 32 bits)
.model flat, stdcall				; Utilizar el modelo de memoria flat (plano), llamadas de convención stdcall, para usar win32
.stack 4096 						; Definir el stack (pila) de 4096 bytes (se reserva un espacio en memoria de ese tamaño)

extrn ExitProcess@4:proc			; Funciones de la API Win32 (@bytes que toman sus parámetros)

.data								; Crear un segmento de datos cercano, las variables locales se especifican después
	cad1	DB	"Cadena No. 01"
	cad1a	DW	"Ca", "de", "na"
	cad1b	DD	"Cade", "na01"
	cad2	DB	?
	cad3	DW	?
	cad4	DD	?

.code								; Indica el comienzo del segmento de código
	main:							; Etiqueta main
		nop							; No Operation
		push 0

									; La instrucción MOVS ayuda para transferir cadenas 
		mov esi, offset cad1		; Para ello se utiliza ESI con la dirección de la cadena origen
		mov edi, offset cad2		; y EDI para la dirección de la cadena destino
		mov ecx, 6					; ECX funcionará como contandor para la transferencia de cadenas
		rep movs cad2, cad1			; MOVS entonces moverá bytes de información de una cadena a otra, usando REP como si fuera LOOP

		mov esi, offset cad1a
		mov edi, offset cad3
		mov ecx, 3
		rep movsw cad3, cad1a		; MOVWS mueve cadenas de tamaño palabra (2 bytes)

		mov esi, offset cad1b
		mov edi, offset cad4
		mov ecx, 2
		rep movsd cad4, cad1b		; MOVSD mueve cadenas de tamaño doble-palabra (4 bytes)


		lea edi, cad1				; Cargar en EDI la dirección de la cadena
		mov al, " "					; Mover al registro AL el caracter a buscar
		mov ecx, 12					; Mover en ECX el número de datos a recorrer
		repne scas cad1				; REPNE repetir hasta que no sea igual la búsqueda del caracter en AL en cad1
									; REPNE / REPNZ repite mientras no sea igual o que el registro ZR no este activo
									; REPE / REPZ repite mientras sea igual o que el registro ZR este activo


		lea edi, cad1				; Cargar la dirección de cad1
		mov ax, "0"					; Cargar un "0" (cadena) en el registro AX
		mov ecx, 20					; Mover un 20 a ECX
		repne scas cad1				; Buscar en cad1 lo que se cargó en AX y repetir hasta encontrar
		jcxz no_encon				; Salta si el registro ECX llegó a 0 (no se encontró el caracter)
		sub edi, 1					; Restar un 2 al registro EDI
		mov ecx, 6					; Mover un 6 a ECX
		rep stos cad1				; Almacenar o transferir el contenido de AL o AX a la cadena
		no_encon:
			nop
									; Puede utilizarse la instrucción LODS para transferir a lo que se está apuntando en la cadena
									; al registro AL o AX

		push 0						; La siguiente función requiere de un 0
		call ExitProcess@4			; Llamada a la función de la API ( exit(0) )
	end main						; fin de esta sección de código y del programa