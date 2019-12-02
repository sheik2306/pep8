; INF2171
; Organisation des ordinateurs et assembleur
; UQAM
; Hiver 2019
; @auteur Alex Dufour-Couture
; @codePermanent DUFA23059001 
; @auteur Jeremie Gour
; @codePermanent GOUJ18089208

; Ce programme permet a l'utilisateur de jouer une partie d'un jeu de bataille navale.
; Il affiche une grille de jeu sur laquelle l'utilisateur place des bateaux et effectue des tirs.
; Le programme se termine lorsque tous les bateaux ont ete coules.

; Debut du programme
         STRO    msgDebut,d
E_loop:  STRO    msgEnt,d    ; Affiche le message de demande de saisie des tirs
         LDA     buffer,i
         LDX     size,i 
         CALL    STRI        ; STRI(buffer,size)
         STX     bufferSz,d
         CHARO   '\n',i


; Cree un tableau vide.
         CALL tb_vide
         CALL tb_vide
   
; Place les bateaux un par un sur la grille.
         LDX     0,i
B_loop:  CPX     bufferSz,d  ; while (resteBateauxAPlacer){
         BRGE    afficheB
         CALL    verifBat
         ADDX    4,i
         BR      B_loop 
afficheB:CALL    afficher
         CALL    verifTab
         BR      TB_Start

TB_Loop: STRO    msgRTire,d
TB_Start:STRO    msgTir,d

; Place les tirs saisis dans un tampon.
         LDA     bufferT,i    
         LDX     size,i      
         CALL    striT        ; STRI(buffer,size);
         STRO    bufferT,d  
         STX     buffSzT,d
         CHARO   '\n',i 

; Insere les numeros de ligne et les lettre des colonnes dans des variables.
         LDX     0,i 
T_Loop:  CPX     buffSzT,d
         BRGE    finMain
         CALL    alignT

; Prepare le sous-programme insertT avec la ligne et la colonne en entree.
         LDA     var0T,d
         LDX     var1T,d
         call    insertT
         LDX     ptrTire,d
         ADDX    2,i
         BR      T_Loop

; Affiche la grille et termine le jeu de bataille navalle.       
finMain: CALL    afficher      
         CALL    verifTab
finjeux: STRO    msgFin,d  

         CHARI rejouer,d;
         LDA 0,i;
         LDBYTEA rejouer,d;
         CPA '\n',i;
         BREQ vide_tp;
         STOP




; Verifie une grille de jeu de dimension 9x18.
verifTab:LDX     0,i;        
         STX     ix,d
         STX     jx,d

iLoop:   CPX     18,i
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
         LDA     0,x
         CPA     'v',i
         BREQ    TB_Loop
         CPA     '>',i
         BREQ    TB_Loop  
         LDX     jx,d
         ADDX    1,i
         STX     jx,d
         BR      jLoop

nextI:   LDX     ix,d
         ADDX    2,i
         STX     ix,d
         BR      iLoop  
   
finVerif:LDA     1,i
         STA     nb_ligne,d
         BR      finjeux
         RET0




; Effectue les tirs et verifie les positions adjacentes d'un tir de facon recursive.
;        IN      A=Colonne
;                X=Ligne
insertT: SUBSP   4,i         ;reserve #sauveCol #sauveLig 
         STA     sauveCol,s
         STX     sauveLig,s

; Verifie si un tir peut etre ajoute a la cellulle.
         LDX     sauveLig,s
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    sauveCol,s
         LDA     0,i
         LDA     0,x
         CPA     'v',i
         BREQ    couler
         CPA     '>',i
         BREQ    couler
         CPA     '*',i
         BREQ    finTire
       
; Si une vague est dans la celulle, effectue le tir.
         LDA     'o',i
         STA     0,x
         BR      finTire
couler:  LDA     '*',i
         STA     0,x

; Verifie de facon recursive si la cellulle en haut du tir effectue est valide.
         LDA     sauveCol,s      
         LDX     sauveLig,s
         CPX     0,i
         BRLE    verif_B
         SUBX    2,i
         call    insertT

; Verifie de facon recursive si la cellulle en bas du tir effectue est valide.
verif_B: LDA     sauveCol,s
         LDX     sauveLig,s
         CPX     16,i
         BRGE    verif_D
         ADDX    2,i
         call    insertT
         
; Verifie de facon recursive si la cellulle a droite du tir effectue est valide.
verif_D: LDA     sauveCol,s
         CPA     34,i        ; Compare avec la borne de droite de la grille.                               
         BRGE    verif_G
         ADDA    2,i
         LDX     sauveLig,s    
         call    insertT

; Verifie de facon recursive si la cellulle a gauche du tir effectue est valide.
verif_G: LDA     sauveCol,s
         CPA     0,i         ; Compare avec la borne de gauche de la grille.
         BRLE    finTire
         SUBA    2,i  
         LDX     sauveLig,s
         call    insertT

finTire: ADDSP   4,i         ; dereserve #sauveCol #sauveLig 
         LDX     0,i
         RET0

sauveCol:.EQUATE 2           ;#2d
sauveLig:.EQUATE 0           ;#2d 


; alignT: Initialize VAR0T et VAR1T au positionnement necessaire reel du grid
;        IN      X= Ptr du buffer
;        OUT     A=position de la colonne a placer
;                X=position de la ligne a placer

;(Colonne * 2) et ajoute dans la variable VAR0T
alignT:  LDA     0,i
         LDBYTEA bufferT,x
         STX     ptrTire,d
         SUBA    'A',i
         ASLA
         STA     var0T,d
         LDA     0,i

;((Ligne * 2) -2 ) et ajoute dans la variable VAR1T  
         ADDX    1,i
         LDA     0,i
         LDBYTEA bufferT,x
         SUBA    '0',i      
         ASLA
         SUBA    2,i
         STA     var1T,d
         LDX     ptrTire,d     
         RET0

var0T:   .BLOCK  2           ;#2d
var1T:   .BLOCK  2           ;#2d
ptrTire: .BLOCK  2

     






;StriT : Verifie si un caractere est valide ([A] a [R]).
; IN     A = addresse du tampon
;        X = taille du buffer   
; OUT    X = taille du tampon                                   
                 
; 
striT:   STA     striPtr,d   ; sauve A;
         ADDX    striPtr,d   
         STX     striPtr2,d  ; striPtr2 = A+X;
         LDX     striPtr,d   ; X = striPtr;

strLoopT:CPX     striPtr2,d  ; while(true) {
         BRGE    striErr     ;   if(X>=striPtr2) new Error();
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     'A',i
         BRLT    striErrT
         CPA     'R',i
         BRGT    striErrT
         BR      un_neufT

; Verifie si un caractere est valide ([1] a [9]).
un_neufT:ADDX    1,i
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     '1',i
         BRLT     striErrT
         CPA     '9',i
         BRGT    striErrT
         BR      enterT


; Verifie si un espace ou un '\n' suit la chaine de caracteres.
; S'il y'a un espace, retourne au debut de la boucle.
enterT:  ADDX    1,i
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i
         LDBYTEA 0,x
         CPA     ' ',i
         BREQ    strLoopT

         CPA     '\n',i      
         BREQ    striFinT 
         ADDX    1,i         ;   X++;
         BR      strLoopT    ; } // fin boucle infinie
striFinT:LDBYTEA 0,i         
         STBYTEA 0,x         ; *X='\x00';
         SUBX    striPtr,d   ; X = X-striPtr
         LDBYTEA striPtr,d   ; restaure A;
         RET0                ; return;

striErrT:STRO    msgErrT,d                
         STOP  

bufferT: .BLOCK  200          ; Initialise un tampon pouvant contenir 100 caracteres.
buffSzT: .BLOCK  2











; Remplie une grille de jeu par des vagues ['~'].
; Borne par des ['|'].
;        IN = /
;        OUT = /
tb_vide: LDX     ix,d        
         STX     ix,d

i_loop:  LDX     ix,d; 
         CPX     tab_fin,i
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
         LDA '~',i
         STA     0,x
         LDX     jx,d
         ADDX    2,i
         STX     jx,d
         BR      j_loop

next_ix: LDX     ix,d
         ADDX    2,i
         STX     ix,d   
         BR      i_loop     
fin:     LDX 0,i;
         STX ix,d;
         LDX 0,i;
         STX jx,d;
         RET0

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








; afficher: Affiche un tableau de taille 9x18.
;        IN = /
;        OUT = /
afficher:STRO    col_aff,d
         LDX     0,i
         STX     ix,d
         STX     jx,d
i_loo:   CPX     18,i
         BRGE    finaff

; Affiche les numeros de ligne de la grille de jeu.  
         LDA     nb_ligne,d
         DECO    nb_ligne,d
         ADDA    1,i
         STA     nb_ligne,d   
; Fin affichage des numeros de ligne
         LDX     0,i
         STX     jx,d
j_loo:   CPX     40,i
         BRGE    next_i
         LDX     ix,d
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    jx,d
         CHARO   0,x
         LDX     jx,d
         ADDX    1,i
         STX     jx,d
         BR      j_loo
next_i:  CHARO    '\n',i
         LDX     ix,d
         ADDX    2,i
         STX     ix,d
         BR      i_loo     
finaff:  LDA     1,i
         STA     nb_ligne,d
         RET0

nb_ligne:.WORD   1           ; Affichage des numeros de ligne         
col_aff: .ASCII  " ABCDEFGHIJKLMNOPQR\n\x00"








; STRI: lit une ligne dans un tampon et place '\x00' a la fin.
; In:  A = Adresse du tampon
;      X = Taille du tampon en octet
; Out: A = Adresse du tampon (inchang?)
;      X = Nombre de caracteres lu (ou offset du '\x00')
; Err: Avorte si le tampon n'est pas assez grand pour
;      stocker la ligne et le '\0' final
STRI:    STA     striPtr,d   ; sauve A;
         ADDX    striPtr,d   
         STX     striPtr2,d  ; striPtr2 = A+X;
         LDX     striPtr,d   ; X = striPtr;
striLoop:CPX     striPtr2,d  ; while(true) { 
         BRGE    striErr     ;   if(X>=striPtr2) new Error();

         
; Verifie une taille de bateau valide ([p],[m], ou [g]).
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x 
         CPA     'p',i
         BRNE    lettre_m
         BR      lettre_h
lettre_m:CPA     'm',i
         BRNE    lettre_g
         BR      lettre_h
lettre_g:CPA     'g',i
         BRNE    striErr


; Verifie un alignement de bateau valide ([h] ou [v]).        
lettre_h:ADDX    1,i
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     'h',i
         BRNE    lettre_v
         BR      A_R

lettre_v:CPA     'v',i
         BRNE    striErr
         BR      A_R

; Verifie qu'une colonne est valide (de [A] a [R]).        
A_R:     ADDX    1,i
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     'A',i
         BRLT    striErr
         CPA     'R',i
         BRGT    striErr
         BR      un_neuf

; Verifie qu'une ligne est valide (de [1] a [9]).        
un_neuf: ADDX    1,i
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     '1',i
         BRLT     striErr
         CPA     '9',i
         BRGT    striErr
         BR      enter


; Verifie que le cinquieme caractere d'une chaine est bien un [' '] ou un ['\n'].        
; S'il y'a un espace, retourner au debut de la boucle qui place les bateaux (striLoop).
enter:   ADDX    1,i
         CHARI   0,x         ;   *X = getChar();
         LDA     0,i         
         LDBYTEA 0,x
         CPA     ' ',i
         BREQ    striLoop

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

; Variables locales et constantes
estRendu:.ASCII  "Cest rendu ou tu veux\n\x00";              
striEMsg:.ASCII  "STRI erreur: d?bordement de capacit?\n\x00"
striPtr: .BLOCK  2           ; #2d adresse de debut du tampon 
striPtr2:.BLOCK  2           ; #2d adresse de fin de tampon
buffer:  .BLOCK  200         ; Buffer for the string
bufferSz:.BLOCK  2
size:    .EQUATE 200         ; Size of the buffer
msg_err: .ASCII  "Vous n'avez pas rentrer un bon format,recommencer\n\x00"
            
; Vide le tampon si l'entree d'utilsateur est invalide.
vide_tp: CPA     '\n',i
         BREQ    E_loop
         CHARI   tmp,d
         LDBYTEA tmp,d
         BR      vide_tp
tmp:     .BLOCK  2           







; VF_BAT: lit un buffer de 4 espace et insere les bateaux
; In:  X=Pointeur du buffer
; Out: X=Pointeur du buffer inchanger, OU si ne rentre pas Pointeur du bateau + 4
; determine la grosseur du bateau et place dans la variable VAR0
verifBat:SUBSP   10,i ; reserve #var0 #var1 #var2 #var3 #sauveX 
         STX     sauveX,s 
         LDA     0,i
         LDBYTEA buffer,x
         CPA     'm',i
         BREQ    trois
         CPA     'g',i
         BREQ    cinq
         LDA     0,i
         ADDA    1,i
         STA     var0,s
         BR      nextVar
      
cinq:    LDA     0,i
         ADDA    5,i
         STA     var0,s   
         BR      nextVar

trois:   LDA     0,i
         ADDA    3,i
         STA     var0,s

;Ajoute [h] ou [v] dans la variable VAR1;
nextVar: ADDX    1,i
         LDA     0,i  
         LDBYTEA buffer,x
         STBYTEA var1,s
         LDA     0,i

;(Colonne * 2) et ajoute dans la variable VAR2.
         ADDX    1,i
         LDA     0,i
         LDBYTEA buffer,x
         SUBA    'A',i
         ASLA
         STA     var2,s
         LDA     0,i

;((Ligne * 2) -2 ) et ajoute dans la variable VAR3.  
         ADDX    1,i
         LDA     0,i
         LDBYTEA buffer,x
         SUBA    '0',i   
         ASLA
         SUBA    2,i
         STA     var3,s

; Verifie si le bateau peut etre insere entre les bornes de la grille de jeu.
         LDBYTEA var1,s
         CPA     'h',i
         BREQ    hCheck
         BR      vCheck  
         

; Verifie si le bateau peut etre insere entre les bornes verticales de la grille de jeu.
vCheck:  LDA     0,i
         LDA     var0,s
         ASLA
         ADDA    var3,s
         CPA     18,i
         BRLE    subPosV             
         BR      finAdd      ;sinon, passe au prochain bateau du tampon.

subPosV: LDX     var3,s           ; insertion du pointeur (iX)
         STX     stockV,d;

         LDA     0,i;
subVLoop:CPA     var0,s;
         BRGE    insert
         LDX     stockV,d;
         LDA     tableau,x        ; rangee choisie du tableau   
         STA     ptr,d
         LDX     ptr,d            ; tableau[i]
         ADDX    var2,s           ; tableau[i][j]   Decalage de colonne (jx)



vSubChek:LDA     0,i
         LDA     0,x              ;
         CPA     '>',i;
         BREQ    finAdd
         CPA     'v',i
         BREQ    finAdd; 
         LDX     stockV,d;
         ADDX    2,i
         STX     stockV,d; 
         LDA     ptrV,d;
         ADDA    1,i;
         STA     ptrV,d;
         BR      subVLoop 





; Verifie si le bateau peut etre insere entre les bornes horizontales de la grille de jeu.
hCheck:  LDA     0,i              
         LDBYTEA '>',i       
         STBYTEA var1,s           
         LDA     0,i
         LDA     var0,s
         ASLA
         ADDA    var2,s
         CPA     36,i
         BRLE    subPosH                 
         BR      finAdd      ; sinon passer au prochain bateau du tampon.


subPosH: LDX     var3,s           ; insertion du pointeur (iX)
         LDA     tableau,x        ; rangee choisie du tableau   
         STA     ptr,d
         STX     var3,s
         LDX     ptr,d            ; tableau[i]
         ADDX    var2,s           ; tableau[i][j]   Decalage de colonne (jx)
         BR Hcheck


subHLoop:CPA var0,s;
         BRGE insert;

Hcheck:  LDA     0,i
         LDA     0,x              ;
         CPA     '>',i;
         BREQ finAdd
         CPA     'v',i
         BREQ finAdd; 
         ADDX    2,i;
         LDA     ptrH,d;
         ADDA    1,i;
         STA     ptrH,d;
         BR subHLoop

ptrH:    .BLOCK 2; pointeur verificaiton de bateau
stockV:    .BLOCK 2; pointeur verificaiton de bateau
ptrV:    .BLOCK 2; pointeur verificaiton de bateau
       
; In:  A = Longueur de Ligne
;      X = Longueur de colonne
insert:  LDX     var3,s           ; insertion du pointeur (iX)
         LDA     tableau,x        ; rangee choisie du tableau   
         STA     ptr,d
         STX     var3,s
         LDX     ptr,d            ; tableau[i]
         ADDX    var2,s           ; tableau[i][j]   Decalage de colonne (jx)

; Compare pour brancher: 
; ajout des bateaux d'alignement horizontal ou vertical. 
         LDA     0,i
         LDBYTEA var1,s
         CPA     '>',i   
         BREQ    srtLoopH
                 
; Boucle qui ajoute un bateau d'alignement vertical.
         LDA     0,i
addLoopV:CPA     var0,s
         BRGE    finAdd   
         LDA     0,i
         LDBYTEA var1,s
         STA     0,x
       
         LDX     var3,s      ; insertion du pointeur (iX)
         ADDX    2,i         ; changement d'adresse (ix)              
         LDA     tableau,x   
         STA     ptr,d
         STX     var3,s
         LDX     ptr,d       ;tableau[i+2]
         ADDX    var2,s      ;tableau[i+2][j]   Decalage de colonne (jx)
         LDA     ptrAdd,d
         ADDA    1,i
         STA     ptrAdd,d
         LDA     ptrAdd,d
         BR      addLoopV

; Boucle qui ajoute un bateau d'alignement horizontal.
srtLoopH:LDA     0,i

addLoopH:CPA     var0,s
         BRGE    finAdd   
         LDA     0,i
         LDBYTEA var1,s
         STA     0,x
         ADDX    2,i
         LDA     ptrAdd,d
         ADDA    1,i
         STA     ptrAdd,d
         LDA     ptrAdd,d
         BR      addLoopH
      
finAdd:  LDA     0,i          
         STA     ptrAdd,d
         LDX     0,i
         LDX     sauveX,s
         ADDSP   10,i        ;dereserve #var0 #var1 #var2 #var3 #sauveX    
         RET0

; Variables globales         
var0:    .EQUATE 8           ;#2d taille du bateau
var1:    .EQUATE 6           ;#2d alignement du bateau
var2:    .EQUATE 4           ;#2d lettre de colonne
var3:    .EQUATE 2           ;#2d numero de ligne
sauveX:  .EQUATE 0           ;#2d
ptrAdd:  .BLOCK  2
test5:   .BLOCK  2
rejouer: .BLOCK  2           





; Messages d'affichage
msgPlace:.ASCII  "Vous avez mal entrez les bateaux, veuillez replacer\n\x00"
msgTir:  .ASCII  "Feu a volonte!\n(entrer les coups a tirer: colonne [A-R] rangee [1-9])\nex: A3 I5 M3\n\x00"
msgRTire:.ASCII  "Il reste encore au moins un bateau a couler!\n\x00";
msgFin:  .ASCII  "Vous avez aneanti la flotte!\nAppuyer sur <Enter> pour jouer a nouveau ou\nn'importe quelle autre saisie pour quitter.\n\x00"
msgEnt:  .ASCII  "Entrer la description et la position des bateaux\nselon le format suivant, separes par des espaces:\ntaille[p/m/g] orientation[h/v] colonne[A-R] rangee[1-9]\nex: ghC4 mvM2 phK9\n\x00"
msgErrT: .ASCII  "Les tirs saisis sont invalides. Fin du programme.\n\x00"
msgDebut:.ASCII  "Bienvenue au jeu de bataille navale!\n\x00"
         
         .END
; Fin du programme