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
	glDefine GL_ARRAY_BUFFER, 0x8892
	glDefine GL_COLOR_BUFFER_BIT, 0x00004000
	glDefine GL_COMPILE_STATUS, 0x8b81
	glDefine GL_DYNAMIC_DRAW, 0x88e8
	glDefine GL_ELEMENT_ARRAY_BUFFER, 0x8893
	glDefine GL_FALSE, 0x0
	glDefine GL_FLOAT, 0x1406
	glDefine GL_FRAGMENT_SHADER, 0x8b30
	glDefine GL_GEOMETRY_SHADER, 0x8dd9
	glDefine GL_LINES, 0x1
	glDefine GL_LINK_STATUS, 0x8b82
	glDefine GL_POINTS, 0x0
	glDefine GL_STATIC_DRAW, 0x88e4
	glDefine GL_TEXTURE_2D, 0xde1
	glDefine GL_TEXTURE0, 0x84c0
	glDefine GL_TEXTURE1, 0x84c1
	glDefine GL_TEXTURE2, 0x84c2
	glDefine GL_TEXTURE3, 0x84c3
	glDefine GL_TEXTURE4, 0x84c4
	glDefine GL_TEXTURE5, 0x84c5
	glDefine GL_TEXTURE6, 0x84c6
	glDefine GL_TEXTURE7, 0x84c7
	glDefine GL_TEXTURE8, 0x84c8
	glDefine GL_TEXTURE9, 0x84c9
	glDefine GL_TEXTURE10, 0x84ca
	glDefine GL_TEXTURE11, 0x84cb
	glDefine GL_TEXTURE12, 0x84cc
	glDefine GL_TEXTURE13, 0x84cd
	glDefine GL_TEXTURE14, 0x84ce
	glDefine GL_TEXTURE15, 0x84cf
	glDefine GL_TEXTURE16, 0x84d0
	glDefine GL_TEXTURE17, 0x84d1
	glDefine GL_TEXTURE18, 0x84d2
	glDefine GL_TEXTURE19, 0x84d3
	glDefine GL_TEXTURE20, 0x84d4
	glDefine GL_TEXTURE21, 0x84d5
	glDefine GL_TEXTURE22, 0x84d6
	glDefine GL_TEXTURE23, 0x84d7
	glDefine GL_TEXTURE24, 0x84d8
	glDefine GL_TEXTURE25, 0x84d9
	glDefine GL_TEXTURE26, 0x84da
	glDefine GL_TEXTURE27, 0x84db
	glDefine GL_TEXTURE28, 0x84dc
	glDefine GL_TEXTURE29, 0x84dd
	glDefine GL_TEXTURE30, 0x84de
	glDefine GL_TEXTURE31, 0x84df
	glDefine GL_TRIANGLES, 0x4
	glDefine GL_TRUE, 0x1
	glDefine GL_UNSIGNED_BYTE, 0x1401
	glDefine GL_UNSIGNED_INT, 0x1405
	glDefine GL_VERSION, 0x1f02
	glDefine GL_VERTEX_SHADER, 0x8b31
	

	;function names
	name_glActiveTexture db "glActiveTexture",0
	name_glAttachShader db "glAttachShader",0
	name_glBindBuffer db "glBindBuffer",0
	name_glBindTexture db "glBindTexture",0
	name_glBindVertexArray db "glBindVertexArray",0
	name_glBufferData db "glBufferData",0
	name_glClear db "glClear",0
	name_glClearColor db "glClearColor",0
	name_glCompileShader db "glCompileShader",0
	name_glCreateProgram db "glCreateProgram",0
	name_glCreateShader db "glCreateShader",0
	name_glDeleteBuffers db "glDeleteBuffers",0
	name_glDeleteProgram db "glDeleteProgram",0
	name_glDeleteShader db "glDeleteShader",0
	name_glDeleteTextures db "glDeleteTextures",0
	name_glDeleteVertexArrays db "glDeleteVertexArrays",0
	name_glDisableVertexAttribArray db "glDisableVertexAttribArray",0
	name_glDrawArrays db "glDrawArrays",0
	name_glDrawElements db "glDrawElements",0
	name_glEnableVertexAttribArray db "glEnableVertexAttribArray",0
	name_glGenBuffers db "glGenBuffers",0
	name_glGenTextures db "glGenTextures",0
	name_glGenVertexArrays db "glGenVertexArrays",0
	name_glGetError db "glGetError",0
	name_glGetProgramInfoLog db "glGetProgramInfoLog",0
	name_glGetProgramiv db "glGetProgramiv",0
	name_glGetShaderInfoLog db "glGetShaderInfoLog",0
	name_glGetShaderiv db "glGetShaderiv",0
	name_glGetString db "glGetString",0
	name_glGetUniformLocation db "glGetUniformLocation",0
	name_glLinkProgram db "glLinkProgram",0
	name_glShaderSource db "glShaderSource",0
	name_glUniform1f db "glUniform1f",0
	name_glUniform1fv db "glUniform1fv",0
	name_glUniform1i db "glUniform1i",0
	name_glUniform1iv db "glUniform1iv",0
	name_glUniform2f db "glUniform2f",0
	name_glUniform2fv db "glUniform2fv",0
	name_glUniform2i db "glUniform2i",0
	name_glUniform2iv db "glUniform2iv",0
	name_glUniform3f db "glUniform3f",0
	name_glUniform3fv db "glUniform3fv",0
	name_glUniform3i db "glUniform3i",0
	name_glUniform3iv db "glUniform3iv",0
	name_glUniform4f db "glUniform4f",0
	name_glUniform4fv db "glUniform4fv",0
	name_glUniform4i db "glUniform4i",0
	name_glUniform4iv db "glUniform4iv",0
	name_glUniformMatrix2fv db "glUniformMatrix2fv",0
	name_glUniformMatrix3fv db "glUniformMatrix3fv",0
	name_glUniformMatrix4fv db "glUniformMatrix4fv",0
	name_glUseProgram db "glUseProgram",0
	name_glViewport db "glViewport",0


section .bss use32
	;function pointers
	glFunc glActiveTexture
	glFunc glAttachShader
	glFunc glBindBuffer
	glFunc glBindTexture
	glFunc glBindVertexArray
	glFunc glBufferData
	glFunc glClear
	glFunc glClearColor
	glFunc glCompileShader
	glFunc glCreateProgram
	glFunc glCreateShader
	glFunc glDeleteBuffers
	glFunc glDeleteProgram
	glFunc glDeleteShader
	glFunc glDeleteTextures
	glFunc glDeleteVertexArrays
	glFunc glDisableVertexAttribArray
	glFunc glDrawArrays
	glFunc glDrawElements
	glFunc glEnableVertexAttribArray
	glFunc glGenBuffers
	glFunc glGenTextures
	glFunc glGenVertexArrays
	glFunc glGetError
	glFunc glGetProgramInfoLog
	glFunc glGetProgramiv
	glFunc glGetShaderInfoLog
	glFunc glGetShaderiv
	glFunc glGetString
	glFunc glGetUniformLocation
	glFunc glLinkProgram
	glFunc glShaderSource
	glFunc glUniform1f
	glFunc glUniform1fv
	glFunc glUniform1i
	glFunc glUniform1iv
	glFunc glUniform2f
	glFunc glUniform2fv
	glFunc glUniform2i
	glFunc glUniform2iv
	glFunc glUniform3f
	glFunc glUniform3fv
	glFunc glUniform3i
	glFunc glUniform3iv
	glFunc glUniform4f
	glFunc glUniform4fv
	glFunc glUniform4i
	glFunc glUniform4iv
	glFunc glUniformMatrix2fv
	glFunc glUniformMatrix3fv
	glFunc glUniformMatrix4fv
	glFunc glUseProgram
	glFunc glViewport

section .text use32

	global load_gl_functions	;int load_gl_functions(function* (*glFunctionLoader)(const char*)) ,  returns 0 if an error happened
	
	extern my_printf
	
load_gl_functions:
	push ebp
	mov ebp, esp
	
	;load functions
	load dword[ebp+8], glActiveTexture
	load dword[ebp+8], glAttachShader
	load dword[ebp+8], glBindBuffer
	load dword[ebp+8], glBindTexture
	load dword[ebp+8], glBindVertexArray
	load dword[ebp+8], glBufferData
	load dword[ebp+8], glClear
	load dword[ebp+8], glClearColor
	load dword[ebp+8], glCompileShader
	load dword[ebp+8], glCreateProgram
	load dword[ebp+8], glCreateShader
	load dword[ebp+8], glDeleteBuffers
	load dword[ebp+8], glDeleteProgram
	load dword[ebp+8], glDeleteShader
	load dword[ebp+8], glDeleteTextures
	load dword[ebp+8], glDeleteVertexArrays
	load dword[ebp+8], glDisableVertexAttribArray
	load dword[ebp+8], glDrawArrays
	load dword[ebp+8], glDrawElements
	load dword[ebp+8], glEnableVertexAttribArray
	load dword[ebp+8], glGenBuffers
	load dword[ebp+8], glGenTextures
	load dword[ebp+8], glGenVertexArrays
	load dword[ebp+8], glGetError
	load dword[ebp+8], glGetProgramInfoLog
	load dword[ebp+8], glGetProgramiv
	load dword[ebp+8], glGetShaderInfoLog
	load dword[ebp+8], glGetShaderiv
	load dword[ebp+8], glGetString
	load dword[ebp+8], glGetUniformLocation
	load dword[ebp+8], glLinkProgram
	load dword[ebp+8], glShaderSource
	load dword[ebp+8], glUniform1i
	load dword[ebp+8], glUniform1iv
	load dword[ebp+8], glUniform1f
	load dword[ebp+8], glUniform1fv
	load dword[ebp+8], glUniform2i
	load dword[ebp+8], glUniform2iv
	load dword[ebp+8], glUniform2f
	load dword[ebp+8], glUniform2fv
	load dword[ebp+8], glUniform3i
	load dword[ebp+8], glUniform3iv
	load dword[ebp+8], glUniform3f
	load dword[ebp+8], glUniform3fv
	load dword[ebp+8], glUniform4i
	load dword[ebp+8], glUniform4iv
	load dword[ebp+8], glUniform4f
	load dword[ebp+8], glUniform4fv
	load dword[ebp+8], glUniformMatrix2fv
	load dword[ebp+8], glUniformMatrix3fv
	load dword[ebp+8], glUniformMatrix4fv
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