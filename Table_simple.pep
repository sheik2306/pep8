         DECI    valeur,d; entrer un index mem[valeur]
         LDX     valeur,d;    Valeur = mem[valeur]
         ASLX
         LDA     table,x ;   Accumulateur = mem[table+x] (table[x]
         STA     case,d      ; case = meme[table+x]
         STRO    case,n      ; pointer l'adresse de la case table[5] = <se>

        


fin:     STOP 
valeur:  .BLOCK 2;               
errMsg:  .ASCII  "Caract�re invalide\n\x00"
c:       .BLOCK  1           ; #1c
case:    .BLOCK  2           ; #2h
table:   .ADDRSS sa          
         .ADDRSS sb          
         .ADDRSS sc          
         .ADDRSS sd          
         .ADDRSS se          
         .ADDRSS sf          
         .ADDRSS sg          
         .ADDRSS sh          
         .ADDRSS si          
         .ADDRSS sj          
         .ADDRSS sk          
         .ADDRSS sl          
         .ADDRSS sm          
         .ADDRSS sn          
         .ADDRSS so          
         .ADDRSS sp          
         .ADDRSS sq          
         .ADDRSS sr          
         .ADDRSS ss          
         .ADDRSS st          
         .ADDRSS su          
         .ADDRSS sv          
         .ADDRSS sw          
         .ADDRSS sx          
         .ADDRSS sy          
         .ADDRSS sz          
sa:      .ASCII  "alpha\x00" 
sb:      .ASCII  "bravo\x00" 
sc:      .ASCII  "charlie\x00"
sd:      .ASCII  "delta\x00" 
se:      .ASCII  "echo\x00"  
sf:      .ASCII  "fox-trot\x00"
sg:      .ASCII  "golf\x00"  
sh:      .ASCII  "hotel\x00" 
si:      .ASCII  "india\x00" 
sj:      .ASCII  "juliet\x00"
sk:      .ASCII  "kilo\x00"  
sl:      .ASCII  "lima\x00"  
sm:      .ASCII  "mike\x00"  
sn:      .ASCII  "november\x00"
so:      .ASCII  "oscar\x00" 
sp:      .ASCII  "papa\x00"  
sq:      .ASCII  "quebec\x00"
sr:      .ASCII  "romeo\x00" 
ss:      .ASCII  "sierra\x00"
st:      .ASCII  "tango\x00" 
su:      .ASCII  "uniform\x00"
sv:      .ASCII  "victor\x00"
sw:      .ASCII  "whiskey\x00"
sx:      .ASCII  "x-ray\x00" 
sy:      .ASCII  "yankee\x00"
sz:      .ASCII  "zulu\x00"  
         .END   