TITLE Composite Numbers	(prog4.asm)

; Author: Kyle Esquerra
; Last Modified: 05/08/2020
; OSU email address: esquerrk@oregonstate.edu
; Course number/section: C400_S2020
; Project Number: 4                Due Date: 05/10/2020
; Description: Program takes a user number within 1 and 400
;	and prints that many composite numbers to screen

INCLUDE Irvine32.inc

;constants
UPPER_BOUND = 400
LOWER_BOUND = 1

.data
authName		BYTE	"Author: Kyle Esquerra",0
progTitle		BYTE	"Title: Composite Numbers",0
ec1				BYTE	"**Check against prime divisors saved from those that failed composite test",0
ec2				BYTE	"**Align the output columns",0
instrMsg		BYTE	"Enter the number of composite numbers to display [",0
ellipses		BYTE	"...",0
endBracket		BYTE	"]: ",0
invalidMsg		BYTE	"Number is not in range. Try again.",0
farewellMsg		BYTE	"Results certified by Kyle Esquerra. Goodbye.",0
userNum			DWORD	?
compCount		DWORD	0
compNum			DWORD	4
divisors		DWORD	2, 3, ?, ?, ?, ?, ?, ?, ?, ?
divCount		DWORD   2
compBool		WORD	0
compDivCount	DWORD	?
numCount		DWORD	0

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

	call	displayIntro
	call	getUserData
	call	showComposites
	call	farewell
	exit
	
main ENDP

; ------------------------------------------------------------------
displayIntro PROC
; 
; Description: Displays information for program, including author, 
;	program title, and extra credit messages
; Receives: N/A
; Returns: N/A
; Preconditions:  N/A
; Registers changed: N/A
;
; ------------------------------------------------------------------
	pushad
	;author name
	mov		edx, OFFSET authName
	call	WriteString
	call	CrLf

	;program title
	mov		edx, OFFSET progTitle
	call	WriteString
	call	CrLf

	;extra credit messages
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf

	;return
	popad
	ret
displayIntro ENDP

; ------------------------------------------------------------------
getUserData PROC
; 
; Description: Displays instructions for number entry, then gets an
;	integer from the user to store in userNum
; Receives: integer between LOWER_BOUND and UPPER_BOUND
; Returns: userNum
; Preconditions: validate subprocedure must exist
; Registers changed: N/A
;
; ------------------------------------------------------------------
	pushad
	;display instructions
	numberInstr:
	mov		edx, OFFSET instrMsg
	call	WriteString
	mov		eax, LOWER_BOUND
	call	WriteDec
	mov		edx, OFFSET ellipses
	call	WriteString
	mov		eax, UPPER_BOUND
	call	WriteDec
	mov		edx, OFFSET endBracket
	call	WriteString

	;get number from user
	call	ReadInt
	mov		userNum, eax
	call	validate
	
	;data is valid, end procedure
	popad
	ret

getUserData ENDP

; ------------------------------------------------------------------
validate PROC
; 
; Description: validates integer is between LOWER_BOUND and UPPER_BOUND
; Receives: EAX
; Returns: N/A
; Preconditions: must have integer in EAX, getUserData must exist
; Registers changed: N/A
;
; ------------------------------------------------------------------
	;if user number is lower than lower bound
	cmp		eax, LOWER_BOUND
	jl		invalid

	;if user number is higher than upper bound
	cmp		eax, UPPER_BOUND
	jg		invalid
	jmp		valid

	;invalid number, restart start of top level procedure
	invalid:
		mov		edx, OFFSET invalidMsg
		call	WriteString
		call	CrLf
		call	getUserData

	;valid number, end procedure
	valid:
		ret
		
validate	ENDP

; ------------------------------------------------------------------
isComposite PROC
; 
; Description: checks if number in compNum is a composite number
; Receives: compNum
; Returns: compBool, 1 for true, 0 for false
; Preconditions: compNum must have an unsigned integer
; Registers changed: N/A
;
; ------------------------------------------------------------------
	;save registers
	pushad

	;set current loop counter
	mov		eax, divCount
	mov		compDivCount, eax

	;reset ebx
	mov		ebx, 0

	;put prime array onto stack
	mov		esi, OFFSET divisors

	divisor:
		;set up registers
		mov		eax, compNum
		mov		edx, 0

		;check if current number is in our prime array
		mov		ebx, [esi]
		cmp		ebx, compNum
		je		compRet

		;divide current number by our prime array
		cdq
		div		ebx

		;if no remainder, it is composite, jump to composite
		cmp		edx, 0
		jz		compTrue

		;increment stack address for next prime number
		add		esi, 4

		;decrement counter for number of primes in our array
		dec		compDivCount

		;no more primes, current number is prime, jump to prime
		cmp		compDivCount, 0
		je		compFalse

		;restart loop to check against next prime
		jmp		divisor

	compTrue:									;is composite
		;set boolean flag
		mov		compBool, 1
		
		;increment counter for composites
		inc		compCount
		jmp		compRet

	compFalse:									;is prime
		;set boolean flag
		mov		compBool, 0

		;only hold 10 prime numbers
		cmp		divCount, 10
		je		compRet

		;increment address for divisor array, store current prime number
		mov		eax, divCount
		mov		ecx, 4
		mul		ecx
		mov		ebx, compNum
		mov		[divisors + eax], ebx
		inc		divCount

	compRet:
		;return registers
		popad
		ret

isComposite ENDP

; ------------------------------------------------------------------
showComposites PROC
; 
; Description: Prints out the first Nth composite numbers, N = userNum
; Receives: userNum
; Returns: N/A
; Preconditions: must have a number in userNum, isComposite must exist
; Registers changed: N/A
;
; ------------------------------------------------------------------
	;save registers
	pushad

	;set loop counter
	mov ecx, userNum

	;loop to find next composite number
	compLoop:
		;reset boolean value
		mov		compBool, 0

		;check if current number is composite
		mov		eax, compNum
		call	isComposite

		;move to next number
		inc		compNum

		;if number is prime, restart loop without decrementing ecx
		cmp		compBool, 0
		je		compLoop

	;print composite number
	call	WriteDec

	;print tab
	mov		al, 9
	call	WriteChar

	;increment number of composites on line
	inc		numCount

	;if 10 numbers on line, go to newLine
	cmp		numCount, 10
	jz		newLine

	;not 10, continue
	jmp		endLoop

	newLine:
		;reset counter, write new line
		mov		numCount, 0
		call	CrLf

	endLoop:
		;restart loop, decrement ecx
		loop	compLoop

	call	CrLf
	;return registers
	popad
	ret


showComposites ENDP

; ------------------------------------------------------------------
farewell PROC
; 
; Description: prints farewell message to screen
; Receives: N/A
; Returns: N/A
; Preconditions: N/A
; Registers changed: N/A
;
; ------------------------------------------------------------------
	pushad

	;print farewell message
	mov		edx, OFFSET farewellMsg
	call	WriteString
	call	CrLf

	;return
	popad
	ret


farewell ENDP

END main

