TITLE DogYears		DogYears.asm

; Author: Kyle Esquerra
; Last Modified: 
; OSU email address: esquerrk@oregonstate.edu
; Course number/section: C400_S2020
; Project Number: 1               Due Date: 4/12/20
; Description:

INCLUDE Irvine32.inc

DOG_FACTOR = 7

.data

userName	BYTE	33 DUP(0)	;string to be entered by user
userAge		DWORD	?			;integer to be entered by user
intro_1		BYTE	"Intro text",0
prompt_1	BYTE	"What is your name? ",0
intro_2		BYTE	"Nice to meet you",0
prompt_2	BYTE	"How old are you? ",0
dogAge		DWORD	?
result_1	BYTE	"Wow... that's ",0
result_2	BYTE	" in dog years!",0
goodbye		BYTE	"Goodbye, ",0

.code
main PROC

;Introduce programmer
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

;Get username
	mov		edx, OFFSET	prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

;Get user age
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		userAge, eax

;Calculate user dog years
	mov		eax, userAge
	mov		ebx, DOG_FACTOR
	mul		ebx
	mov		dogAge, eax

;Report result
	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, dogAge
	call	WriteDec
	mov		edx, OFFSET result_2
	call	WriteString
	call	CrLf

;Say goodbye
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

;Exit program
	exit	; exit to operating system

main ENDP

END main
