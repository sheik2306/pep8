E_loop:  STRO    msgEnt,d; 
         LDA     buffer,i    
         LDX     size,i      
         CALL    STRI        ; STRI(buffer,size);
         STRO    buffer,d   
         STX     bufferSz,d 
         CHARO   '\n',i   


;        Creation d;'un tableau vide
         call tb_vide
   
;Boucle le placement des bateaux    
         LDX     0,i;
B_loop:  CPX     bufferSz,d;
         BRGE    afficheB; 
         call    verifBat
         ADDX    4,i;
         BR      B_loop;  
      


afficheB:call afficher
         BR TB_Start
  

TB_Loop:  STRO   msgRTire,d; 
TB_Start: STRO    msgTire,d; 

;Placement  des tirs dans le tampon Tire

         LDA     bufferT,i    
         LDX     size,i      
         CALL    striT        ; STRI(buffer,size);
         STRO    bufferT,d  
         STX     buffSzT,d;

         CHARO   '\n',i 
;Fin de placement des tirs



;LOAD buffer 0 en premier, et ensuite mets colonne et ligne dans des variables
         LDX     0,i;
T_Loop:  CPX     buffSzT,d;
         BRGE    finMain;
         call    alignT

;        Prepare le methode insertT avec la ligne et la colonne
         LDA var0T,d;
         LDX var1T,d;
         call insertT
         LDX     ptrTire,d;
         ADDX    2,i;
         BR T_Loop

      

         
         
         
;FIN DE METHODE          
finMain: call afficher      

         call verifTab

         STRO msgFin,d;
  
         STOP




;verifTab: Verifie un tableau globale 9x18

;        IN= /

;        OUT= /
verifTab:LDX     0,i;        
         STX     ix,d;
         STX     jx,d;
iLoop:   CPX      18,i; 
         BRGE    finVerif


         LDX     0,i
         STX     jx,d
jLoop:   CPX     40,i
         BRGE    nextI
         LDX     ix,d
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    jx,d
         LDA     0,x;
         CPA     'v',i;
         BREQ TB_Loop;
         CPA     '>',i;
         BREQ TB_Loop;    
         LDX     jx,d
         ADDX    1,i;
         STX     jx,d;
         BR      jLoop

nextI:   LDX     ix,d
         ADDX    2,i
         STX     ix,d
         BR      iLoop  
   
finVerif:LDA 1,i;
         STA nb_ligne,d; 
         RET0










;METHOD RECURSIVE DE TIRE

;        Call alignT avant.
;        IN      A=Colonne
;                X=Ligne


insertT:         SUBSP       4,i; reserve #sauveCol #sauveLig 
                 STA         sauveCol,s;
                 STX         sauveLig,s;


;Load 2 var dans le buffers et verifie la postion mettre en Local

         LDX     sauveLig,s;
         LDA     tableau,x;
         STA     ptr,d;
         LDX     ptr,d
         ADDX    sauveCol,s;
         LDA     0,i;
         LDA     0,x;
         CPA     'v',i;
         BREQ    couler
         CPA     '>',i;
         BREQ    couler
         CPA     '*',i;
         BREQ finTire
       
         ;IF not = aller mettre un /o/
         LDA     'o',i;
         STA     0,x;
         ;fin de boucle na pas eu un bateau brancher au prochaine buffer
       
         BR finTire


couler:  LDA '*',i;
         STA 0,x;

;Verification en haut (Recursivement) 
         LDA     sauveCol,s      
         LDX     sauveLig,s;
         CPX     0,i;
         BRLE    verif_B;
         SUBX    2,i;
         call    insertT;


;Verification en bas (Recursivement)
verif_B: LDA     sauveCol,s      
         LDX     sauveLig,s;
         CPX     16,i;
         BRGE    verif_D;
         ADDX    2,i;
         call    insertT;

         
;Verification a droite (Recursivement)
verif_D: LDA sauveCol,s;
         CPA 34,i            ;Regarde la limite droite                               
         BRGE verif_G
         ADDA    2,i;
         LDX  sauveLig,s;    
         call insertT


;Verification a gauche (Recursivement)
verif_G: LDA sauveCol,s;
         CPA 0,i             ;Regarde la limite a gauche
         BRLE    finTire
         SUBA    2,i;        
         LDX  sauveLig,s;    
         call insertT



               
finTire:         ADDSP   4,i; dereserve #sauveCol #sauveLig 
                 LDX 0,i;
                 RET0;

sauveCol:       .EQUATE 2           ;#2d
sauveLig:       .EQUATE 0           ;#2d 


                






; ALIGNT: Initialize VAR0T et VAR1T au positionnement necessaire reel du grid

;        IN      X= Ptr du buffer

;        OUT     A=position de la colonne a placer
;                X=position de la ligne a placer


;(Colonne * 2) et ajoute dans la variable VAR0T

alignT:  LDA     0,i;
         LDBYTEA bufferT,x;
         STX     ptrTire,d;
         SUBA    'A',i;
         ASLA
         STA     var0T,d;
         LDA     0,i;


;((Ligne * 2) -2 ) et ajoute dans la variable VAR1T  

         ADDX    1,i; 
         LDA     0,i; 
         LDBYTEA bufferT,x;
         SUBA    '0',i;      
         ASLA
         SUBA    2,i;
         STA     var1T,d;
         LDX     ptrTire,d;         
         RET0;

var0T:         .BLOCK 2           ;#2d
var1T:         .BLOCK 2           ;#2d
ptrTire:       .BLOCK 2








;        TAMPON TIRE - bufferT
       
;        IN      A = address du buffer
;                X= grosseur du buffer   
;        OUT     X= grandeur du tampon                                   
                 

;Verification 1e char entre A et R          
striT:   STA     striPtr,d   ; sauve A;
         ADDX    striPtr,d   
         STX     striPtr2,d  ; striPtr2 = A+X;
         LDX     striPtr,d   ; X = striPtr;
strLoopT:CPX     striPtr2,d  ; while(true) {
         BRGE    striErr     ;   if(X>=striPtr2) new Error();
 

         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     'A',i;
         BRLT    striErrT;
         CPA     'R',i;
         BRGT    striErrT; 
         BR      un_neufT; 

;Verification 2ieme char entre 1 et 9
un_neufT: ADDX    1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     '1',i;
         BRLT     striErrT;
         CPA     '9',i;
         BRGT    striErrT; 
         BR      enterT; 


;Verification ( Espace ou Enter)
; S'il y'a un espace brancher a la loop sinon terminer
enterT:  ADDX    1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     ' ',i;
         BREQ    strLoopT;

         CPA     '\n',i      
         BREQ    striFinT 
         ADDX    1,i         ;   X++;
         BR      strLoopT    ; } // fin boucle infinie
striFinT:LDBYTEA 0,i         
         STBYTEA 0,x         ; *X='\x00';
         SUBX    striPtr,d   ; X = X-striPtr
         LDBYTEA striPtr,d   ; restaure A;
         RET0     ; return;

striErrT:STRO msgErrT,d;        
         
         STOP  


bufferT:         .BLOCK  200          ; Buffer for the string
buffSzT:         .BLOCK 2; 








;inserer: Rempli un tableau 9x18 globale par des chars ~ 

; Debutant et finissant par |

;        IN= /

;        OUT=/

tb_vide: LDX      ix,d        
         STX      ix,d;

i_loop:  LDX     ix,d; 
         CPX     tab_fin,i;
         BRGE    fin     

         
         LDX     0,i
         STX     jx,d
              
j_loop:  CPX     36,i
         BRGE    next_ix
         LDX     ix,d
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    jx,d       
         LDA     0,i
         LDBYTEA '~',i
         STA     0,x
         LDX     jx,d
         ADDX    2,i;
         STX     jx,d;
         BR      j_loop

next_ix: LDX     ix,d
         ADDX    2,i
         STX     ix,d   
         BR      i_loop     
fin:     RET0

tableau: .ADDRSS r1          ;#2h
         .ADDRSS r2          ;#2h 
         .ADDRSS r3          ;#2h
         .ADDRSS r4          ;#2h
         .ADDRSS r5          ;#2h
         .ADDRSS r6          ;#2h
         .ADDRSS r7          ;#2h
         .ADDRSS r8          ;#2h
         .ADDRSS r9          ;#2d
r1:      .BLOCK  40          ;#2d20a 
r2:      .BLOCK  40          ;#2d20a 
r3:      .BLOCK  40          ;#2d20a 
r4:      .BLOCK  40          ;#2d20a 
r5:      .BLOCK  40          ;#2d20a 
r6:      .BLOCK  40          ;#2d20a 
r7:      .BLOCK  40          ;#2d20a 
r8:      .BLOCK  40          ;#2d20a 
r9:      .BLOCK  40          ;#2d20a 
ix:      .BLOCK  2           ;#2d iterateur ix
jx:      .BLOCK  2           ;#2d iterateur jx
ptr:     .BLOCK  2           ;#2h
tab_fin: .EQUATE 18          ;fin tableau 9 lignes*2 bytes










;afficher: Affiche un tableau globale 9x18

;        IN= /

;        OUT= /
afficher:STRO col_aff,d;
         LDX     0,i;        
         STX     ix,d;
         STX     jx,d;
i_loo:   CPX      18,i; 
         BRGE    finaff


;        Affichage des numeros de lignes  
   
         LDA     nb_ligne,d;
         DECO    nb_ligne,d;
         ADDA    1,i;
         STA     nb_ligne,d;                      

;        Fin affichage des numeros de ligne   

         LDX     0,i
         STX     jx,d
j_loo:   CPX     40,i
         BRGE    next_i
         LDX     ix,d
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    jx,d
         CHARO   0,x;    
         LDX     jx,d
         ADDX    1,i;
         STX     jx,d;
         BR      j_loo
next_i:  CHARO    '\n',i; 
         LDX     ix,d
         ADDX    2,i
         STX     ix,d
         BR      i_loo     
finaff:  LDA 1,i;
         STA nb_ligne,d; 
         RET0

nb_ligne:.WORD   1                            ;Affichage des numeros de ligne         
col_aff: .ASCII " ABCDEFGHIJKLMNOPQR\n\x00"  ;










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
         CPA     'p',i;
         BRNE    lettre_m; 
         BR      lettre_h; 
lettre_m:CPA     'm',i;
         BRNE    lettre_g;
         BR      lettre_h;
lettre_g:CPA     'g',i;
         BRNE    striErr;


;Verification 2ieme char [h],[v]         
lettre_h:ADDX    1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     'h',i;
         BRNE    lettre_v;
         BR      A_R; 

lettre_v:CPA     'v',i;
         BRNE    striErr;
         BR      A_R;

;Verification 3ieme char entre A et R          
A_R:     ADDX    1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     'A',i;
         BRLT    striErr;
         CPA     'R',i;
         BRGT    striErr; 
         BR      un_neuf; 


;Verification 4ieme char entre 1 et 9
un_neuf: ADDX    1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     '1',i;
         BRLT     striErr;
         CPA     '9',i;
         BRGT    striErr; 
         BR      enter; 


;Verification du 5ieme ( Espace ou Enter)
; S'il y'a un espace brancher a la loop sinon terminer
enter:   ADDX    1,i; 
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     ' ',i;
         BREQ    striLoop;

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
striErr: STRO    msg_err,d   
         BR      vide_tp
         STOP  
estRendu:.ASCII "Cest rendu ou tu veux\n\x00";              
striEMsg:.ASCII  "STRI erreur: débordement de capacité\n\x00"
striPtr: .BLOCK  2           ; #2d adresse de début du tampon 
striPtr2:.BLOCK  2           ; #2d adresse de fin de tampon                       ; exit();
buffer:  .BLOCK  200          ; Buffer for the string
bufferSz:.BLOCK 2;
size:    .EQUATE 200          ; Size of the buffer
msg_err: .ASCII "Vous n'avez pas rentrer un bon format,recommencer\n\x00"
            







; Fonction qui vide le buffer si l'entree d'utilsateur est du mauvais format

;
vide_tp: CPA     '\n',i;
         BREQ    E_loop;
         CHARI   tmp,d;
         LDBYTEA tmp,d
         BR      vide_tp
tmp:     .BLOCK  2;           



          









; VF_BAT: lit un buffer de 4 espace et insere les bateaux

; In:  X=Pointeur du buffer

; Out: X=Pointeur du buffer inchanger, OU si ne rentre pas Pointeur du bateau + 4



;determine la grosseur du bateau et place dans la variable VAR0

verifBat:SUBSP   10,i; reserve #var0 #var1 #var2 #var3 #sauveX 
         STX     sauveX,s; 
         LDA     0,i;
         LDBYTEA buffer,x;
         CPA     'm',i 
         BREQ    trois
         CPA     'g',i;
         BREQ    cinq
         LDA     0,i;
         ADDA    1,i;
         STA     var0,s; 
         BR      nextVar
      
cinq:    LDA     0,i;
         ADDA    5,i;
         STA     var0,s;    
         BR      nextVar

trois:   LDA     0,i;
         ADDA    3,i;
         STA     var0,s;



;Ajoute h ou v dans la variable VAR1;
nextVar: ADDX    1,i;
         LDA     0,i;    
         LDBYTEA buffer,x;
         STBYTEA var1,s;
         LDA     0,i;


;(Colonne * 2) et ajoute dans la variable VAR2
         ADDX    1,i;
         LDA     0,i;
         LDBYTEA buffer,x;
         SUBA    'A',i;
         ASLA
         STA     var2,s;
         LDA     0,i;


;((Ligne * 2) -2 ) et ajoute dans la variable VAR3  

         ADDX    1,i; 
         LDA     0,i; 
         LDBYTEA buffer,x;
         SUBA    '0',i;      
         ASLA
         SUBA    2,i;
         STA     var3,s;



; Verifier si il rentre avec longueur du tableau + la position  (limite Horizontale ou Verticale)

LDA              0,i;
LDBYTEA          var1,s;
CPA              'h',i;
BREQ             hCheck
BR               vCheck  
stop



; Limite verticale ( var0 + var3 <= 9lignes *2)
vCheck:  LDA     0,i
         LDA     var0,s
         ASLA
         ADDA    var3,s
         CPA     18,i
         BRLE    insert             
         BR      finAdd           ;sinon passer au prochain bateau (avancer le pointeur +4





; Limite horizontale ( var0 + var2 <= 18Colonnes*2)

hCheck:  LDA     0,i              ; Load '> dans l'accumulateur
         LDBYTEA '>',i       
         STBYTEA var1,s  
         
         LDA     0,i;
         LDA     var0,s;
         ASLA
         ADDA    var2,s;
         CPA     36,i;
         BRLE    insert                 
         BR  finAdd;              ;sinon passer au prochain bateau (avancer le pointeur +4
         



;a CHANGER pour une methode inserer a la position
; In:  A=Longueur de Ligne (a faire *2 - 2)
;      X=Longueur de colonne ( a faire *2)

insert:  LDX     var3,s           ;insertion du pointeur (iX)
         LDA     tableau,x        ;Rangee choisi du tableau   
         STA     ptr,d;
         STX     var3,s;
         LDX     ptr,d            ;tableau[i]
         ADDX    var2,s           ;tableau[i][j]   Decalage de colonne (jx)

  

;Compare pour brancher: /ajout des bateaux horizontales OU verticale/
         
         LDA     0,i;
         LDBYTEA var1,s; 
         CPA     '>',i;     
         BREQ    srtLoopH;
                 


;Loop ADD d'un bateau verticale

         LDA     0,i;
addLoopV:CPA     var0,s;
         BRGE    finAdd   
         LDA     0,i;
         LDBYTEA var1,s;
         STA     0,x
       
         LDX     var3,s           ;insertion du pointeur (iX)
         ADDX    2,i              ;Changement d'adresse (ix)              
         LDA     tableau,x;    
         STA     ptr,d;
         STX     var3,s;
         LDX     ptr,d;           ;tableau[i+2]
         ADDX    var2,s;          ;tableau[i+2][j]   Decalage de colonne (jx)
         LDA     ptrAdd,d; 
         ADDA    1,i;
         STA     ptrAdd,d;
         LDA     ptrAdd,d;
         BR      addLoopV




         
;Loop ADD d'un bateau horizontale

srtLoopH:LDA     0,i;
addLoopH:CPA     var0,s;
         BRGE    finAdd   
         LDA      0,i;
         LDBYTEA var1,s;
         STA      0,x
         ADDX     2,i
         LDA     ptrAdd,d; 
         ADDA    1,i;
         STA     ptrAdd,d;
         LDA     ptrAdd,d;
         BR      addLoopH



      
finAdd:  LDA     0,i;            
         STA     ptrAdd,d;
         LDX     0,i;
         LDX     sauveX,s
         ADDSP   10,i        ;dereserve #var0 #var1 #var2 #var3 #sauveX 
    
         RET0
  
         

var0:         .EQUATE 8           ;#2d
var1:         .EQUATE 6           ;#2d
var2:         .EQUATE 4           ;#2d
var3:         .EQUATE 2           ;#2d
sauveX:       .EQUATE 0           ;#2d 
ptrAdd:       .BLOCK  2           ;#2d
test5:        .BLOCK       2;






;--------------- CONSTANTES ------------------------------;
msgPlace:.ASCII            "Vous avez mal entrez les bateaux, veuillez replacer\n\x00"; 
msgTire:.ASCII            "Entrez vos tire\n\x00"; 
msgRTire:.ASCII            "Ils Restentet des bateaux a couler\n\x00";
msgFin:.ASCII            "Ils ne reste plus de bateau! BRAVO\n\x00"; 
msgEnt:  .ASCII            "Veuillez placer les bateaux\n\x00"; 
msgErrT:.ASCII            "Vous avez mal entrez vos tires Au revoir\n\x00"; 

.END