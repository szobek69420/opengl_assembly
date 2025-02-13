[BITS 32]

global TEXT_ALIGN_TOP_LEFT
global TEXT_ALIGN_TOP_CENTER
global TEXT_ALIGN_TOP_RIGHT
global TEXT_ALIGN_CENTER_LEFT
global TEXT_ALIGN_CENTER_CENTER
global TEXT_ALIGN_CENTER_RIGHT
global TEXT_ALIGN_BOTTOM_LEFT
global TEXT_ALIGN_BOTTOM_CENTER
global TEXT_ALIGN_BOTTOM_RIGHT


section .rodata use32
	print_int db "%d",10,0
	print_two_floats db "%f %f",10,0

	ZERO dd 0.0
	ONE dd 1.0
	
	vertex_shader_location db "shaders/text/text.vag",0
	fragment_shader_location db "shaders/text/text.fag",0
	
	uniform_tex_name db "tex",0
	uniform_pv_name db "pv",0
	uniform_position_name db "position",0
	uniform_scale_name db "scale",0
	
	vertex_data:
	dd 1.0, 0.0, 1.0, 1.0
	dd 1.0, 1.0, 1.0, 0.0
	dd 0.0, 1.0, 0.0, 0.0
	dd 0.0, 0.0, 0.0, 1.0
	
	TEXT_ALIGN_TOP_LEFT 		dd		0b100100
	TEXT_ALIGN_TOP_CENTER 		dd	 	0b100010
	TEXT_ALIGN_TOP_RIGHT		dd		0b100001
	TEXT_ALIGN_CENTER_LEFT		dd		0b010100
	TEXT_ALIGN_CENTER_CENTER	dd		0b010010
	TEXT_ALIGN_CENTER_RIGHT		dd		0b010001
	TEXT_ALIGN_BOTTOM_LEFT		dd		0b001100
	TEXT_ALIGN_BOTTOM_CENTER	dd		0b001010
	TEXT_ALIGN_BOTTOM_RIGHT		dd		0b001001
	

section .bss use32
	screen_matrix resb 64
	character_textures resb 512		;128 * GLuint
	
	font_size_x_int resb 4
	font_size_y_int resb 4
	font_size_x resb 4				;float
	font_size_y resb 4				;float
	
	vao resb 4
	vbo resb 4
	shader resb 4
	uniform_pv_location resb 4
	uniform_position_location resb 4
	uniform_scale_location resb 4

section .text use32
	
	global textRenderer_init			;void textRenderer_init()
	global textRenderer_deinit			;void textRenderer_deinit()
	
	;it doesn't touch the face cull settings, so that can cause some anomalies
	global textRenderer_drawText		;void textRenderer_drawText(const char* text, int alignment, int xPos, int yPos)
	
	global textRenderer_setScreenSize	;void textRenderer_setScreenSize(int widthInPixels, int heightInPixels)
	global textRenderer_setFontSize		;void textRenderer_setFontSize(int xSize, int ySize)
	
	
	extern my_printf
	
	extern mat4_ortho
	extern mat4_print
	extern vec4_mulWithMat
	extern vec4_print
	
	extern shader_import
	extern shader_destroy
	
	extern FONT_TABLE
	extern FONT_CHAR_WIDTH
	extern FONT_CHAR_HEIGHT
	
	extern glGetError
	
	extern glGenVertexArrays
	extern glDeleteVertexArrays
	extern glBindVertexArray
	extern glGenBuffers
	extern glDeleteBuffers
	extern glBindBuffer
	extern glBufferData
	extern glVertexAttribPointer
	extern glEnableVertexAttribArray
	extern glGetUniformLocation
	extern glUniform1i
	extern glUniform2f
	extern glUniform2fv
	extern glUniformMatrix4fv
	extern glUseProgram
	extern glDrawArrays
	extern GL_ARRAY_BUFFER
	extern GL_STATIC_DRAW
	extern GL_TRUE
	extern GL_FALSE
	extern GL_FLOAT
	extern GL_TRIANGLE_FAN
	
	
	extern glActiveTexture
	extern glGenTextures
	extern glDeleteTextures
	extern glBindTexture
	extern glTexImage2D
	extern glGenerateMipmap
	extern glTexParameteri
	extern glPixelStorei
	
	extern GL_TEXTURE0
	extern GL_TEXTURE_2D
	extern GL_REPEAT
	extern GL_NEAREST
	extern GL_TEXTURE_WRAP_S
	extern GL_TEXTURE_WRAP_T
	extern GL_TEXTURE_MIN_FILTER
	extern GL_TEXTURE_MAG_FILTER
	extern GL_RGBA
	extern GL_RED
	extern GL_UNSIGNED_BYTE
	extern GL_UNPACK_ALIGNMENT
	
	
textRenderer_init:
	push ebp
	push esi
	mov ebp, esp
	
	sub esp, 4			;texture data size per pixel
	
	;set screen size to 100*100
	push 100
	push 100
	call textRenderer_setScreenSize
	add esp, 8
	
	;set font size
	mov eax, dword[FONT_CHAR_HEIGHT]
	shl eax, 2
	push eax
	mov eax, dword[FONT_CHAR_WIDTH]
	shl eax, 2
	push eax
	call textRenderer_setFontSize
	add esp, 8
	
	;create vao and vbo
	push vao
	push 1
	call [glGenVertexArrays]
	push vbo
	push 1
	call [glGenBuffers]
	
	push dword[vao]
	call [glBindVertexArray]
	push dword[vbo]
	push dword[GL_ARRAY_BUFFER]
	call [glBindBuffer]
	
	push dword[GL_STATIC_DRAW]
	push vertex_data
	push 64
	push dword[GL_ARRAY_BUFFER]
	call [glBufferData]
	
	push 0
	push 16
	push dword[GL_FALSE]
	push dword[GL_FLOAT]
	push 2
	push 0
	call [glVertexAttribPointer]
	push 8
	push 16
	push dword[GL_FALSE]
	push dword[GL_FLOAT]
	push 2
	push 1
	call [glVertexAttribPointer]
	push 0
	call [glEnableVertexAttribArray]
	push 1
	call [glEnableVertexAttribArray]
	
	;compile shaders and get uniform location
	push 0
	push fragment_shader_location
	push vertex_shader_location
	call shader_import
	mov dword[shader], eax
	add esp, 12
	
	push uniform_pv_name
	push dword[shader]
	call [glGetUniformLocation]
	mov dword[uniform_pv_location], eax
	push uniform_position_name
	push dword[shader]
	call [glGetUniformLocation]
	mov dword[uniform_position_location], eax
	push uniform_scale_name
	push dword[shader]
	call [glGetUniformLocation]
	mov dword[uniform_scale_location], eax
	
	push uniform_tex_name
	push dword[shader]
	call [glGetUniformLocation]
	push 0
	push eax
	call [glUniform1i]			;sets the "tex" as it is always 0
	
	
	;calculate texture data size
	mov eax, dword[FONT_CHAR_WIDTH]
	imul eax, dword[FONT_CHAR_HEIGHT]
	imul eax, 3					;3 colour components
	mov dword[ebp-4], eax
	
	;generate textures
	push character_textures
	push 128
	call [glGenTextures]
	
	;create texture data for the characters
	push 1
	push dword[GL_UNPACK_ALIGNMENT]
	call [glPixelStorei]			;so that the pixel data doesn't need to align to 4 bytes
	
	xor esi, esi			;index
	textRenderer_init_loop_start:
		;bind the current texture
		push dword[4*esi+character_textures]
		push dword[GL_TEXTURE_2D]
		call [glBindTexture]
		
		;set the texture parameters
		push dword[GL_REPEAT]
		push dword[GL_TEXTURE_WRAP_S]
		push dword[GL_TEXTURE_2D]
		call [glTexParameteri]
		
		push dword[GL_REPEAT]
		push dword[GL_TEXTURE_WRAP_T]
		push dword[GL_TEXTURE_2D]
		call [glTexParameteri]
		
		push dword[GL_NEAREST]
		push dword[GL_TEXTURE_MIN_FILTER]
		push dword[GL_TEXTURE_2D]
		call [glTexParameteri]
		
		push dword[GL_NEAREST]
		push dword[GL_TEXTURE_MAG_FILTER]
		push dword[GL_TEXTURE_2D]
		call [glTexParameteri]
		
		;load data and generate mipmaps
		push dword[4*esi+FONT_TABLE]		;data
		push dword[GL_UNSIGNED_BYTE]
		push dword[GL_RED]
		push 0
		push dword[FONT_CHAR_HEIGHT]
		push dword[FONT_CHAR_WIDTH]
		push dword[GL_RGBA]
		push 0
		push dword[GL_TEXTURE_2D]
		call [glTexImage2D]
		
		push dword[GL_TEXTURE_2D]
		call [glGenerateMipmap]
	
		inc esi
		cmp esi, 128
		jl textRenderer_init_loop_start
	
	mov esp, ebp
	pop esi
	pop ebp
	ret
	
	
textRenderer_deinit:
	push ebp
	mov ebp, esp
	
	;delete textures
	push character_textures
	push 128
	call [glDeleteTextures]
	
	;delete shader
	push dword[shader]
	call shader_destroy
	add esp, 4
	
	;release vao and vbo
	push vao
	push 1
	call [glDeleteVertexArrays]
	push vbo
	push 1
	call [glDeleteBuffers]
	
	mov esp, ebp
	pop ebp
	ret
	
textRenderer_drawText:
	push ebp
	push esi
	push edi
	mov ebp, esp
	
	sub esp, 4			;ypos
	sub esp, 4			;xpos
	
	;set the uniform values
	push dword[shader]
	call [glUseProgram]
	
	push dword[font_size_y]
	push dword[font_size_x]
	push dword[uniform_scale_location]
	call [glUniform2f]
	
	push screen_matrix
	push dword[GL_TRUE]
	push 1
	push dword[uniform_pv_location]
	call [glUniformMatrix4fv]
	
	;calculate position TODO!!!!!!
	fild dword[ebp+24]
	fstp dword[ebp-8]
	fild dword[ebp+28]
	fstp dword[ebp-4]
	
	
	;prepare the texture and vertex array
	push dword[GL_TEXTURE0]
	call [glActiveTexture]
	
	push dword[vao]
	call [glBindVertexArray]
	
	
	;draw characters
	mov esi, dword[ebp+16]			;text in esi
	cmp byte[esi], 0
	je textRenderer_drawText_loop_end
	textRenderer_drawText_loop_start:
		;set texture
		xor eax, eax
		mov al, byte[esi]
		push dword[4*eax+character_textures]
		push dword[GL_TEXTURE_2D]
		call [glBindTexture]

		;set position		
		push dword[ebp-4]
		push dword[ebp-8]
		push dword[uniform_position_location]
		call [glUniform2f]
		
		
		;draw
		push 4
		push 0
		push dword[GL_TRIANGLE_FAN]
		call [glDrawArrays]
		
		;update position
		movss xmm0, dword[ebp-8]
		movss xmm1, dword[font_size_x]
		addss xmm0, xmm1
		movss xmm1, dword[ONE]
		addss xmm0, xmm1
		movss dword[ebp-8], xmm0
	
		;continue
		inc esi
		cmp byte[esi], 0
		jne textRenderer_drawText_loop_start
	textRenderer_drawText_loop_end:
	
	mov esp, ebp
	pop edi
	pop esi
	pop ebp
	ret
	
	
textRenderer_setScreenSize:
	push ebp
	mov ebp, esp
	
	sub esp, 4			;width float
	sub esp, 4			;height float
	
	fild dword[ebp+8]
	fstp dword[ebp-4]
	
	fild dword[ebp+12]
	fstp dword[ebp-8]
	
	push dword[ONE]
	push 0
	push dword[ebp-8]
	push 0
	push dword[ebp-4]
	push 0
	push screen_matrix
	call mat4_ortho
	
	mov esp, ebp
	pop ebp
	ret
	

textRenderer_setFontSize:
	push ebp
	mov ebp, esp
	
	mov eax, dword[ebp+8]
	mov dword[font_size_x_int], eax
	mov eax, dword[ebp+12]
	mov dword[font_size_y_int], eax
	
	fild dword[ebp+8]
	fstp dword[font_size_x]
	fild dword[ebp+12]
	fstp dword[font_size_y]
	
	mov esp, ebp
	pop ebp
	ret