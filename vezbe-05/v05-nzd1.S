# nzd kao potprogram, varijanta 1
# Imenko Prezimić ra1234

#potprogram za računanje nzd
.section .data
a:  .long 123
b:  .long 456
r:  .long 0

.section .text
.globl main

#int nzd(int a, int b)
nzd:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx  

    movl 8(%ebp),%eax
    movl 12(%ebp),%ebx
nzd_uporedi:
    cmpl %ebx,%eax
    je nzd_kraj
    ja nzd_vece
    subl %eax,%ebx
    jmp nzd_uporedi
nzd_vece:
    subl %ebx,%eax
    jmp nzd_uporedi

nzd_kraj:
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

main:
    pushl b
    pushl a
    call nzd
    addl $8, %esp
    movl %eax, r

kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

