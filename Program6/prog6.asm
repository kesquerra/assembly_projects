TITLE Sorting and Counting Random Integers	(prog5.asm)

; Author: Kyle Esquerra
; Last Modified: 05/18/2020
; OSU email address: esquerrk@oregonstate.edu
; Course number/section: C400_S2020
; Project Number: 5                Due Date: 05/24/2020
; Description:	Creates an array of random integers,
;	finds the median, the instances of each integer, 
;	and sorts the array from the instance counts.

INCLUDE Irvine32.inc

;constants

;macros
displayString MACRO	inputStr
	push	edx
	mov		edx, inputStr
	call	WriteString
	pop		edx
ENDM

getString MACRO	prompt, inputStr, size
	displayString	prompt
	push			ecx
	push			edx
	mov				edx, inputStr
	mov				ecx, size
	call			ReadString
	pop				edx
	pop				ecx
ENDM

.data
authName		BYTE	"Author: Kyle Esquerra",0
progTitle		BYTE	"Title: Designing Low-Level I/O Procedures",0
numPrompt		BYTE	"Please enter a signed number: ",0
stringInput		BYTE	12 DUP(?)
invalidStr		BYTE	"An invalid number was entered. Please try again.",0
isValid			DWORD	?
numInput		DWORD	?
intArray		DWORD	10 DUP(-1)
numLength		DWORD	0
numString		BYTE	12 DUP(?)



.code
; ------------------------------------------------------------------
main PROC
; 
; Description: Main procedure, calls all subprocedures
; Receives: N/A
; Returns: N/A
; Preconditions: N/A
; Registers changed: N/A
;
; ------------------------------------------------------------------
	;push	OFFSET invalidStr
	;push	(SIZEOF stringInput)-1
	;push	OFFSET stringInput
	;push	OFFSET numPrompt
	;push	OFFSET intArray
	;push	LENGTHOF intArray
	;call	fillArray

	push	OFFSET numString
	push	+312
	push	OFFSET numLength
	call	writeVal


	exit
main ENDP

; ------------------------------------------------------------------
readVal PROC
; 
; Description: Prompts user for input, reads input as string,
;	converts to integer value, stores value in eax
; Receives: invalidStr, size, stringInput, numPrompt
; Returns: integer value in EAX, valid boolean in EDX (1 is valid,
;	0 is invalid)
; Preconditions: parameters must exist
; Registers changed: EAX, EBX, ECX, EDX, ESI, EDI
;
; ------------------------------------------------------------------
	push		ebp
	mov			ebp, esp
	
	mov			edx, [ebp+8]			;set edx to	prompt for number
	mov			edi, 0					;set edi to zero
	mov			esi, [ebp+12]			;set esi to input string variable
	mov			ecx, [ebp+16]			;set ecx to size
	getString	edx, esi, ecx			;set inputStr to user input

	mov			ecx, eax				;set loop counter to size of string
	mov			edx, 1					;set edx to 1 for positive number multiplier
	push		edx						;save valid int
	cld

	loadInt:
		mov		ebx, 10					;set ebx to 10 for multiplier	
		mov		eax, edi				;set eax to previous number
		mul		ebx						;multiply eax by multiplier to get next digit
		mov		ebx, eax				;save number to ebx
		mov		eax, 0					;clear eax for lodsb
		lodsb							;get char from string in esi

		;validating block
		cmp		eax, 43					;char is '+'?
		je		skip					;skip calculations
		cmp		eax, 45					;char is '-'?
		je		negative				;skip calculations and go to negative label
		cmp		eax, 48					;char is '0'?
		jl		invalid					;if less than 0, char is invalid
		cmp		eax, 57					;char is '9'?
		jg		invalid					;if greater than 9, char is invalid

		mov		edi, ebx				;move number back into edi
		sub		eax, 48					;subtract by ascii value 48 to get integer
		add		edi, eax				;add current value to running total
		jmp		skip					;jump over negative label

		negative:
			pop		ebx					;get saved multiplier
			mov		ebx, -1				;set multiplier to -1
			push	ebx					;save multiplier

		skip:
			loop	loadInt				;loop through for all characters in string

		mov		edx, 1					;is valid
		jmp		fin						

	invalid:
		displayString	[ebp+20]		;write invalid message
		call			CrLf
		mov				edx, 0			;not valid
		jmp				fin
	fin:
		mov			eax, edi			;put final integer into eax
		pop			ebx					;get pos or neg multiplier
		cmp			ebx, -1				;is -1?
		je			negate				;negate eax
		jmp			pos					;skip negation
		negate:
			neg		eax					;negate eax
		pos:
			pop			ebp			
			ret			16
readVal ENDP

; ------------------------------------------------------------------
fillArray PROC
; 
; Description: fills parameter array with integers that user inputs
;	using readVal procedure
; Receives: invalidStr, size, stringInput, numPrompt, int* array, arraySize
; Returns: array will be filled with integers from user input
; Preconditions:  parameters must exist, readVal must be valid
; Registers changed: EAX, EBX, ECX, EDX, ESI, EDI
;
; ------------------------------------------------------------------
	push	ebp
	mov		ebp, esp	

	mov		esi, [ebp+12]			;set esi to array
	mov		ecx, [ebp+8]			;set loop counter to array size

	fillLoop:
		push	ecx					;save loop counter
		push	esi					;save array address
		retry:
		push	[ebp+28]			;push numPrompt
		push	[ebp+24]			;push stringInput
		push	[ebp+20]			;push size
		push	[ebp+16]			;push invalidStr
		call	readVal				;get value input from user
		
		cmp		edx, 0				;check if input is invalid
		je		retry				;restart loop without decrement on invalid
		pop		esi					;put back array address
		mov		[esi], eax			;set array to val from input
		add		esi, 4				;increment array
		pop		ecx					;put back loop counter
		loop	fillLoop

	pop ebp
	ret 24

fillArray ENDP

; ------------------------------------------------------------------
getLength PROC
; 
; Description:
; Receives: int num, int numLength
; Returns: 
; Preconditions: 
; Registers changed: 
;
; ------------------------------------------------------------------
	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]
	mov		eax, [ebp+12]
	push	eax

	countLoop:
		pop		eax
		mov		ebx, 10
		cdq
		idiv	ebx
		push	eax
		cmp		eax, 0
		je		complete
			mov		ecx, 2
			jmp		cont
		complete:
			mov		ecx, 1
		cont:
			mov		eax, [esi]
			add		eax, 1
			mov		[esi], eax
		loop	countLoop

	pop		eax
	mov		eax, [esi]

	pop		ebp
	ret		8

getLength ENDP

; ------------------------------------------------------------------
writeVal PROC
; 
; Description: gets integer, converts to string and outputs string
; Receives: string numString, int numInput, int numLength
; Returns: 
; Preconditions: 
; Registers changed: 
;
; ------------------------------------------------------------------

	push	ebp
	mov		ebp, esp


	mov		edi, [ebp+16]
	mov		eax, [ebp+12]			;set eax to number
	push	eax
	push	[ebp+8]
	call	getLength
	mov		esi, [ebp+8]
	mov		eax, [ebp+12]

	push	eax
	mov		ecx, [esi]		
	test	eax, eax
	jns		positive

	negative:
		mov		eax, 45
		stosb
		pop		eax
		neg		eax
		push	eax
		jmp		startNum

	positive:
		mov		eax, 43
		stosb
		
	startNum:
		add		edi, [esi]
		dec		edi

	stringLoop:
		pop		eax
		mov		ebx, 10
		cdq
		idiv	ebx
		push	eax
		add		edx, 48
		mov		eax, edx
		std
		stosb
		loop	stringLoop

	pop	eax
		

	displayString	[ebp+16]

	pop		ebp
	ret		12


writeVal ENDP


	
END main