[BITS 32]

;layout:
;struct player{
;	camera* cum;			0
;	vec3 position;			4
;	float pitch, yaw;		16
;}		24 bytes

section .text use32

	global player_init		;player* player_init(camera* cum)
	global player_destroy	;void player_destroy(player* player)
	global player_update 	;void player_update(player* player, float deltaTime)
	
	extern my_malloc
	extern my_free
	
player_init:
	push ebp
	mov ebp, esp
	
	sub esp, 4		;player*
	
	push 24
	call my_malloc
	mov dword[ebp-4], eax
	add esp, 4
	
	;initialize it
	mov ecx, dword[ebp+8]
	mov dword[eax], ecx
	
	mov dword[eax+4], 0
	mov dword[eax+8], 0
	mov dword[eax+12], 0
	mov dword[eax+16], 0
	mov dword[eax+20], 0
	
	mov esp, ebp
	pop ebp
	ret
	
	
player_destroy:
	push ebp
	mov ebp, esp
	
	push dword[ebp+8]
	call my_free
	
	mov esp, ebp
	pop ebp
	ret
	
	
player_update:
	push ebp
	mov ebp, esp
	
	mov esp, ebp
	pop ebp
	ret