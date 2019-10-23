# nzd kao potprogram, varijanta 2
# Imenko Prezimić ra1234

#potprogram za računanje nzd
.section .data
a:  .long 123
b:  .long 456
r:  .long 0

.section .text
.globl main

#void nzd(int a, int b, int *rez)
nzd:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp),%eax
    movl 12(%ebp),%ecx
nzd_uporedi:
    cmpl %ecx,%eax
    je nzd_kraj
    ja nzd_vece
    subl %eax,%ecx
    jmp nzd_uporedi
nzd_vece:
    subl %ecx,%eax
    jmp nzd_uporedi

nzd_kraj:
    movl 16(%ebp), %ecx
    movl %eax, (%ecx)
    movl %ebp, %esp
    popl %ebp
    ret

main:
    pushl $r
    pushl b
    pushl a
    call nzd
    addl $12, %esp

kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

