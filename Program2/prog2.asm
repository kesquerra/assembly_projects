TITLE Sum and Differences of 3 Numbers		(prog2.asm)

; Author: Kyle Esquerra
; Last Modified: 04/18/2020
; OSU email address: esquerrk@oregonstate.edu
; Course number/section: C400_S2020
; Project Number: 2                Due Date: 04/19/2020
; Description: Get user name and amount of Fibonacci numbers
; to be calculated, display Fibonacci numbers to user

INCLUDE Irvine32.inc

;constants
LOW_BOUND = 1
HIGH_BOUND = 46

.data
authName		BYTE	"Author: Kyle Esquerra",0
progTitle		BYTE	"Title: Fibonacci Numbers",0
promptName		BYTE	"Please enter your name: ",0
userName		BYTE	30 dup(0)
greetUser		BYTE	"Hello, ",0
exclam			BYTE	"!",0
promptNum		BYTE	"Please enter the amount of Fibonacci numbers to display (1-46): ",0
invalidNum		BYTE	"Number is not in range (1-46).",0
exitMsg			BYTE	"Goodbye, ",0
verifMsg		BYTE	"Results verified by Kyle Esquerra.",0
ec				BYTE	"**EC: Numbers in aligned columns",0
fibCount		DWORD	?
fibCurr			DWORD	1
fibPrev			DWORD	0
fibTemp			DWORD	0
lineCount		DWORD	0

.code
main PROC

;introduction
	;author name
	mov		edx, OFFSET authName
	call	WriteString
	call	CrLf

	;program title
	mov		edx, OFFSET progTitle
	call	WriteString
	call	CrLf

	;extra credit message
	mov		edx, OFFSET ec
	call	WriteString
	call	CrLf
	call	CrLf

;greet user
	;get user name
	mov		edx, OFFSET promptName
	call	WriteString
	mov		ecx, 30
	mov		edx, OFFSET userName
	call	ReadString

	;greet user
	mov		edx, OFFSET greetUser
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET exclam
	call	WriteString
	call	CrLf
	call	CrLf

	;skip error on first run
	jmp		getCount

;validation error for fibonacci count
invalid:
	mov		edx, OFFSET invalidNum
	call	WriteString
	call	CrLf
	call	CrLf

;get user fibonacci count
getCount:
	;prompt for amount
	mov		edx, OFFSET promptNum
	call	WriteString
	call	ReadInt
	mov		fibCount, eax

	;validate if user number is higher than low bound
	mov		eax, fibCount
	cmp		eax, LOW_BOUND
	jl		invalid

	;validate if user number is lower than high bound
	cmp		eax, HIGH_BOUND
	jg		invalid

;display fib numbers
	;set counter for loop
	mov		ecx, fibCount
	;set counter for new line
	mov		ebx, 0
	;set remainder to zero
	mov		edx, 0

;run fib algorithm
	jmp		firstRun				;jump past the tab and new line

runFib:
	;increment count and if it is a multiple of 5, write a new line, otherwise jump to the tab characters
	inc		lineCount
	mov		eax, lineCount
	mov		ebx, 5	
	cdq
	div		ebx
	cmp		edx, 0
	jne		tabChar

newLine:
	;write new line and skip tab character
	call	CrLf
	jmp		firstRun

tabChar:
	;write two tab characters between each number
	mov		eax, 9
	call	WriteChar
	call	WriteChar

firstRun:
	;display current fibonacci number
	mov		eax, fibCurr
	call	WriteDec

	;add previous fibonacci number and current fibonacci number, store it in temp
	add		eax, fibPrev
	mov		fibTemp, eax

	;move current fibonacci number to previous fibonacci number
	mov		eax, fibCurr
	mov		fibPrev, eax

	;move temp fibonacci number into current fibonacci number
	mov		eax, fibTemp
	mov		fibCurr, eax

	;loop until its written the fibonacci number for the amount the user selected
	loop	runFib

	;final new lines
	call	CrLf
	call	CrLf

;exit program
	;verification message from author
	mov		edx, OFFSET verifMsg
	call	WriteString
	call	CrLf

	;goodbye message to user
	mov		edx, OFFSET exitMsg
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET exclam
	call	WriteString
	call	CrLf

	;exit program
	exit
main ENDP

END main