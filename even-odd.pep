DECI num,d;


LDA num,d;

ANDA 0x0001,i    ; si x0000 ET x0001 = 0 .alors  A == 0 BREQ
                 ; sinon x0001 ET x0001 = 1 .alors A != 0 (Ne pas brancher)

BREQ pair;


STRO oddmsg,d;
BR fin;

pair: STRO evenmsg,d; 

fin:STOP




num: .block 2;
evenmsg: .ASCII "Valeur even \x00"
oddmsg: .ASCII "Valeur odd \x00"


.END