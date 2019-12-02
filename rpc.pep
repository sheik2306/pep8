;DUFA23059001 INF2171 Groupe 93
;Author: Alex Dufour-Couture
;Tp2 Jeu de roche papier ciseaux



         
;Message d'entree et verification de manche pair ou pas
         STRO MSG_ENT,d;
         CHARO '\n',i; 
         STRO MSG_M,d; Message nomnbre de match a jouer

         DECI nbmtch,d; 

         LDA nbmtch,d ;
         ANDA 0x0001,i ; si (A == 0) le nombre est pair 
         BREQ pair ; 
         BR impair ; 


;Methode qui ajoute +1 manche a un nombre pair
pair: LDA nbmtch,d;
         ADDA 1,i; 
         STA nbmtch,d;
         

impair:    LDA 0,i; REFRESH l'accumulateur a 0




;Message nombre de manches restantes et choix des joueurs         
while:   STRO nbManche,d     ; Message de manches a jouer
         LDA nbmtch,d;  
         SUBA iterate,d      ; (nbmtch - iterate) = le nombre de match restant
         STA  restant,d;
         DECO restant,d; 
         STRO nbManch2,d;

         LDA 0,i             ; reset les choixs a <*>
         LDA '*',i;
         STA choix1,d;
         LDA 0,i;
         LDA '*',i;
         STA choix2,d; 


         STRO    MSG1,d      ;
         CHARI   tmp,d       ;

         LDA 0,i;


;Compare les entrees s'ils sont <r>/<p>/ ou <c>
isNotRPC:LDBYTEA tmp,d ;
         CPA  114, i         ; COMPARE l'accumulateur a la valeur decimal de  `r` 
         BRNE    nextp; 
         BR assigner;

nextp:   CPA     'p',i  
         BRNE    nextc  
         BR assigner;         
      
nextc:   CPA     'c',i  
         BRNE    erreur; Si il ne sait pas rendu a assigner apres c, envoyer erreur
         BR assigner;


assign1:STBYTEA choix1,d; 
 


;Vide le ENTRER dans 'accumulateur' et le compare si 
;l'entree n'est <\n> lancer une erreur
vider:   CHARI enter,d; 
         LDBYTEA enter,d; 
         CPA '\n',i; 
         BRNE erreur;



         LDX choix2,d; 
         CPX '*',i; 
         BRNE main; si ce n'est pas egaux a '*", passer a main.


;Demande le choix a joueur 2
         STRO    MSG2,d      ;
         CHARI   tmp,d       ; 
         BR isNotRPC         ; Brancher vers la verification de R,P ou C




; assigne le choix a joueur 1 ou 2
assigner: LDX choix1, d;
          CPX '*', i;
          BREQ assign1; 


          STBYTEA choix2,d;
          BR vider;

     

;Message d'erreur et stop le program si l'input n'est pas bon
erreur: STRO    MSG_ERR,d  
        STOP


       
;Ajoute +1 a l'iterateur et retourne a la boucle while
i:      LDA 0,i              ; 
        LDA iterate,d        ; 
        ADDA 1,i;            
        STA iterate,d;      
        BR while



;Le main sera en 2 calcul. Un sans 'papier' et la methode calculp avec 'papier'
main:    LDA 0,i;
         LDA choix1,d;
         CPA choix2,d;
         BREQ mtchnul        ; Verifie si le choix du joueur 1 et 2 sont egaux
         
         LDA 0,i             ; Reset L'accumulateur
         LDBYTEA choix1,d    ; verifie si choix1 est egale a "papier (112);
         CPA 112,i           ; if choix1 && choix 2 != 112
         BREQ calculp        ; sinon passer a autre calcul ( incluant papier)

         LDBYTEA choix2,d    ; verifie si choix2 est egale a "papier (112);
         CPA 112,i;
         BREQ calculp        ; sinon passer a autre calcul ( incluant papier)

         LDA 0,i;
         LDA choix2,d;       Sinon comparer Roche et Ciseaux;
         CPA choix1,d;       Si L'accumulateur (choix2 est > choix1)
         BRGT gagner2;       Joueur 2 vers gagnant2
         BR   gagner1;       SINON Joueur 1 vers gagnant1


;Methode calculant le gagnant avec un des choix qui est 'papier'         
calculp: LDA 0,i;
         LDA choix1,d;
         CPA choix2,d;
         BRLT gagner1;
         BR gagner2;




;Match nul, aucune iteration++, affichier le score et refaire la manche
mtchnul: STRO egale,d;
      
         STRO manche,d; 
         DECO points1,d; 
         STRO tiret,d;
         DECO points2,d; 
         CHARO '\n',i;



         BR while



;Ajout d'un point au joueur 2      
gagner2: STRO gagnant2,d;
         LDA 0,i;
         LDA points2,d;
         ADDA 1,i;
         STA points2,d;
         LDA 0,i;
         BR verifier; Vers verification des points (si assez pour gagner)


;Ajout d'un point au joueur 1     
gagner1:  STRO gagnant1,d;
         LDA 0,i;
         LDA points1,d; Load le nombre de points pour Joueur 1
         ADDA 1,i;           Ajoute +1 a son pointage
         STA points1,d;      Store la nouvelle valeure dans points1
         BR verifier; 



; DEBUT -> verification de points, si est suffisant pour gagner.
verifier:LDA 0,i
         LDA nbmtch,d; 
         ASRA ; Nombre de Match / 2
         ADDA 1,i; (Nombre de Match  +1) dans l'accumulateur
         CPA points1,d; if ( points1 == (nombreDeMatch/2)+1)
         BREQ termine1; 

         CPA points2,d; if ( points2 == (nombreDeMatch/2)+1)  
         BREQ termine2; Brancher au gagnant (joueur 2)


;affiche le score apres une manche si il n'ya pas de gagnant 
         STRO manche,d; 
         DECO points1,d; 
         STRO tiret,d;
         DECO points2,d; 
         CHARO '\n',i;


         BR i; FIN -> si aucun gagnant brancher a l'iteration



;Messages des gagnants
termine1:   CHARO '\n',i;
         STRO fin1,d;
         BR fin;

termine2:   CHARO '\n',i;
         STRO fin2,d;
         BR fin;


;Affiche le score final et termine le programme
fin:     STRO manche,d; 
         DECO points1,d; 
         STRO tiret,d;
         DECO points2,d; 
         
         STOP;



enter: .BLOCK 2;
dummy: .BLOCK 2   ;
tmp:     .BLOCK   2           ;
iterate: .WORD 0 ; 
restant: .WORD 0;
nbmtch:  .WORD 2;
egale:   .ASCII "Manche Nulle... \x00";
choix1:  .WORD '*'          ; 
choix2:  .WORD '*'          ;
points1: .WORD 0;
points2: .WORD 0;
nbManche: .ASCII "\nIls restent \x00";
nbManch2: .ASCII " manche(s) à jouer. \n\x00"
MSG_ENT: .ASCII  "-----------------------------------------------\n";
         .ASCII  "---Bienvenue au jeu de roche-papier-ciseau ---\n";
         .ASCII  "-----------------------------------------------\n\x00";

MSG1:    .ASCII  "JOUEUR 1, quel est votre choix? [r/p/c]\n\x00";
MSG2:    .ASCII  "JOUEUR 2, quel est votre choix? [r/p/c]\n\x00";
MSG_ERR: .ASCII  "\nErreur d'entrée! Programme terminé.\x00";
MSG_M:   .ASCII  "\nCombien de manches voulez-vous jouer?\n\x00";
gagnant1:    .ASCII  "JOUEUR 1 a gagné cette manche! \x00";
gagnant2:    .ASCII  "JOUEUR 2 a gagné cette manche! \x00";
fin1: .ASCII "\nJOUEUR 1 A GAGNÉ LE MATCH! FÉLICITATIONS!\n\x00";
fin2:    .ASCII "\nJOUEUR 2 A GAGNÉ LE MATCH! FÉLICITATIONS!\n\x00";
termine:        .ASCII "le nombre de manche est terminer\n\x00";
manche: .ASCII "Score : \x00";
tiret: .ASCII " - \x00" ;
END: .ASCII "\nend of program \n\x00";
         .END                  