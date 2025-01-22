[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

GLFW_CONTEXT_VERSION_MAJOR equ 0x00022002
GLFW_CONTEXT_VERSION_MINOR equ 0x00022003
GLFW_OPENGL_PROFILE equ 0x00022008
GLFW_OPENGL_CORE_PROFILE equ 0x00032001

section .text use32
	global window_create			;GLFWwindow* window_create(const char* name)
	
	
window_create:
	push ebp
	mov ebp, esp
	
	
	
	mov esp, ebp
	pop ebp
	ret