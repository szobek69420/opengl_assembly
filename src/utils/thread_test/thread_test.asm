[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

section .rodata use32
	message1 db "sugus1",10,0
	message2 db "sugus2",10,0
	
section .bss use32
	thread resb 4
	
section .text use32
	
	dll_import kernel32.dll, ExitProcess
	
	extern my_printf
	extern thread_create
	extern thread_join
	
	..start:
		push ebp
		mov ebp, esp
		
		finit
		
		;init thread
		push 69		;start immediately
		push 0
		push test_thread_func1
		call thread_create
		mov dword[thread], eax
		add esp, 12
		
		
		push message1
		call my_printf
		add esp, 4
		
		push -1
		push dword[thread]
		call thread_join
		add esp, 8
		
		push message1
		call my_printf
		add esp, 4
		
		
		start_end:
		mov esp, ebp
		pop ebp
		
		push 0
		call [ExitProcess]
		
		
	test_thread_func1:
		push ebp
		mov ebp, esp
		
		push message2
		call my_printf
		add esp, 4
		
		mov esp, ebp
		pop ebp
		ret