[BITS 32]

;layout
;struct HyperCube{
;	vec4 position;			0
;	mat4 otherTransforms;	16
;}		overall 80 bytes

;side order: +z, -x, -z, +x, +y, -y, +w, -w
section .rodata use32
	ZERO dd 0.0
	ONE dd 1.0

	edgeIndices:
	dd 0,1, 1,2, 2,3, 3,0, 4,5, 5,6, 6,7, 7,4, 0,4, 1,5, 2,6, 3,7
	edgeIndexCount dd 24
	
	print_int db "%d",10,0
	
	;vec4 pos, vec2 uv
	cell0:	;+z
	dd -0.5,-0.5,0.5,0.5,	0.0,0.0,
	dd -0.5,0.5,0.5,0.5,	0.0,1.0,
	dd 0.5,0.5,0.5,0.5,		1.0,1.0,
	dd 0.5,-0.5,0.5,0.5,	1.0,0.0,
	dd -0.5,-0.5,0.5,-0.5,	0.0,0.0,
	dd -0.5,0.5,0.5,-0.5,	0.0,1.0,
	dd 0.5,0.5,0.5,-0.5,	1.0,1.0,
	dd 0.5,-0.5,0.5,-0.5,	1.0,0.0
	
	cell1:	;-x
	dd -0.5,-0.5,-0.5,0.5,	0.0,0.0,
	dd -0.5,0.5,-0.5,0.5,	0.0,1.0,
	dd -0.5,0.5,0.5,0.5,	1.0,1.0,
	dd -0.5,-0.5,0.5,0.5,	1.0,0.0,
	dd -0.5,-0.5,-0.5,-0.5,	0.0,0.0,
	dd -0.5,0.5,-0.5,-0.5,	0.0,1.0,
	dd -0.5,0.5,0.5,-0.5,	1.0,1.0,
	dd -0.5,-0.5,0.5,-0.5,	1.0,0.0
	
	cell2:	;-z
	dd 0.5,-0.5,-0.5,0.5,	0.0,0.0,
	dd 0.5,0.5,-0.5,0.5,	0.0,1.0,
	dd -0.5,0.5,-0.5,0.5,	1.0,1.0,
	dd -0.5,-0.5,-0.5,0.5,	1.0,0.0,
	dd 0.5,-0.5,-0.5,-0.5,	0.0,0.0,
	dd 0.5,0.5,-0.5,-0.5,	0.0,1.0,
	dd -0.5,0.5,-0.5,-0.5,	1.0,1.0,
	dd -0.5,-0.5,-0.5,-0.5,	1.0,0.0
	
	cell3:	;+x
	dd 0.5,-0.5,0.5,0.5,	0.0,0.0,
	dd 0.5,0.5,0.5,0.5,		0.0,1.0,
	dd 0.5,0.5,-0.5,0.5,	1.0,1.0,
	dd 0.5,-0.5,-0.5,0.5,	1.0,0.0,
	dd 0.5,-0.5,0.5,-0.5,	0.0,0.0,
	dd 0.5,0.5,0.5,-0.5,	0.0,1.0,
	dd 0.5,0.5,-0.5,-0.5,	1.0,1.0,
	dd 0.5,-0.5,-0.5,-0.5,	1.0,0.0
	
	cell4:	;+y
	dd -0.5,0.5,0.5,0.5,	0.0,0.0,
	dd -0.5,0.5,-0.5,0.5,	0.0,1.0,
	dd 0.5,0.5,-0.5,0.5,	1.0,1.0,
	dd 0.5,0.5,0.5,0.5,		1.0,0.0,
	dd -0.5,0.5,0.5,-0.5,	0.0,0.0,
	dd -0.5,0.5,-0.5,-0.5,	0.0,1.0,
	dd 0.5,0.5,-0.5,-0.5,	1.0,1.0,
	dd 0.5,0.5,0.5,-0.5,	1.0,0.0,
	
	cell5:	;-y
	dd -0.5,-0.5,-0.5,0.5,	0.0,0.0,
	dd -0.5,-0.5,0.5,0.5,	0.0,1.0,
	dd 0.5,-0.5,0.5,0.5,	1.0,1.0,
	dd 0.5,-0.5,-0.5,0.5,	1.0,0.0,
	dd -0.5,-0.5,-0.5,-0.5,	0.0,0.0,
	dd -0.5,-0.5,0.5,-0.5,	0.0,1.0,
	dd 0.5,-0.5,0.5,-0.5,	1.0,1.0,
	dd 0.5,-0.5,-0.5,-0.5,	1.0,0.0
	
	cell6:	;+w
	dd -0.5,-0.5,0.5,0.5,	0.0,0.0,
	dd -0.5,0.5,0.5,0.5,	0.0,1.0,
	dd 0.5,0.5,0.5,0.5,		1.0,1.0,
	dd 0.5,-0.5,0.5,0.5,	1.0,0.0,
	dd -0.5,-0.5,-0.5,0.5,	0.0,0.0,
	dd -0.5,0.5,-0.5,0.5,	0.0,1.0,
	dd 0.5,0.5,-0.5,0.5,	1.0,1.0,
	dd 0.5,-0.5,-0.5,0.5,	1.0,0.0
	
	cell7:	;-w
	dd -0.5,-0.5,0.5,-0.5,	0.0,0.0,
	dd -0.5,0.5,0.5,-0.5,	0.0,1.0,
	dd 0.5,0.5,0.5,-0.5,	1.0,1.0,
	dd 0.5,-0.5,0.5,-0.5,	1.0,0.0,
	dd -0.5,-0.5,-0.5,-0.5,	0.0,0.0,
	dd -0.5,0.5,-0.5,-0.5,	0.0,1.0,
	dd 0.5,0.5,-0.5,-0.5,	1.0,1.0,
	dd 0.5,-0.5,-0.5,-0.5,	1.0,0.0
	
section .text use32

	global hyperCube_create		;void hyperCube_create(HyperCube* buffer)
	global hyperCube_intersectWithPlane		;void hyperCube_iwp(HyperPlane* plane, HyperCube* pcube, vector<vec3>* vertexBuffer, vector<int>* indexBuffer)
	
	extern my_memcpy
	extern my_memset_dword
	
	extern my_printf
	
	extern vec4_add
	extern vec4_sub
	extern vec4_dot
	extern vec4_scale
	extern vec4_mulWithMat
	extern vec4_magnitude
	extern vec4_normalize
	extern vec4_print
	
	extern vector_init
	extern vector_destroy
	extern vector_push_back
	extern vector_pop_back
	
	extern hyperPlane_getNormal
	
hyperCube_create:
	push ebp
	mov ebp, esp
	

	push 80
	push 0
	push dword[ebp+8]
	call my_memset_dword
	add esp, 12
	
	
	mov eax, dword[ebp+8]
	mov ecx, dword[ONE]
	mov dword[eax+16], ecx
	mov dword[eax+36], ecx
	mov dword[eax+56], ecx
	mov dword[eax+76], ecx
	
	mov esp, ebp
	pop ebp
	ret
	

hyperCube_intersectWithPlane:
	push ebp
	push esi
	mov ebp, esp
	
	sub esp, 64		;translated plane
	sub esp, 16		;normalizedPlaneNormal
	
	;translate plane
	lea eax, [ebp-64]
	push 64
	push dword[ebp+12]
	push eax
	call my_memcpy
	add esp, 12
	
	lea eax, [ebp-16]		;&plane.point
	mov ecx, dword[ebp+16]		;&cube.position in ecx
	push ecx
	push eax
	push eax
	call vec4_sub
	add esp, 12
	
	;get normalized normal
	lea eax, [ebp-64]
	lea ecx, [ebp-80]
	push ecx
	push eax
	call hyperPlane_getNormal
	add esp, 8
	
	lea ecx, [ebp-80]
	push ecx
	call vec4_normalize
	add esp, 4
	
	;calculate intersection points
	mov esi, 8		;number of cells
	hyperPlane_intersectWithPlane_loop_start:
		push dword[ebp+24]		;index buffer
		push dword[ebp+20]		;vertex buffer
		lea eax, [ebp-80]
		push eax		;normalized normal
		lea eax, [esi-1]
		push eax		;cell index
		push dword[ebp+16]		;kuba
		lea eax, [ebp-64]
		push eax				;translated plane
		call hyperCube_cellIntersection
		add esp, 24
		
		dec esi
		test esi, esi
		jnz hyperPlane_intersectWithPlane_loop_start
	
	mov esp, ebp
	pop esi
	pop ebp
	ret
	
	
;helper function for hyperCube_intersectWithPlane
;void hyperCube_cellIntersection(
;	HyperPlane* pTranslatedPlane, 
;	HyperCube* pcube, 
;	int cellIndex, 
;	vec4* normalizedPlaneNormal, 
;	vector<vec3>* vertices, 
;	vector<int>* indices
;)
;vertex and index buffers should be at least 6 elements long
hyperCube_cellIntersection:
	push ebp
	push esi
	push edi
	mov ebp, esp
	
	sub esp, 4		;current vertex count										-4
	sub esp, 4		;number of added vertices									-8
	mov dword[esp], 0
	
	sub esp, 128	;scaled and rotated cell vertices							-136
	
	sub esp, 16		;helper (edge[1]-edge[0])									-152
	sub esp, 16		;helper2 (planePoint-edge[0])								-168
	sub esp, 4		;helper3 ( |edge[1]-edge[0]| )								-172
	sub esp, 4		;helper4 ( <edge[1]-edge[0]; normalizedPlaneNormal> )		-176
	sub esp, 4		;helper5 ( <planePoint-edge[0]; normalizedPlaneNormal> )	-180
	
	sub esp, 16		;helper6 ( intersection point in 4D)						-196
	sub esp, 12		;helper7 ( intersection point 3D projection )				-208
	
	mov eax, dword[ebp+32]
	mov eax, dword[eax]
	mov dword[ebp-4], eax
	
	mov dword[ebp-8], 0
	
	;copy the vertex data
	lea eax, [ebp-136]
	mov ecx, dword[ebp+24]		;cell index
	imul ecx, 192
	add ecx, cell0		;cell data in ecx
	mov edx, 8
	hyperCube_cellIntersection_copy_loop_start:
		push edx		;save edx
		push 16
		push ecx
		push eax
		call my_memcpy
		pop eax		;restore eax
		pop ecx		;restore ecx
		add esp, 4
		pop edx		;restore edx
		
		add eax, 16
		add ecx, 24
		dec edx
		test edx, edx
		jnz hyperCube_cellIntersection_copy_loop_start
		
	;apply transforms on cell vertices
	lea eax, [ebp-136]
	mov ecx, dword[ebp+20]
	lea ecx, [ecx+16]		;address of the transform matrix
	mov edx, 8
	
	push ecx
	push eax
	hyperCube_cellIntersection_transform_loop_start:
		call vec4_mulWithMat
		
		add dword[esp], 16
		dec edx
		test edx, edx
		jnz hyperCube_cellIntersection_transform_loop_start
	add esp, 8
	
	;search for intersection with the edges
	mov esi, dword[edgeIndexCount]		;index count left
	mov edi, edgeIndices				;current index
	
	hyperCube_cellIntersection_intersect_loop_start:
		mov eax, dword[edi]
		shl eax, 4
		lea eax, [eax+ebp-136]
		push eax
		
		mov eax, dword[edi+4]
		shl eax, 4
		lea eax, [eax+ebp-136]
		push eax
		
		lea eax, [ebp-152]		;helper1
		push eax
		call vec4_sub
		
		call vec4_magnitude
		fstp dword[ebp-172]		;helper3
		
		push dword[ebp+28]		;normalizedPlaneNormal
		call vec4_dot
		fstp dword[ebp-176]		;helper4
		
		add esp, 12		;&edge[0] is left on the stack
		
		push dword[ebp+16]		;plane point
		lea eax, [ebp-168]		;helper2
		push eax
		call vec4_sub
		
		push dword[ebp+28]		;normalizedPlaneNormal
		call vec4_dot
		fstp dword[ebp-180]		;helper5
		add esp, 16
		
		
		;if the sign of helper4 and helper5 differs, the point is definitely not on the plane
		mov eax, dword[ebp-180]	;helper5
		and eax, 0x80000000
		mov ecx, dword[ebp-176]	;helper4
		and ecx, 0x80000000
		xor eax, ecx
		test eax, eax
		jnz hyperCube_cellIntersection_intersect_loop_continue
		
		
		;if |helper4| >=|helper5|, then the point is not on the line either
		mov eax, dword[ebp-180]
		and eax, 0x80000000
		cmp ecx, eax
		jge hyperCube_cellIntersection_intersect_loop_continue
			;calculate the 3d projection of the point and add it to the vector
			
			mov dword[ebp-176], ecx		;|helper4|
			mov dword[ebp-180], eax		;|helper5|
			
			movss xmm0, dword[ebp-176]
			movss xmm1, dword[ebp-180]
			divss xmm0, xmm1
			
			lea ecx, [ebp-196]
			sub esp, 4
			movss dword[esp], xmm0
			lea eax, [ebp-152]		;helper1
			push eax
			push ecx				;helper6
			call vec4_scale
			pop ecx		;restore ecx
			
			mov eax, dword[edi]
			shl eax, 4
			lea eax, [eax+ebp-136]
			push eax		;edge[0]
			push ecx
			push ecx
			call vec4_add
			
			mov eax, dword[ebp+16]
			add eax, 16		;hyperplane direction 1
			push eax
			call vec4_dot
			fstp dword[ebp-208]
			add dword[esp], 16
			call vec4_dot
			fstp dword[ebp-204]
			add dword[esp], 16
			call vec4_dot
			fstp dword[ebp-200]
			
			add esp, 36
			
			
			inc dword[ebp-8]		;increment index count
			
			push dword[ebp-200]
			push dword[ebp-204]
			push dword[ebp-208]
			push dword[ebp+32]		;vertices
			call vector_push_back
			add esp, 16
			
			
		hyperCube_cellIntersection_intersect_loop_continue:
		add edi, 8
		sub esi, 2
		test esi, esi
		jnz hyperCube_cellIntersection_intersect_loop_start
		
		
	
	;check if the index count is valid
	mov eax, dword[ebp-8]
	cmp eax, 3
	jl hyperCube_cellIntersect_remove_added_vertices
	cmp eax, 6
	jg hyperCube_cellIntersect_remove_added_vertices
	
	;add indices (NOT FINAL!!!!)
	mov esi, dword[ebp-8]
	sub esi, 2					;triangle count in esi
	hyperCube_cellIntersect_indices_loop_start:
		push dword[ebp-4]
		push dword[ebp+36]
		call vector_push_back
		add esp, 8
		
		mov eax, esi
		add eax, 1
		add eax, dword[ebp-4]
		push eax
		push dword[ebp+36]
		call vector_push_back
		add esp, 8
	
		mov eax, esi
		add eax, 2
		add eax, dword[ebp-4]
		push eax
		push dword[ebp+36]
		call vector_push_back
		add esp, 8
		
		dec esi
		test esi, esi
		jnz hyperCube_cellIntersect_indices_loop_start
		
	jmp hyperCube_cellIntersect_end
		
	hyperCube_cellIntersect_remove_added_vertices:
		mov esi, dword[ebp-8]		;index count in esi
		test esi, esi
		jz hyperCube_cellIntersect_end
		hyperCube_cellIntersect_remove_vertices_loop_start:
			push dword[ebp+32]
			call vector_pop_back
			add esp, 8
			dec esi
			test esi, esi
			jnz hyperCube_cellIntersect_remove_vertices_loop_start
	
	hyperCube_cellIntersect_end:
	mov esp, ebp
	pop edi
	pop esi
	pop ebp
	ret
	