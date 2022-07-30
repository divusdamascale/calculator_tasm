.model small ;tipul de model de memorie (small)
.stack 100h ;cifraarul de octeti alocati stivei (100h=64d)
.data ;variabile definite si nedefinite in curs de alocare (declaratii de date)

m1 db 10,13,'Adunare:1$'
m2 db 10,13,'Scadere:2$'
m3 db 10,13,'Inmultire:3$'
m4 db 10,13,'Impartire:4$'
m5 db 10,13,'Alege o cifra:$'
m6 db 10,13,10,13,'Introduceti prima cifra:$'
m7 db 10,13,'Introduceti a doua cifra:$'
m8 db 10,13,10,13,'Rezultatul este:$' 

                           

cifra1 db ? ;?-rezervare fara initializare
cifra2 db ?
rezultat db ?
.code ;codul programului

    mov ax,@data ;initializarea segmentului de date
    mov ds,ax
	
	  
    mov dx,offset m1 ;dx primeste adresa mesajului 1(dx ~= pointer)
    mov ah,9 ;funtctia 9 pe int21 afiseaza pe ecran sirul pointat de reg DX
    int 21h ;se apeleaza intreruperea 21h
    
    mov dx,offset m2
    mov ah,9
    int 21h
    
    mov dx,offset m3
    mov ah,9
    int 21h
    
    mov dx,offset m4
    mov ah,9
    int 21h 
    
    
    mov dx,offset m5
    mov ah,9
    int 21h
    
  
    mov ah,1 ;functia 1 pe int21 preia un caracter in al
    int 21h
    mov bh,al ;pastram caracterul in bh, pentru a nu il pierde mai tarziu din al
    sub bh,48 ;convertim caracterul preluat mai sus intr o cifra
;0=48 in codul ASCII, cand introducem de ex 0, de la tastatura
;OS interpreteaza codul sau ASCII 48, asa ca sa ajungem la cifra adevarata
;scadem 48 din din acea cifra 0, ceea ce ne lasa in bh,in cazul nostru
;ASCII 0 ca sa putem face operatii cu el   

    cmp bh,1 ;comparam ,acum cifra, din bh cu cifra 1
    je adunare ; daca sunt egale sare la eticheta "adunare"
    
    cmp bh,2
    je scadere
     
    cmp bh,3
    je inmultire
    
    cmp bh,4
    je imp1
    
 
  adunare:
    mov dx, offset m6  ;se afiseaza sa se introduca prima cifra
    mov ah,9
    int 21h 
    
    mov ah,1  ;se citeste un caracter de la tastatura
    int 21h
    mov bl,al  ;se salveaza in bl pentru a nu se pierde
    
    mov dx, offset m7    ;se afiseaza sa se introduca a doua cifra
    mov ah,9
    int 21h 
    

    mov ah,1 
    int 21h
    mov cl,al ;se salveaza in cl pentrua  nu se pierde
    
    add al,bl ;se face operatia de adunare intre cele doua cifraere
    mov ah,0 ;setam ah 0 pentru a putea transorma rezultatul BCD (binary coded decimal)
    aaa   ;adjust after addition, se foloseste dupa functia add pentru a transforma
	;rezultatul din al in format bcd
    
    
    mov bx,ax ;mutam rezultatul stocat din ax ,in bx
    add bh,48 ;se transforma cifra salvata in segmentul bh in caracter ,pentru a putea fi afisata
    add bl,48 ;se transforma cifra salvata in segmentul bl in caracter ,pentru a putea fi afisata
    
 
    
    mov dx,offset m8 ;se afiseaza mesajul rezultatului
    mov ah,9
    int 21h
    
    
    mov ah,2 ;functia 2 afiseaza un caracter din dl
    mov dl,bh ;mutam in dl ,primul caracter al rezultatului nostru
    int 21h
    
    mov ah,2
    mov dl,bl ;mutam in dl, al doilea caracter al rezultatului nostru 
    int 21h
    
	;rezultatul va fi afisat de forma xx,unde daca rezultatul este o cifra, rezultatul va fi de forba 0x
    
    jmp exit ;sarim la eticheta care contine codul pentru incheierea normala a programului
    
    
imp1: ;am mai creat un pas catre eticheta ,deoarece offsetul era prea mare initial
jmp imp2

   scadere:
   ;citirea primei cifre
 
    mov dx,offset m6  
    mov ah,9
    int 21h 
    
    mov ah,1
    int 21h
    mov bl,al
    
	;citirea celei de a doua cifre
    mov dx, offset m7    
    mov ah,9
    int 21h 
 
    
    mov ah,1
    int 21h
    mov cl,al
    
	;calculul scaderii si transformarea lui in cod ascii pentru a putea fii afisat
    sub bl,cl
    add bl,48

;afisarea rezultatului
    mov dx,offset m8
    mov ah,9
    int 21h
    
    
    mov ah,2
    mov dl,bl
    int 21h
    
  
    jmp exit ;jump spre exit pentru incheierea programului
    
 
   inmultire:
 ;citirea primei cifre
    mov dx,offset m6 
    mov ah,9
    int 21h
    
    
    mov ah,1
    int 21h
	;transformarea caracterului citit in cifra pentru a putea fi folosit in operatii
	;salvarea acestuia in variabila cifra1 , pentru a nu fi pierduta
    sub al,48
    mov cifra1,al
    
    ;citirea celei de a doua cifre
    mov dx,offset m7
    mov ah,9
    int 21h 
    
    
    mov ah,1
    int 21h
	;transformarea caracterului citit in cifra pentru a putea fi folosit in operatii
	;salvarea acestuia in variabila cifra1 , pentru a nu fi pierduta 
    sub al,48
    mov cifra2,al
    
    
    mul cifra1 ; <=> al=al*cifra1 ,in al fiind cifra2,destinatia functiei mul este implicita ax, dar cum folosim doar cifre,rezultatul nu depaseste al deoarece nu depaseste 100
    mov rezultat,al ;mutam rezultatul stocat in al in variabila rezultat
    aam ;adjust ax after multiply, se foloseste dupa functia mul
	;transforma rezultatul stocat in format BCD,impartind AL la 10
	;stocand cel mai semnificativ digit in AH, si cel mai nesemnificativ in AL
    
    ;transformarea registrului AX in caracatere pentru a putea fi afisat
    add ah,48 ;trns lui ah
    add al,48 ;trns lui al
    
    
    mov bx,ax ;mutam ax in bx pentru a nu pierde mai departe rezultatul
    
    ;afisarea rezultatului
    mov dx,offset m8 ;mesajul rezultatului
    mov ah,9
    int 21h 
    
    mov ah,2  ;afisarea primului caracter din bh
    mov dl,bh
    int 21h
    
    mov ah,2 ;afisarea celui de al doilea caracter din bl
    mov dl,bl
    int 21h
    
;rezultatul va fi afisat de forma xx,unde daca rezultatul este o cifra, rezultatul va fi de forba 0x
    jmp exit 
    
 
   
   imp2:
    mov dx,offset m6 ;se cere introducerea primului caracter
    mov ah,9
    int 21h
    
    
    mov ah,1 ;se citeste primul caracter
    int 21h
	;se transforma in cifra pentru a putea fi folosti in operatii
    sub al,48
    mov cifra1,al ;se stocheaza in var cifra 1 pentru a nu fi pierdut la urmatoarea comanda
    
    
    mov dx,offset m7;se cere introducerea celui de al doilea caracter
    mov ah,9  
    int 21h 
    
    
    mov ah,1;se citeste al doilea caracter 
    int 21h
	;se transforma in cifra pentru a se putea fi folosit in operatii
    sub al,48
    mov cifra2,al
    
    mov cl,cifra1 ;mutam cifra 1 in cl 
    mov ch,0 ;setam sub registrul ch cu 0
    mov ax,cx  ;mutam cx(cifra 1) in ax pentru ca div imparte automat la ax
    
    div cifra2  ; al=ax/cifra 2, ah=ax%cifra2 (restul)
    mov rezultat,al ;mutam catul ,deoarece de el avem nevoie in rezultat
    mov ah,0 ;setam restul cu 0
    aad   ; Rezultatul este transformat BCD
    
    ;transformam cifrele in caractere pentru a le putea afisa
    add ah,48
    add al,48
    
    ;mutam registrul ax in bx, pentru a nu il pierde mai tarziu
    mov bx,ax 
    
    ;afisamr rezultatul
    mov dx,offset m8
    mov ah,9
    int 21h 
    
    mov ah,2 ;afisam prima cifra a rezultatului
    mov dl,bh
    int 21h
    
    mov ah,2 ;afisam a doua cifra a rezultatului
    mov dl,bl
    int 21h
    
     
    jmp exit
    
      
        
    exit:
    
    mov ah,4ch ;apel functie terminare normala a programului
    int 21h
	
end 



