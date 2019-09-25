DECI x,d; INPUT a decimal into X
LDA x,d ; LOAD into ACCUMULATOR the variable x
ADDA num,d; ADD num to accumulator
STA num,d; STORE from Accumulator into num

DECO num,d; Decimal OUTPUT from variable num




CHARO'\n',i;
CHARO 'A',i;

CHARI A,d; CHAR input dans la variable A

CHARO'\n',i;

CHARO A,d; CHAR output de la variable A

STOP

msg: .ASCII "NOTHING \n\x00";
num: .WORD 8;
x: .BLOCK 2; 
A: .BLOCK 1;
.END ; OUTPUT WOULD BE 16