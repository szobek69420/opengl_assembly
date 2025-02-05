[BITS 32]

;layout
;struct HyperCube{
;	vec4 position;			0
;	mat4 otherTransforms;	16
;}		overall 80 bytes

;side order: +z, -x, -z, +x, +y, -y, +w, -w
section .rodata use32
	EPSILON dd 0.000001
	ZERO dd 0.0
	ONE dd 1.0

	edgeIndices:
	dd 0,1, 1,2, 2,3, 3,0, 4,5, 5,6, 6,7, 7,4, 0,4, 1,5, 2,6, 3,7
	edgeIndexCount dd 24
	
	print_int db "%d",10,0
	print_new_line db 10,0
	
	cellColours:
	dd 1.0,1.0,1.0
	dd 1.0,0.0,0.0
	dd 0.0,1.0,0.0
	dd 0.0,0.0,1.0
	dd 1.0,1.0,0.0
	dd 1.0,0.0,1.0
	dd 0.0,1.0,1.0
	dd 0.0,0.0,0.0
	
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
	global hyperCube_intersectWithPlane		;void hyperCube_iwp(HyperPlane* plane, HyperCube* pcube, vector<float>* vertexBuffer, vector<int>* indexBuffer)
	
	extern my_memcpy
	extern my_memset_dword
	
	extern my_printf
	
	extern vec3_add
	extern vec3_sub
	extern vec3_scale
	extern vec3_dot
	extern vec3_cross
	extern vec3_print
	
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
	
	sub esp, 64		;translated plane											-64
	sub esp, 16		;normalizedPlaneNormal										-80
	
	sub esp, 12		;center of the shape in 3D									-92
	sub esp, 12		;triangle[1]-triangle[0]									-104
	sub esp, 12		;triangle[2]-triangle[0]									-116
	sub esp, 12		;(triangle[1]-triangle[0]) x (triangle[2]-triangle[0])		-128
	sub esp, 12		;triangle[0]-center											-140
	sub esp, 4		; <triangle[0]-center; (triangle[1]-triangle[0]) x (triangle[2]-triangle[0])>	-144
	
	
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
	hyperCube_intersectWithPlane_loop_start:
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
		jnz hyperCube_intersectWithPlane_loop_start
	
	;calculate the (non-weighted) center of the shape
	mov dword[ebp-92], 0
	mov dword[ebp-88], 0
	mov dword[ebp-84], 0
	
	
	mov esi, dword[ebp+20]
	mov esi, dword[esi]			;vertex float count in esi
	test esi, esi
	jz hyperCube_intersectWithPlane_end
	push edi		;save edi
	mov edi, dword[ebp+20]
	mov edi, dword[edi+12]		;vertices in edi
	
	hyperCube_intersectWithPlane_center_loop_start:
		lea eax, [ebp-92]
		push edi
		push eax
		push eax
		call vec3_add
		add esp, 12
		
		add edi, 24			;24 bytes/vertex attrib
		sub esi, 6
		cmp esi, 0
		jg hyperCube_intersectWithPlane_center_loop_start
	pop edi			;restore edi
	
	mov eax, dword[ebp+20]
	mov eax, dword[eax]
	xor edx, edx
	mov ecx, 6
	div ecx
	
	push eax
	fld1
	fild dword[esp]
	fdivp
	fstp dword[esp]
	lea eax, [ebp-92]
	push eax
	push eax
	call vec3_scale
	add esp, 12
	
	;flip the triangles that are facing towards the center
	push ebx		;save ebx
	push edi		;save edi
	mov ebx, dword[ebp+20]
	mov ebx, dword[ebx+12]		;vertices in ebx
	
	mov esi, dword[ebp+24]
	mov edi, dword[esi+12]		;indices in edi
	mov esi, dword[esi]			;index count in esi
	hyperCube_intersectWithPlane_flip_loop_start:
		lea eax, [ebp-92]
		push eax		;center
	
		mov eax, dword[edi]
		imul eax, 24
		add eax, ebx
		push eax		;triangle[0]
		
		lea eax, [ebp-140]
		push eax
		call vec3_sub
		add esp, 4		;triangle[0] and center stay on the stack
		
		mov eax, dword[edi+4]
		imul eax, 24
		add eax, ebx
		push eax		;triangle[1]
	
		lea eax, [ebp-104]
		push eax
		call vec3_sub
		add esp, 8		;triangle[0] and center stay on the stack
		
		
		mov eax, dword[edi+8]
		imul eax, 24
		add eax, ebx
		push eax		;triangle[2]
		
		lea eax, [ebp-116]
		push eax
		call vec3_sub
		add esp, 16
		
		lea eax, [ebp-116]
		push eax
		lea eax, [ebp-104]
		push eax
		lea eax, [ebp-128]
		push eax
		call vec3_cross
		add esp, 12
		
		lea eax, [ebp-128]
		push eax
		lea eax, [ebp-140]
		push eax
		call vec3_dot
		fstp dword[ebp-144]
		add esp, 8
		
		;flip the face if necessary
		mov eax, dword[ebp-144]
		and eax, 0x80000000
		test eax, eax
		jz hyperCube_intersectWithPlane_flip_loop_continue
			mov eax, dword[edi]
			mov ecx, dword[edi+4]
			mov dword[edi], ecx
			mov dword[edi+4], eax
			
		hyperCube_intersectWithPlane_flip_loop_continue:
		add edi, 12
		sub esi, 3
		cmp esi, 0
		jg hyperCube_intersectWithPlane_flip_loop_start
		
	pop edi			;restore edi
	pop ebx			;restore ebx
	
	hyperCube_intersectWithPlane_end:
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
;	vector<float>* vertices, 
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
	
	sub esp, 16		;helper1 (edge[0]-planePoint)								-152
	sub esp, 16		;helper2 (edge[1]-planePoint)								-168
	sub esp, 4		;helper3 ( <edge[0]-planePoint; normalizedPlaneNormal> )	-172
	sub esp, 4		;helper4 ( <edge[1]-planePoint; normalizedPlaneNormal> )	-176
	sub esp, 4		;helper5 ( |helper1| / (|helper1| + |helper2|) )			-180
	
	sub esp, 16		;helper6 ( intersection point in 4D)						-196
	sub esp, 12		;helper7 ( intersection point 3D projection )				-208
	
	sub esp, 12		;cell colour												-220
	
	mov eax, dword[ebp+32]
	mov eax, dword[eax]
	xor edx, edx
	mov ecx, 6			;6 floats per vertex
	div ecx
	mov dword[ebp-4], eax
	
	mov dword[ebp-8], 0
	
	;get cell colour
	mov eax, dword[ebp+24]
	imul eax, 12
	add eax, cellColours
	
	mov ecx, dword[eax]
	mov dword[ebp-220], ecx
	mov ecx, dword[eax+4]
	mov dword[ebp-216], ecx
	mov ecx, dword[eax+8]
	mov dword[ebp-212], ecx
	
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
		push dword[ebp+16]		;plane point
		mov eax, dword[edi]
		shl eax, 4
		lea eax, [eax+ebp-136]
		push eax				;edge[0]
		lea eax, [ebp-152]
		push eax				;helper1
		call vec4_sub
		
		push dword[ebp+28]		;plane normal
		call vec4_dot
		fstp dword[ebp-172]		;helper3
		add esp, 16
		
		
		push dword[ebp+16]		;plane point
		mov eax, dword[edi+4]
		shl eax, 4
		lea eax, [eax+ebp-136]
		push eax				;edge[1]
		lea eax, [ebp-168]
		push eax				;helper2
		call vec4_sub
		
		push dword[ebp+28]		;plane normal
		call vec4_dot
		fstp dword[ebp-176]		;helper4
		add esp, 16
		
		
		
		;if the sign of helper3 and helper4 is the same, then the point is not on the plane
		mov eax, dword[ebp-176]	;helper4
		and eax, 0x80000000
		mov ecx, dword[ebp-172]	;helper3
		and ecx, 0x80000000
		xor eax, ecx
		test eax, eax
		jz hyperCube_cellIntersection_intersect_loop_continue
		
		;remove the signs of helper3 and helper4
		and dword[ebp-172], 0x7fffffff		;|helper3|
		and dword[ebp-176], 0x7fffffff		;|helper4|
		
		;is edge[1]-edge[0] too short?
		movss xmm0, dword[ebp-172]
		movss xmm1, dword[ebp-176]
		
		movss xmm2, xmm1
		addss xmm2, xmm0
		
		ucomiss xmm2, dword[EPSILON]
		jbe hyperCube_cellIntersection_intersect_loop_continue
			;calculate helper5 (we already have |helper1|+|helper2| in xmm2 here
			movss xmm3, xmm0		;helper3 in xmm3
			divss xmm3, xmm2
			movss dword[ebp-180], xmm3
		
			;calculate the 3d projection of the point and add it to the vector			
			mov eax, dword[edi]
			shl eax, 4
			lea eax, [eax+ebp-136]
			push eax				;edge[0]
			mov eax, dword[edi+4]
			shl eax, 4
			lea eax, [eax+ebp-136]
			push eax				;edge[1]
			lea ecx, [ebp-196]
			push ecx				;helper6
			call vec4_sub
		
			
			push dword[ebp-180]		;helper5
			lea ecx, [ebp-196]
			push ecx
			push ecx
			call vec4_scale
			
			add esp, 20			;leave edge[0] on the stack
			
			lea ecx, [ebp-196]
			push ecx
			push ecx
			call vec4_add
			add esp, 12
		
		
			lea ecx, [ebp-196]
			push ecx			;helper6
			mov eax, dword[ebp+16]
			add eax, 16			;hyperplane direction 1
			push eax
			call vec4_dot
			fstp dword[ebp-208]
			add esp, 4
			mov eax, dword[ebp+16]
			add eax, 32			;hyperplane direction 2
			push eax
			call vec4_dot
			fstp dword[ebp-204]
			add esp, 4
			mov eax, dword[ebp+16]
			add eax, 48			;hyperplane direction 3
			push eax
			call vec4_dot
			fstp dword[ebp-200]
			add esp, 8
			
			
			inc dword[ebp-8]		;increment index count
			
			;add vertex position
			push dword[ebp-208]
			push dword[ebp+32]		;vertices
			call vector_push_back
			mov eax, dword[ebp-204]
			mov dword[esp+4], eax
			call vector_push_back
			mov eax, dword[ebp-200]
			mov dword[esp+4], eax
			call vector_push_back
			add esp, 8
			
			;add vertex colour
			push dword[ebp-220]
			push dword[ebp+32]		;vertices
			call vector_push_back
			mov eax, dword[ebp-216]
			mov dword[esp+4], eax
			call vector_push_back
			mov eax, dword[ebp-212]
			mov dword[esp+4], eax
			call vector_push_back
			add esp, 8
			
		hyperCube_cellIntersection_intersect_loop_continue:
		add edi, 8
		sub esi, 2
		test esi, esi
		jnz hyperCube_cellIntersection_intersect_loop_start
		
	;sort the vertex values so that the are in the correct order to form a polygon
		
		
	
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
		add eax, dword[ebp-4]
		push eax
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
		
		dec esi
		test esi, esi
		jnz hyperCube_cellIntersect_indices_loop_start
		
	jmp hyperCube_cellIntersect_end
		
	hyperCube_cellIntersect_remove_added_vertices:
		mov esi, dword[ebp-8]		;index count in esi
		imul esi, 6					;6 floats per vertex attrib
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
	