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
	
	extern my_memset_dword
	
	extern vec4_mulWithMat
	
	extern vector_push_back
	
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
	mov ebp, esp
	
	
	
	mov esp, ebp
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
	
	sub esp, 4		;current vertex count
	sub esp, 4		;number of added vertices
	
	sub esp, 128	;scaled and rotated cell vertices
	
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
	add ecx, [ecx+16]		;address of the transform matrix
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
		
	
	mov esp, ebp
	pop edi
	pop esi
	pop ebp
	ret
	