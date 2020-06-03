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
   push 3
   push 13
   call rcrsn
   exit
main ENDP

rcrsn PROC
   push ebp
   mov ebp,esp
   mov eax,[ebp + 12]
   mov ebx,[ebp + 8]
   cmp eax,ebx
   jl recurse
   jmp quit
recurse:
   inc eax
   push eax
   push ebx
   call rcrsn
   mov eax,[ebp + 12]
   call WriteDec
   ;Space 2
quit:
   pop ebp
   ret 8
rcrsn ENDP

END main
