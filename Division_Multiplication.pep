



LDA 6,i; 
ASRA ; DIVISION/2 par la droite (Shift right)
STA nombre,d;

DECO nombre,d; 


CHARO '\n',i; NEXT line
LDA 0,i; REST acuumulateur
LDA 6,i; LOAD 6
ASLA; MULTIPLICATION * 2 (shit vers la gauche;
STA nombre,d;

DECO nombre,d; 

STOP


nombre: .word 0;


.END