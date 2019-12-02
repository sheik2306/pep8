         LDA     buffer,i    ;    A= buffer[mem]
         LDX     buffSz,i      ;    X= 0 
         CALL    STRI        ; STRI(buffer,size)
         STX     buffSz,d  ; Size de 1 serpent 
         DECO    buffSz,d

         LDX     0,i;
         call    char_rd

         STBYTEA  tmp,d;
         CHARO    tmp,d

         STOP
         


; CHAR_RD: Fetch une donner du buffer
;        In: X = Pointeur du caractere a aller chercher
;        Out: A= la valeur a mettre
char_rd: LDA     buffer,i;
         LDBYTEA buffer,x;
         RET0;



        
         

tmp:     .BLOCK 2






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
buffSz: .BLOCK  2            ; adresse

         .END  

