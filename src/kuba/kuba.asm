[BITS 32]

;kuba layout
;struct kuba{
;	GLuint vao;		4
;	GLuint vbo;		8
;	GLuint ebo;		12
;}

section .rodata use32
	print_int db "%d",10,0

	vertices:
	dd -0.5, -0.5, 0.0
	dd -0.5, 0.5, 0.0
	dd 0.5, 0.5, 0.0
	dd 0.5, -0.5, 0.0
	
	indices:
	dd 0,1,2,0,2,3
	
	uniform_pv db "pv",0
	
section .text use32
	
	global kuba_create		;void kuba_create(struct kuba* buffer)
	global kuba_destroy		;void kuba_destroy(struct kuba* buffer)
	global kuba_render		;void kuba_render(struct kuba* buffer, GLuint program, struct mat4* pv)
	
	extern my_printf
	
	extern glGenVertexArrays
	extern glGenBuffers
	extern glDeleteVertexArrays
	extern glDeleteBuffers
	
	extern glBindVertexArray
	extern glBindBuffer
	
	extern glBufferData
	extern glVertexAttribPointer
	extern glEnableVertexAttribArray
	
	extern glUniformMatrix4fv
	extern glGetUniformLocation
	
	extern glDrawElements
	extern glUseProgram
	
	extern glGetError
	
	extern GL_ARRAY_BUFFER
	extern GL_ELEMENT_ARRAY_BUFFER
	extern GL_STATIC_DRAW
	extern GL_FLOAT
	extern GL_UNSIGNED_INT
	extern GL_TRUE
	extern GL_FALSE
	extern GL_TRIANGLES
	
kuba_create:
	push ebp
	mov ebp, esp
	
	sub esp, 4		;vao
	sub esp, 4		;vbo
	sub esp, 4		;ebo
	
	;create vao
	lea eax, [ebp-4]
	push eax
	push 1
	call [glGenVertexArrays]
	
	push dword[ebp-4]
	call [glBindVertexArray]
	
	;create vbo and fill it with data
	lea eax, [ebp-8]
	push eax
	push 1
	call [glGenBuffers]
	
	push dword[ebp-8]
	push dword[GL_ARRAY_BUFFER]
	call [glBindBuffer]
	
	push dword[GL_STATIC_DRAW]
	push vertices
	push 64
	push dword[GL_ARRAY_BUFFER]
	call [glBufferData]
	
	push 0
	push 12
	push dword[GL_FALSE]
	push dword[GL_FLOAT]
	push 3
	push 0
	call [glVertexAttribPointer]
	
	push 0
	call [glEnableVertexAttribArray]
	
	;create ebo and fill it up with data
	lea eax, [ebp-12]
	push eax
	push 1
	call [glGenBuffers]
	
	push dword[ebp-12]
	push dword[GL_ELEMENT_ARRAY_BUFFER]
	call [glBindBuffer]
	
	push dword[GL_STATIC_DRAW]
	push indices
	push 24
	push dword[GL_ELEMENT_ARRAY_BUFFER]
	call [glBufferData]
	
	
	push 0
	call [glBindVertexArray]
	
	;copy the data to the buffer
	mov eax, dword[ebp+8]
	
	mov ecx, dword[ebp-4]
	mov dword[eax], ecx
	mov ecx, dword[ebp-8]
	mov dword[eax+4], ecx
	mov ecx, dword[ebp-12]
	mov dword[eax+8], ecx
	
	mov esp, ebp
	pop ebp
	ret
	
kuba_destroy:
	push ebp
	mov ebp, esp
	
	mov eax, dword[ebp+8]
	lea ecx, [eax+4]
	lea edx, [eax+8]
	push eax
	push 1
	push ecx
	push 1
	push edx
	push 1
	call [glDeleteBuffers]
	call [glDeleteBuffers]
	call [glDeleteVertexArrays]
	
	mov esp, ebp
	pop ebp
	ret
	
	
kuba_render:
	push ebp
	mov ebp, esp
	
	sub esp, 4		;pv uniform location
	
	;use program
	push dword[ebp+12]
	call [glUseProgram]
	
	;get uniform location and set it
	push uniform_pv
	push dword[ebp+12]
	call [glGetUniformLocation]
	
	push dword[ebp+16]
	push dword[GL_TRUE]		;transpose it as my matrices are row major
	push 1
	push dword[ebp-4]
	call [glUniformMatrix4fv]
	
	
	;bind vao
	mov eax, dword[ebp+8]		;buffer* in eax
	push dword[eax]
	call [glBindVertexArray]
	
	;draw
	push 0
	push dword[GL_UNSIGNED_INT]
	push 6
	push dword[GL_TRIANGLES]
	call [glDrawElements]
	
	;unbind vao
	push 0
	call [glBindVertexArray]
	
	mov esp, ebp
	pop ebp
	ret