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
	glDefine GL_COMPILE_STATUS, 0x8b81
	glDefine GL_FRAGMENT_SHADER, 0x8b30
	glDefine GL_GEOMETRY_SHADER, 0x8dd9
	glDefine GL_LINK_STATUS, 0x8b82
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
	name_glGetShaderInfoLog db "glGetShaderInfoLog",0
	name_glGetShaderiv db "glGetShaderiv",0
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
	glFunc glGetShaderInfoLog
	glFunc glGetShaderiv
	glFunc glLinkProgram
	glFunc glShaderSource
	glFunc glUseProgram
	glFunc glViewport

section .text use32

	global load_gl_functions	;int load_gl_functions(function* (*glFunctionLoader)(const char*)) ,  returns 0 if an error happened
	
load_gl_functions:
	push ebp
	mov ebp, esp
	
	load dword[ebp+8], glAttachShader
	load dword[ebp+8], glClear
	load dword[ebp+8], glClearColor
	load dword[ebp+8], glCompileShader
	load dword[ebp+8], glCreateProgram
	load dword[ebp+8], glCreateShader
	load dword[ebp+8], glDeleteProgram
	load dword[ebp+8], glDeleteShader
	load dword[ebp+8], glGetShaderInfoLog
	load dword[ebp+8], glGetShaderiv
	load dword[ebp+8], glLinkProgram
	load dword[ebp+8], glShaderSource
	load dword[ebp+8], glUseProgram
	load dword[ebp+8], glViewport
	
	
	
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