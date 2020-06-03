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

;macros
; ------------------------------------------------------------------
displayString MACRO	inputStr
; 
; Description: displays string to console
; Receives: inputStr
; Returns: writes inputStr to console
; Preconditions: inputStr must exist
; Registers changed: N/A
;
; ------------------------------------------------------------------

	push	edx
	mov		edx, inputStr
	call	WriteString
	pop		edx

ENDM

; ------------------------------------------------------------------
getString MACRO	prompt, inputStr, size
; 
; Description: gets string input from user
; Receives: prompt, inputStr, size
; Returns: integer as string into inputStr
; Preconditions: displayString, inputStr, size, prompt must exist
; Registers changed: N/A
;
; ------------------------------------------------------------------

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
progInstr1		BYTE	"Please provide 10 signed decimal integers.",0
progInstr2		BYTE	"After you have finished inputting the numbers, ",0
progInstr3		BYTE	"I will display the list of integers, their sum and their average value.",0
numPrompt		BYTE	"Please enter a signed number: ",0
stringInput		BYTE	12 DUP(?)
invalidStr		BYTE	"An invalid number was entered. Please try again.",0
isValid			DWORD	?
numInput		DWORD	?
intArray		DWORD	10 DUP(?)
numLength		DWORD	0
numString		BYTE	12 DUP(?)
arrayTitle		BYTE	"You entered the following numbers:",0
sumTitle		BYTE	"The sum of these numbers is: ",0
avgTitle		BYTE	"The rounded average is: ",0
farewell		BYTE	"Thanks for playing!",0




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
	
	push	OFFSET progInstr3
	push	OFFSET progInstr2
	push	OFFSET progInstr1
	push	OFFSET progTitle
	push	OFFSET authName
	call	intro

	push	OFFSET invalidStr
	push	(SIZEOF stringInput)-1
	push	OFFSET stringInput
	push	OFFSET numPrompt
	push	OFFSET intArray
	push	LENGTHOF intArray
	call	fillArray

	push	OFFSET farewell
	push	OFFSET arrayTitle
	push	OFFSET sumTitle
	push	OFFSET avgTitle
	push	OFFSET intArray
	push	OFFSET numString
	push	OFFSET numLength
	call	displayArray


	exit
main ENDP

; ------------------------------------------------------------------
intro PROC
; 
; Description: calls all introductory lines
; Receives: authName, progTitle, progInstr1, progInstr2, progInstr3
; Returns: prints all strings to console
; Preconditions: displayString must exist
; Registers changed: N/A
;
; ------------------------------------------------------------------
	
	push	ebp
	mov		ebp, esp

	displayString	[ebp+8]			;display authName
	call			CrLf
	displayString	[ebp+12]		;display progTitle
	call			CrLf
	call			CrLf
	displayString	[ebp+16]		;display progInstr1
	call			CrLf
	displayString	[ebp+20]		;display progInstr2
	displayString	[ebp+24]		;display progInstr3
	call			CrLf
	call			CrLf

	pop		ebp
	ret		20


intro ENDP

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
; Description: gets the amount of digits in an integer
; Receives: int num, int numLength
; Returns: saves amount of digits in numLength
; Preconditions: N/A
; Registers changed: EAX, EBX, ESI
;
; ------------------------------------------------------------------
	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]			;set esi to numLength
	mov		eax, 0					;clear eax
	mov		[esi], eax				;set numLength to zero
	mov		eax, [ebp+12]			;set eax to number
	push	eax						;save eax

	countLoop:
		pop		eax					;put value back into eax
		mov		ebx, 10				;put 10 into ebx
		cdq		
		idiv	ebx					;divide eax by 10
		push	eax					;save new eax
		cmp		eax, 0				;is last digit?
		je		complete			;finish loop
			mov		ecx, 2			;increase loop counter
			jmp		cont			;skip end loop
		complete:
			mov		ecx, 1			;set loop counter to end
		cont:
			mov		eax, [esi]		;set eax to numLength
			add		eax, 1			;increment eax
			mov		[esi], eax		;put new eax back into numLength
		loop	countLoop

	pop		eax						;clear stack
	mov		eax, [esi]				;put numLength into eax

	pop		ebp
	ret		8

getLength ENDP

; ------------------------------------------------------------------
writeVal PROC
; 
; Description: gets integer, converts to string and outputs string
; Receives: string numString, int numInput, int numLength
; Returns: writes string value of number to console
; Preconditions: displayString MACRO must exist
; Registers changed: EAX, EBX, ECX, EDX, EDI, ESI
;
; ------------------------------------------------------------------

	push	ebp
	mov		ebp, esp

	;clean string
	mov		edi, [ebp+16]			;set edi to numString
	mov		ecx, 12					;set loop counter to length of numString
	mov		eax, 0					;set eax to clear value
	cld								;flag set to forward
	rep		stosb					;repeat store string ecx times

	mov		edi, [ebp+16]			;set edi back to beginning of numString
	mov		eax, [ebp+12]			;set eax to number

	push	eax						;num for getLength
	push	[ebp+8]					;numLength for getLength
	call	getLength

	mov		esi, [ebp+8]			;set esi to numLength
	mov		eax, [ebp+12]			;set eax to number

	push	eax						;save eax
	mov		ecx, [esi]				;set loop counter to numLength value
	test	eax, eax				;test for sign value
	jns		positive				;has no sign?

	negative:
		mov		eax, 45				;set eax to '-'
		stosb						;store string
		pop		eax					;put num back in eax
		neg		eax					;negate eax to get positive value
		push	eax					;save num
		jmp		startNum			;skip positive block

	positive:
		mov		eax, 43				;set eax to '+'
		stosb						;store string
		
	startNum:
		add		edi, [esi]			;move forward string values by number of digits in integer
		dec		edi					;decrement 1 to get to last value

	stringLoop:
		pop		eax					;put num back in eax
		mov		ebx, 10				;set ebx to 10
		cdq
		idiv	ebx					;divide eax by 10
		push	eax					;save new eax
		add		edx, 48				;change to ascii value
		mov		eax, edx			;move ascii value to eax
		std							;set flag to backwards
		stosb						;store string
		loop	stringLoop			

	pop	eax
		

	displayString	[ebp+16]		;write string to console

	pop		ebp
	ret		12


writeVal ENDP

; ------------------------------------------------------------------
displayArray PROC
; 
; Description: displays contents of array, sum total of array values, 
;	average of array values, and farewell message
; Receives: string farewell, string arrayTitle, string sumTitle, 
;	string avgTitle, int* array, string numString, int numLength
; Returns: prints to console
; Preconditions: writeVal must exist, displayString MACRO must exist
; Registers changed: EAX, EBX, ECX, EDX, EDI, ESI
;
; ------------------------------------------------------------------

	push	ebp
	mov		ebp, esp

	call			CrLf					
	displayString	[ebp+28]				;write arrayTitle to console
	call			CrLf					
	mov				esi, [ebp+16]			;set esi to array
	mov				ecx, 10					;set loop counter to amount of items in array
	mov				ebx, 0					;clear ebx

	writeLoop:
		push	esi							;save esi
		push	ecx							;save eax

		add		ebx, [esi]					;add value of array to ebx for sum
		push	ebx							;save ebx

		push	[ebp+12]					;numString for writeVal
		push	[esi]						;numInput for writeVal
		push	[ebp+8]						;numLength for writeVal
		call	WriteVal					;write number value to console

		pop		ebx							;put ebx back
		pop		ecx							;put loop counter back
		cmp		ecx, 1						;is last loop?
		je		endList						;skip ', '
		mov		al, 44					
		call	WriteChar					;write ','
		mov		al, 32
		call	WriteChar					;write ' '

		endList:
			pop		esi						;put esi back
			add		esi, 4					;go to next index in array
			loop	writeLoop

	sum:
		call			CrLf		
		displayString	[ebp+24]			;write sumTitle to console
		push			ebx					;save ebx

		push			[ebp+12]			;numString for writeVal
		push			ebx					;numInput for writeVal
		push			[ebp+8]				;numLength for writeVal
		call			WriteVal			;write number value to console
		pop				ebx					;put ebx back

	avg:
		call			CrLF				
		displayString	[ebp+20]			;write avgTitle to console
		mov				eax, ebx			;put sum total into eax
		mov				ebx, 10				;set ebx to number of items in array
		cdq
		idiv			ebx					;divide sum total / items

		push			[ebp+12]			;numString for writeVal
		push			eax					;numInput for writeVal
		push			[ebp+8]				;numLength for writeVal
		call			WriteVal			;write number value to console

	fare:
		call			CrLf
		call			CrLf
		displayString	[ebp+32]			;write farewell to console

	pop		ebp
	ret		28

displayArray ENDP

END main