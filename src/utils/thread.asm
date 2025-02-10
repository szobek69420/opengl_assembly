[BITS 32]

;layout
;struct Thread{
;	void* threadHandle;
;	int threadID;
;}			8 bytes overall

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro


CREATE_SUSPENDED equ 0x00000004
CREATE_NOT_SUSPENDED equ 0
WAIT_INFINITE equ 0xffffffff

section .text use32

	global thread_create			;Thread* thread_create(void* functionAddress, void* params, int startImmediately)
	
	;returns 0 if there were no problems
	global thread_destroy			;int thread_destroy(Thread* thread)
	
	;returns 0 if there were no problems (not zero on timeout)
	;if the waiting was successful, thread_destroy is also called
	;waitMilliseconds is -1 if the waiting time is unlimited
	global thread_join				;int thread_join(Thread* thread, int waitMilliseconds)
	
	
	dll_import kernel32.dll, CreateThread
	dll_import kernel32.dll, CloseHandle
	dll_import kernel32.dll, WaitForSingleObject
	
	extern my_malloc
	extern my_free
	
	extern my_printf
	
thread_create:
	push ebp
	mov ebp, esp
	
	sub esp, 4			;Thread*
	
	;alloc thread
	push 8
	call my_malloc
	mov dword[ebp-4], eax
	add esp, 4
	test eax, eax
	jz thread_create_end
	
	;create thread
	mov eax, dword[ebp-4]
	add eax, 4
	push eax			;&threadID
	push CREATE_NOT_SUSPENDED
	mov eax, dword[ebp+16]
	test eax, eax
	jnz thread_start_immediately
		mov dword[esp], CREATE_SUSPENDED
	thread_start_immediately:
	push dword[ebp+12]		;params
	push dword[ebp+8]		;start address
	push 0					;default stack size
	push 0					;default security attributes
	call [CreateThread]
	mov ecx, dword[ebp-4]
	mov dword[ecx], eax		;save handle
	
	test eax, eax
	jnz thread_create_successful
		push dword[ebp-4]
		call my_free
		xor eax, eax
		jmp thread_create_end
		
	thread_create_successful:
	
	mov eax, dword[ebp-4]		;set return value
	
	thread_create_end:
	mov esp, ebp
	pop ebp
	ret
	
	
thread_destroy:
	push ebp
	mov ebp, esp
	
	
	mov eax, dword[ebp+8]
	push dword[eax]
	call [CloseHandle]
	
	;check if it was successful
	test eax, eax
	jnz thread_destroy_successful
		mov eax, 69
		jmp thread_destroy_end
	thread_destroy_successful:
	
	push dword[ebp+8]
	call my_free
	xor eax, eax
	
	thread_destroy_end:
	mov esp, ebp
	pop ebp
	ret
	
	
thread_join:
	push ebp
	mov ebp, esp
	
	push WAIT_INFINITE
	mov eax, dword[ebp+12]
	cmp eax, -1
	je thread_join_wait_infinite
		mov dword[esp], eax
	thread_join_wait_infinite:
	
	mov eax, dword[ebp+8]
	push dword[eax]
	
	call [WaitForSingleObject]
	
	;check if the waiting was successful
	test eax, eax
	jz thread_join_wait_successful
		mov eax, 69
		jmp thread_join_end
		
	thread_join_wait_successful:
	
	
	push dword[ebp+8]
	call thread_destroy
	
	thread_join_end:
	mov esp, ebp
	pop ebp
	ret
