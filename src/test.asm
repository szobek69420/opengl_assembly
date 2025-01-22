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

section .text use32

	dll_import user32.dll, MessageBoxA
	
	dll_import kernel32.dll, GetStdHandle
	dll_import kernel32.dll, WriteFile
	
	dll_import glfw3.dll, glfwInit
	dll_import glfw3.dll, glfwTerminate
	
	extern my_strlen
	extern my_strcat
	extern my_sprintf
	
	..start:
		push ebp
		mov ebp, esp
		
		finit
		
		;push 0
		;push messagebox_title
		;push messagebox_text
		;push 0
		;call [MessageBoxA]
		
		call get_stdout_handle
		
		;call [glfwInit]
		;cmp eax, 0
		;je start_end
		
		
		;call [glfwTerminate]
		
		push mega
		push dword[float_number]
		push format
		push buffer
		call my_sprintf
		add esp, 16
		
		push sus
		push buffer
		call my_strcat
		add esp, 8
		
		push buffer
		call print_string
		add esp, 4
		
		start_end:
		mov esp, ebp
		pop ebp
		ret
		
		
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