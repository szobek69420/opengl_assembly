[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

section .rodata use32
	ZERO dd 0.0
	ONE dd 1.0
	ONE_PER_THOUSAND dd 0.001
	P15 dd 0.15
	P6 dd 0.6
	
	test_text db "HOLODO MORBIUS",0
	print_int db "%d",10,0
	print_two_ints db "%d %d",10,0
	print_float db "%f",0
	print_new_line db 10,0
	
section .bss use32
	pkuba resb 4
	
	camera resb 36
	pv_matrix resb 64
	
	pplayer resb 4
	
	helper resb 4
	
	hyperPlane resb 64
	hyperCube resb 104
	hyperCube_vertices resb 16
	hyperCube_indices resb 16
	hyperCube_renderable resb 4
	
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
	extern glFrontFace
	
	extern GL_DEPTH_TEST
	extern GL_COLOR_BUFFER_BIT
	extern GL_DEPTH_BUFFER_BIT
	extern GL_CULL_FACE
	extern GL_CCW
	extern GL_POINTS

	
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
	
	extern renderable_init
	extern renderable_deinit
	extern renderable_render
	extern renderable_create
	extern renderable_destroy
	extern renderable_setPrimitive
	extern RENDERABLE_ATTRIB_P3C3

	extern hyperPlane_create
	extern hyperCube_create
	extern hyperCube_intersectWithPlane
	extern hyperCube_update
	
	extern vector_init
	extern vector_destroy
	extern vector_clear
	
	extern vec3_print
	
	extern textRenderer_init
	extern textRenderer_deinit
	extern textRenderer_setScreenSize
	extern textRenderer_drawText
	extern TEXT_ALIGN_BOTTOM_LEFT
	
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
	
	
	;init camera
	push camera
	call camera_init
	add esp, 4
	
	;init renderable
	call renderable_init
	
	;init text renderer
	call textRenderer_init
	push 1000
	push 1000
	call textRenderer_setScreenSize
	add esp, 8
	
	;create player
	push camera
	call player_init
	mov dword[pplayer], eax
	add esp, 4
	
	;construct hypercube cross section
	push hyperPlane
	call hyperPlane_create
	add esp, 4
	
	push hyperCube
	call hyperCube_create
	add esp, 4
	
	push 4		;vector<float>
	push hyperCube_vertices
	call vector_init
	add esp, 8
	push 4		;vector<int>
	push hyperCube_indices
	call vector_init
	add esp, 8
	
	mov dword[hyperCube_renderable], 0
	
	
	push esi		;save esi
	push edi		;save edi
	mov esi, dword[hyperCube_vertices]
	mov edi, hyperCube_vertices
	mov edi, dword[edi+12]
	sugus2:
		push edi
		;call vec3_print
		add esp, 4
		
		lea eax, [edi+12]
		push eax
		;call vec3_print
		add esp, 4
		
		push print_new_line
		;call my_printf
		add esp, 4
		
		add edi, 24
		sub esi, 6
		test esi, esi
		jnz sugus2
	pop edi			;restore edi
	pop esi			;restore esi
	
	
	;enable depth test and face cull
	push dword[GL_DEPTH_TEST]
	call [glEnable]
	
	push dword[GL_CCW]
	call [glFrontFace]
	push dword[GL_CULL_FACE]
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
		
		
		;update the hyperkuba
		push dword[delta_time_seconds]
		push hyperCube
		call hyperCube_update
		add esp, 8
		
		call game_loop_update_hyperCube_renderable
	
	
		;set clear color
		push dword[ONE]
		push dword[P6]
		push dword[ZERO]
		push dword[P15]
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
		push 0
		push pv_matrix
		push dword[hyperCube_renderable]
		call renderable_render
		add esp, 12
		
		;draw text
		push 400
		push 400
		push dword[TEXT_ALIGN_BOTTOM_LEFT]
		push test_text
		call textRenderer_drawText
		add esp, 16
		
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
		
		
	;destroy hypercube renderable and the vectors
	push dword[hyperCube_renderable]
	call renderable_destroy
	add esp, 4
	
	push hyperCube_vertices
	call vector_destroy
	add esp, 4
	push hyperCube_indices
	call vector_destroy
	add esp, 4
	
	;destroy player
	push dword[pplayer]
	call player_destroy
	add esp, 4
	
	;deinit text renderer
	call textRenderer_deinit
	
	;deinit renderable
	call renderable_deinit
	
	mov esp, ebp
	pop ebp
	ret
	
	
game_loop_update_hyperCube_renderable:
	push ebp
	mov ebp, esp
	
	;delete the previous renderable if necessary
	cmp dword[hyperCube_renderable], 0
	je gluhcr_skip_delete
		push dword[hyperCube_renderable]
		call renderable_destroy
		add esp, 4
	gluhcr_skip_delete:
	
	
	push hyperCube_vertices
	call vector_clear
	push hyperCube_indices
	call vector_clear
	add esp, 8
	
	
	;construct the new renderable
	push hyperCube_indices
	push hyperCube_vertices
	push hyperCube
	push hyperPlane
	call hyperCube_intersectWithPlane
	add esp, 16
	
	push dword[RENDERABLE_ATTRIB_P3C3]
	push hyperCube_indices
	push hyperCube_vertices
	call renderable_create
	mov dword[hyperCube_renderable], eax
	add esp, 12
	
	mov esp, ebp
	pop ebp
	ret
