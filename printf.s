.intel_syntax noprefix
.global itoa
.global atoi
.global _start
_start:
mov rcx, [rsp]
cmp rcx, 1
je error



mov r13, rsp
add r13, 16
mov rdi, [r13]
mov r15, [r13]
mov rcx, 0

mov r12, r13
add r12, 8
sub rsp, 128
mov rsi, rsp
mov r14, rsi
loop:           
cmp byte ptr [r15+rcx], 0x0
je write 


cmp byte ptr [r15+rcx], '\\'
jne percent_case
inc rcx
cmp byte ptr [r15+rcx], 'n'
je newline

cmp byte ptr [r15+rcx], 'x'
je decode_hex

cmp byte ptr [r15+rcx], '\\'
je black_slash

percent_case:
cmp byte ptr [r15+rcx], '%'
jne continu
inc rcx
cmp byte ptr [r15+rcx], '%'
je percent

cmp byte ptr [r15+rcx], 'd'
je digit_case

cmp byte ptr [r15+rcx], 's'
je string_case

sub rcx, 1
continu:
mov al, [r15+rcx]
mov [rsi], al
inc rcx
inc rsi
jmp loop


decode_hex:

first:
inc rcx
mov al, [r15+rcx]
cmp al, 'f'
ja not_hex
cmp al, 'a'
jae small_case
cmp al, 'F'
ja not_hex
cmp al, 'A'
jae big_case
cmp al, '9'
ja not_hex
cmp al, '0'
jb not_hex
sub al,0x30
inc rcx

second:
mov dil, [r15+rcx]
cmp dil, 'f'
ja not_hex
cmp dil, 'a'
jae small_case2
cmp dil, 'F'
ja not_hex
cmp dil, 'A'
jae big_case2
cmp dil, '9'
ja not_hex
cmp dil, '0'
jb not_hex
sub dil,0x30
store:
shl al, 4
or al, dil
mov [rsi], al
inc rsi
inc rcx
jmp loop

small_case:
sub al, 'a'
add al, 10
inc rcx
jmp second

big_case:
sub al, 'A'
add al, 10
inc rcx
jmp second


small_case2:
sub dil, 'a'
add dil, 10
jmp store

big_case2:
sub dil, 'A'
add dil, 10
jmp store




not_hex:
inc rcx
jmp loop




string_case:
mov rdi, [r12]
loop_s:
mov al, byte ptr [rdi]
cmp al, 0x0
jne insert
add r12, 8
inc rcx
jmp loop
insert:
mov [rsi], al
inc rsi
inc rdi
jmp loop_s


digit_case:
mov rdi, [r12] 
call atoi
mov rdi, rax
call itoa
add rsi, rax
inc rcx
add r12, 8
jmp loop


newline:
mov al, 0x0a
mov [rsi], al
inc rcx
inc rsi
jmp loop

percent:
mov al, '%'
mov [rsi], al
inc rsi
inc rcx
jmp loop



black_slash:
mov al, '\\'
mov [rsi], al
inc rsi
inc rcx
jmp loop




write:
mov rdx,rsi
sub rdx, r14
mov rdi, 1
mov rsi, r14
mov rax, 1
syscall 

exit:
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
mov r11, rsi
cmp rdi, 0
jge loop3
mov byte ptr [r11], '-'

inc r11
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
mov [r11+r9], dl
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
mov r11, rsi
mov byte ptr [r11], '0'
ret
