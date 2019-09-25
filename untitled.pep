DECI x,d; 
LDA x,d
ADDA num,d;
STA num,d; STORE from Accumulator into num

DECO num,d; Decimal OUTPUT from variable num

STOP


num: .WORD 8;
x: .BLOCK 2; 
.END