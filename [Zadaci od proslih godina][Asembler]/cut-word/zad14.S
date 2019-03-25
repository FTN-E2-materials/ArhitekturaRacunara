.section .data
poruka1: .ascii "Unesite proizvoljnu recenicu: \0"
por1_len=.-poruka1

MAX=100
prijem: .fill MAX,1,42

duzina: .long 0
brojacIzmenjenih: .long 0			        #brojac za ukupan broj izmenjenih reci

greska: .long 0                             #indikator za prekoracenje
brojacSlova: .long 0

pocetak: .long 0                            #promenljiva koja oznacava pocetak reci
.section .text

.globl main
main:
    movl $0,greska                          #inicijalizacija indikatora


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
    #provera unos
    cmpl $94,%eax
    jae prekoracenje                        #ako je u eax >= od 94,prekoracen unos
    
    
                          
    leal prijem,%edi                        #pokazivac na nas string koji smo primili
    movl $0,brojacSlova
#ideja:
#nadjemo kraj reci(spejs iskljucivo!)
#potom ako je broj slova veci od 5 idemo od kraja te reci ka pocetak+5
#i tako dobijamo interval [pocetakReci,krajReci] i onda taj interval popunjavamo sa spejsom

krajReci:

    cmpb $' ',(%edi)
    jne sledeceSlovo
    #NADJEN KRAJ RECI
    cmpl $5,brojacSlova                     #ako je broj slova u reci 5 ili manje,ides na  
    jle sledecaRec2                         #sledecu rec i nju proveravas
                                            #inace znaci da je rec veca od 5 slova npr 8
                                            #i interval reci od [6-8] trebas postaviti na space
    
    movl %edi,pocetak                       #[pocetak,%edi] u taj interval stavljamo space
    subl $5,brojacSlova
    movl brojacSlova,%eax
    subl %eax,pocetak                       #na ovaj nacin smo dobili pocetak intervala
    
postavljanjeSpace:
    cmpl %edi,pocetak                       #posto je edi pokazivac koji krece sa desna
    je sledecaRec                           #tj sa kraja prema pocetku reci,kad dodje do
                                            # pocetka
                                            #to znaci da smo prosli kroz citav interval
    decl %edi
    movb $' ',(%edi)
    jmp postavljanjeSpace
    
sledeceSlovo:                               #prelazak na sledeci karakter u nasem stringu
    incl %edi                               #i pri tome brojimo broj slova u reci
    incl brojacSlova
    jmp proveraKraja
    
sledecaRec2:                                #ovde se ulazi kad je rec bila npr 'je' tj manja
    movl $0,brojacSlova                     #od 5 karaktera
    incl %edi
    jmp proveraKraja
    
sledecaRec:                                 #ovde udjemo kad je rec bila duza od 5 karaktera
                                            #i zavrsili smo postavljanje space u intervalu
                                            #i trebamo edi da vratimo gde je bio i nastavimo 
                                            #dalje
    addl brojacSlova,%edi
    incl %edi
    movl $0,brojacSlova

proveraKraja:

    movl duzina,%edx                        #provera da li smo zavrsili sa unetom recenicom
    addl $prijem,%edx                       #ovako u edx dobijemo adresu poslednjeg elementa
    cmpl %edx,%edi
    jl krajReci
   
dalje:

    #ispis recenice posle njenog koriscenja tj menjanja
    movl $4,%eax
    movl $1,%ebx
    leal prijem,%ecx
    movl duzina,%edx
    int $0x80
    jmp kraj
    
prekoracenje:
    movl $255,greska

kraj:
    movl $1,%eax
    movl greska,%ebx                        #ako je sve uredu 0 ce se smestiti u ebx inace 255
    int $0x80
    
    


#Uneti 94 karaktera,sa razmakom se odredjuje kraj reci,ukoliko neka (svaka) rec ima vise od 5 karaketera ubacujemo razmak umesto ostatka reci,povratna vrednost treba da bude koliko se izmenilo karaketera,ukoliko je neko pokusao da unese vise od 94 karaktera povratna vrednost je 255

#Uneses danijela je carina
#On izbaci
#Danij    je carin
