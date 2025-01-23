[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

GLFW_CONTEXT_VERSION_MAJOR equ 0x00022002
GLFW_CONTEXT_VERSION_MINOR equ 0x00022003
GLFW_OPENGL_PROFILE equ 0x00022008
GLFW_OPENGL_CORE_PROFILE equ 0x00032001

section .rodata use32
	window_could_not_be_created db "window could not be created",10,0

section .text use32
	global window_create			;GLFWwindow* window_create(const char* name)
	global window_destroy			;void window_destroy(GLFWwindow* pwindow)
	
	dll_import glfw3.dll, glfwInit
	dll_import glfw3.dll, glfwTerminate
	
	dll_import glfw3.dll, glfwWindowHint
	
	dll_import glfw3.dll, glfwCreateWindow
	dll_import glfw3.dll, glfwDestroyWindow
	
	dll_import glfw3.dll, glfwMakeContextCurrent
	
	dll_import glfw3.dll, glfwSwapInterval
	
	dll_import glfw3.dll, glfwGetProcAddress
	
	extern load_gl_functions
	extern glViewport
	
window_create:
	push ebp
	mov ebp, esp
	
	sub esp, 4		;created GLFWwindow*
	
	call [glfwInit]
	
	push 3
	push GLFW_CONTEXT_VERSION_MAJOR
	call [glfwWindowHint]
	
	push 3
	push GLFW_CONTEXT_VERSION_MINOR
	call [glfwWindowHint]
	
	push GLFW_OPENGL_CORE_PROFILE
	push GLFW_OPENGL_PROFILE
	call [glfwWindowHint]
	
	;create window
	push 0
	push 0
	push dword[ebp+8]
	push 420
	push 420
	call [glfwCreateWindow]
	mov dword[ebp-4], eax
	cmp eax, 0
	jne window_create_no_gebasz
		call [glfwTerminate]
		mov eax, 0
		
		mov esp, ebp
		pop ebp
		ret
	window_create_no_gebasz:
	
	;set the current context to this thread
	push dword[ebp-4]
	call [glfwMakeContextCurrent]
	
	;swap as fast as possible
	push 0
	call [glfwSwapInterval]
	
	;load the opengl functions
	push dword[glfwGetProcAddress]
	call load_gl_functions
	add esp, 4
	
	test eax, eax
	jne window_create_load_functions_no_gebasz
		push dword[ebp-4]
		call [glfwDestroyWindow]
		
		call [glfwTerminate]
		mov eax, 0
		
		mov esp, ebp
		pop ebp
		ret
	window_create_load_functions_no_gebasz:
	
	
	;set the viewport size
	push 420
	push 420
	push 0
	push 0
	call [glViewport]
	
	
	mov eax, dword[ebp-4]
	
	mov esp, ebp
	pop ebp
	ret
	

window_destroy:
	push ebp
	mov ebp, esp
	
	push dword[ebp+8]
	call [glfwDestroyWindow]
	
	call [glfwTerminate]
	
	mov esp, ebp
	pop ebp
	ret