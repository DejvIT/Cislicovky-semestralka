 BYTE 0xc0	;0
 BYTE 0xf9	;1
 BYTE 0xa4	;2
 BYTE 0xb0	;3
 BYTE 0x99	;4
 BYTE 0x92	;5
 BYTE 0x82	;6
 BYTE 0xf8	;7
 BYTE 0x80	;8
 BYTE 0x90	;9
 BYTE 0x88	;A	10
 BYTE 0x83	;b	11
 BYTE 0xc6	;C	12
 BYTE 0xa1	;d	13
 BYTE 0x86	;E	14
 BYTE 0x8e	;F	15
 BYTE 0xc7	;L	16	- kvoli DEL
 BYTE 0x89	;H	17	- kvoli HEX
 BYTE 0x09	;X	18	- kvoli HEX
 BYTE 0x8b;h	19      - kvoli h_
 BYTE 0xf7; _	20	- kvoli h_


tlacidloDelete:
mvi a,0	
mvi b,1	;na index 0 dam, ze kolko uz mam vlozenych cislic
str a,b
xor a,a
mvi b,0xff	; vsetky displeje, kde este nic nie je budu zhasnute (indexy 1-4)
inicializuj:
	inc a
	str a,b		;na index 1 a vyssie dam reprezentaciu zhasnuteho displeja
	cmi a,4
jnz inicializuj 

mvi a,4
mvi b,0	; same nuly,lebo este nic nie je vlozene
inicializujDruhuCast:
	inc a
	str a,b		;na index 5 a vyssie dam zatial nuly
	cmi a,14	;napr nula na indexe 14 informuje,ze este nemam k dispozicii HEX

jnz inicializujDruhuCast 


enterDEC:
	
	inc d

	mvi b,0x0d		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x07		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
	mvi b,0x0e		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x0b		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
	mvi b,0x0c		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x0d		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
cmi d,100
jnz enterDEC

	
programBezi:
	vynulujAktivatorRiadku:
	dit
	mvi a,0x80
	mvi c,0x00
	mvi d,0xff
	start: 
	inc c			;aktivovanie konkretneho riadku
	xor a,d
	out 1,a
	xor a,d
	shr a,1
	eit
	cmi c,4
	jzr vynulujAktivatorRiadku 
	jmp start

;jmp programBezi




int07:
cal spomalovac      ; pouziva register d, na konci ho vynuluje

cmi c,1
jzr klavesF
cmi c,2
jzr klavesB
cmi c,3
jzr klaves7
cmi c,4
jzr klaves3


klavesF:
mvi b,0
ldr a,b
cmi a,4
jnz programBezi
napisHEX:
	
	inc d

	mvi b,0x13		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x07		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
	mvi b,0x0e		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x0b		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
	mvi b,0x12		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x0d		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
cmi d,50
jnz napisHEX
cal prevedNaCislo
cal prevedNaHex
cal vypis
jmp programBezi

klavesB:
jmp programBezi

klaves7:
mvi b,0x07		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
jmp vypis
jmp programBezi

klaves3:
mvi b,0x03		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
jmp vypis
jmp programBezi

;-------------------------------------------------------------------------------

int0b:
cal spomalovac      ; pouziva register d, na konci ho vynuluje

cmi c,1
jzr klavesE
cmi c,2
jzr klavesA
cmi c,3
jzr klaves6
cmi c,4
jzr klaves2


klavesE:
cal vypis
jmp programBezi

klavesA:
jmp programBezi

klaves6:
mvi b,0x06		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi

klaves2:
mvi b,0x02		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi

;-------------------------------------------------------------------------------

int0d:
cal spomalovac      ; pouziva register d, na konci ho vynuluje

cmi c,1
jzr klavesD
cmi c,2
jzr klaves9
cmi c,3
jzr klaves5
cmi c,4
jzr klaves1


klavesD:
cal vymazJedenZnak
jmp programBezi

klaves9:
mvi b,0x09		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi

klaves5:
mvi b,0x05		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi

klaves1:
mvi b,0x01		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi
;-------------------------------------------------------------------------------

int0e:
cal spomalovac      ; pouziva register d, na konci ho vynuluje


cmi c,1
jzr klavesC
cmi c,2
jzr klaves8
cmi c,3
jzr klaves4
cmi c,4
jzr klaves0


klavesC:
del:
	
	inc d

	mvi b,0x0d		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x07		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
	mvi b,0x0e		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x0b		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
	mvi b,0x10		;medzikrok
	MMR  a,b		;znak do registra a
	mvi b,0x0d		;kam do registra b
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a
cmi d,50
jnz del
jmp tlacidloDelete

klaves8:
mvi b,0x08		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi

klaves4:
mvi b,0x04		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi

klaves0:
mvi b,0x00		;medzikrok
MMR  a,b		;znak do registra a
cal uloz
cal vypis
jmp programBezi
;--------------------------------------------------------------------------------

spomalovac:
	xor d,d
	spomal:
		inc d
		cmi d,50
	jnz spomal
	xor d,d
ret


vypis:			;ak uz je cislo prelozene do hex,vypise hex,inac
			;vypise dec
	mvi c,14
	ldr d,c
	cmi d,1
	jzr vypisHexCislo	;kontrola,ci je cislo uz prevedene

	xor d,d
	zoparKratVypisInput:
	inc d

	mvi b,1
	ldr a,b
	mvi b,0x07		;kam do registra b --> 1.displej
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a

	mvi b,2
	ldr a,b
	mvi b,0x0b		;kam do registra b --> 2.displej
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a

	mvi b,3
	ldr a,b
	mvi b,0x0d		;kam do registra b --> 3.displej
	out 1,b
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a

	mvi b,4
	ldr a,b
	mvi b,0x0e		;kam do registra b --> 4.displej
	out 1,b 
	out 2,a
	mvi a,0xff     ;zhasnutie
	out 2,a

	cmi d,50
	jnz zoparKratVypisInput
	
ret

vypisHexCislo:
	xor d,d 		;pocitadlo
	zoparKratVypisHexCislo:	
		inc d

		mvi b,10	;jedina zmena je,ze sa posunu indexy v pamati
		ldr a,b
		mvi b,0x07		;kam do registra b --> 1.displej
		out 1,b
		out 2,a
		mvi a,0xff     ;zhasnutie
		out 2,a

		mvi b,11
		ldr a,b
		mvi b,0x0b		;kam do registra b --> 2.displej
		out 1,b
		out 2,a
		mvi a,0xff     ;zhasnutie
		out 2,a

		mvi b,12
		ldr a,b
		mvi b,0x0d		;kam do registra b --> 3.displej
		out 1,b
		out 2,a
		mvi a,0xff     ;zhasnutie
		out 2,a

		mvi b,13
		ldr a,b
		mvi b,0x0e		;kam do registra b --> 4.displej
		out 1,b 
		out 2,a
		mvi a,0xff     ;zhasnutie
		out 2,a

		cmi d,200
	jnz zoparKratVypisHexCislo
ret			;vrati az na miesto tesne za ''prevedNaHex''



vymazJedenZnak:
	
	mvi d,8		;  bolo na index 4 uz nieco vlozene? 8 =4+4
	ldr c,d			; ulozi do c
	cmi c,1		; zatial nebolo
	jzr vymazAktualnyZnak

	mvi d,7		;  bolo na index 3 uz nieco vlozene? 7 =3+4
	ldr c,d		; ulozi do c
	cmi c,1		; zatial nebolo
	jzr vymazAktualnyZnak


	mvi d,6		;  bolo na index 2 uz nieco vlozene? 6 =2+4
	ldr c,d		; ulozi do c
	cmi c,1		; zatial nebolo
	jzr vymazAktualnyZnak


	mvi d,5		;  bolo na index 1 uz nieco vlozene? 5 =1+4
	ldr c,d		; ulozi do c
	cmi c,1		; zatial nebolo
	jzr vymazAktualnyZnak


ret

vymazAktualnyZnak:
	mvi c,0
	str d,c		;na indexy 5-8 da 0 ako cislo
	mvi c,0xff     ; na indexy 1-4 da reprezentaciu zhasnuteho displeja
	sbi d,4
	str d,c
	cal vypis
ret	

uloz:
	mvi d,5		;  bolo na index 1 uz nieco vlozene? 5 =1+4
	ldr c,d		; ulozi do c
	cmi c,0		; zatial nebolo
	jzr vlozNaPrvy

	mvi d,6		;  bolo na index 2 uz nieco vlozene? 6 =2+4
	ldr c,d		; ulozi do c
	cmi c,0		; zatial nebolo
	jzr vlozNaDruhy

	mvi d,7		;  bolo na index 3 uz nieco vlozene? 7 =3+4
	ldr c,d		; ulozi do c
	cmi c,0		; zatial nebolo
	jzr vlozNaTreti

	mvi d,8		;  bolo na index 4 uz nieco vlozene? 8 =4+4
	ldr c,d		; ulozi do c
	cmi c,0		; zatial nebolo
	jzr vlozNaStvrty
ret

vlozNaPrvy:
	mvi d,1	;na index vloz reprezentaciu znaku
	str d,a
	mvi c,0
	str c,d		;na indexe 0 zvys pocet uz vlozenych znakov na 1
	adi d,4	; informuj,ze uz tam nieco je
	mvi c,1
	str d,c		; informuj zmenou na 'true' ... log 1
ret

vlozNaDruhy:
	mvi d,2	;na index vloz reprezentaciu znaku
	str d,a
	mvi c,0
	str c,d		;na indexe 0 zvys pocet uz vlozenych znakov na 2
	adi d,4	; informuj,ze uz tam nieco je
	mvi c,1
	str d,c		; informuj zmenou na 'true' ... log 1
ret

vlozNaTreti:
	mvi d,3	;na index vloz reprezentaciu znaku
	str d,a
	mvi c,0
	str c,d		;na indexe 0 zvys pocet uz vlozenych znakov na 3
	adi d,4	; informuj,ze uz tam nieco je
	mvi c,1
	str d,c		; informuj zmenou na 'true' ... log 1
ret

vlozNaStvrty:
	mvi d,4	;na index vloz reprezentaciu znaku
	str d,a
	mvi c,0
	str c,d		;na indexe 0 zvys pocet uz vlozenych znakov na 4
	adi d,4	; informuj,ze uz tam nieco je
	mvi c,1
	str d,c		; informuj zmenou na 'true' ... log 1
ret

prevedNaCislo:
	mvi c,0
	xor d,d
	zvysCislicu1:
	mvi b,2
	ldr a,b	;do a da displejovu reprezentaciu
	mov b,c	;kontroluje zhodu znakov, v c bude ciselna repr.
	MMR  d,b	;znak v displej. reprezentacii do registra d
	xor b,b	;tu uz mozem b vynulovat
	cmp a,d
	jzr vynasobSto
	inc c
	jmp zvysCislicu1	
	
	vynasobSto:
		mov d,c	; ulozi do d hodnotu z c 
		xor c,c
		opakujStoKrat:
			add c,d
			inc b
			cmi b,100
		jnz opakujStoKrat 
	mvi d,9      ;na pozicii 9 v internej pamati bude vysl. v DEC
	str d,c
	xor d,d
	xor c,c

	zvysCislicu2:
		mvi b,3
		ldr a,b	;do a da displejovu reprezentaciu
		mov b,c	;kontroluje zhodu znakov, v c bude ciselna repr.
		MMR  d,b	;znak v displej. reprezentacii do registra d
		xor b,b	;tu uz mozem b vynulovat
		cmp a,d
		jzr vynasobDesat
		inc c
	jmp zvysCislicu2
	
	vynasobDesat:
		mov d,c	; ulozi do d hodnotu z c
		xor c,c
		opakujDesatKrat:
			add c,d
			inc b
			cmi b,10
		jnz opakujDesatKrat
	mvi a,9 
	ldr d,a	; vytiahni medzivysledok
	add d,c	; prirataj desiatky
	str a,d  	; vrat spat
	xor d,d
	xor c,c

	zvysCislicu3:
		mvi b,4
		ldr a,b	;do a da displejovu reprezentaciu
		mov b,c	;kontroluje zhodu znakov, v c bude ciselna repr.
		MMR  d,b	;znak v displej. reprezentacii do registra d
		cmp a,d
		jzr priratajJednotky
		inc c
	jmp zvysCislicu3


	priratajJednotky:
		mvi a,9 
		ldr d,a	; vytiahni medzivysledok
		add d,c	; prirataj jednotky
		str a,d  	; vrat spat
		xor c,c	
	; po navrate bude vysl. v DEC zapisany v registri d
ret



znakA:
	mvi c,12 		;na poziciu 12 v pamati
	mvi a,0x00		;pojde 0
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,13		;na poziciu 13 v pamati
	mvi a,0x0a		;pojde a
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
ret

znakB:
	mvi c,12 		;na poziciu 12 v pamati
	mvi a,0x00		;pojde 0
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,13		;na poziciu 13 v pamati
	mvi a,0x0b		;pojde b
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
ret

znakC:
	mvi c,12 		;na poziciu 12 v pamati
	mvi a,0x00		;pojde 0
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,13		;na poziciu 13 v pamati
	mvi a,0x0c		;pojde c
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
ret

znakD:
	mvi c,12 		;na poziciu 12 v pamati
	mvi a,0x00		;pojde 0
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,13		;na poziciu 13 v pamati
	mvi a,0x0d		;pojde d
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
ret

znakE:
	mvi c,12 		;na poziciu 12 v pamati
	mvi a,0x00		;pojde 0
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,13		;na poziciu 13 v pamati
	mvi a,0x0e		;pojde e
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
ret

znakF:
	mvi c,12 		;na poziciu 12 v pamati
	mvi a,0x00		;pojde 0
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,13		;na poziciu 13 v pamati
	mvi a,0x0f		;pojde f
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
ret			;vrati az na miesto tesne za ''prevedNaHex''






menejAkoSestnast:		;pripad,ked je len jeden vysl. znak
	cmi a,10
	jzr znakA
	cmi a,11
	jzr znakB
	cmi a,12
	jzr znakC
	cmi a,13
	jzr znakD
	cmi a,14
	jzr znakE
	cmi a,15
	jzr znakF
	
	;najskor pozicia 13,aby som si nevynuloval a
	mvi c,13		;na poziciu 13 v pamati		
				;pojde prislusna cislica 0-9
	;nesmiem ju tam dat ako cislo, ale ako displejovu reprezentaciu
	;daneho cisla
	MMR  b,a		;displejova repr. cisla z registra a pojde do b 
	str c,b

	mvi c,12 		;na poziciu 12 v pamati
	mvi a,0x00		;pojde 0 ....teraz uz a mozem vynulovat
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
		
ret
	


prevedNaHex:
	;displejova reprezentacia cisla v hex sustave sa zacina 
	;v pamati na pozicii 10 a konci na 13
	
	mvi c,10 		;vypis sa zacne vzdy h_
	mvi a,0x13		
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,11
	mvi a,0x14		;vypis sa zacne vzdy h_
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,14 		;informuje,ze uz mam k dispozicii HEX
	mvi a,0x01	
	str c,a
				

	
	mov a,d	;zaloha ciselnej hodnoty
	mvi c,0	
	shr d,4	;vydeli 16timi
	cmp c,d
	jnc menejAkoSestnast
	shl d,4
	cmp d,a
	jcy pokracuj2
pokracuj2:
	mvi c,13	;ulozenie prveho cisla sprava v cisl. repr.
	sub a,d
	MMR  b,a		;displej. repr. znaku pojde do b 
	str c,b
	shr d,4
	mvi c,12
	MMR  b,d		;displej. repr. znaku pojde do b 
	str c,b
	mvi c,0
ret





