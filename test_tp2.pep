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
         LDA 0,i
         LDX 0,i;
         call tab_loop; creation du table
         
        ; call afficher;



LDX bufferSz,d;
SUBX 1,i;
STX i,d;

 
;Positionne la ligne et ajoute dans une variable VAR3  

recom:   LDX i,d; 
         LDA 0,i;
         LDBYTEA buffer,x;
         SUBA '0',i;
         STA var3,d;



;Positionne la colonne et ajoute dans une variable VAR2
        SUBX 1,i;
; LDX 2,i
         LDA 0,i;
         LDBYTEA buffer,x;
         SUBA 'A',i;
         ASLA
         STA var2,d;
         LDA 0,i;
         ;LDX 0,i;


;mets h ou v dans la VAR1;
         SUBX 1,i;
         ;LDX 1,i;
         LDA 0,i;    
         LDBYTEA buffer,x;
         STBYTEA var1,d;
         LDA 0,i;
; FIN dinsertion


;determine la grosseur du bateau mets dans VAR0
         SUBX 1,i;
         ;LDX 0,i
         LDA 0,i;
         LDBYTEA buffer,x;
         STBYTEA var0,d;
         LDA 0,i;
;fin de grosseur du bateau


         LDA var3,d;
         LDX var2,d;
       
         call inserer; retourne la position a placer
         STX pos,d; Store la position a commencer
         

    
         LDBYTEA var1,d;
         CPA 'v',i;
         BREQ vertical

         LDA 0,i;

hori:   LDBYTEA '>',i;
        STBYTEA var1,d;

         LDX 0,i

         LDX pos,d;
         STA tableau,x;
        
         LDA 0,i;
         LDBYTEA var0,d;
         CPA 'p',i;
         BREQ finpos;
         CPA 'm',i;        
         BREQ deux_
         
         LDA 0,i;
         LDA '>',i;
         ADDX 2,i 
         STA tableau,x;

         ADDX 2,i 
         STA tableau,x;

deux_:   LDa 0,i
         LDBYTEA '>',i;
         ADDX 2,i 
         STA tableau,x;

         ADDX 2,i;
         STA tableau,x;
         BR verif
         

vertical:LDX 0,i
         LDX dummy,d;
         STA tableau,x;

         ADDX 36,i;
         STA tableau,x;

         ADDX 36,i;
         STA tableau,x;


        DECO dummy,d;
         charo '\n',i;

verif:   LDX 0,i;      
         LDX i,d
         SUBX 4,i;
         CPX 0,i;
         BRLE finpos;
         STX i,d;
         BR recom;

finpos:   call afficher
         CHARO '\n',i;

         STOP

sizebat: .WORD 1;
var3: .BLOCK 2; element 3 dans le buffer
var2: .BLOCK 2; element 2 dans le buffer
var1: .BLOCK 2; element 1 dans le buffer
var0: .BLOCK 2; element 0 dans le buffer
pos: .BLOCK 2; element position du tableau
i: .BLOCK 2; iterateur de buffer



;METHODE qui retourne la position du tableau a inserer
; Pour le nombre de lignes , ajouter 36 ( longueur de J )
;
;        IN: A = LIGNE (i)
;            X = COLONNES (j)
;
;        OUT: X = place du tableau a placer

inserer: SUBA 1,i;
         STA lignes,d; 
         STX col,d;
         LDA 0,i;
         LDX 0,i;
         ADDA col,d;
loop_i: CPX lignes,d; 
        BRGE fin_i                    ;nombre de lignes terminer
        ADDA 36,i;
        ADDX 1,i;
        BR loop_i;
fin_i:  STA dummy,d;
         LDX dummy,d;
         ret0

;Variable locale sauve A
lignes: .BLOCK 2;
col: .BLOCK 2;
dummy: .BLOCK 2;
dummy2: .BLOCK 2;







; Methode qui affiche un tableau 
; Methode d'un long tableau;

afficher:LDa 0,i
         STRO aff_col,d; 

         LDX     0,i         
         STX     ix,d  

;Debut de ligne      
loop_ix:  CPX     324,i     
         BRGE    fin         ; for(ix=0;ix<324;ix+=36) {
         DECO  neuf_ln,d;
         CHARO '\|',i;   
         LDX     0,i;       
         STX     jx,d  ;
; incremente le saut de ligne par 1       
         LDA 0,i;   
         LDA neuf_ln,d;
        ADDA 1,i;
         STA neuf_ln,d;
         LDA 0,i;
      
loop_jx: CPX     36,i         
         BRGE    next_ix     ;   for(jx=0;jx<36;jx+=1) {
         ADDX    ix,d         
         CHARO    tableau,x   
         LDX     jx,d        
         ADDX    1,i        
         STX     jx,d        
         BR      loop_jx     ;   } // fin for jx

;Saut de ligne
next_ix: CHARO '\|',i;
         CHARO   '\n',i      ;
         LDX     ix,d        
         ADDX    36,i         
         STX     ix,d        
         BR      loop_ix     ; } // fin for ix
fin:     LDA 1,i;
         STA neuf_ln,d; 
         ret0                ; exit();

; Variables globales
ix:      .BLOCK  2           ; #2d itérateur ix pour tri
jx:      .BLOCK  2           ; #2d itérateur jx pour tri
neuf_ln: .WORD 1;
aff_col: .ASCII "  ABCDEFGHIJKLMNOPQR\n\x00";




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



;METHODE qui cree un tableau globale 9x 18
; IN A=lignes
;    B= Colonnes

tab_loop:  CPX 324,i;
           BRGE tab_fin;
           LDA 0,i;
           LDBYTEA '~',i;      
           STA tableau,x; 
           ADDX 2,i;
           BR tab_loop

tab_fin: ret0;

tableau: .BLOCK 324;

;FIN TABLEAU






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
estRendu: .ASCII "Cest rendu ou tu veux\n\x00";              
striEMsg:.ASCII  "STRI erreur: débordement de capacité\n\x00"
striPtr: .BLOCK  2           ; #2d adresse de début du tampon
striPtr2:.BLOCK  2           ; #2d adresse de fin de tampon                       ; exit();
buffer:  .BLOCK  20          ; Buffer for the string
bufferSz:  .BLOCK 2;
size:    .EQUATE 20          ; Size of the buffer
         .END                  
