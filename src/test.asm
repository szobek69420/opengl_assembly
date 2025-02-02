[BITS 32]

%macro dll_import 2
    import %2 %1
    extern %2
%endmacro

section .rodata use32
	print_new_line db 10,0
	print_int db "%d ",0

	sus db "sus",0
	mega db "mega",0
	
	write_mode db "w",0
	file_name db "sigma.gyatt",0
	
	format db "sugus %f %s",0
	format2 db "%d",0
	
	float_number dd -69.42
	
section .bss use32
	stdout resb 4			;HANDLE for the standard output 
	
	buffer resb 1000
	file resb 4
	
	pwindow resb 4		;GLFWwindow*
	
	hyperPlane resb 64
	hyperPlaneNormal resb 16
	hyperCube resb 80
	hyperCube_vertices resb 16
	hyperCube_indices resb 16
	
	renderable resb 56

section .text use32
	
	dll_import kernel32.dll, ExitProcess
	
	extern my_printf
	
	extern window_create
	extern window_destroy
	
	extern game_loop
	
	extern hyperPlane_create
	extern hyperPlane_getNormal
	extern hyperCube_create
	extern hyperCube_intersectWithPlane
	extern vec4_print
	extern vec3_print
	
	extern vector_init
	
	..start:
		push ebp
		mov ebp, esp
		
		finit
		
		;hyperplane test
		push hyperPlane
		call hyperPlane_create
		add esp, 4
		
		push hyperPlaneNormal
		push hyperPlane
		call hyperPlane_getNormal
		add esp, 8
		
		
		;hypercube test
		push 12
		push hyperCube_vertices
		call vector_init
		add esp, 8
		
		push 4
		push hyperCube_indices
		call vector_init
		add esp, 8
		
		push hyperCube
		call hyperCube_create
		add esp, 4
		
		push hyperCube_indices
		push hyperCube_vertices
		push hyperCube
		push hyperPlane
		call hyperCube_intersectWithPlane
		add esp, 16
		
		push esi		;save esi
		mov esi, dword[hyperCube_vertices]
		test_print_hc_vertices_loop_start:
			mov eax, hyperCube_vertices
			mov eax, dword[eax+12]
			mov ecx, esi
			dec ecx
			imul ecx, 12
			add eax, ecx
			push eax
			call vec3_print
			add esp, 4
			
			dec esi
			test esi, esi
			jnz test_print_hc_vertices_loop_start
		pop esi			;restore esi
		
		push esi		;save esi
		mov esi, dword[hyperCube_indices]
		test_print_hc_indices_loop_start:
			mov eax, hyperCube_indices
			mov eax, dword[eax+12]
			lea eax, [eax+4*esi-4]
			push dword[eax]
			push print_int
			call my_printf
			add esp, 8
			
			dec esi
			test esi, esi
			jnz test_print_hc_indices_loop_start
		push print_new_line
		call my_printf
		add esp, 4
		pop esi			;restore esi
		
		;create window and opengl context
		push sus
		call window_create
		mov dword[pwindow], eax
		add esp, 4
		
		cmp dword[pwindow], 0
		jne window_creation_successful
			jmp start_end
		window_creation_successful:
		
		;game loop
		push dword[pwindow]
		call game_loop
		add esp, 4
		
		
		;destroy window and opengl context
		push dword[pwindow]
		call window_destroy
		add esp, 4
		
		
		start_end:
		mov esp, ebp
		pop ebp
		
		push 0
		call [ExitProcess]