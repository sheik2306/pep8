         LDA     buffer,i    ;    A= buffer[mem]
         LDX     snakeSz,i      ;    X= 0 
         CALL    STRI        ; STRI(buffer,size)
         STX     snakeSz,d  ; Size de 1 serpent 
         DECO snakeSz,d;
         CHARO '\n',i;

    

; // Lit la liste
         LDA     snakeSz,d;        
         STA     cpt,d       
         LDA     hpPtr,d     
         STA     head,d      
loop_in: CPA     0,i         
         BRLE    out         ; for(cpt=10; cpt>0; cpt--) {
         LDA     mLength,i   
         CALL    new         ;   X = new Maillon(); #mVal #mNext
         STX     adrMail,d  
;Inserer buffer ici
         LDX     0,i;
         LDX     snakeCpt,d;
         call    char_rd
         call    verify;
         LDX     snakeCpt,d;
         ADDX    1,i;
         STX     snakeCpt,d;
         LDX     adrMail,d
         STBYTEA     mVal,x 
        ; CHARI    mVal,x      ;   X.val = getInt();
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
         LDBYTEA     mVal,x      
         CHARO    mVal,x      
         CHARO   ' ',i       ;       print(X.val + " ");}
         LDX     mNext,x     
         BR      loop_out    ; } // fin for
fin:     STOP                
head:    .BLOCK  2           ; #2h tête de liste (0 si liste vide)
cpt:     .BLOCK  2           ; #2d compteur de boucle
adrMail: .BLOCK  2           ; #2h
snakeCpt:.WORD   0           ; #2d compteur longueur du serpent         
         




; CHAR_RD: Fetch une donner du buffer
;        In: X = Pointeur du caractere a aller chercher
;        Out: A= la valeur a mettre
char_rd: LDA     0,i
         LDA     buffer,i;
         LDBYTEA buffer,x;
         RET0;






; VERIFY: verifie le previous maillon  (if !HEAD && A= - ) sinon retourner >
; mettre le previous maillon dans le maillon present
;        In      A= un byte ( -,d ou g,)
;        Out     A= un byte (>,^,V,>)

verify:  STBYTEA     tmp,d;      Byte temporaire a inserer
         LDA     0,i;
         LDBYTEA tmp,d
         CPA     '-',i;
         BREQ    garder;
         STOP
         



garder:  LDX     adrMail,d
         LDA     0,i         
         STA     mNext,x     ;   X.next = 0;
         CPX     head,d    
         BREQ    debutS    ;si le debut du serpent mettre >
         SUBX    mLength,i   
         LDBYTEA mVal,x  
         RET0

         
         

debutS:  LDA 0,i;
         LDBYTEA '>',i;
         RET0;

tmp:     .BLOCK 2;           #2h 

















; STRI: lit une ligne dans un tampon et place '\x00' à la fin
; In:  A=Adresse du tampon
;      X=Taille du tampon en octet
; Out: A=Adresse du tampon (inchangé)
;      X=Nombre de caractères lu (ou offset du '\x00')
; Err: Avorte si le tampon n'est pas assez grand pour
;      stocker la ligne et le '\0' final
STRI:    STA     striPtr,d   ; sauve A;
         ADDX    striPtr,d   
         STX     striPtr2,d  ; striPtr2 = A+X;
         LDX     striPtr,d   ; X = striPtr;
striLoop:CPX     striPtr2,d  ; while(true) {
         BRGE    striErr     ;   if(X>=striPtr2) new Error();
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x         
         CPA     '\n',i      
         BREQ    striFin     
         CPA     '\x00',i    
         BREQ    striFin     ;   if(*X=='\n' || *X=='\x00') break;
; Verifie une taille de bateau valide ([p],[m], ou [g]).
        
         CPA     '-',i
         BRNE    lettre_g
         BR      suite
lettre_g:CPA     'g',i
         BRNE    lettre_d
         BR      suite
lettre_d:CPA     'd',i
         BRNE    striErr



suite:   ADDX    1,i         ;   X++;
         BR      striLoop    ; } // fin boucle infinie
striFin: LDBYTEA 0,i         
         STBYTEA 0,x         ; *X='\x00';
         SUBX    striPtr,d   ; X = X-striPtr
         LDBYTEA striPtr,d   ; restaure A;
         RET0                ; return;
striErr: STRO    striEMsg,d  
         STOP                
striEMsg:.ASCII  "STRI erreur: débordement de capacité\n\x00"
striPtr: .BLOCK  2           ; #2d adresse de début du tampon
striPtr2:.BLOCK  2           ; #2d adresse de fin de tampon
                      


buffer: .BLOCK  200          ; adresse Initialise un tampon pouvant contenir 100 caracteres. 
snakeSz: .BLOCK  2            ; adresse



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

