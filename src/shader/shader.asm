[BITS 32]

section .rodata use32
	read_mode db "r",0

section .bss use32
	info_buffer resb 512
	shader_buffer resb 10000		;the max length of the shader is about 10kB
	
section .text use32
	
	global shader_import		;GLuint shader_import(const char* pathToVertexShader, const char* pathToFragmentShader, const char* nullablePathToGeometryShader)
	
	extern my_fopen
	extern my_fclose
	extern my_fgets
	
	extern my_strlen
	extern my_strcpy
	
	extern my_printf
	
shader_import:
	push ebp
	mov ebp, esp
	
	sub esp, 4		;program
	sub esp, 4		;file
	
	push dword[ebp+8]
	call shader_import_read_file
	add esp, 4
	
	push shader_buffer
	call my_printf
	add esp, 4
	
	mov esp, ebp
	pop ebp
	ret
	
	
;int shader_import_read_file(const char* pathToFile)
;reads the contents of the file into the shader_buffer
;returns 0 if all is well
shader_import_read_file:
	push ebp
	push ebx
	push esi
	push edi
	mov ebp, esp
	
	sub esp, 300	;line buffer
	sub esp, 4		;file
	
	;open file
	push read_mode
	push dword[ebp+20]
	call my_fopen
	mov dword[ebp-304], eax		;save the file
	add esp, 8
	
	test eax, eax
	jz shader_import_read_file_error
	
	;read the contents line by line
	mov esi, shader_buffer		;the start of the next line in esi
	shader_import_read_file_loop_start:
	
		;read line into the line buffer
		lea eax, [ebp-300]
		push dword[ebp-304]
		push 300
		push eax
		call my_fgets
		add esp, 12
		
		;was it successful?
		test eax, eax
		jz shader_import_read_file_loop_end
		
		;copy the line into the shader_buffer
		lea eax, [ebp-300]
		push eax
		push esi
		call my_strcpy
		add esp, 8
		
		;adjust the value of esi
		lea eax, [ebp-300]
		push eax
		call my_strlen
		add esp, 4
		
		add esi, eax
		
		jmp shader_import_read_file_loop_start
		
	shader_import_read_file_loop_end:
	
	;close the file
	push dword[ebp-304]
	call my_fclose
	add esp, 4
	
	xor eax, eax
	jmp shader_import_read_file_end
	shader_import_read_file_error:
		mov eax, 69
		jmp shader_import_read_file_end
		
	shader_import_read_file_end:
	mov esp, ebp
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret