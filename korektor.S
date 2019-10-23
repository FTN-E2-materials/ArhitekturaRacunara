# Program koji ulazni tekst na srpskom jeziku (bez kvačica) čini razumljivijim
# za čitanje, korišćenjem jednostavne forme veštačke inteligencije

# Korišćenje: ./naziv_programa < neki_tekst.txt 
# (ili, alternativno, može se otkucati neki tekst nakon startovanja programa i pritisnuti Enter)

# Na primer, početak romana "Na Drini ćuprija", koji se nalazi u fajlu
# andric.txt je mnogo razumljiviji i čitljiviji ako se koriguje ovim programom:
# gcc -m32 -o korektor korektor.S
# ./korektor < andric.txt

# Stepen korekcije teksta se može podešavati konstantom STEPEN
# (1 - maksimalna korekcija, 10 - minimalna korekcija)

# Imenko Prezimić ra1234

.section .data
STEPEN = 3
korekcija1: .fill 7,1,0102    # prvi niz za korekciju
korekcija2: .fill 7,1,0142    # drugi niz za korekciju
korekcija3: .long 4044615538, 57531    # podaci za korekciju
poruka1:    .ascii "Ulazni tekst: \0"
poruka2:    .ascii "\n\nKorigovani tekst:\n\0"
newline:    .ascii "\n\n\0"
unutar:     .byte 0 # da li se trenutno obrađuje reč na početku rečenice ili unutar rečenice
stepen:     .byte 0 # trenutni stepen korekcije

INPUT_BUFF_LEN = 4096   #maksimalna dužina ulaznog teksta
input_buffer:    .fill INPUT_BUFF_LEN,1,0

.section .text
.globl main

# ispis stringa, dužina se računa u petlji
# void print_str(char *str)
print_str:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    movl $4, %eax
    movl $1, %ebx
    movl 8(%ebp), %ecx
    movl $0, %edx
print_find:
    cmpb $0, (%ecx, %edx,1)
    je print_end
    incl %edx
    jmp print_find
print_end:
    int $0x80
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

# glavni program
main:
    # inicijalizacija korekcije
    xorl %eax, %eax     # koristiće se samo al
    xorl %ecx, %ecx     # indeks niza
main_init:
    addb korekcija3(,%ecx,1), %al
    movb %al, korekcija1+1(,%ecx,1)
    movb %al, korekcija2+1(,%ecx,1)
    incl %ecx
    andb %al, %al
    jnz main_init

    # preuzimanje znakova sa ulaza
    pushl $poruka1
    call print_str
    addl $4, %esp
    movl $3, %eax
    movl $0, %ebx
    movl $input_buffer, %ecx
    movl $INPUT_BUFF_LEN, %edx
    int $0x80
    movb $0, -1(%ecx,%eax,1)

    movb $1, stepen # početni stepen
    movb $1, unutar # početak rečenice
    movl %ecx, %esi # adresa ulaznog stringa

    pushl $poruka2
    call print_str
    addl $4, %esp

    # provera da li treba raditi korekciju
main_kor:
    decb stepen             # da li treba raditi korekciju?
    jnz main_rec0
    movb $STEPEN, stepen
    movl $korekcija1, %ecx
    cmpb $1, unutar         # prva ili druga korekcija?
    je main_kor1
    movl $korekcija2, %ecx
main_kor1:
    pushl %ecx
    call print_str
    addl $4, %esp

main_rec0:
    incb unutar
    movl %esi, %edi
    # traženje kraja tekuće reči
main_rec:
    cmpb $0, (%esi)
    je main_rec_ispis
    cmpb $'A', (%esi)
    jl main_rec_kraj2
    cmpb $'Z', (%esi)
    jle main_rec_kraj
    cmpb $'a', (%esi)
    jl main_rec_kraj2
    cmpb $'z', (%esi)
    jg main_rec_kraj2
main_rec_kraj:
    incl %esi
    jmp main_rec
    # traženje početka sledeće reči
main_rec_zadnja:
    movb $1, unutar
    jmp main_rec_kraj3
main_rec_kraj2:
    cmpb $0, (%esi)
    je main_rec_ispis
    cmpb $'.', (%esi)
    je main_rec_zadnja
    cmpb $'?', (%esi)
    je main_rec_zadnja
    cmpb $'!', (%esi)
    je main_rec_zadnja
    cmpb $'A', (%esi)
    jl main_rec_kraj3
    cmpb $'Z', (%esi)
    jle main_rec_ispis
    cmpb $'a', (%esi)
    jl main_rec_kraj3
    cmpb $'z', (%esi)
    jle main_rec_ispis
main_rec_kraj3:
    incl %esi
    jmp main_rec_kraj2

main_rec_ispis:
    movb (%esi), %al    # čuvanje znaka iza reči
    pushl %eax
    movb $0, (%esi)
    pushl %edi          # ispis reči
    call print_str
    addl $4, %esp
    popl %eax
    movb %al, (%esi)
    cmpb $0, (%esi)
    jne main_kor

    pushl $newline
    call print_str
    addl $4, %esp

    movl $1, %eax       # kraj programa
    movl $0, %ebx
    int $0x80

