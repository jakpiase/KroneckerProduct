public kronecker	; extern void kronecker(float* AMatrix, float* BMatrix, float* DestMatrix, int* SizeMatrix);
.data
	ARows dd  ?
	ACols dd  ?
	BRows dd  ?
	BCols dd  ?
	DestPointer dq ?
	Multiplier dd ?
.code

initializeData PROC
	push rbx
	bswap r8
	mov DestPointer, r8
	bswap r8
	mov ebx, [r9]
	mov ARows, ebx
	mov ebx, [r9+4]
	mov ACols, ebx
	mov ebx, [r9+8]
	mov BRows, ebx
	mov ebx, [r9+12]
	mov BCols, ebx
	pop rbx
	ret
initializeData ENDP

fillDestMatrix PROC
	push rax
	push rbx
	push rcx
	push rdx
	push rsi	; iterator macierzy B
	push rdi
	push r12
	push r13
	push r14

	mov r12, DestPointer
	bswap r12
	mov r13, rdx

	mov rsi, 0
	mov rdi, 0
	mov rax, 0 ;; do mnozenia
	mov rdx, 0 ;; do mnozenia
	mov rbx, 0
	mov r14, 0

cols:
	
rows:
	fld dword ptr [r13+4*rsi]
	fld dword ptr multiplier
	fmulp
	fstp dword ptr[r12+4*rdi]
	;mov ebx, [r13+4*rsi]
	;mov [r12+4*rdi], ebx

	inc rsi
	inc rdi

	cmp edi, BCols
	jnz rows

pastrows:
	inc r14 ;; kolejny wiersz

	mov edx, 0
	mov rax, 0  ;; do dzielenia
	mov rdi, 0  ;; rdi to iterator poziomy, r12 sie przesuwa przy kolejnym wierszu
	mov eax, BCols
	mul ACols
	shl eax, 2;  eax * 4
	add r12, rax

	cmp r14d, BRows
	jnz rows

	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret
fillDestMatrix ENDP
				;	   RCX             RDX             R8               R9
kronecker PROC;(float* AMatrix, float* BMatrix, float* DestMatrix, int* SizeMatrix);
	push rbx ; przechowanie rejestrów
	push rsi
	push rdi
	push r14
	push r15

	

	finit

	call initializeData

	mov r14, rcx
	mov r15, rdx
	
	mov r10, 0 ; iterator I
	mov r11, 0 ; iterator J

	mov rbx, 0 ;; iterator 

outer:

inner:
	mov ecx, [r14+4*rbx]
	mov multiplier, ecx
	mov rdx, r15
	call fillDestMatrix

	mov eax, BCols
	shl eax, 2 ; BCols * 4
	mov rcx, DestPointer
	bswap rcx
	add rcx, rax			; bo konwencje się psują
	bswap rcx
	mov DestPointer, rcx

	inc rbx
	inc r10
	cmp r10d, ACols
	jnz inner

	mov eax, BRows
	sub eax, 1
	mul BCols
	mul ACols
	shl eax, 2

	mov rcx, DestPointer
	bswap rcx
	add rcx, rax
	bswap rcx
	mov DestPointer, rcx

	mov r10, 0
	inc r11
	cmp r11d, ARows
	jnz outer

	mov rax, r8

	pop r15
	pop r14
	pop rdi
	pop rsi
	pop rbx
	ret

kronecker ENDP
END
END