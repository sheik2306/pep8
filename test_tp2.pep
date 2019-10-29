         LDA     buffer,i    
         LDX     size,i      
         CALL    STRI        ; STRI(buffer,size);
         STRO    buffer,d    
         CHARO   '\n',i   
         STX     bufferSz,d; 
         DECO    bufferSz,d;
         CHARO   '\n',i   ;
         
         LDX 0,i;
         LDA buffer,d;
         LDX bufferSz,d;
         call b_start;
          STOP
        ; STRO    buffer,d    ; print(buffer + '\n' + buffer);

; METHODE QUI ITERE UN STRING 
; IN: A=buffer
;     X=bufferSize
b_start: STX bufferSz,d;
         LDX 0,i;
b_loop:  CPX bufferSz,d;
         BRGT b_fin; 
         CHARO buffer,x;
         CHARO   '\n',i ;
         ADDX 1,i;
         BR b_loop;

b_fin:     RET0;




         STOP                ; exit();
buffer:  .BLOCK  20          ; Buffer for the string
bufferSz:  .BLOCK 2;
size:    .EQUATE 20          ; Size of the buffer
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


;Verification premier char [p],[m], ou [g]
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x 
         CPA 'p',i;
         BRNE lettre_m; 
         BR lettre_h; 
lettre_m:CPA 'm',i;
         BRNE lettre_g;
         BR lettre_h;
lettre_g:CPA 'g',i;
         BRNE striErr;


;Verification 2ieme char [h],[v]         
lettre_h:ADDX 1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA 'h',i;
         BRNE lettre_v;
         BR A_R; 

lettre_v:CPA 'v',i;
         BRNE striErr;
         BR A_R;

;Verification 3ieme char entre A et R          
A_R:     ADDX 1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA 'A',i;
         BRLT striErr;
         CPA 'R',i;
         BRGT striErr; 
         BR un_neuf; 


;Verification 4ieme char entre 1 et 9
un_neuf: ADDX    1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA '1',i;
         BRLT striErr;
         CPA '9',i;
         BRGT striErr; 
         BR enter; 

;Verification du 5ieme ( Espace ou Enter)
; S'il y'a un espace brancher a la loop sinon terminer
enter:   ADDX 1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA ' ',i;
         BREQ striLoop;

         CPA     '\n',i      
         BREQ    striFin     
         CPA     '\x00',i    
         BREQ    striFin     ;   if(*X=='\n' || *X=='\x00') break;
         ADDX    1,i         ;   X++;
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
         .END                  
