global core
;rdi uint64_t n 
;rsi char const *p
extern get_value
extern put_value

section .data

align 8
value: times N dq N, 
number: times N dq N 

section .text
core:
mov r8, rsp
mov r9, rsi

loop:
    xor eax, eax
    mov al, [r9]
choice:
    cmp al, '+'
    je sum
    cmp al, '*'
    je product
    cmp al, '-'
    je negation
    cmp al, 'n'
    je push_core
    cmp al, 'B'
    je operation_B
    cmp al, 'C'
    je operation_C
    cmp al, 'D'
    je operation_D
    cmp al, 'E'
    je operation_E
    cmp al, 'G'
    je operation_G
    cmp al, 'P'
    je operation_P
    cmp al, 'S' 
    je operation_S
    cmp al, 0x3a
    jnb exit
    sub al, 0x30
    jnb push_value
    jmp exit
control:
    inc r9
    jmp loop
exit:
    mov rax, [rsp]
    mov rsp, r8
    ret
sum:
    pop rax
    add [rsp], rax
    jmp control
push_value:
    push rax
    jmp control
product:
    pop rax
    pop rcx
    imul rcx
    push rax 
    jmp control
negation:   
    neg QWORD [rsp]
    jmp control
push_core:
    push rdi
    jmp control
operation_B:
    pop rdx
    cmp QWORD [rsp], 0x0
    je control
    add r9, rdx
    jne control
operation_C:
    pop rax
    jmp control
operation_D:
    push QWORD [rsp]
    jmp control
operation_E:
    pop rax
    pop rcx
    push rax
    push rcx    
    jmp control
operation_G:
    mov rsi, rdi
    push rdi
    push r8
    push r9
    test rsp, 0xF
    jz aligned
not_aligned:
    sub rsp, 0x8
    call get_value
    add rsp, 0x8
    jmp finished
aligned:
    call get_value
finished:
    pop r9
    pop r8
    pop rdi
    push rax    
    jmp control
operation_P:
    pop rsi
    push rdi
    push r8
    push r9
    test rsp, 0xF
    jz aligned_P
    sub rsp, 0x8
    call put_value
    add rsp, 0x8
    jmp finished_P
aligned_P:
    call put_value
finished_P:
    pop r9
    pop r8
    pop rdi
    jmp control
operation_S:
    pop rax
    pop rcx
    mov rsi, rax
    lea rdx, [rel number] 
    lea r10, [rel value]
    xchg [r10 + 8*rdi], rcx
    xchg [rdx + 8*rdi], rsi
    cmp rdi, QWORD [rdx + 8*rax]
    jne wait_S
    push QWORD [r10 + 8*rax]
    mov QWORD [rdx + 8*rax], N
busy_wait:
    mov rcx, [rdx + 8*rdi]
    cmp rcx, N
    jne busy_wait
    jmp control
wait_S:
    cmp QWORD [rdx + 8*rdi], N
    jne wait_S
    push QWORD [r10 + 8*rax]
    mov QWORD [rdx + 8*rax], N
    jmp control


