; Version originale
         LDX     index,d     ; X = mem[index] = 4
         CHARO   mot,x       ; mem[mot+X] = mem[mot+4] = 'X'
                             ; Sortir le 4ieme caractere a partir de 0

         STOP                
index:   .WORD   2           
mot:     .ASCII  "..DCX...." 
ptr:     .BLOCK  2           ; #2h
         .END                  