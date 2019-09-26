
         STRO MSG_M,d; Message nomnbre de match a jouer

         DECI nbmtch,d; entre le nombre de match a jouer.

         LDA nbmtch,d ; LOAD le nombre de match
         ANDA 0x0001,i ; Si ce n'est pas egale a 1 le dernier bit ->
         BREQ impaire ; aller a impaire
         BR pair ; sinon branche pair;

impaire: LDA nbmtch,d;
         ADDA 1,i; IF EVEN ADD TO ACCUMULATOR +1; 
         STA nbmtch,d;
         

pair:    LDA 0,i; REFRESH l'accumulateur a 0

         
while:   LDA 0,i;
         LDA '*',i;
         STA choix1,d;
         LDA 0,i;
         LDA '*',i;
         STA choix2,d; RESET a 0

         STRO    MSG1,d      ;
         CHARI   tmp,d       ;

         LDA 0,i;

isNotRPC:LDBYTEA tmp,d ; LOAD dans l'accumulateur la valeur dans tmp 
         CPA  114, i ; COMPARE l'accumulateur a la lettre `r` immediat 
         BRNE    nextp; if (tmp !=<r> && != <p> && != <c>) { fin du programme (arrete) }
         BR assigner;

nextp:   CPA     'p',i  
         BRNE    nextc  
         BR assigner;         
      
nextc:   CPA     'c',i  
         BRNE    arrete 
         BR assigner;


assign1:STBYTEA choix1,d; STORE le premier byte 
 

vider:   CHARI enter,d; INSERE LE \n dans l'accumulateur
         LDBYTEA enter,d; LOAD la valeur dans l'accumulateur
         CPA '\n',i; COMPARE cette VALEUR si elle n'est pas un next line arrete le script.
         BRNE arrete;

         LDX choix2,d; Si la valeur de choix2 n'est pas "nulle' passer au programme main
         CPX '*',i; la valeur nulle
         BRNE main; si ce n'est pas egaux a '*", passer a main.

         STRO    MSG2,d      ;
         CHARI   tmp,d       ; INSERE le `char` dans la variable `tmp`
         BR isNotRPC; verification de R,P ou C


assigner: LDX choix1, d;
          CPX '*', i;
          BREQ assign1; 


          STBYTEA choix2,d;
          BR vider;

     


arrete: STRO    MSG_ERR,d  
        STOP

mtchnul: STRO egale,d;
         LDA 0,i;
         LDA nbmtch,d;
         ADDA 1,i;
         STA nbmtch,d;
         DECO nbmtch,d;
         BR while


verifier: LDA 0,i; DEBUT -> verification de points, si est suffisant pour gagner.
         LDA nbmtch,d; 
         ASRA ; Nombre de Match / 2
         ADDA 1,i; (Nombre de Match  +1) dans l'accumulateur
         CPA points1,d; if ( points1 == (nombreDeMatch/2)+1)
         BREQ termine1; 

         CPA points2,d; if ( points2 == (nombreDeMatch/2)+1)     
         BREQ termine2; Brancher au gagnant (joueur 2)
         BR i; FIN -> si aucun gagnant brancher a l'iteration

i:      LDA 0,i; DEBUT -> boucle d'iteration
        LDA iterate,d; valeur de [i] 
        ADDA 1,i;            i+1;
         STA iterate,d;      iterate = i;
         CPA nbmtch,d;       while (iterate < nombreDeMatch )
         BRLT while;          {continue program} else
         STRO termine,d;          S.O.P termine
         BR arrete;              STOP

gagner2:  STRO gagnant2,d;
         LDA 0,i;
         LDA points2,d;
         ADDA 1,i;
         STA points2,d;
         LDA 0,i;
         BR verifier;

gagner1:  STRO gagnant1,d;
         LDA 0,i;
         LDA points1,d; Load le nombre de points pour Joueur 1
         ADDA 1,i;           Ajoute +1 a son pointage
         STA points1,d;      Store la nouvelle valeure dans points1

      
         BR verifier;

termine1: STRO joueur1,d;
         DECO points1,d; 
         STOP;

termine2: STRO joueur2,d;
         DECO points2,d;
         STOP;

main:    LDA 0,i;
         LDA choix1,d;
         CPA choix2,d;
         BREQ mtchnul; Verifie si le choix du joueur 1 et 2 sont egaux
         
         LDA 0,i; Reset L'accumulateur
         LDBYTEA choix1,d; verifie si choix1 est egale a "papier (112);
         CPA 112,i; if choix1 && choix 2 != 112
         BREQ arrete; sinon passer a autre calcul ( incluant papier)

         LDBYTEA choix2,d; verifie si choix2 est egale a "papier (112);
         CPA 112,i;
         BREQ arrete; sinon passer a autre calcul ( incluant papier)

         LDA 0,i;
         LDA choix2,d;       Sinon comparer Roche et Ciseaux;
         CPA choix1,d;       Si L'accumulateur (choix2 est > choix1)
         BRGT gagner2;       Joueur 2 vers gagnant2
         BR   gagner1;       SINON Joueur 1 vers gagnant1
         

         CHARO   choix1,d    ;
          

         CHARO   '\n',i   ;
         CHARO choix2,d;
         CHARO   '\n',i   ;
 


  
         


         
     
next: DECO nbmtch,d

         STRO END,d;
          
         STOP                


enter: .BLOCK 2;
dummy: .BLOCK 2   ;
tmp:     .BLOCK   2           ;
iterate: .WORD 0 ; 
nbmtch:  .WORD 2;
egale:   .ASCII "Les valeurs sont egaux, jouer une autre fois\n\x00"; 
choix1:  .WORD '*'          ; 
choix2:  .WORD '*'          ;
points1: .WORD 0;
points2: .WORD 0; 
MSG_ENT: .ASCII  "Bienvenue a Roche-Papier-Ciseaux\x00";
MSG1:    .ASCII  "JOUEUR 1, quel est votre choix? [r/p/c]\n\x00";
MSG2:    .ASCII  "JOUEUR 2, quel est votre choix? [r/p/c]\n\x00";
MSG_ERR: .ASCII  "\nERREUR DENTREE - JEUX TERMINER\x00";
MSG_M:   .ASCII  "\nVeuillez entrer le nombre de match a jouer\n\x00";
gagnant1:    .ASCII  "JOUEUR 1: +1 points!\n\x00";
gagnant2:    .ASCII  "JOUEUR 2: +1 points!\n\x00";
termine:        .ASCII "le nombre de match est terminer";
joueur1: .ASCII "joueur1 est le gagnant avec un score de : \x00";
joueur2: .ASCII "joueur2 est le gagnant avec un score de : \x00";
END: .ASCII "\nend of program \n\x00";
         .END                  