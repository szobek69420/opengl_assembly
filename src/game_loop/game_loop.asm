[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

section .rodata use32
	ZERO dd 0.0
	ONE dd 1.0
	
	vertex_shader_file db "shaders/sigma.vag",0
	fragment_shader_file db "shaders/sigma.fag",0
	
	print_int db "%d",10,0
	
section .bss use32
	kuba resb 12
	kuba_shader resb 4
	
	camera resb 36
	pv_matrix resb 64

section .text use32

	dll_import glfw3.dll, glfwSwapBuffers
	dll_import glfw3.dll, glfwPollEvents
	dll_import glfw3.dll, glfwWindowShouldClose
	
	
	global game_loop		;void game_loop(GLFWwindow* pwindow)
	
	extern glClear
	extern glClearColor
	
	extern GL_COLOR_BUFFER_BIT
	
	extern shader_import
	
	extern kuba_create
	extern kuba_destroy
	extern kuba_render
	
	extern camera_init
	extern camera_viewProjection
	
	extern my_printf
	
game_loop:
	push ebp
	mov ebp, esp
	
	sub esp, 4			;pwindow
	
	;save pwindow
	mov eax, dword[ebp+8]
	mov dword[ebp-4], eax
	
	;compile shader
	push 0
	push fragment_shader_file
	push vertex_shader_file
	call shader_import
	mov dword[kuba_shader], eax
	add esp, 12
	
	
	;create kuba
	push kuba
	call kuba_create
	add esp, 4
	
	;init camera
	push camera
	call camera_init
	add esp, 4
	
	;the actual game loop
	game_loop_loop_start:
	
		;set clear color
		push dword[ONE]
		push dword[ONE]
		push dword[ZERO]
		push dword[ZERO]
		call [glClearColor]
		
		;clear color buffer bit
		push dword[GL_COLOR_BUFFER_BIT]
		call [glClear]
		
		;get camera pv matrix
		push pv_matrix
		push camera
		call camera_viewProjection
		add esp, 8
		
		;render kuba
		push 0
		push dword[kuba_shader]
		push kuba
		call kuba_render
		add esp, 12
		
		;swap buffers
		push dword[ebp-4]
		call [glfwSwapBuffers]
		
		;poll events
		call [glfwPollEvents]
		
		;check if the window is closed or not
		push dword[ebp-4]
		call [glfwWindowShouldClose]
		test eax, eax
		jz game_loop_loop_start
		
		
	;destroy kuba
	push kuba
	call kuba_destroy
	add esp, 4
	
	mov esp, ebp
	pop ebp
	ret