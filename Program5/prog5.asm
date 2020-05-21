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
LO = 10
HI = 29
ARRAYSIZE = 200

.data
authName		BYTE	"Author: Kyle Esquerra",0
progTitle		BYTE	"Title: Sorting and Counting Random Integers",0
ec				BYTE	"**EC: Derive counts before sorting array",0
unsortedTitle	BYTE	"Unsorted Random Numbers:",0
sortedTitle		BYTE	"Sorted Random Numbers:",0
medianTitle		BYTE	"List Median: ",0
countTitle		BYTE	"Amount of instances of each number in range:",0
array			DWORD	ARRAYSIZE DUP(?)
countArray		DWORD	HI-LO+1	DUP(0)


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
	call	Randomize

	;push parameters and display introduction
	push	OFFSET authName
	push	OFFSET progTitle
	push	OFFSET ec
	call	displayIntro

	;push parameters and fill array with random values
	push	OFFSET array
	push	ARRAYSIZE
	push	LO
	push	HI
	call	fillArray
	
	;push parameters and print unsorted array
	push	OFFSET array
	push	ARRAYSIZE
	push	OFFSET unsortedTitle
	call	displayList

	;push parameters and get counts of instances of numbers in array
	push	OFFSET countArray
	push	OFFSET array
	push	ARRAYSIZE
	push	LO
	call	countList

	;push parameters and print instance count array
	push	OFFSET countArray
	push	HI-LO+1
	push	OFFSET countTitle
	call	displayList

	;push parameters and sort array by counted array
	push	OFFSET countArray
	push	OFFSET array
	push	HI-LO+1
	push	LO
	call	sortList

	;push parameters and print sorted array
	push	OFFSET array
	push	ARRAYSIZE
	push	OFFSET sortedTitle
	call	displayList

	;push parameters and print median of sorted array
	push	OFFSET array
	push	ARRAYSIZE
	push	OFFSET medianTitle
	call	medianList
	

	exit
main ENDP

; ------------------------------------------------------------------
displayIntro PROC
; 
; Description: Displays information for program, including author, 
;	program title, and extra credit messages
; Receives: string authName, string progTitle, string ec
; Returns: N/A
; Preconditions:  N/A
; Registers changed: EDX
;
; ------------------------------------------------------------------
	push	ebp
	mov		ebp, esp

	;write author name
	mov		edx, [ebp+16]
	call	WriteString
	call	CrLf

	;write program title
	mov		edx, [ebp+12]
	call	WriteString
	call	CrLf

	;write extra credit message
	mov		edx, [ebp+8]
	call	WriteString
	call	CrLf
	call	CrLf

	pop		ebp
	ret		12	

displayIntro ENDP

; ------------------------------------------------------------------
fillArray PROC
; 
; Description: fills parameter array with random integers in range
;	from LO to HI
; Receives: int* array, ARRAYSIZE, LO, HI
; Returns: int* array with values from range (LO-HIGH)
; Preconditions:  N/A
; Registers changed: EAX, EBX, ECX, ESI
;
; ------------------------------------------------------------------
	push	ebp
	mov		ebp, esp	

	mov		ebx, [ebp+8]						;set ebx to HI
	sub		ebx, [ebp+12]						;subtract LO from HI
	add		ebx, 1								;add 1 to HI-LO
	mov		ecx, [ebp+16]						;set loop counter to ARRAYSIZE
	mov		esi, [ebp+20]						;set esi to array

	fillLoop:
		mov		eax, ebx						;set eax to range (HI-LO+1)
		call	RandomRange						;set eax to random number in range
		add		eax, [ebp+12]					;add LO to random number
		mov		[esi], eax						;set array to random number
		add		esi, 4							;increment array OFFSET
		loop	fillLoop						;loop for entire array

	pop ebp
	ret 16

fillArray ENDP

; ------------------------------------------------------------------
displayList PROC
; 
; Description: Displays array values in terminal
; Receives: int* array, int ARRAYSIZE, string arrayTitle
; Returns: N/A
; Preconditions:  Must pass it an array, size of array, and title
; Registers changed: EAX, EBX, ECX, ESI
;
; ------------------------------------------------------------------
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+8]
	call	WriteString
	call	CrLf
	mov		ecx, [ebp+12]
	mov		esi, [ebp+16]
	mov		ebx, 0
	
	displayLoop:
		;get number from array
		mov		eax, [esi]
		call	WriteDec
		add		esi, 4						;increment array OFFSET

		cmp		ebx, 19						;is 20th number?		
		je		newLine						;write new line if 20th
		inc		ebx							;increment number count

		;print 2 spaces
		mov		al, 32
		call	WriteChar
		mov		al, 32
		call	WriteChar

		jmp		loopInstr					;skip new line

		newLine:
			mov		ebx, 0					;reset counter
			call	CrLf

		loopInstr:
			loop	displayLoop				;loop through entire array
		
		cmp		ebx, 0						;check if 20th number
		je		endFunction					;if 20th, skip newLine
		call	CrLf						;if ends on non-20th number, write newLine


	endFunction:
		call	CrLf
		pop		ebp
		ret		12


displayList ENDP

; ------------------------------------------------------------------
countList PROC
; 
; Description: gets the count of instances of each integer in array
;	and stores them in countArray
; Receives: int* countArray, int* array, int ARRAYSIZE, int LO
; Returns: N/A
; Preconditions:  Must pass it an array, size of array, and title
; Registers changed: EAX, EBX, ECX, ESI, EDI
;
; ------------------------------------------------------------------

	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+12]					;loop counter to ARRAYSIZE
	mov		esi, [ebp+16]					;set esi to array
	mov		edi, [ebp+20]					;set edi to countArray
	
	countLoop:
		mov		eax, [esi]					;get number from array
		sub		eax, [ebp+8]				;set index to increment
		mov		ebx, 4						;set DWORD multiplier
		mul		ebx							;set offset for DWORD
		mov		ebx, [edi+eax]				;get count from countArray
		add		ebx, 1						;increment count
		mov		[edi+eax], ebx				;increment count at index offset
		add		esi, 4						;increment array index offset
		loop	countLoop					;loop through entire array

	pop		ebp
	ret		20

countList ENDP

; ------------------------------------------------------------------
sortList PROC
; 
; Description: sorts array list from the instances in count array
; Receives: int* countArray, int* array, int ARRAYSIZE, int LO
; Returns: N/A
; Preconditions:  Must pass it an array, size of array, and title
; Registers changed: EAX, EBX, ECX, EDI, ESI
;
; ------------------------------------------------------------------

	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+12]				;loop counter to range count
	mov		edi, [ebp+16]				;set edi to array
	mov		esi, [ebp+20]				;set esi to countArray
	mov		ebx, 0

	indexLoop:
		mov		eax, [ebp+8]			;set LO as base for number
		add		eax, ebx				;add index to LO
		push	ecx						;save indexLoop counter on stack		
		mov		ecx, [esi+ebx*4]		;set amountLoop counter as instances of number
		add		ebx, 1					;increment index of countArray
		cmp		ecx, 0
		je		indexLoopInstr
		amountLoop:
			mov		[edi], eax			;set array index to LO + index
			add		edi, 4				;increment OFFSET to array
			loop	amountLoop			;loop for number of instances, inner loop
		indexLoopInstr:
			pop		ecx						;get indexLoop counter off stack into ecx
			loop	indexLoop				;loop outer loop


	pop		ebp
	ret		20

sortList ENDP

; ------------------------------------------------------------------
medianList PROC
; 
; Description: finds median of array and prints to screen
; Receives: int* array, int ARRAYSIZE, medianTitle
; Returns: N/A
; Preconditions:  Must pass it an array, size of array, and title
; Registers changed: EAX, EBX, ECX, ESI
;
; ------------------------------------------------------------------

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+16]				;set esi to array
	mov		eax, [ebp+12]				;set eax to ARRAYSIZE

	;divide array size by 2
	cdq
	mov		ebx, 2
	div		ebx

	;if divisible by 2, go to evenArray, otherwise oddArray
	cmp		edx, 0
	je		evenArray

	oddArray:
		mov		ebx, eax				;set ebx to ARRAYSIZE / 2
		mov		eax, [esi+ebx*4]		;set eax to (ARRAYSIZE / 2)'th offset of array
		jmp printMedian

	evenArray:
		mov		ebx, eax				;set ebx to ARRAYSIZE / 2
		sub		ebx, 1					;set ebx to (ARRAYSIZE / 2) - 1
		mov		ecx, [esi+eax*4]		;set ecx to number in (ARRAYSIZE / 2)th array index
		add		ecx, [esi+ebx*4]		;add number in ((ARRAYSIZE / 2) - 1)th index to ecx to get sum of two numbers
		mov		eax, ecx				;mov ecx to eax for operations
		mov		ecx, 100				;set ecx to 100
		mul		ecx						;multiply sum by 100 for float math
		mov		ebx, 2					;set ebx to 2
		cdq
		div		ebx						;divide (sum*100) by 2
		add		eax, 50					;round up
		mov		ebx, 100				;set ebx to 100
		cdq
		div		ebx						;divide average of two numbers by 100 for rounded integer

	printMedian:
		;print median title
		mov		edx, [ebp+8]		
		call	WriteString
		call	WriteDec				;print eax



	pop		ebp
	ret		12

medianList ENDP

END main

