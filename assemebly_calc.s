.intel_syntax noprefix 
.global _start
.global atoi 
.global itoa 
_start: 
mov rcx, [rsp]
cmp rcx, 4
jg error

mov r13,rsp
cmp rcx, 4
jl oprator

mov r13,rsp


mov rcx, [rsp+24]
cmp byte ptr [rcx], '+'
je valid

cmp byte ptr [rcx], '-'
je valid

cmp byte ptr [rcx], '*'
je valid

cmp byte ptr [rcx], '^'
je valid

cmp byte ptr [rcx], '|'
je valid

cmp byte ptr [rcx], '&'
je valid
jmp error

valid:
add r13, 16
mov rdi, [r13]
call atoi
mov r12, rax
mov rdi, [r13+16]
call atoi
cmp byte ptr [rcx], '+'
je addition
cmp byte ptr [rcx], '-'
je substraction

cmp byte ptr [rcx], '*'
je multi

cmp byte ptr [rcx], '^'
je xor_num

cmp byte ptr [rcx], '|'
je or_num

cmp byte ptr [rcx], '&'
je and_num

addition: 
add r12, rax
jmp con
substraction:
sub r12, rax
jmp con

multi:
imul r12, rax
jmp con

xor_num:
xor r12, rax
jmp con

or_num:
or r12, rax
jmp con

and_num:
and r12, rax
jmp con

oprator:
mov rcx, [rsp+16]
cmp byte ptr [rcx], '-'
je valid2

cmp byte ptr [rcx], '~'
je valid2

jmp error
valid2:
mov rdi, [r13+24]
call atoi
mov r12, rax

cmp byte ptr [rcx], '-'
je neg_case

cmp byte ptr [rcx], '~'
je not_case

neg_case:
neg r12
jmp con
not_case:
not r12
jmp con
con:
mov rdi, r12
sub rsp, 32
mov rsi, rsp
call itoa
jmp write

write:
mov rdi, 1
mov rsi, rsp
mov rdx, rax
mov rax, 1
syscall
mov rdi, 0
mov rax, 60
syscall 
error:
mov rdi, 1
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
