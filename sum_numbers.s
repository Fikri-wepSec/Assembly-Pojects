.intel_syntax noprefix 
.global _start
.global atoi 
.global itoa 
_start: 
mov rcx, [rsp]
cmp rcx, 1
jle no_arg
mov r13, rsp  
add r13, 16 
mov rbx, 1 
mov r8, 0 
                                                                   
loop:                                                             
mov rdi, [r13] 
call atoi 
add r8, rax  
add r13, 8     
inc rbx
cmp rbx, rcx 
jl loop
mov rdi, r8  
sub rsp, 32
mov rsi, rsp
call itoa

mov rdi, 1
mov rsi, rsp
mov rdx, rax
mov rax, 1
syscall
jmp end
no_arg:
mov rdi, 0
sub rsp, 32
mov rsi, rsp
call itoa
mov rdi, 1
mov rsi, rsp
mov rdx, rax
mov rax, 1
syscall
end:
mov rdi, 0
mov rax, 60
syscall 

atoi:
push rcx
mov rcx, 0
mov r11, 0
movzx rax, byte ptr [rdi]
cmp rax, '-'
jne loop2
mov r11, 1
inc rdi
loop2:
movzx rax, byte ptr [rdi]
sub rax, 0x30
cmp rax, 9               
ja finsh
imul rcx, 10
add rcx, rax
inc rdi
jmp loop2
finsh:
mov rax, rcx
cmp r11, 1
jne done
neg rax
done:
pop rcx
mov r11, 0
ret





itoa:
push rbx
mov r8, 0
mov rax, rdi
cmp rax, 0
je zero
mov rbx, 10
mov r10, 0
cmp rdi, 0
jge loop3
mov byte ptr [rsi], '-'

inc rsi
mov r8,1
neg rax
loop3:
xor rdx,rdx  
div rbx       
add rdx, 0x30    
push rdx       
inc r10
cmp rax, 0
jne loop3
mov r9, 0
loop4:
pop rdx
mov [rsi+r9], dl
inc r9
cmp r9, r10
jl loop4
mov rax, r10
cmp r8, 1
jne done2
inc rax
done2:
pop rbx
ret

zero:
pop rbx
mov rax,1
mov byte ptr [rsi], '0'
ret
