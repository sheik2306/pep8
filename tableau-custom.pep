
;DECO tab,d;
         LDX 0,i;


addLoop: CPX  size,d
         BRGE output;
         DECI tableau,x
         ADDX 2,i;
         BR addLoop; 
         stop      



output:    charo'\n',i; 
          LDX i,d;
         DECO tableau,x
         charo'\n',i; 
         ADDX 2,i;
         STX i,d;
         CPX size,d
         BRLT output;



STOP


         tableau: .BLOCK 10;

  

i: .WORD 0;

size: .WORD 10;   20 octets car 1 .WORD = 2 octet.          
case: .BYTE 2;
reusi: .ASCII "reusi\x00"

.END