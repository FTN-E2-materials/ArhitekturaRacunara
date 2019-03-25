.section .data
MAX=100
poruka: .fill 100,1,42
duzina: .long 0                         #posle cemo ovde posle unosa sa tastature
                                        #zadrzaj registra eax staviti u duzinu
                                        #posle unosa u eax je duzina unetog stringa !!!
poruka2: .ascii "Unesite string : \0"
por2_len= .-poruka2

poruka3: .ascii "Uneli ste vise elemenata nego sto je dozvoljeno ! \n"
por3_len=.-poruka3
not_alphanum:   .byte 0

.section .text
.globl main
main:
    

    movl $4,%eax                        #kod za ispis
    movl $1,%ebx
    leal poruka2,%ecx
    movl $por2_len,%edx                 #mora $ jer je por2_len konstanta ustvari
    int $0x80
    
    
    movl $3,%eax                        #kod za prijem stringa
    movl $0,%ebx
    leal poruka,%ecx
    movl $MAX,%edx
    int $0x80
    
	cmpl $MAX,%eax
	jae greska                          #ako se unese vise nego sto je dozvoljeno->kraj
    
    movl %eax,duzina                    #posle unosa u eax je duzina unetog stringa !!
                    
    movl $poruka,%esi                   #esi cemo iskoristiti kao pokazivac na nas niz
#ideja:
#proci kroz citav niz stringova
#ako je veci od 48 ( nula ) ide dalje1 - ako nije=> alfanumerik je u pitanju
#ako je manji od 57(devetka) ide dalje2
#ako je veci od 65(A) ide dalje3
#ako je manji od 90(Z) ide dalje4
#ako je veci od 97(a) ide dalje5
#ako je manji od 122(z) ide dalje6
#kad dodje do dalje6 onda znaci da je okej i da je on alfanumerik i ne treba da ga menja
#posle dalje6 ide na sledeci_el_niza

    
   
pocetak:                                #prvo provera opsega brojeva 0-9
    #treba proveriti kad je kraj
    cmpb $10,(%esi)                     #10 jer je to kod za kraj tj enter
    je ispis
    
    cmpb $48,(%esi)
    jae dalje1
    jmp alfanumerik
    
dalje1:
    cmpb $57,(%esi)
    jle nije_alfanumerik



dalje2:                                 #provera opsega A-Z
    cmpb $65,(%esi)
    jae dalje3                          #ako nije znad 65 => izmedju 57 i 65 je=>alfanumerik
    jmp alfanumerik
    
dalje3:
    cmpb $90,(%esi)
    jle nije_alfanumerik                #u opsegu 65-90 je [A-Z]=> nije alfanumerik
    
    
    
dalje4:                                 #provera opsega 97-122[a-z]
    cmpb $97,(%esi)
    jae dalje5
    jmp alfanumerik                     #nije iznad 97 a iznad 90 je => alfanumerik
dalje5:
    cmpb $122,(%esi)
    jle nije_alfanumerik
    jmp alfanumerik
    
nije_alfanumerik:                       #nije potrebno da ga promenimo 
    jmp sledeci_el_niza
alfanumerik:                            #treba ga promeniti posto je alfanumerik
    movb $0,(%esi)
    incb not_alphanum
sledeci_el_niza:
    incl %esi
    jmp pocetak
    
ispis:
    movl $4,%eax
    movl $1,%ebx
    leal poruka,%ecx
    movl duzina,%edx
    int $0x80
    jmp kraj
   
greska:
    movl $4,%eax
    movl $1,%ebx
    leal poruka3,%ecx
    movl $por3_len,%edx
    int $0x80
    
kraj:
    movl $1, %eax
    movl not_alphanum, %ebx             #bez $ jer on ide samo za konstante
                                        #u ebx je izlazni kod
    int $0x80

#Napraviti program koji traži unos stringa str1 (maks dužine 100 bajtova) i nalazi koliko znakova u unetom stringu nisu alfanumerici (nisu ni slovo i nisu cifra). Svaki od tih znakova zameniti znakom ‘0’ (nula) i ispisati tako dobijeni string, a broj zamenjenih karaktera postaviti u 8-bitnu promenljivu not_alphanum i vratiti ga ao izlazni kod programa.
