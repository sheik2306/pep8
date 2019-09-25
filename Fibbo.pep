LDA somme,d;
CPA 500,i;
BRGE Affiche; ;ERROR: Symbol Affiche is used but not defined.
LDA dernier,d;
STA avant,d;
LDA somme,d;
STA dernier,d;
ADDA avant,d;
STA somme,d;
BR Boucle;

STOP;

dernier: .BLOCK 2; 
somme: .BLOCK 8;
avant: .BLOCK 16;

.END;