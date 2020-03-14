#include <stdio.h>

unsigned int RUNPP_REG_ERR = 0;

int SvakiPeti(unsigned int* vrednost);

void printbin(unsigned int x) {
    unsigned int m=0x80000000, s=0;
    while(m) {
        printf("%s%s",m&x ? "1" : "0",++s%8 ? "" : " ");
        m >>= 1;
    }
}

int main() {
    unsigned int v, g=0;
    int r;

    printf("Vrednost (hex): ");
    scanf("%x",&v);
    printf("Binarno: ");
    printbin(v);
    r = SvakiPeti(&v);
    printf("\nIzlaz  : ");
    printbin(v);
    printf(" (%X)",v);
    printf("\nPovratna vrednost: %d\n",r);

    #ifdef LEVEL42
    printf("\nRUNPP_REG_ERR:%d\n",RUNPP_REG_ERR);
    #endif
    return g;
}

