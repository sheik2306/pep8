; // Lit la liste
         LDA     10,i        
         STA     cpt,d       
         LDA     hpPtr,d     
         STA     head,d      
loop_in: CPA     0,i         
         BRLE    out         ; for(cpt=10; cpt>0; cpt--) {
         LDA     mLength,i   
         CALL    new         ;   X = new Maillon(); #mVal #mNext
         STX     adrMail,d   
         DECI    mVal,x      ;   X.val = getInt();
         LDA     0,i         
         STA     mNext,x     ;   X.next = 0;
         CPX     head,d      
         BREQ    firstEl     ; if(X!=head){
         SUBX    mLength,i   
         LDA     adrMail,d   
         STA     mNext,x     ;  X[prev].next = X }
firstEl: LDA     cpt,d       
         SUBA    1,i         
         STA     cpt,d       
         BR      loop_in     ; } // fin for
;
;                            ; // Affiche la liste
out:     LDX     head,d      
loop_out:CPX     0,i         
         BREQ    fin         ; for (X=head; X!=null; X=X.next) {
         LDA     mVal,x      
         DECO    mVal,x      
         CHARO   ' ',i       ;       print(X.val + " ");}
         LDX     mNext,x     
         BR      loop_out    ; } // fin for
fin:     STOP                
head:    .BLOCK  2           ; #2h tête de liste (0 si liste vide)
cpt:     .BLOCK  2           ; #2d compteur de boucle
adrMail: .BLOCK  2           ; #2h

;******* Structure de liste d'entiers
; Une liste est constituée d'une chaîne de maillons.
; Chaque maillon contient une valeur et l'adresse du maillon suivant
; fin de liste marquée arbitrairement par l'adresse 0
mVal:    .EQUATE 0           ; #2d valeur de l'élément dans maillon
mNext:   .EQUATE 2           ; #2h maillon suivant (0:fin de liste)
mLength: .EQUATE 4           ; taille d'un maillon en octets
;
;
;******* operator new
;        Precondition: A contains number of bytes
;        Postcondition: X contains pointer to bytes
new:     LDX     hpPtr,d     ;returned pointer
         ADDA    hpPtr,d     ;allocate from heap
         STA     hpPtr,d     ;update hpPtr
         RET0                
hpPtr:   .ADDRSS heap        ;address of next free byte
heap:    .BLOCK  1           ;first byte in the heap
         .END                  