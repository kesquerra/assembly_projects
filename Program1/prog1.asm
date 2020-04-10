TITLE Sum and Differences of 3 Numbers		(prog1.asm)

; Author: Kyle Esquerra
; Last Modified: 04/10/2020
; OSU email address: esquerrk@oregonstate.edu
; Course number/section: C400_S2020
; Project Number: 1                Due Date: 04/12/2020
; Description: Get 3 numbers from user, calculate and display sum and differences of numbers

INCLUDE Irvine32.inc

.data

authName		BYTE	"Author: Kyle Esquerra",0
progTitle		BYTE	"Title: Sum and Differences of 3 Numbers",0
instrString		BYTE	"Enter 3 numbers in descending order.",0
promptNumA		BYTE	"First number: ",0
promptNumB		BYTE	"Second number: ",0
promptNumC		BYTE	"Third number: ",0
numA			DWORD	?
numB			DWORD	?
numC			DWORD	?
sumAB			DWORD	?
sumAC			DWORD	?
sumBC			DWORD	?
sumABC			DWORD	?
diffAB			DWORD	?
diffAC			DWORD	?
diffBC			DWORD	?
diffBA			DWORD	?
diffCA			DWORD	?
diffCB			DWORD	?
diffCBA			DWORD	?
goodbye			BYTE	"Goodbye!",0
plus			BYTE	' + ',0
minus			BYTE	' - ',0
equals			BYTE	' = ',0
invalidNum		BYTE	"The numbers are not in descending order.",0
promptCon		BYTE	"Enter 0 to quit or any other integer to continue: ",0
ec1				BYTE	"**EC: Program repeats until user chooses to quit.",0
ec2				BYTE	"**EC: Program checks if numbers are in non-descending order.",0
ec3				BYTE	"**EC: Program handles negative results and computes B-A, C-A, C-B, C-B-A.",0

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

	;extra credit 1-3
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec3
	call	WriteString
	call	CrLf
	call	CrLf

	;program instructions
	mov		edx, OFFSET instrString
	call	WriteString
	call	CrLf
	call	CrLf
	
	;skip error message
	jmp		beg

	;error message for invalid descending order
error:
	mov		edx, OFFSET invalidNum
	call	WriteString
	call	CrLf
	call	CrLf

;get the data
beg:
	;get numA
	mov		edx, OFFSET promptNumA
	call	WriteString
	call	ReadInt
	mov		numA, eax

	;get numB
	mov		edx, OFFSET promptNumB
	call	WriteString
	call	ReadInt
	mov		numB, eax

	;get numC
	mov		edx, OFFSET promptNumC
	call	WriteString
	call	ReadInt
	mov		numC, eax
	call	CrLf

;compare values
	;set comparison value
	mov		eax, numB
	;if B is greater than A, error
	cmp		eax, numA
	jg		error
	;if B is less than C, error
	cmp		eax, numC
	jl		error


;calculate the required values
	;calc A + B
	mov		eax, numA
	add		eax, numB
	mov		sumAB, eax

	;calc A - B
	mov		eax, numA
	sub		eax, numB
	mov		diffAB, eax

	;calc A + C
	mov		eax, numA
	add		eax, numC
	mov		sumAC, eax

	;calc A - C
	mov		eax, numA
	sub		eax, numC
	mov		diffAC, eax

	;calc B + C
	mov		eax, numB
	add		eax, numC
	mov		sumBC, eax

	;calc B - C
	mov		eax, numB
	sub		eax, numC
	mov		diffBC, eax

	;calc A + B + C
	mov		eax, numA
	add		eax, numB
	add		eax, numC
	mov		sumABC, eax

	;calc B - A
	mov		eax, numB
	sub		eax, numA
	mov		diffBA, eax

	;calc C - A
	mov		eax, numC
	sub		eax, numA
	mov		diffCA, eax

	;calc C - B
	mov		eax, numC
	sub		eax, numB
	mov		diffCB, eax

	;calc C - B - A
	mov		eax, numC
	sub		eax, numB
	sub		eax, numA
	mov		diffCBA, eax



;display the results
	;A + B
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sumAB
	call	WriteDec
	call	CrLf

	;A - B
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diffAB
	call	WriteDec
	call	CrLf

	;A + C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sumAC
	call	WriteDec
	call	CrLf

	;A - C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diffAC
	call	WriteDec
	call	CrLf
	
	;B + C
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sumBC
	call	WriteDec
	call	CrLf

	;B - C
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diffBC
	call	WriteDec
	call	CrLf

	;A + B + C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sumABC
	call	WriteDec
	call	CrLf
	call	CrLf

	;B - A
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diffBA
	call	WriteInt
	call	CrLf

	;C - A
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diffCA
	call	WriteInt
	call	CrLf

	;C - B
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diffCB
	call	WriteInt
	call	CrLf

	;C - B - A
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diffCBA
	call	WriteInt
	call	CrLf
	call	CrLf

	;ask user to continue
	mov		edx, OFFSET promptCon
	call	WriteString
	call	ReadInt
	cmp		eax, 1
	jl		endLoop
	jmp		beg


;say goodbye
endLoop:
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

;exit program
	exit
main ENDP

END main