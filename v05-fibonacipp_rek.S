# Potprogram za rekurzivno računanje fibonačijevih brojeva
# Imenko Prezimić ra1234

.section .text
.globl fibonaci
#int fibonaci(int n)
fibonaci:
    pushl %ebp
    movl %esp, %ebp
    cmpl $2, 8(%ebp)    # f(1) = f(2) = 1
    jbe fib_1

    movl 8(%ebp), %eax  # f(n-1)
    decl %eax
    pushl %eax
    call fibonaci
    addl $4, %esp
    pushl %eax          # izračunata vrednost se čuva na steku

    movl 8(%ebp), %eax  # f(n-2)
    subl $2, %eax
    pushl %eax
    call fibonaci
    addl $4, %esp
    popl %ecx           # sačuvana vrednost za f(n-1)
    addl %ecx, %eax
    jmp fib_kraj
fib_1:
    movl $1,%eax
fib_kraj:
    movl %ebp, %esp
    popl %ebp
    ret

# Za vežbu, dopuniti potprogram još jednim parametrom:
# int fibonaci(int n, int *g)
# u kome će se nalaziti 0 ako je računanje prošlo kako treba,
# odnosno 1 ako je došlo do greške (prekoračenja)
