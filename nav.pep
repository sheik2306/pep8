


LDA buffer,i;
LDX size,i;

CALL STRI; STRI(Adresse du tampon,Taille du tampon)

STRI: STA striPtr,d ; sauve A;
          ADDX striPtr,d; striPtr2 = A+X
          STX striPtr2,d ; , La fin du tampon
          LDX striPtr,d ; X = striPtr;



STOP

buffer: .BLOCK 200;
size: .EQUATE 200;
lines: .BLOCK 9;
nblines: .EQUATE 9;
ptr: .BLOCK 2;