[BITS 32]


%macro load 2		;loader function (stdcall), gl function name
push name_%2
call %1
mov dword[%2], eax
test eax, eax
jz load_gl_functions_cringe
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
	load_error db "load_gl_functions: there was an error",10,0
	print_version db "OpenGL version: %s",10,0
	print_int db "%d",10,0

	;defines
	glDefine GL_COLOR_BUFFER_BIT, 0x00004000
	glDefine GL_COMPILE_STATUS, 0x8b81
	glDefine GL_FRAGMENT_SHADER, 0x8b30
	glDefine GL_GEOMETRY_SHADER, 0x8dd9
	glDefine GL_LINK_STATUS, 0x8b82
	glDefine GL_VERSION, 0x1f02
	glDefine GL_VERTEX_SHADER, 0x8b31
	

	;function names
	name_glAttachShader db "glAttachShader",0
	name_glClear db "glClear",0
	name_glClearColor db "glClearColor",0
	name_glCompileShader db "glCompileShader",0
	name_glCreateProgram db "glCreateProgram",0
	name_glCreateShader db "glCreateShader",0
	name_glDeleteProgram db "glDeleteProgram",0
	name_glDeleteShader db "glDeleteShader",0
	name_glGetError db "glGetError",0
	name_glGetShaderInfoLog db "glGetShaderInfoLog",0
	name_glGetShaderiv db "glGetShaderiv",0
	name_glGetString db "glGetString",0
	name_glLinkProgram db "glLinkProgram",0
	name_glShaderSource db "glShaderSource",0
	name_glUseProgram db "glUseProgram",0
	name_glViewport db "glViewport",0


section .bss use32
	;function pointers
	glFunc glAttachShader
	glFunc glClear
	glFunc glClearColor
	glFunc glCompileShader
	glFunc glCreateProgram
	glFunc glCreateShader
	glFunc glDeleteProgram
	glFunc glDeleteShader
	glFunc glGetError
	glFunc glGetShaderInfoLog
	glFunc glGetShaderiv
	glFunc glGetString
	glFunc glLinkProgram
	glFunc glShaderSource
	glFunc glUseProgram
	glFunc glViewport

section .text use32

	global load_gl_functions	;int load_gl_functions(function* (*glFunctionLoader)(const char*)) ,  returns 0 if an error happened
	
	extern my_printf
	
load_gl_functions:
	push ebp
	mov ebp, esp
	
	;load functions
	load dword[ebp+8], glAttachShader
	load dword[ebp+8], glClear
	load dword[ebp+8], glClearColor
	load dword[ebp+8], glCompileShader
	load dword[ebp+8], glCreateProgram
	load dword[ebp+8], glCreateShader
	load dword[ebp+8], glDeleteProgram
	load dword[ebp+8], glDeleteShader
	load dword[ebp+8], glGetError
	load dword[ebp+8], glGetShaderInfoLog
	load dword[ebp+8], glGetShaderiv
	load dword[ebp+8], glGetString
	load dword[ebp+8], glLinkProgram
	load dword[ebp+8], glShaderSource
	load dword[ebp+8], glUseProgram
	load dword[ebp+8], glViewport
	
	;get version
	cmp dword[glGetString], 0
	je load_gl_functions_cringe
	
	push dword[GL_VERSION]
	call [glGetString]
	test eax, eax
	jz load_gl_functions_cringe
	
	push eax
	push print_version
	call my_printf
	add esp, 8
	
	
	jmp load_gl_functions_successful
	load_gl_functions_cringe:
		push load_error
		call my_printf
	
		mov eax, 0
		mov esp, ebp
		pop ebp
		ret
	
	load_gl_functions_successful:
	mov eax, 69
	mov esp, ebp
	pop ebp
	ret