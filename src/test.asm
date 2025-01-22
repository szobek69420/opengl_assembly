[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

section .rodata use32
	sus db "sus",0
	mega db "mega",0
	
	format db "sugus %f %s",0
	
	float_number dd -69.42
	
section .bss use32
	stdout resb 4			;HANDLE for the standard output 
	
	buffer resb 1000
	
	pwindow resb 4		;GLFWwindow*

section .text use32

	dll_import user32.dll, MessageBoxA
	
	dll_import kernel32.dll, GetStdHandle
	dll_import kernel32.dll, WriteFile
	
	dll_import kernel32.dll, ExitProcess
	
	dll_import glfw3.dll, glfwInit
	dll_import glfw3.dll, glfwTerminate
	
	extern my_strlen
	extern my_strcat
	extern my_sprintf
	
	extern window_create
	extern window_destroy
	
	..start:
		push ebp
		mov ebp, esp
		
		finit
		
		call get_stdout_handle
		
		push sus
		call window_create
		mov dword[pwindow], eax
		add esp, 4
		
		cmp dword[pwindow], 0
		jne window_creation_successful
			jmp start_end
		window_creation_successful:
		
		
		push dword[pwindow]
		call window_destroy
		add esp, 4
		
		
		push mega
		push dword[float_number]
		push format
		push buffer
		;call my_sprintf
		add esp, 16
		
		push sus
		push buffer
		;call my_strcat
		add esp, 8
		
		push buffer
		;call print_string
		add esp, 4
		
		start_end:
		mov esp, ebp
		pop ebp
		
		push 0
		call [ExitProcess]
		
		
	get_stdout_handle:		;void get_stdout_handle(void)
		push ebp
		mov ebp, esp
		
		push -11			;stdout
		call [GetStdHandle]
		mov dword[stdout], eax
		
		mov esp, ebp
		pop ebp
		ret
		
	print_string:			;void print_string(const char* str)
		push ebp
		mov ebp, esp
		
		push dword[ebp+8]
		call my_strlen
		add esp, 4
		
		;print
		push 0
		push 0
		push eax
		push dword[ebp+8]
		push dword[stdout]
		call [WriteFile]
		
		mov esp, ebp
		pop ebp
		ret