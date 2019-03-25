.section .data
poruka1: .ascii "Unesite proizvoljnu recenicu: \0"
por1_len=.-poruka1


poruka2: .ascii "Rimuju se :D \0"
por2_len=.-poruka2

poruka3: .ascii "Nema rime :( \0"
por3_len=.-poruka3

MAX=100
prijem1: .fill MAX,1,42
duzina1: .long 0

prijem2: .fill MAX,1,42
duzina2: .long 0

indikatorRime: .long 0                      #kad se poklope zadnja 3 slova u obe recenice
                                            #onda cemo ga aktivirati
indikatorPoklapanja: .long 0                #njega cemo aktivirati ako se poklapaju zadnje reci
.section .text

.globl main
main:
    

	movl $4,%eax                            #unosenje prve recenice
	movl $1,%ebx
	leal poruka1,%ecx
	movl $por1_len,%edx
	int $0x80
	
	movl $3,%eax
	movl $0,%ebx
	leal prijem1,%ecx
	movl $MAX,%edx
	int $0x80
	movl %eax,duzina1
	
	movl $4,%eax                            #UNOSENJE DRUGE recenice
	movl $1,%ebx
	leal poruka1,%ecx
	movl $por1_len,%edx
	int $0x80
	
	movl $3,%eax
	movl $0,%ebx
	leal prijem2,%ecx
	movl $MAX,%edx
	int $0x80
	movl %eax,duzina2
	
	leal prijem1,%esi
	leal prijem2,%edi                       #pokazivaci na nase primljene nizove
	
	
	
krajRecenice1:
    cmpb $10,(%esi)
    jne dalje
    #NASLI SMO KRAJ PRVE RECENICE
    jmp krajRecenice2
    
dalje:
    incl %esi
    
    movl duzina1,%edx                        #provera da li smo zavrsili sa unetom recenicom
    addl $prijem1,%edx                       #ovako u edx dobijemo adresu poslednjeg elementa
    cmpl %edx,%esi
    jl krajRecenice1

	
krajRecenice2:
    cmpb $10,(%edi)
    jne dalje2
    #NASLI SMO KRAJ I DRUGE RECENICE
    jmp poredjenje
    
dalje2:
    incl %edi
    
    movl duzina2,%edx                        #provera da li smo zavrsili sa unetom recenicom
    addl $prijem2,%edx                       #ovako u edx dobijemo adresu poslednjeg elementa
    cmpl %edx,%edi
    jl krajRecenice2

poredjenje:                                 #idemo od kraja reci i poredimo ig
    decl %edi
    decl %esi
    cmpl $' ',%esi
    je nemaRime
    
    movb (%esi),%al                          #u al sadrzaj pokazivaca jer ne moze
                                            #cmpl (%esi),(%edi)
    cmpb (%edi),%al
    jne nemaRime
    #JEDNAKI SU KORESPODENTNI ELEMENTI
    incl indikatorRime
    cmpl $3,indikatorRime
    je rimujuSe
    jmp poredjenje
    
nemaRime:
    movl $4,%eax
    movl $1,%ebx
    leal poruka3,%ecx
    movl $por3_len,%edx
    int $0x80
    jmp kraj


rimujuSe:
    movl $4,%eax
    movl $1,%ebx
    leal poruka2,%ecx
    movl $por2_len,%edx
    int $0x80
    
kraj:
    movl $1,%eax
    movl $0,%ebx                        
    int $0x80



#Unesu se 2 recenice,proveriti da li se rimuju(rimuju se ako imaju ista 3 poslednja slova
#ispisati da li se rimuju ili ne


