[BITS 32]


%macro load 2		;loader function (stdcall), gl function name
push name_%2
call %1
mov dword[%2], eax
test eax, eax
je load_gl_functions_cringe
%endmacro

%macro glFunc 1		;gl function name
%1 resb 4
global %1
%endmacro

%macro glDefine 2		;name, value
%1 dd %2
global %1
%endmacro


section .rodata use32
	;defines
	glDefine GL_COLOR_BUFFER_BIT, 0x00004000
	

	;function names
	name_glViewport db "glViewport",0

	name_glClear db "glClear",0
	name_glClearColor db "glClearColor",0

section .bss use32
	;function pointers
	glFunc glViewport

	glFunc glClear
	glFunc glClearColor

section .text use32

	global load_gl_functions	;int load_gl_functions(function* (*glFunctionLoader)(const char*)) ,  returns 0 if an error happened
	
load_gl_functions:
	push ebp
	mov ebp, esp
	
	load dword[ebp+8], glViewport
	
	load dword[ebp+8], glClear
	load dword[ebp+8], glClearColor
	
	
	jmp load_gl_functions_successful
	load_gl_functions_cringe:
		mov eax, 0
		mov esp, ebp
		pop ebp
		ret
	
	load_gl_functions_successful:
	mov eax, 69
	mov esp, ebp
	pop ebp
	ret