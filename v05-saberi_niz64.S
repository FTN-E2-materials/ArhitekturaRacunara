# Potprogram za sumiranje elemenata dva 64-bitna niza
# Imenko Prezimić ra1234

.section .text
.globl saberi_niz

#int saberi_niz(long long *a, long long *b, long long *c, int n);
saberi_niz:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp       #lokalna promenljiva, za grešku
    pushl %ebx
    pushl %esi
    movl 8(%ebp), %eax
    movl 12(%ebp), %ebx
    movl 16(%ebp), %ecx
    movl 20(%ebp), %edx
    decl %edx           #kreće se od poslednjeg elementa
    movl $0, -4(%ebp)   #greška = 0

sniz_petlja:
    movl (%eax, %edx, 8), %esi  #niži delovi
    addl (%ebx, %edx, 8), %esi
    movl %esi, (%ecx, %edx, 8)
    movl 4(%eax, %edx, 8), %esi #viši delovi
    adcl 4(%ebx, %edx, 8), %esi
    movl %esi, 4(%ecx, %edx, 8)
    jo sniz_greska
    decl %edx                   #prethodni element
    jns sniz_petlja
    jmp sniz_kraj

sniz_greska:
    incl -4(%ebp)

sniz_kraj:
    movl -4(%ebp), %eax         #greška u eax
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

