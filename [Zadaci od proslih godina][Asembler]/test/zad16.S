.section .data
poruka1: .ascii "Unesite proizvoljnu recenicu: \0"
por1_len=.-poruka1

MAX=100
prijem: .fill MAX,1,42

duzina: .long 0

brojac: .long 0

poruka2: .ascii "Broj ponavljanja reci 'test' u unetoj recenici je: \0"
por2_len=.-poruka2


.section .text
.globl main


main:

    movl $4, %eax                           #ispis na ekran
    movl $1, %ebx
    leal poruka1, %ecx
    movl $por1_len, %edx
    int $0x80
    
    movl $3,%eax                            #prijem stringa sa tastature
    movl $0,%ebx
    leal prijem,%ecx
    movl $MAX,%edx
    int $0x80
    
    movl %eax,duzina
    
    leal prijem,%esi                        #pokazivac na nas string koji smo primili
    
#prvo sve prebaciti u velika slova zbog lakse provere posle
#ukoliko je space,zanemariti i ici do sledeceg karaktera

upcase:                                     #prebacujemo sve u velika
   cmpb $'a',(%esi)
   jb nijeMalo
   cmpb $'z',(%esi)
   ja nijeMalo
   
   subb $32,(%esi)                          #ako je u pitanju malo slovo prebacimo ga u veliko
        
nijeMalo:
    incl %esi
                                            #provera da li smo dosli do kraja stringa
    movl duzina,%edx
    addl $prijem,%edx                       #adresa poslednjeg elementa
    cmpl %edx,%esi
    jl upcase


    leal prijem,%esi
    leal prijem,%edi                        #pomocni pokazivac
poredjenje:
    cmpb $'T',(%esi)                        
    jne nije 
    
    movl %esi,%edi                          #pomocni pokazivac
slovoE:
    incl %edi
    cmpb $'E',(%edi)
    jne nijeE
slovoS:
    incl %edi
    cmpb $'S',(%edi)
    jne nijeS
slovoT:
    incl %edi
    cmpb $'T',(%edi)
    jne nijeT
    
jeste:
    incl brojac
    movl %edi,%esi
    
nije:
    incl %esi 
    jmp proveraKraja   
    #incl %edi
    
    
nijeE:
    cmpb $' ',(%edi)                        #u slucaju da je spejs njega zelimo zanemariti
    je slovoE
    jmp proveraKraja
nijeS:
    cmpb $' ',(%edi)
    je slovoS
    jmp proveraKraja
nijeT:
    cmpb $' ',(%edi)
    je slovoT
    jmp proveraKraja
    
proveraKraja:
    movl duzina,%edx
    addl $prijem,%edx
    cmpl %edx,%esi
    jl poredjenje

    #ISPISIVANJE NA EKRAN KOLIKO SE PUTA PONOVILA REC TEST U PROGRAMU
    movl $4,%eax
    movl $1,%ebx
    leal poruka2,%ecx
    movl $por2_len,%edx
    int $0x80
    
    addl $48,brojac                         #kako bi se na ekranu ispisao lepo stringovnobroj
    
    movl $4,%eax
    movl $1,%ebx
    leal brojac,%ecx
    movl $1,%edx
    int $0x80
    
        
kraj:
    movl $1,%eax
    movl $0,%ebx
    int $0x80

#Korisnik unese recenicu,treba proveriti koliko ima reci 'TEST' u prosledjenoj recenici i to ispisati na ekran.

#Primer: Testiraju test t12 i tako .
#Ocekivani izlaz:
#U unetoj recenici reci 'test' ima : 2
