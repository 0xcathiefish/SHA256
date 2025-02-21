#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>


#include "Typedef.h"


uint8_t     msg_orignal[64]; 
message64   msg ={0};
word64      words ={0};

unsigned char *ptr_msg   = (unsigned char *)&msg;  
uint32_t *ptr_word       = (uint32_t *)&words;     


uint32_t combination_4x8_32(uint8_t a0, uint8_t a1, uint8_t a2, uint8_t a3) {

    uint32_t word;

    word =  ((uint32_t)a0 << 24) | 
            ((uint32_t)a1 << 16) | 
            ((uint32_t)a2 << 8)  | 
            ((uint32_t)a3);

    return word;
}


void segement_64_8x8(uint64_t word,uint8_t *b0,uint8_t *b1,uint8_t *b2,uint8_t *b3,uint8_t *b4,uint8_t *b5,uint8_t *b6,uint8_t *b7)
{

    *b0 = (word>>56)  & 0xff;
    *b1 = (word>>48)  & 0xff;
    *b2 = (word>>40)  & 0xff;
    *b3 = (word>>32)  & 0xff;
    *b4 = (word>>24)  & 0xff;
    *b5 = (word>>16)  & 0xff;
    *b6 = (word>>8)   & 0xff;
    *b7 = (word>>0)   & 0xff;
}


uint32_t rightrotate(uint32_t c0,int n)
{

    uint32_t rg;

    rg = (c0>>n) | ( c0<<(32-n) );
    
    return rg;
}


void cout_bit(uint8_t message)
{
    uint8_t temp,j=0;   
    for(int i=7;i>=0;i--){
        
        temp = (message>>i) & 1;

        //if(j%4==0 && j!=0) printf(" ");

        printf("%d",temp);
        j++;
    }
    printf(" ");
}



void msg_initial() 
{
     
    for(int i=0;i<=63;i++){

        msg_orignal[i]=0;
    }
    printf("hello\n");
    printf("Input your message here: ");
    scanf("%63s", msg_orignal);  

    size_t msg_length = strlen(msg_orignal);

    printf("length=%d\r\n",msg_length);

    for(int i = 0;i<=msg_length-1;i++){

        printf("Your message[%d] is: %d\n", i,msg_orignal[i]);     
    }


    //unsigned char *ptr_msg = (unsigned char *)&msg;  // 将结构体的地址转换为指向字符的指针

    for(int i=0;i<=63;i++) ptr_msg[i]=0x00;

    for(int i=0;i<=msg_length-1;i++){   //change the message into binary bit
        
        ptr_msg[i] = msg_orignal[i];
        //cout_bit(ptr_msg[i]);
    }


    //printf("\r\n");

    ptr_msg[msg_length] = 0x80; //first complement

    for(int i=msg_length+1;i<=55;i++){  //rest complement

        ptr_msg[i]=0x00;
    }

    //cout_bit(ptr_msg[55]);
    //cout_bit(ptr_msg[57]);

    uint64_t msg_len=(uint64_t)(msg_length*8);

    /*
    cout_bit(ptr_msg[60]);
    cout_bit(ptr_msg[61]);
    cout_bit(ptr_msg[62]);
    cout_bit(ptr_msg[63]);
    */

    segement_64_8x8(msg_len,&ptr_msg[56],&ptr_msg[57],&ptr_msg[58],&ptr_msg[59],&ptr_msg[60],&ptr_msg[61],&ptr_msg[62],&ptr_msg[63]);

    /*
    cout_bit(ptr_msg[60]);
    cout_bit(ptr_msg[61]);
    cout_bit(ptr_msg[62]);
    cout_bit(ptr_msg[63]);
    */

   int count =0;
   for(int i=0;i<=63;i++){

        if(count!=0 && count%4==0) printf("\n");

        cout_bit(ptr_msg[i]);
        count ++;
   }

}


void words_init()
{
    int j =0;

    printf("\r\n");
    for(int i =0;i<=15;i++){
    
    j = i*4;

    ptr_word[i] = combination_4x8_32(ptr_msg[j],ptr_msg[j+1],ptr_msg[j+2],ptr_msg[j+3]);

    printf("word[%d]: 0x%08X\n",i,ptr_word[i]);

    }

}


void words_expansion()
{

    uint32_t s0=0 ,s1=0; 

    for(int i=16;i<=63;i++){
    
        s0 = rightrotate(ptr_word[i-15],7) ^ rightrotate(ptr_word[i-15],18) ^ (ptr_word[i-15]>>3);
        
        s1 = rightrotate(ptr_word[i-2],17) ^ rightrotate(ptr_word[i-2],19)  ^ (ptr_word[i-2]>>10);

        ptr_word[i] = ptr_word[i-16] + s0 + ptr_word[i-7] + s1;

        printf("word[%d]: 0x%08X\n",i,ptr_word[i]);
    }

}


void words_encryption()
{

    uint32_t s0,s1,ch,temp1,maj,temp2,count =0;

    uint32_t a = H[0];
    uint32_t b = H[1];
    uint32_t c = H[2];
    uint32_t d = H[3];
    uint32_t e = H[4];
    uint32_t f = H[5];
    uint32_t g = H[6];
    uint32_t h = H[7];


    for(int i=0;i<=63;i++){

        s1 = rightrotate(e,6) ^ rightrotate(e,11) ^ rightrotate(e,25);

        ch = (e & f) ^ (~e & g);

        temp1 = h + s1 + ch + K[i] + ptr_word[i];

        s0 = rightrotate(a,2) ^ rightrotate(a,13) ^ rightrotate(a,22);

        maj = (a & b) ^ (a & c) ^ (b & c);

        temp2 = s0 + maj;

        h = g;
        g = f;
        f = e;
        e = d + temp1;
        d = c;
        c = b;
        b = a ;
        a = temp1 + temp2;

/*
        count++;
        printf("count=%d\r\n",count);
        printf("s0=%08x\r\n", s0);
        printf("ch=%08x\r\n", ch);
        printf("temp1=%08x\r\n", temp1);
        printf("s1=%08x\r\n", s1);
        printf("maj=%08x\r\n", maj);

        printf("temp2=%08x\r\n", temp2);

        system("pause");

*/

    }

    F[0] = H[0] + a;
    F[1] = H[1] + b;
    F[2] = H[2] + c;
    F[3] = H[3] + d;
    F[4] = H[4] + e;
    F[5] = H[5] + f;
    F[6] = H[6] + g;
    F[7] = H[7] + h;




    // 输出 256 位的 SHA-256 哈希结果
    printf("SHA-256 Hash: ");
    for (int i = 0; i < 8; i++) {
        printf("%08x", F[i]);
    }
    printf("\n");

}

int main() {


    msg_initial();

    words_init();

    words_expansion();

    words_encryption();

    return 0;
}
