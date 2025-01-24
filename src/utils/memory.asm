[BITS 32]

section .rodata use32
	my_memset_dword_error_1 db "my_memset_dword: The number of bytes is not divisible by 4",10,0

section .text use32

	global my_memcpy			;void my_memcpy(void* dst, void* src, int numberOfBytes)
	
	global my_memset			;void my_memset(void* mem, int(!!!) byteValue, int numberOfBytes)		;the last byte of the value will be berucksichtingt
	global my_memset_dword		;void my_memset_dword(void* mem, int dwordValue, int numberOfBytes)		;the number of bytes shall be divisible by 4
	
	extern my_printf
	
my_memcpy:
	push ebp
	mov ebp, esp
	
	;is the memory region of the length of zero bytes?
	mov eax, dword[ebp+16]
	cmp eax, 0
	jle my_memcpy_end
	
	;should the copy start from the front or back
	mov eax, dword[ebp+8]
	cmp eax, dword[ebp+12]
	ja my_memcpy_copy_back_to_front		;so that it handles overlapping memory regions as well
	
	my_memcpy_copy_front_to_back:
		mov eax, dword[ebp+8]				;dst in eax
		mov ecx, dword[ebp+12]				;src in ecx
		mov edx, dword[ebp+16]				;byteNum in edx
		
		push ebx
		my_memcpy_copy_front_to_back_loop_start:
			mov bl, byte[ecx]
			mov byte[eax], bl
			
			inc eax
			inc ecx
			dec edx
			test edx, edx
			jnz my_memcpy_copy_front_to_back_loop_start
		pop ebx
	
	my_memcpy_copy_back_to_front:
		mov eax, dword[ebp+8]				;dst in eax
		mov ecx, dword[ebp+12]				;src in ecx
		mov edx, dword[ebp+16]				;byteNum in edx
		
		add eax, edx
		dec eax
		add ecx, edx
		dec ecx
		
		push ebx
		my_memcpy_copy_back_to_front_loop_start:
			mov bl, byte[ecx]
			mov byte[eax], bl
			
			dec eax
			dec ecx
			dec edx
			test edx, edx
			jnz my_memcpy_copy_back_to_front_loop_start
		pop ebx
	
	
	my_memcpy_end:
	mov esp, ebp
	pop ebp
	ret
	
	
my_memset:
	push ebp
	mov ebp, esp
	
	;is the number of bytes zero?
	cmp dword[ebp+16], 0
	jle my_memset_end
	
	mov eax, dword[ebp+8]		;mem in eax
	mov ecx, dword[ebp+12]		;value in cl
	mov edx, dword[ebp+16]		;byteNum in edx
	my_memset_loop_start:
		mov byte[eax], cl
		
		inc eax
		dec edx
		test edx, edx
		jnz my_memset_loop_start
	
	my_memset_end:
	mov esp, ebp
	pop ebp
	ret
	

my_memset_dword:
	push ebp
	mov ebp, esp
	
	;is the number of bytes zero?
	mov eax, dword[ebp+16]
	cmp eax, 0
	jle my_memset_dword_end
	
	;is the number of bytes divisible by 4?
	shr eax, 2
	test eax, eax
	jnz my_memset_dword_divisible_by_four
		push my_memset_dword_error_1
		call my_printf
		add esp, 4
		jmp my_memset_dword_end
	my_memset_dword_divisible_by_four:
	
	mov eax, dword[ebp+8]		;mem in eax
	mov ecx, dword[ebp+12]		;value in ecx
	mov edx, dword[ebp+16]		;byteNum in edx
	my_memset_dword_loop_start:
		mov dword[eax], ecx
		
		add eax, 4
		sub edx, 4
		test edx, edx
		jnz my_memset_dword_loop_start
	
	my_memset_dword_end:
	mov esp, ebp
	pop ebp
	ret
