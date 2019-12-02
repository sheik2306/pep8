
;DECO tab,d;

add:     LDX 0,i
         DECI tableau,x;
         
       
      
         deco tableau,x;
       

STOP


         tableau: .EQUATE 20;

  

i: .WORD 0;

size: .WORD 20;   20 octets car 1 .WORD = 2 octet.          
case: .BYTE 2;


.END