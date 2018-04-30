// EnsambladorconC.cpp: define el punto de entrada de la aplicación de consola.
//

#include "stdafx.h"
#include "stdio.h"
#include "conio.h"

int _tmain(int argc, _TCHAR* argv[])
{

	// Variables locales que se almacenan en memoria
	int valor = 200;	// Se inicia a un valor
	int resultado;		// Aquí se guardará el resultado
	int resultadoC;

	/*
		Inclusión de una rutina en código ensamblador en
		el programa en C
		Esto agiliza a ejecución del programa, reduciendo además,
		la cantidad de opcodes que se almacenarán en memoria
	*/
	_asm	// La directiva _asm permite inclur código en ensamblador
	{
		nop						; Los comentarios en ensamblador aún pueden hacerse con ;
		nop
		nop
		nop
		mov eax, 0xffffffff
		mov al, 2
		mov ah, 2
		mov ax, 2
		mov eax, 2

		mov ebx, [valor]		; valor está almacenado en memoria, por lo que se puede pasar el valor al registro EBX
		lea esi, valor			; Se puede hallar su posición en memoria
		lea edi, resultado		; Y la del resultado

		add eax, ebx			; Hacer una suma
		mov [resultado], eax	; y mover el resultado a memoria

	}

	resultadoC = valor + 2;		// Para comparar como se efectua una suma

	printf("Resultado: %d", resultado);
	_getch();

	return 0;
}

