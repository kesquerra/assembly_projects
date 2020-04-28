TITLE Integer Accumulator		(prog3.asm)

; Author: Kyle Esquerra
; Last Modified: 04/28/2020
; OSU email address: esquerrk@oregonstate.edu
; Course number/section: C400_S2020
; Project Number: 3                Due Date: 05/03/2020
; Description: 

INCLUDE Irvine32.inc

;constants
LOW_BOUND_1 = -88
HIGH_BOUND_1 = -55
LOW_BOUND_2 = -40
HIGH_BOUND_2 = -1

.data
authName		BYTE	"Author: Kyle Esquerra",0
progTitle		BYTE	"Title: Integer Accumulator",0
promptName		BYTE	"Please enter your name: ",0
userName		BYTE	30 dup(0)
greetUser		BYTE	"Hello, ",0
exclam			BYTE	"!",0
numInstr1		BYTE	"Please enter numbers in [",0
space			BYTE	"  ",0
comma			BYTE	", ",0
numInstr2		BYTE	"] or [",0
numInstr3		BYTE	"].",0
nonNegInstr		BYTE	"Enter a non-negative number when you are finished to see the results.",0
enterNum		BYTE	"Enter number: ",0
invalidNum		BYTE	"Number is not in range.",0
validNumMsg1	BYTE	"You entered ",0
validNumMsg2	BYTE	" valid numbers.",0
sumMsg			BYTE	"The sum of your valid numbers is ",0
avgMsg			BYTE	"The rounded average is ",0
maxMsg			BYTE	"The maximum valid number is ",0
minMsg			BYTE	"The minimum valid number is ",0
exitMsg			BYTE	"Goodbye, ",0
noValidsMsg		BYTE	"No valid numbers were entered.",0
ec				BYTE	"**EC: Number lines during user input",0
lineCount		DWORD	1
userNum			SDWORD	?
numCount		DWORD	0
numTotal		SDWORD	0
maxNum			SDWORD	LOW_BOUND_1
minNum			SDWORD	HIGH_BOUND_2

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
	jmp		numberInstr

;number is not in range
invalid:
	mov		edx, OFFSET invalidNum
	call	WriteString
	call	CrLf
	jmp		enterNumber

boundCheck:
	;if user number is higher than high_bound_1 and less than low_bound_2, go to error
	mov		eax, userNum
	cmp		eax, LOW_BOUND_2
	jl		invalid
	jge		numSuccess

;give user the instructions
numberInstr:
	;instructions for range of numbers to enter
	mov		edx, OFFSET numInstr1
	call	WriteString
	mov		eax, LOW_BOUND_1
	call	WriteInt
	mov		edx, OFFSET comma
	call	WriteString
	mov		eax, HIGH_BOUND_1
	call	WriteInt
	mov		edx, OFFSET numInstr2
	call	WriteString
	mov		eax, LOW_BOUND_2
	call	WriteInt
	mov		edx, OFFSET comma
	call	WriteString
	mov		eax, HIGH_BOUND_2
	call	WriteInt
	mov		edx, OFFSET numInstr3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET nonNegInstr
	call	WriteString
	call	CrLf

enterNumber:
	;prompt user for number
	mov		eax, lineCount
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	mov		edx, OFFSET enterNum
	call	WriteString
	call	ReadInt
	mov		userNum, eax

	;exit loop if a non-negative number is entered
	mov		eax, userNum
	test	eax, eax
	jns		exitLoop

	;validate if user number is higher than low bound 1
	mov		eax, userNum
	cmp		eax, LOW_BOUND_1
	jl		invalid

	;validate if user number is lower than high bound 2
	cmp		eax, HIGH_BOUND_2
	jg		invalid

	;if user number is higher than high bound 1, go to second check
	cmp		eax, HIGH_BOUND_1
	jg		boundCheck

numSuccess:
	;increment count of numbers, increment line count, add number to sum
	inc		numCount
	inc		lineCount
	mov		eax, userNum
	add		numTotal, eax

checkMax:
	;check if number is greater than maximum number
	cmp		eax, maxNum
	jg		newMax
	jmp		checkMin

newMax:
	mov		maxNum, eax

checkMin:
	;update minimum number value
	cmp		eax, minNum
	jl		newMin
	jmp		numLoop

newMin:
	mov		minNum, eax

numLoop:
	;loop to enter another number
	jmp		enterNumber

exitLoop:
	;check if no valid numbers were entered
	mov		eax, numCount
	test	eax, eax
	jz		noValids

	;display how many valid numbers were entered
	mov		edx, OFFSET validNumMsg1
	call	WriteString
	call	WriteDec
	mov		edx, OFFSET validNumMsg2
	call	WriteString
	call	CrLf

	;display sum of numbers entered
	mov		edx, OFFSET sumMsg
	call	WriteString
	mov		eax, numTotal
	call	WriteInt
	call	CrLf

	;display max value
	mov		edx,OFFSET maxMsg
	call	WriteString
	mov		eax, maxNum
	call	WriteInt
	call	CrLf

	;display min value
	mov		edx,OFFSET minMsg
	call	WriteString
	mov		eax, minNum
	call	WriteInt
	call	CrLf

	;display average of sum
	mov		edx, OFFSET avgMsg
	call	WriteString
	mov		eax, numTotal
	mov		ebx, 100				
	imul	ebx									;multiply by 100 to change decimals to whole numbers
	cdq
	idiv	numCount							;divide by number count
	sub		eax, 50								;add -0.5 to total for rounding
	cdq
	idiv	ebx									;divide by 100 to put decimals back
	call	WriteInt
	call	CrLf

	jmp		exitProgram

noValids:
	mov		edx, OFFSET noValidsMsg
	call	WriteString
	call	CrLf
	


exitProgram:
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