; Serpent
; INF2171
; Organisation des ordinateurs et assembleur
; UQAM
; Hiver 2019
; @auteur Alex Dufour-Couture
; @codePermanent DUFA23059001 
; @auteur Jeremie Gour
; @codePermanent GOUJ18089208


main:    STRO    msgbvn,d
         call tb_vide

;        STRO    msgentr,d
mainLoop:LDA     buffer,i    ; A= buffer[mem]
         LDX     snakeSz,i   ; X= 0 
         CALL    STRI        ; STRI(buffer,size)
         SUBX    1,i;
         STX     snakeSz,d   ; Size de 1 serpent 
         DECO    snakeSz,d
         CHARO   '\n',i;
         STRO buffer,d;




         LDX 0,i; A5  A -0 , 5 =1 ;
         call alignT ; var0t et var1t



         DECO var0T,d;
         DECO var1T,d;

         call startLi
         charo '\n',i;

          call     afficher

         charo '\n',i;

         call verifR5
         CPA 0,i;
         BREQ vfConnex


         call mainLoop

;Les serpents passent par A5 et R5, maintenant verificer la connexion entre eux.
;Compter les points


vfConnex:  STOP







; // Lit la liste
startLi: LDA     snakeSz,d;        
         STA     cpt,d       
         LDA     hpPtr,d     
         STA     head,d      
loop_in: CPA     0,i         
         BRLE    out         ; for(cpt=10; cpt>0; cpt--) {
         LDA     mLength,i   
         CALL    new         ; X = new Maillon(); #mVal #mNext
         STX     adrMail,d  
;Inserer SnakeCpy ici
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
         ;LDBYTEA mVal,x  
         call    insert    
         CHARO   mVal,x      
         CHARO   ' ',i       ;       print(X.val + " ");}
         LDX     mNext,x     
         BR      loop_out    ; } // fin for
fin:     LDA    1,i;
         STA    snakeCpt,d; 
         RET0              
head:    .BLOCK  2           ; #2h tête de liste (0 si liste vide)
cpt:     .BLOCK  2           ; #2d compteur de boucle
adrMail: .BLOCK  2           ; #2h
snakeCpt:.WORD   1           ; #2d compteur longueur du serpent         
         




; INSERP: Insere le serpent dans la grille
;        In: X = Pointeur du debut de la liste chainee
;
inserp:  LDX     head,d
         



; CHAR_RD: Fetch une donner du buffer
;        In: X = Pointeur du caractere a aller chercher
;        Out: A= la valeur d'un byte pris dans le BUFFER [-,d,g]
char_rd: LDA     0,i
         LDA     buffer,i;
         LDBYTEA buffer,x;
         RET0;



; VERIFY: verifie le previous maillon  (if !HEAD && A= - ) sinon retourner >
; mettre le previous maillon dans le maillon present
;        In      A= un byte ( -,d ou g,)
;        Out     A= un byte (>,^,V,>)

verify:  STBYTEA tmp,d;      Byte temporaire a inserer
         LDA     0,i;
         LDBYTEA tmp,d
         CPA     '-',i;
         BREQ    garder;
         CPA     'g',i;
         BREQ    Lturn
Rturn:   call d_search         
         RET0
Lturn:   call g_search    
         RET0

      
         
         

; DEBUT DE GARDER LE PREVIOUS MAILLION
garder:  LDX     adrMail,d
         LDA     0,i         
         STA     mNext,x     ;   X.next = 0;
         CPX     head,d    
         BREQ    debutS    ;si le debut du serpent mettre >
         SUBX    mLength,i   
         LDBYTEA mVal,x  
         RET0
; FIN DE GARDER LE PREVIOUS MAILLON
debutS:  LDA 0,i;
         LDBYTEA '>',i;
         RET0;




; EFFECTUE les virages a DROITE dependant de la position du maillon precedent
d_search:LDX     adrMail,d
         LDA     0,i         
         STA     mNext,x     ;   X.next = 0;
         CPX     head,d    
         BREQ    debutS    ;si le debut du serpent mettre >
         SUBX    mLength,i   
         LDBYTEA mVal,x 
         CPA     '>',i;
         BREQ    plus24
         CPA     '<',i;
         BREQ    plus34
         CPA     '^',i;
         BREQ    moin32
         SUBA 26,i
         RET0

plus34:  ADDA    34,i;
         RET0

moin32:  SUBA    32,i;
         RET0

         STOP
plus24:  ADDA 24,i;
         RET0




;EFFECTUE les virages a GAUCHE dependant de la position du maillon precedent

g_search:LDX     adrMail,d
         LDA     0,i         
         STA     mNext,x     ;   X.next = 0;
         CPX     head,d    
         BREQ    debutS    ;si le debut du serpent mettre >
         SUBX    mLength,i   
         LDBYTEA mVal,x 
         CPA     '>',i;
         BREQ    plus32
         CPA     '<',i;
         BREQ    plus26
         CPA     '^',i;
         BREQ    moin34
         SUBA 24,i
         RET0

moin34:  SUBA    34,i; 
         RET0

plus26:  ADDA    26,i;
         RET0

         STOP
plus32:  ADDA 32,i;
         RET0


tmp:     .BLOCK 2;           #2h 




; alignT: Initialize VAR0T et VAR1T au positionnement necessaire reel du grid
;        IN      X= Ptr du buffer
;        OUT     A=position de la colonne a placer
;                X=position de la ligne a placer

;(Colonne * 2) et ajoute dans la variable VAR0T
alignT:  LDA     0,i
         LDBYTEA buffer,x
        ; STX     ptrTire,d
         SUBA    'A',i
         ASLA
         STA     var0T,d
         LDA     0,i

;((Ligne * 2) -2 ) et ajoute dans la variable VAR1T  
         ADDX    1,i
         LDA     0,i
         LDBYTEA buffer,x
         SUBA    '0',i      
         ASLA
         SUBA    2,i
         STA     var1T,d
        ; LDX     ptrTire,d     
         RET0

var0T:   .BLOCK  2           ;#2d
var1T:   .BLOCK  2           ;#2d
;ptrTire: .BLOCK  2




; In:  A = Variable mVal a sauvegarder;
;        X = position rendu au dans la liste chainee

;        Out: X -> Inchangee

insert:  STBYTEA sauveA,d; 
         STX     sauveX,d;
         LDA     0,i;
         LDX     var1T,d           ; insertion du pointeur (iX)
         LDA     tableau,x        ; rangee choisie du tableau   
         STA     ptr,d 
         STX     var1T,d
         LDX     ptr,d            ; tableau[i]
         ADDX    var0T,d           ; tableau[i][j]   Decalage de colonne (jx)
         
;LOAD byte d'un tableau
         LDA     0,i
         LDA 0,x;
         CPA ' ',i;
         BRNE arret

         LDA 0,i;
         LDA sauveX,d;
         STA     0,x



         LDA     0,i;
         LDX sauveX,d;
         LDX mNext,x;
         LDBYTEA mVal,x;
         
      
         CPA '>',i;
         BREQ droit
         CPA'<',i;
         BREQ gauche
         CPA'^',i;
         BREQ haut
         CPA'V',i;
         BREQ bas;

haut:    LDX var1T,d; 
         SUBX    2,i;
         STX var1T,d;
         BR finInsrt

bas:     LDX var1T,d; 
         ADDX    2,i;
         STX var1T,d;
         BR finInsrt
    
droit:   LDX var0T,d; 
         ADDX    2,i;
         STX var0T,d;
         BR finInsrt
         
gauche:  LDX var0T,d; 
         SUBX    2,i;
         STX var0T,d;
         BR finInsrt

finInsrt:LDX     sauveX,d;
         LDBYTEA sauveA,d;
         RET0;

arret:   CHARO '\n',i;
         call afficher;
         STRO msgfin,d;

         STOP;


sauveA:  .block 2;
sauveX:  .block 2;





; Verification si il y'a un serpent dans R5
;        OUT: A = 0 si faut compter les point 
;             A = 1 si le jeu continue                                
                 

verifR5: LDX     8,i;
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    34,i;
         LDA     0,x;
         STBYTEA  valR5,d;
        
         LDA     0,i
         LDBYTEA valR5,d; 
         CPA     ' ',i;
         BRNE    verifA5
         BR cont



verifA5: LDX     8,i;
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    0,i;
         LDA     0,x;
         STBYTEA  valA5,d;

         
         LDA     0,i     
         LDBYTEA valA5,d; 
         CPA     ' ',i;
         BRNE    points
         BR cont
  
points: LDA 0,i;
         RET0;


cont:   LDA   0,i
        ADDA 1,i;
         RET0;


valR5:   .BLOCK 2;
valA5:   .BLOCK 2;



















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



; Verifie qu'une colonne est valide (de [A] a [R]).        
A_R:     CHARI   0,x         ;   *X = getChar();
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
         ADDX    1,i
         CHARI   0,x
         LDA     0,i         
         LDBYTEA 0,x
         BR      next


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





next:    CPA     '-',i
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






; Remplie une grille de jeu par des vagues ['~'].
; Borne par des ['|'].
;        IN = /
;        OUT = /
tb_vide: LDX     ix,d        
         STX     ix,d

i_loop:  LDX     ix,d; 
         CPX     tab_fin,i
         BRGE    finT     

         
         LDX     0,i
         STX     jx,d
              
j_loop:  CPX     40,i
         BRGE    next_ix
         LDX     ix,d
         LDA     tableau,x
         STA     ptr,d
         LDX     ptr,d
         ADDX    jx,d       
         LDA     0,i
         LDA ' ',i
         STA     0,x
         LDX     jx,d
         ADDX    2,i
         STX     jx,d
         BR      j_loop

next_ix: LDX     ix,d
         ADDX    2,i
         STX     ix,d   
         BR      i_loop     
finT:     LDX 0,i; 
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
afficher:SUBSP 2,i;          reserve  #tabAdd 
         STRO    col_aff,d
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
         LDA     0,i
         LDBYTEA     0,x

         CPA     ' ',i;
        BRNE affSerp
         CHARO   0,x
        BR nextJ

affSerp: LDA     0,i
         LDA 0,x
         STA tabAdd,s
         CHARO tabAdd,sf;


         
nextJ:   LDX     jx,d
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
         ADDSP   2,i; dereserve  #tabAdd 
         RET0

nb_ligne:.WORD   1           ; Affichage des numeros de ligne         
col_aff: .ASCII  " ABCDEFGHIJKLMNOPQR\n\x00"

tabAdd:        .EQUATE 0; #2d






; Messages d'affichage a l'ecran
msgbvn:  .ASCII  "Bienvenue au serpentin!\n\x00"
msgentr: .ASCII  "\nEntrer un serpent qui part vers l'est: {position initiale et parcours} avec [-] (tout droit), [g] (virage à gauche), [d] (virage à droite)\n\x00"
msgerr:  .ASCII  "Erreur d'entrée. Veuillez recommencer.\n\x00"
msgfin:  .ASCII  "Le serpent est mort! Fin du jeu.\x00"
msgscore:.ASCII  "Fin! Score: \x00"
tmp2:    .BLOCK 2;





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