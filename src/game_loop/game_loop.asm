[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

section .rodata use32
	ZERO dd 0.0
	ONE dd 1.0

section .text use32

	dll_import glfw3.dll, glfwSwapBuffers
	dll_import glfw3.dll, glfwPollEvents
	dll_import glfw3.dll, glfwWindowShouldClose
	
	
	global game_loop		;void game_loop(GLFWwindow* pwindow)
	
	extern glClear
	extern glClearColor
	
	extern GL_COLOR_BUFFER_BIT
	
game_loop:
	push ebp
	mov ebp, esp
	
	sub esp, 4			;pwindow
	
	;save pwindow
	mov eax, dword[ebp+8]
	mov dword[ebp-4], eax
	
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
		
		;swap buffers
		push dword[ebp-4]
		call [glfwSwapBuffers]
		
		;poll events
		call [glfwPollEvents]
		
		;check if the window is closed or not
		push dword[ebp-4]
		call [glfwWindowShouldClose]
		test eax, eax
		je game_loop_loop_start
	
	mov esp, ebp
	pop ebp
	ret