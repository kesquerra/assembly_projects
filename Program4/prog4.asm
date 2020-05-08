TITLE Integer Accumulator		(prog3.asm)

; Author: Kyle Esquerra
; Last Modified: 04/28/2020
; OSU email address: esquerrk@oregonstate.edu
; Course number/section: C400_S2020
; Project Number: 3                Due Date: 05/03/2020
; Description: 

INCLUDE Irvine32.inc

;constants
UPPER_BOUND = 400
LOWER_BOUND = 1

.data
authName		BYTE	"Author: Kyle Esquerra",0
progTitle		BYTE	"Title: Composite Numbers",0
ec				BYTE	"EC Placeholder",0
instrMsg		BYTE	"Enter the number of composite numbers to display [",0
ellipses		BYTE	"...",0
endBracket		BYTE	"]: ",0
invalidMsg		BYTE	"Number is not in range. Try again.",0
userNum			DWORD	?
compCount		DWORD	0
compNum			DWORD	4
divisors		DWORD	2, 3, 5, 7, 11, 13, 17, 19
divCount		DWORD   8
compBool		WORD	0

.code
main PROC

	call	displayIntro
	call	getUserData
	call	showComposites

	exit
	
main ENDP

displayIntro PROC
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

	;return
	ret
displayIntro ENDP

getUserData PROC
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
	ret

getUserData ENDP

validate	PROC
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

;check if number in compNum is composite, if true compBool = 1
isComposite PROC
	pushad
	mov		divCount, 8
	mov		ebx, 0
	mov		esi, OFFSET divisors

	divisor:
		mov		eax, compNum
		mov		edx, 0
		mov		ebx, [esi]
		cmp		ebx, compNum
		je		compRet
		cdq
		div		ebx
		cmp		edx, 0
		jz		compTrue
		add		esi, 4
		dec		divCount
		cmp		divCount, 0
		je		compFalse
		jmp		divisor

	compTrue:
		mov		compBool, 1
		inc		compCount
		jmp		compRet

	compFalse:
		mov		compBool, 0

	compRet:
		popad
		ret

isComposite ENDP

showComposites PROC
	pushad
	mov ecx, userNum

	renameLoop:
		mov		compBool, 0
		mov		eax, compNum
		call	isComposite
		inc		compNum
		cmp		compBool, 0
		je		renameLoop

	call	WriteDec
	mov		al, 9
	call	WriteChar
	loop	renameLoop

	popad
	ret


showComposites ENDP


END main

