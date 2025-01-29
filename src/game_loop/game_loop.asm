[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

section .rodata use32
	ZERO dd 0.0
	ONE dd 1.0
	ONE_PER_THOUSAND dd 0.001
	
	vertex_shader_file db "shaders/sigma.vag",0
	fragment_shader_file db "shaders/sigma.fag",0
	
	test_text db "skibidi lidl",10,0
	print_int db "%d",10,0
	print_two_ints db "%d %d",10,0
	
section .bss use32
	kuba resb 12
	kuba_shader resb 4
	
	camera resb 36
	pv_matrix resb 64
	
	pplayer resb 4
	
	helper resb 4
	
section .data use32
	last_frame_milliseconds dd 0		;int, the GetTickCount of the last frame
	delta_time_milliseconds dd 0		;int
	delta_time_seconds dd 0.0			;float

section .text use32

	dll_import kernel32.dll, GetTickCount
	
	
	global game_loop		;void game_loop(GLFWwindow* pwindow)
	
	extern glClear
	extern glClearColor
	extern glEnable
	
	extern GL_DEPTH_TEST
	extern GL_COLOR_BUFFER_BIT
	extern GL_DEPTH_BUFFER_BIT
	
	extern shader_import
	
	extern kuba_create
	extern kuba_destroy
	extern kuba_render
	
	extern camera_init
	extern camera_viewProjection
	
	extern my_printf
	
	extern glfwSwapBuffers
	extern glfwPollEvents
	extern glfwWindowShouldClose
	extern glfwSetWindowShouldClose
	extern glfwSetKeyCallback
	extern glfwSetMouseButtonCallback
	extern glfwSetCursorPosCallback
	extern glfwSetScrollCallback
	extern glfwSetInputMode
	extern GLFW_CURSOR
	extern GLFW_CURSOR_DISABLED
	extern GLFW_KEY_ESCAPE
	
	extern input_init
	extern input_update
	extern input_keyReleased
	extern input_setMousePosition
	extern input_keyCallback
	extern input_mouseButtonCallback
	extern input_mouseMoveCallback
	extern input_mouseScrollCallback
	
	extern player_init
	extern player_destroy
	extern player_update
	
game_loop:
	push ebp
	mov ebp, esp
	
	sub esp, 4			;pwindow
	
	;save pwindow
	mov eax, dword[ebp+8]
	mov dword[ebp-4], eax
	
	;init input and set callbacks
	call input_init
	mov dword[helper], esp
	
	push input_keyCallback
	push dword[ebp-4]
	call [glfwSetKeyCallback]
	add esp, 8
	
	push input_mouseButtonCallback
	push dword[ebp-4]
	call [glfwSetMouseButtonCallback]
	add esp, 8
	
	push input_mouseMoveCallback
	push dword[ebp-4]
	call [glfwSetCursorPosCallback]
	add esp, 8
	
	push input_mouseScrollCallback
	push dword[ebp-4]
	call [glfwSetScrollCallback]
	add esp, 8
	
	;hide cursor
	push dword[GLFW_CURSOR_DISABLED]
	push dword[GLFW_CURSOR]
	push dword[ebp-4]
	call [glfwSetInputMode]
	add esp, 12
	
	
	;compile shader
	push 0
	push fragment_shader_file
	push vertex_shader_file
	call shader_import
	mov dword[kuba_shader], eax
	add esp, 12
	
	
	;init camera
	push camera
	call camera_init
	add esp, 4
	
	;create player
	push camera
	call player_init
	mov dword[pplayer], eax
	add esp, 4
	
	
	;create kuba
	push kuba
	call kuba_create
	add esp, 4
	
	;enable depth test
	push dword[GL_DEPTH_TEST]
	call [glEnable]
	
	;init last frame time
	call [GetTickCount]
	mov dword[last_frame_milliseconds], eax
	
	;the actual game loop
	game_loop_loop_start:
		
		;calculate delta time
		call [GetTickCount]
		mov ecx, dword[last_frame_milliseconds]
		
		mov dword[last_frame_milliseconds], eax
		sub eax, ecx
		mov dword[delta_time_milliseconds], eax
		
		fild dword[delta_time_milliseconds]
		fld dword[ONE_PER_THOUSAND]
		fmulp
		fstp dword[delta_time_seconds]
		
		
		;player
		push dword[delta_time_seconds]
		push dword[pplayer]
		call player_update
		add esp, 8
	
	
		;set clear color
		push dword[ONE]
		push dword[ONE]
		push dword[ZERO]
		push dword[ZERO]
		call [glClearColor]
		
		
		;clear color and depth buffer bit
		mov eax, dword[GL_COLOR_BUFFER_BIT]
		or eax, dword[GL_DEPTH_BUFFER_BIT]
		push eax
		call [glClear]
		
		;get camera pv matrix
		push pv_matrix
		push camera
		call camera_viewProjection
		add esp, 8
		
		;render kuba
		push pv_matrix
		push dword[kuba_shader]
		push kuba
		call kuba_render
		add esp, 12
		
		;swap buffers
		push dword[ebp-4]
		call [glfwSwapBuffers]
		add esp, 4
		
		;poll events and update input
		call [glfwPollEvents]
		call input_update

		;check if the user is trying to escape
		push dword[GLFW_KEY_ESCAPE]
		call input_keyReleased
		add esp, 4
		test eax, eax
		jz game_loop_loop_no_escape
			push 69
			push dword[ebp-4]
			call [glfwSetWindowShouldClose]
			add esp, 8
		game_loop_loop_no_escape:
		
		;check if the window is closed or not
		push dword[ebp-4]
		call [glfwWindowShouldClose]
		add esp, 4
		test eax, eax
		jz game_loop_loop_start
		
		
	;destroy kuba
	push kuba
	call kuba_destroy
	add esp, 4
	
	;destroy player
	push dword[pplayer]
	call player_destroy
	add esp, 4
	
	mov esp, ebp
	pop ebp
	ret