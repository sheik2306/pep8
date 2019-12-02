         LDA     5,i; 
         LDX     10,i;
         CALL    ajout

         CALL    ajout
         STOP

ajout:   SUBSP   8,i; reserve #var0 #var1 #var2 #var3
         STA     var0,s
         STX     var1,s
         DECO    var0,s;
         DECO    var1,s;
         ADDSP   8,i;dereserve #var0 #var1 #var2 #var3
         RET0;   
        
    








var0:         .EQUATE 0           ;#2d
var1:         .EQUATE 2           ;#2d
var2:         .EQUATE 4           ;#2d
var3:         .EQUATE 6           ;#2d


.END