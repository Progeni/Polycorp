;
;	Stack is at EF00
;
;

;
;	MENU
;	----
; 	This is the menu program that shows the menu and asks for a key press
;
F000 0 }  30 8C 7D       LEAX    $7D,PC ;			Load address of start up message into X
F003      AD 9F FF E8    JSR     [$FFE8];			Print string
F007      AD 9F FF E0    JSR     [$FFE0];
F00B      AD 9F FF E2    JSR     [$FFE2];			print characer in A
F00F      1F 89          TFR     A,B    ;
F011      AD 9F FF E0    JSR     [$FFE0];
F015      81 0D          CMPA    #$0D   ;			<CR>
F017 &    26 E7          BNE     $F000  ;			do it all over again!
F019      1F 98          TFR     B,A    ;
F01B  Q   8D 51          BSR     $F06E  ;
F01D  1   81 31          CMPA    #$31   ;			'0' is $32
F01F -    2D DF          BLT     $F000  ;			do it all over again
F021 &    26 05          BNE     $F028  ;
F023      8E 90 00       LDX     #$9000 ;			$9000
F026  A   20 41          BRA     $F069  ;			GOT0 $9000
->
F028  4   81 34          CMPA    #$34   ;			'2'
F02A &    26 05          BNE     $F031  ;
F02C      8E A0 00       LDX     #$A000 ;			$A000
F02F  8   20 38          BRA     $F069  ;			GOTO $A000
->
F031  D   8D 44          BSR     $F077  ;
F033  3   81 33          CMPA    #$33   ;			'3'
F035 &    26 05          BNE     $F03C  ;
F037      8E 80 00       LDX     #$8000 ;			$8000
F03A  -   20 2D          BRA     $F069  ;			GOTO $8000
->
F03C  2   81 32          CMPA    #$32   ;			'1'
F03E &    26 05          BNE     $F045  ;
F040      8E A0 00       LDX     #$A000 ;			$A000
F043  $   20 24          BRA     $F069  ;			GOTO $A000
->
F045  5   81 35          CMPA    #$35   ;			'3'
F047 &    26 05          BNE     $F04E  ;
F049      8E C0 00       LDX     #$C000 ;			$C000
F04C      20 1B          BRA     $F069  ;			GOTO $C000
->
F04E  6   81 36          CMPA    #$36   ;			'4'
F050 &    26 05          BNE     $F057  ;
F052      8E D0 00       LDX     #$D000 ;			$D000
F055      20 12          BRA     $F069  ;			GOTO $D000
->
F057  7   81 37          CMPA    #$37   ;			'5'
F059 .    2E A5          BGT     $F000  ;			Start Over
F05B &    26 A3          BNE     $F000  ;			Start Over
;
F05D      8E 00 00       LDX     #$0000 ;			Clear all memory between $0000 and $0800
F060 o    6F 80          CLR     ,X+    ;			clear
F062      8C 08 00       CMPX    #$0800 ;			check
F065 -    2D F9          BLT     $F060  ;			loop for mor
;
F067      20 97          BRA     $F000  ;			Start Over
->
F069      BF EF C4       STX     $EFC4  ;			Store the branch addres from the menu choice at $EFC4
F06C n    6E 84          JMP     ,X     ;			go there
->
Routine:
F06E      F6 E0 00       LDB     $E000  ;		Load a byte of data from the keyboard
F071      C4 E7          ANDB    #$E7   ;		%1110 1001
F073      F7 E0 00       STB     $E000  ;		Put it back
F076 9    39             RTS            ;		Return
->
Routine:
F077      F6 E0 00       LDB     $E000  ;		Load a byte of data from the keyboard
F07A      C4 E7          ANDB    #$E7   ;		%1110 1001
F07C      CA 08          ORB     #$08   ;		%0000 1000
F07E      20 F3          BRA     $F073  ;		Store it back and Return
;
;	WELCOME MESSAGE
;	---------------
;
F080 0C 0D 0A 0A 0A 20 20 20 20 20 20 20 3E 3E 3E 2D .....       >>>-   ;
F090 2D 3E 20 41 52 52 4F 57 20 43 6F 6D 70 75 74 65 -> ARROW Compute   ;
F0A0 72 20 2D 20 4D 65 6E 75 20 3C 2D 3C 3C 3C 20 20 r - Menu <-<<<     ;
F0B0 20 20 20 31 36 2F 30 37 2F 38 35 0D 0A 0A 0A 31    16/07/85....1   ;
F0C0 20 2D 20 42 41 53 49 43 0D 0A 32 20 2D 20 50 41  - BASIC..2 - PA   ;
F0D0 53 43 41 4C 0D 0A 33 20 2D 20 46 4F 52 54 48 0D SCAL..3 - FORTH.   ;
F0E0 0A 34 20 2D 20 41 73 73 65 6D 62 6C 65 72 20 2F .4 - Assembler /   ;
F0F0 20 4D 6F 6E 69 74 6F 72 0D 0A 35 20 2D 20 52 4F  Monitor..5 - RO   ;
F100 4D 20 61 74 20 24 43 30 30 30 0D 0A 36 20 2D 20 M at $C000..6 -    ;
F110 52 4F 4D 20 61 74 20 24 44 30 30 30 0D 0A 37 20 ROM at $D000..7    ;
F120 2D 20 43 6C 65 61 72 20 6D 65 6D 6F 72 79 0D 0A - Clear memory..   ;
F130 0A 0A 45 6E 74 65 72 20 79 6F 75 72 20 63 68 6F ..Enter your cho   ;
F140 69 63 65 20 3A 20 00                            ice : .;

;
;	DEAD SPACE
;	----------
;
F147 FF FF FF FF FF FF FF FF FF                     .........          ;
F150 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F160 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F170 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F180 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F190 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F1A0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F1B0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F1C0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F1D0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F1E0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F1F0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F200 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F210 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F220 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F230 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F240 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F250 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F260 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F270 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F280 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F290 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F2A0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F2B0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F2C0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F2D0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F2E0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F2F0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F300 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F310 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F320 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F330 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F340 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F350 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F360 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F370 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F380 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F390 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F3A0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F3B0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F3C0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F3D0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F3E0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F3F0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F400 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F410 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F420 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F430 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F440 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F450 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F460 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F470 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F480 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F490 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F4A0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F4B0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F4C0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F4D0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F4E0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F4F0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F500 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F510 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F520 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F530 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F540 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F550 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F560 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F570 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F580 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F590 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F5A0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F5B0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F5C0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F5D0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F5E0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F5F0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F600 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F610 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F620 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F630 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F640 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F650 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F660 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F670 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F680 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F690 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F6A0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F6B0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F6C0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F6D0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F6E0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F6F0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F700 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F710 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F720 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F730 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F740 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F750 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F760 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F770 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F780 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F790 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F7A0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F7B0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F7C0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F7D0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F7E0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
F7F0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
->
Routine:
F800 46   34 36          PSHS    Y,X,D  ;
F802      8E 01 01       LDX     #$0101 ;
F805 O    4F             CLRA           ;
F806 _    5F             CLRB           ;
F807 4    34 16          PSHS    X,D    ;
F809  E   A6 45          LDA     $05,U  ;
F80B  C   E6 43          LDB     $03,U  ;
F80D  I   A0 49          SUBA    $09,U  ;
F80F $    24 03          BCC     $F814  ;
F811 @    40             NEGA           ;
F812 `b   60 62          NEG     $02,S  ;
->
F814  G   E0 47          SUBB    $07,U  ;
F816 $    24 03          BCC     $F81B  ;
F818 P    50             NEGB           ;
F819 `c   60 63          NEG     $03,S  ;
->
F81B 4    34 04          PSHS    B      ;
F81D      A1 E0          CMPA    ,S+    ;
F81F 4    34 06          PSHS    D      ;
F821 $    24 0A          BCC     $F82D  ;
F823      1E 89          EXG     A,B    ;
F825      ED E4          STD     ,S     ;
F827  e   A6 65          LDA     $05,S  ;
F829  c   A7 63          STA     $03,S  ;
F82B      20 04          BRA     $F831  ;
->
F82D  d   A6 64          LDA     $04,S  ;
F82F  b   A7 62          STA     $02,S  ;
->
F831      A6 E4          LDA     ,S     ;
F833  a   A0 61          SUBA    $01,S  ;
F835 4    34 02          PSHS    A      ;
F837  a   E6 61          LDB     $01,S  ;
F839 T    54             LSRB           ;
F83A O    4F             CLRA           ;
F83B      E0 E4          SUBB    ,S     ;
F83D      82 00          SBCA    #$00   ;
F83F 4    34 06          PSHS    D      ;
F841  I   A6 49          LDA     $09,U  ;
F843  G   E6 47          LDB     $07,U  ;
->
F845  .   8D 2E          BSR     $F875  ;
F847 m    6D E4          TST     ,S     ;
F849 *    2A 0E          BPL     $F859  ;
F84B  e   AB 65          ADDA    $05,S  ;
F84D  f   EB 66          ADDB    $06,S  ;
F84F 4    34 06          PSHS    D      ;
F851  b   EC 62          LDD     $02,S  ;
F853  f   EB 66          ADDB    $06,S  ;
F855      89 00          ADCA    #$00   ;
F857      20 0C          BRA     $F865  ;
->
F859  g   AB 67          ADDA    $07,S  ;
F85B  h   EB 68          ADDB    $08,S  ;
F85D 4    34 06          PSHS    D      ;
F85F  b   EC 62          LDD     $02,S  ;
F861  d   E0 64          SUBB    $04,S  ;
F863      82 00          SBCA    #$00   ;
->
F865  b   ED 62          STD     $02,S  ;
F867 5    35 06          PULS    D      ;
F869 jc   6A 63          DEC     $03,S  ;
F86B &    26 D8          BNE     $F845  ;
F86D      8D 06          BSR     $F875  ;
F86F 3J   33 4A          LEAU    $0A,U  ;
F871 2i   32 69          LEAS    $09,S  ;
F873 5    35 B6          PULS    PC,Y,X,D;
->
Routine:
F875      1F 02          TFR     D,Y    ;
F877 4F   34 46          PSHS    U,D    ;
F879      1F 89          TFR     A,B    ;
F87B      1F 01          TFR     D,X    ;
F87D      EC C4          LDD     ,U     ;
F87F 66   36 36          PSHU    Y,X,D  ;
F881      8D 02          BSR     $F885  ;
F883 5    35 C6          PULS    PC,U,D ;
->
Routine:
F885  7   8D 37          BSR     $F8BE  ;
F887  A   E6 41          LDB     $01,U  ;
F889 Z    5A             DECB           ;
F88A '    27 0B          BEQ     $F897  ;
F88C Z    5A             DECB           ;
F88D '    27 15          BEQ     $F8A4  ;
F88F Z    5A             DECB           ;
F890 '    27 1A          BEQ     $F8AC  ;
F892 Z    5A             DECB           ;
F893 '    27 1D          BEQ     $F8B2  ;
F895      20 0A          BRA     $F8A1  ;
->
F897 M    4D             TSTA           ;
F898 '    27 07          BEQ     $F8A1  ;
F89A      AA 84          ORA     ,X     ;
->
F89C      A7 84          STA     ,X     ;
F89E      BF EF 80       STX     $EF80  ;
->
F8A1 3F   33 46          LEAU    $06,U  ;
F8A3 9    39             RTS            ;
->
F8A4 M    4D             TSTA           ;
F8A5 '    27 FA          BEQ     $F8A1  ;
F8A7 C    43             COMA           ;
F8A8      A4 84          ANDA    ,X     ;
F8AA      20 F0          BRA     $F89C  ;
->
F8AC      1F 89          TFR     A,B    ;
F8AE      E8 84          EORB    ,X     ;
F8B0      E7 84          STB     ,X     ;
->
F8B2 _    5F             CLRB           ;
F8B3      A4 84          ANDA    ,X     ;
F8B5 '    27 01          BEQ     $F8B8  ;
F8B7 \    5C             INCB           ;
->
F8B8 3D   33 44          LEAU    $04,U  ;
F8BA O    4F             CLRA           ;
F8BB      ED C4          STD     ,U     ;
F8BD 9    39             RTS            ;
->
Routine:
F8BE  E   A6 45          LDA     $05,U  ;
F8C0  V   C6 56          LDB     #$56   ;
F8C2 =    3D             MUL            ;
F8C3 4    34 04          PSHS    B      ;
F8C5  @   C6 40          LDB     #$40   ;
F8C7 =    3D             MUL            ;
F8C8 6    36 06          PSHU    D      ;
F8CA      FC EF 84       LDD     $EF84  ;
F8CD      C4 C0          ANDB    #$C0   ;
F8CF      A3 C1          SUBD    ,U++   ;
F8D1      1F 01          TFR     D,X    ;
F8D3 5    35 04          PULS    B      ;
F8D5  C   A6 43          LDA     $03,U  ;
F8D7 +)   2B 29          BMI     $F902  ;
F8D9 G    47             ASRA           ;
F8DA 0    30 86          LEAX    A,X    ;
F8DC      BC EF 82       CMPX    $EF82  ;
F8DF %!   25 21          BCS     $F902  ;
F8E1      86 03          LDA     #$03   ;
F8E3 =    3D             MUL            ;
F8E4      C6 10          LDB     #$10   ;
->
F8E6 J    4A             DECA           ;
F8E7 -    2D 04          BLT     $F8ED  ;
F8E9 W    57             ASRB           ;
F8EA W    57             ASRB           ;
F8EB      20 F9          BRA     $F8E6  ;
->
F8ED  C   A6 43          LDA     $03,U  ;
F8EF G    47             ASRA           ;
F8F0 $    24 01          BCC     $F8F3  ;
F8F2 X    58             ASLB           ;
->
F8F3      A6 84          LDA     ,X     ;
F8F5      84 C0          ANDA    #$C0   ;
F8F7      81 80          CMPA    #$80   ;
F8F9 '    27 04          BEQ     $F8FF  ;
F8FB      86 80          LDA     #$80   ;
F8FD      A7 84          STA     ,X     ;
->
F8FF      1F 98          TFR     B,A    ;
F901 9    39             RTS            ;
->
F902 O    4F             CLRA           ;
F903 9    39             RTS            ;
->
Routine:
F904 4:   34 3A          PSHS    Y,X,DP,A;
F906      86 EF          LDA     #$EF   ;
F908      1F 8B          TFR     A,DP   ;
F90A 7    37 16          PULU    X,D    ;
F90C      9F 97          STX     $97    ;(DP$97);
F90E      DD 99          STD     $99    ;(DP$99);
F910  @   8E 40 00       LDX     #$4000 ;
->
F913  [   8D 5B          BSR     $F970  ;
F915  [   8D 5B          BSR     $F972  ;
F917 0    30 1F          LEAX    $-01,X ;
F919 &    26 F8          BNE     $F913  ;
F91B      86 B3          LDA     #$B3   ;
F91D  $   8D 24          BSR     $F943  ;
F91F      0F 9B          CLR     $9B    ;(DP$9B);
F921      8E EF 97       LDX     #$EF97 ;
F924      C6 04          LDB     #$04   ;
->
F926      A6 80          LDA     ,X+    ;
F928      8D 19          BSR     $F943  ;
F92A Z    5A             DECB           ;
F92B &    26 F9          BNE     $F926  ;
F92D      96 9B          LDA     $9B    ;(DP$9B);
F92F      8D 12          BSR     $F943  ;
F931      0F 9B          CLR     $9B    ;(DP$9B);
F933      9E 97          LDX     $97    ;(DP$97);
->
F935      A6 80          LDA     ,X+    ;
F937      8D 0A          BSR     $F943  ;
F939      9C 99          CMPX    $99    ;(DP$99);
F93B #    23 F8          BLS     $F935  ;
F93D      96 9B          LDA     $9B    ;(DP$9B);
F93F      8D 02          BSR     $F943  ;
F941 5    35 BA          PULS    PC,Y,X,DP,A;
->
Routine:
F943 4    34 04          PSHS    B      ;
F945   h  17 04 68       LBSR    $FDB0  ;
F948      1F 89          TFR     A,B    ;
F94A      DB 9B          ADDB    $9B    ;(DP$9B);
F94C      D7 9B          STB     $9B    ;(DP$9B);
F94E      8D 20          BSR     $F970  ;
F950      8D 1E          BSR     $F970  ;
F952      C6 08          LDB     #$08   ;
F954      D7 9C          STB     $9C    ;(DP$9C);
->
F956      8D 18          BSR     $F970  ;
F958      85 01          BITA    #$01   ;
F95A '    27 04          BEQ     $F960  ;
F95C      8D 12          BSR     $F970  ;
F95E      20 02          BRA     $F962  ;
->
F960      8D 10          BSR     $F972  ;
->
F962 D    44             LSRA           ;
F963      0A 9C          DEC     $9C    ;(DP$9C);
F965 .    2E EF          BGT     $F956  ;
F967      8D 07          BSR     $F970  ;
F969      8D 07          BSR     $F972  ;
F96B   B  17 04 42       LBSR    $FDB0  ;
F96E 5    35 84          PULS    PC,B   ;
->
Routine:
F970      C6 08          LDB     #$08   ;
->
Routine:
F972      10 8E E0 00    LDY     #$E000 ;
F976  !   EA 21          ORB     $01,Y  ;
F978  !   E7 21          STB     $01,Y  ;
F97A      D6 9E          LDB     $9E    ;(DP$9E);
->
F97C Z    5A             DECB           ;
F97D &    26 FD          BNE     $F97C  ;
F97F  !   E6 21          LDB     $01,Y  ;
F981      C4 F7          ANDB    #$F7   ;
F983  !   E7 21          STB     $01,Y  ;
F985      D6 9E          LDB     $9E    ;(DP$9E);
->
F987      12             NOP            ;
F988      20 00          BRA     $F98A  ;
->
F98A Z    5A             DECB           ;
F98B &    26 FA          BNE     $F987  ;
F98D 9    39             RTS            ;
->
Routine:
F98E 48   34 38          PSHS    Y,X,DP ;
F990      86 EF          LDA     #$EF   ;
F992      1F 8B          TFR     A,DP   ;
F994      E6 C0          LDB     ,U+    ;
F996      EA C0          ORB     ,U+    ;
F998      D7 A0          STB     $A0    ;(DP$A0);
F99A      17 00 89       LBSR    $FA26  ;
F99D      17 02 D9       LBSR    $FC79  ;
F9A0      1F 12          TFR     X,Y    ;
F9A2      CC F2 F3       LDD     #$F2F3 ;
F9A5      ED A4          STD     ,Y     ;
->
F9A7  ^   8D 5E          BSR     $FA07  ;
F9A9      81 B3          CMPA    #$B3   ;
F9AB &    26 FA          BNE     $F9A7  ;
F9AD      0F 9B          CLR     $9B    ;(DP$9B);
F9AF      8E EF 97       LDX     #$EF97 ;
F9B2      C6 04          LDB     #$04   ;
->
F9B4  Q   8D 51          BSR     $FA07  ;
F9B6      A7 80          STA     ,X+    ;
F9B8      9B 9B          ADDA    $9B    ;(DP$9B);
F9BA      97 9B          STA     $9B    ;(DP$9B);
F9BC Z    5A             DECB           ;
F9BD &    26 F5          BNE     $F9B4  ;
F9BF  F   8D 46          BSR     $FA07  ;
F9C1      91 9B          CMPA    $9B    ;(DP$9B);
F9C3 &<   26 3C          BNE     $FA01  ;
F9C5      0F 9B          CLR     $9B    ;(DP$9B);
F9C7      9E 95          LDX     $95    ;(DP$95);
F9C9 '    27 0A          BEQ     $F9D5  ;
F9CB      DC 99          LDD     $99    ;(DP$99);
F9CD      93 97          SUBD    $97    ;(DP$97);
F9CF      D3 95          ADDD    $95    ;(DP$95);
F9D1      9F 97          STX     $97    ;(DP$97);
F9D3      DD 99          STD     $99    ;(DP$99);
->
F9D5      9E 97          LDX     $97    ;(DP$97);
->
F9D7  .   8D 2E          BSR     $FA07  ;
F9D9      0D A0          TST     $A0    ;(DP$A0);
F9DB '    27 06          BEQ     $F9E3  ;
F9DD      A1 80          CMPA    ,X+    ;
F9DF &    26 20          BNE     $FA01  ;
F9E1      20 02          BRA     $F9E5  ;
->
F9E3      A7 80          STA     ,X+    ;
->
F9E5      1F 89          TFR     A,B    ;
F9E7      9B 9B          ADDA    $9B    ;(DP$9B);
F9E9      97 9B          STA     $9B    ;(DP$9B);
F9EB      C1 20          CMPB    #$20   ;
F9ED &    26 06          BNE     $F9F5  ;
F9EF      A6 A4          LDA     ,Y     ;
F9F1      88 02          EORA    #$02   ;
F9F3      A7 A4          STA     ,Y     ;
->
F9F5      9C 99          CMPX    $99    ;(DP$99);
F9F7 #    23 DE          BLS     $F9D7  ;
F9F9      8D 0C          BSR     $FA07  ;
F9FB      C6 01          LDB     #$01   ;
F9FD      91 9B          CMPA    $9B    ;(DP$9B);
F9FF '    27 01          BEQ     $FA02  ;
->
FA01 _    5F             CLRB           ;
->
FA02 O    4F             CLRA           ;
FA03 6    36 06          PSHU    D      ;
FA05 5    35 B8          PULS    PC,Y,X,DP;
->
Routine:
FA07      17 03 A6       LBSR    $FDB0  ;
FA0A      86 08          LDA     #$08   ;
FA0C      97 9C          STA     $9C    ;(DP$9C);
->
FA0E  K   8D 4B          BSR     $FA5B  ;
FA10 *    2A FC          BPL     $FA0E  ;
->
FA12      0A 9C          DEC     $9C    ;(DP$9C);
FA14 -    2D 0D          BLT     $FA23  ;
FA16 D    44             LSRA           ;
FA17 4    34 02          PSHS    A      ;
FA19  @   8D 40          BSR     $FA5B  ;
FA1B 5    35 02          PULS    A      ;
FA1D *    2A F3          BPL     $FA12  ;
FA1F      8A 80          ORA     #$80   ;
FA21      20 EF          BRA     $FA12  ;
->
FA23      16 03 8A       LBRA    $FDB0  ;
->
Routine:
FA26      10 8E EF 99    LDY     #$EF99 ;
->
FA2A _    5F             CLRB           ;
FA2B  P   86 50          LDA     #$50   ;
FA2D      97 9F          STA     $9F    ;(DP$9F);
FA2F o    6F A4          CLR     ,Y     ;
FA31 o!   6F 21          CLR     $01,Y  ;
->
FA33  &   8D 26          BSR     $FA5B  ;
FA35 *    2A F3          BPL     $FA2A  ;
FA37 Z    5A             DECB           ;
FA38 &    26 F9          BNE     $FA33  ;
->
FA3A      8D 1F          BSR     $FA5B  ;
FA3C      9B 9F          ADDA    $9F    ;(DP$9F);
FA3E  !   AB 21          ADDA    $01,Y  ;
FA40  !   A7 21          STA     $01,Y  ;
FA42 $    24 02          BCC     $FA46  ;
FA44 l    6C A4          INC     ,Y     ;
->
FA46 \    5C             INCB           ;
FA47      C1 10          CMPB    #$10   ;
FA49 -    2D EF          BLT     $FA3A  ;
->
FA4B d    64 A4          LSR     ,Y     ;
FA4D f!   66 21          ROR     $01,Y  ;
FA4F T    54             LSRB           ;
FA50 $    24 F9          BCC     $FA4B  ;
FA52  !   A6 21          LDA     $01,Y  ;
FA54 d!   64 21          LSR     $01,Y  ;
FA56  !   AB 21          ADDA    $01,Y  ;
FA58      97 9F          STA     $9F    ;(DP$9F);
FA5A 9    39             RTS            ;
->
Routine:
FA5B 4    34 10          PSHS    X      ;
FA5D      8E E0 00       LDX     #$E000 ;
FA60 m    6D 84          TST     ,X     ;
->
FA62 m    6D 01          TST     $01,X  ;
FA64 *    2A FC          BPL     $FA62  ;
FA66 m    6D 84          TST     ,X     ;
FA68 O    4F             CLRA           ;
->
FA69 L    4C             INCA           ;
FA6A      91 9F          CMPA    $9F    ;(DP$9F);
FA6C '    27 04          BEQ     $FA72  ;
FA6E m    6D 01          TST     $01,X  ;
FA70 *    2A F7          BPL     $FA69  ;
->
FA72      90 9F          SUBA    $9F    ;(DP$9F);
FA74 5    35 90          PULS    PC,X   ;
->
;
;
;
Routine:
FA76 4    34 1C          PSHS    X,DP,B ;				Save registers
FA78      C6 EF          LDB     #$EF   ;				Set DP to $EF
FA7A      1F 9B          TFR     B,DP   ;				DP = EF
FA7C      17 01 FA       LBSR    $FC79  ;
FA7F      E6 84          LDB     ,X     ;
FA81 4    34 06          PSHS    D      ;
FA83      96 87          LDA     $87    ;(DP$87);
FA85      A7 84          STA     ,X     ;
->
FA87  ?   8D 3F          BSR     $FAC8  ;
FA89 M    4D             TSTA           ;
FA8A &    26 16          BNE     $FAA2  ;
FA8C      0F 91          CLR     $91    ;(DP$91);
FA8E j    6A E4          DEC     ,S     ;
FA90 &    26 F5          BNE     $FA87  ;
FA92  a   E6 61          LDB     $01,S  ;
FA94 '    27 F1          BEQ     $FA87  ;
FA96      96 87          LDA     $87    ;(DP$87);
FA98      A1 84          CMPA    ,X     ;
FA9A &    26 02          BNE     $FA9E  ;
FA9C      1F 98          TFR     B,A    ;
->
FA9E      A7 84          STA     ,X     ;
FAA0      20 E5          BRA     $FA87  ;
->
FAA2      C6 FF          LDB     #$FF   ;
FAA4      91 91          CMPA    $91    ;(DP$91);
FAA6 &    26 09          BNE     $FAB1  ;
->
FAA8 Z    5A             DECB           ;
FAA9 &    26 FD          BNE     $FAA8  ;
FAAB      0A 92          DEC     $92    ;(DP$92);
FAAD &    26 D8          BNE     $FA87  ;
FAAF      C6 19          LDB     #$19   ;
->
FAB1      D7 92          STB     $92    ;(DP$92);
FAB3      97 91          STA     $91    ;(DP$91);
FAB5 2a   32 61          LEAS    $01,S  ;
FAB7 5    35 04          PULS    B      ;
FAB9      E7 84          STB     ,X     ;
FABB      81 0D          CMPA    #$0D   ;
FABD &    26 07          BNE     $FAC6  ;
->
FABF      8D 07          BSR     $FAC8  ;
FAC1 M    4D             TSTA           ;
FAC2 &    26 FB          BNE     $FABF  ;
FAC4      86 0D          LDA     #$0D   ;
->
FAC6 5    35 9C          PULS    PC,X,DP,B;
->
;
;	GET CHARACTER
;	-------------
;	return in A either 0 if no character waiting or the character that has arrived
;
;	Read from $E008
;	if it returns 0 then nothing to report so return 0
;
Routine:
FAC8 44   34 34          PSHS    Y,X,B  ;	Save X, Y, B (return in A)
FACA      8E E0 08       LDX     #$E008 ;	X = $E008
FACD }    7D EF 93       TST     $EF93  ;
FAD0 +    2B 10          BMI     $FAE2  ;		DO A KEY LOAD AND DECODE
->
FAD2      A6 84          LDA     ,X     ;	Load A from $E008
FAD4 +    2B 01          BMI     $FAD7  ;	if the high bit is set then continue
FAD6 O    4F             CLRA           ;	else A = 0
->
FAD7      84 7F          ANDA    #$7F   ;	Turn off the top bit
FAD9 '    27 18          BEQ     $FAF3  ;	We got a 0 so Return
FADB      B1 EF 91       CMPA    $EF91  ;		what ever is stored here is the "ignore" key
FADE '    27 F2          BEQ     $FAD2  ;		Go get another key press
FAE0      20 11          BRA     $FAF3  ;	Return
->
FAE2 o    6F 04          CLR     $04,X  ;	write 00 to $E00C
FAE4      A6 84          LDA     ,X     ;	read from $E000
FAE6 C    43             COMA           ;
FAE7 '    27 0A          BEQ     $FAF3  ;	if we got $FF then nothing to report?
->
FAE9      8D 0A          BSR     $FAF5  ;	get the key-down event?
FAEB 4    34 02          PSHS    A      ;
FAED      8D 06          BSR     $FAF5  ;	get the key-up event?
FAEF      A1 E0          CMPA    ,S+    ;	were they for the same key?
FAF1 &    26 F6          BNE     $FAE9  ;	not the same key so ignore and re-try
->
FAF3 5    35 B4          PULS    PC,Y,X,B;	Return
->
Routine:
;
;
;	Cycles from $7F to $00 asking the keyboard whether a key is down
;		Send key to $E00C
;		Read $E008
;		if the keyboard returns #$7F when no key to report
;		else it reports $00 to signal that the value at $E00C is the correct key set
;		Read $E008
;		keyboard responds with a bit string with the number of right-aligned 1s being the key in the set ($03 -> 2nd key)
;
FAF5      86 FF          LDA     #$FF   ;			Check 8 values
FAF7 D    44             LSRA           ;			$FF -> $7F -> $3F, etc
FAF8      A7 04          STA     $04,X  ;			write to $E00C
FAFA      E6 84          LDB     ,X     ;			load from $E000
FAFC      CA 80          ORB     #$80   ;			turn the high bit on
FAFE S    53             COMB           ;			B = ~B
FAFF &    26 05          BNE     $FB06  ;			If keyboard didn't return $7F or $FF (correct bit is set)
FB01 M    4D             TSTA           ;
FB02 &    26 F3          BNE     $FAF7  ;			shift and check again.
FB04  $   20 24          BRA     $FB2A  ;	MODIFIER KEYS SOMETHING
->
FB06 _    5F             CLRB           ;			we got a response from the keyboard
FB07 \    5C             INCB           ;
FB08 D    44             LSRA           ;			$FF -> $7F -> $3F, etc
FB09 %    25 FC          BCS     $FB07  ;			find the first 0 in A  (so $07 -> 5)
FB0B Z    5A             DECB           ;			B is position of first unset bit counting from 1 (so $07->4)
FB0C      86 07          LDA     #$07   ;	At this point B holds the keyboard key scan set.
FB0E =    3D             MUL            ;			multiply by 7 (so $07 * $04 -> $1C)
;
;	At this point the keyboard key set is stored in B
;
FB0F Z    5A             DECB           ;
FB10      A6 84          LDA     ,X     ;			Get the next value from the keyboard (the key within the set)
;
FB12 \    5C             INCB           ;			increment B looking for which of the 7 it is
FB13 D    44             LSRA           ;
FB14 %    25 FC          BCS     $FB12  ;
;
;	At this point B holds the key that was pressed.
;
FB16 1 g  31 8C 67       LEAY    $67,PC ;		$FB80 -> keyboard translation table.
FB19      E6 A5          LDB     B,Y    ;		B has the key press
FB1B }    7D EF 94       TST     $EF94  ;		Check the caps lock status
FB1E *    2A 0A          BPL     $FB2A  ;		Otherwise convert to lower case
FB20  A   C1 41          CMPB    #$41   ;		'A'
FB22 -    2D 06          BLT     $FB2A  ;		if less then 'A'
FB24  Z   C1 5A          CMPB    #$5A   ;		'Z'
FB26 .    2E 02          BGT     $FB2A  ;		if greater than 'Z'
FB28      CA 20          ORB     #$20   ;		convert to lower case
->
FB2A      8D 03          BSR     $FB2F  ;		apply modifier keys (ctrl, etc) to the key
FB2C      1F 98          TFR     B,A    ;		retun the key press in A
FB2E 9    39             RTS            ;		Return
->
;
;	MODIFY KEY PRESSED
;	------------------
;	Check the state of the modifier keys then
;	turn the key pressed into an modified key (C -> 'C', etc.)
;
;	In:
;		B = the key that was pressed
;	Out:
;		B = the modified key
;
;	Cycles from $FF to $00 asking the keyboard whether the modifier key is down
;		Send modifier key to $E00C
;		Read $E000
;		if the high bit is set then that modifier is NOT down
;		else the modfier key is down so now tranlate the key based on the modifier
;
;	Known modifiers are:
;		$03 -> BREAK key (translated to ^C)
;		$0F -> Contol key
;		$1F -> Toggle caps lock
;		$3F -> Graphics key?
;		$7F -> Shift key
;
Routine:
FB2F      86 FF          LDA     #$FF   ;		check the status of the modifier keys
FB31 M    4D             TSTA           ;		have we checked all 8 yet?
FB32 'K   27 4B          BEQ     $FB7F  ;		yes, so return
FB34 D    44             LSRA           ;		move down one check ($FF -> $7F -> $3F -> ... $00)
FB35      A7 04          STA     $04,X  ;		at $E00C
FB37 m    6D 84          TST     ,X     ;		Read from the keyboard
FB39 +    2B F6          BMI     $FB31  ;		repeat while the keyboard has a high bit set
FB3B      81 03          CMPA    #$03   ;		BREAK key
FB3D &    26 03          BNE     $FB42  ;		Translate key press ('C' -> '^C', etc.)
FB3F      C6 03          LDB     #$03   ;		Turn BREAK into ^C
FB41 9    39             RTS            ;		Return
->
;
;	TRANSLATE KEY PRESS
;	-------------------
;	State of the control / shift / etc key is in A, the ASCII key is in B
;	Translate to the appropeiate button ('C' -> '^C', etc.)
;
;	A = $0F -> Contol key
;	A = $1F -> Toggle caps lock
;	A = $3F -> Graphics key?
;	A = $7F -> Shift key
;
FB42      81 1F          CMPA    #$1F   ;		%0001 1111
FB44 &    26 08          BNE     $FB4E  ;
FB46 s    73 EF 94       COM     $EF94  ;		is this the CAPS LOCK key
->
FB49 m    6D 84          TST     ,X     ;		loop
FB4B *    2A FC          BPL     $FB49  ;		while the top bit is set, loop (is X=$E008?)
FB4D 9    39             RTS            ;		Return
->
FB4E      81 0F          CMPA    #$0F   ;		%0000 1111		This is a control character (like ^C)
FB50 &    26 07          BNE     $FB59  ;		Nope
FB52  @   C1 40          CMPB    #$40   ;		is it a character that cab become a control character (@, A-Z, etc.)
FB54 /)   2F 29          BLE     $FB7F  ;		Return
FB56      C4 1F          ANDB    #$1F   ;		Turn it into a control character
FB58 9    39             RTS            ;		Return
->
FB59      81 7F          CMPA    #$7F   ;		%0111 1111	Shift key for digits
FB5B &    26 0B          BNE     $FB68  ;		nope
FB5D  1   C1 31          CMPB    #$31   ;		'1'
FB5F -    2D 11          BLT     $FB72  ;		less		 (shift for non-digits)
FB61  ?   C1 3F          CMPB    #$3F   ;		'?'
FB63 .    2E 18          BGT     $FB7D  ;		greater
FB65  /   C4 2F          ANDB    #$2F   ;		Shift key for digits and specials
FB67 9    39             RTS            ;		Return
->
FB68  ?   81 3F          CMPA    #$3F   ;		%0011 1111	is this the "graphics" key
FB6A &    26 13          BNE     $FB7F  ;		Return
FB6C ]    5D             TSTB           ;		We don't change character 0
FB6D '    27 10          BEQ     $FB7F  ;		Return
FB6F      CA C0          ORB     #$C0   ;		%1100 0000
FB71 9    39             RTS            ;		Return
->
FB72  /   C1 2F          CMPB    #$2F   ;		'/'
FB74 .    2E 09          BGT     $FB7F  ;		Return	next after '/' is '0'
FB76  ,   C1 2C          CMPB    #$2C   ;		','
FB78 -    2D 05          BLT     $FB7F  ;		Return
FB7A      CA 10          ORB     #$10   ;		',' -> '<'.  looks like shift key for some punctuations
FB7C 9    39             RTS            ;		Return
->
FB7D      C8 20          EORB    #$20   ;		'@' -> '`'?
->
FB7F 9    39             RTS            ;		Return
->
;
;	Keyboard decoding table
;
;	This is broken into sets of 8 sets of 7 keys
;
;	Keyboard layout is:
;	ESC 2 4 5 6  8  0       - 1 3 5 6 7   :
;	TAB W R Y I  P  ]       Q E T U O [  LF
;	  A D G J L  @  DEL   NIL S F H K ;  \
;     Z C B M .  SP CR      X V N , / BS 4
;
;	Where:
;	LF  = $0A
;	TAB = $09
;	ESC = $1B
;	DEL = $7F
;	NIL = $00
;	SP  = $20
;	CR  = $0D
;	VT  = $0B
;	BS  = $08
;
FB80 1B 32 34 36 38 30 2D 31 33 35 37 39 3A 5E 09 57 .24680-13579:^.W   ;
FB90 52 59 49 50 5D 51 45 54 55 4F 5B 0A 41 44 47 4A RYIP]QETUO[.ADGJ   ;
FBA0 4C 40 7F 00 53 46 48 4B 3B 5C 5A 43 42 4D 2E 20 L@..SFHK;\ZCBM.    ;
FBB0 0D 0B 58 56 4E 2C 2F 08 34 38 C6 EF 1F 9B 17 00 ..XVN,/.48......   ;
FBC0 B8 9F 88 BD FA 76 81 20 2D 10 81 7F 27 0C 0D 86 .....v. -...'...   ;
FBD0 27 08 1F 89 86 01 8D 24 1F 98 8D 20 81 03 10 27 '......$... ...'   ;
FBE0 03 08 81 0D 26 DD 9E 88 1F 12 10 9C 84 24 06 31 ....&........$.1   ;
FBF0 21 6D A4 26 F5 36 30 10 9F 80 35 B8
;
;
;	PRINT CHARACTER
;	---------------
;	Print a charcter in A, interpreting <CR> and (presumably) other characters
;
Routine:
FBFC 4>   34 3E          PSHS    Y,X,DP,D;
FBFE      C6 EF          LDB     #$EF   ;
FC00      1F 9B          TFR     B,DP   ;			DP=$EF
FC02      B4 FF F0       ANDA    $FFF0  ;			ANDA #$FF
FC05      0D 8A          TST     $8A    ;(DP$8A);
FC07 '    27 03          BEQ     $FC0C  ;
FC09      17 01 D7       LBSR    $FDE3  ;
->
FC0C      1F 89          TFR     A,B    ;			B = A
FC0E  i   8D 69          BSR     $FC79  ;			scroll if necesary
FC10  w   8D 77          BSR     $FC89  ;
FC12 %    25 02          BCS     $FC16  ;			check for get some kind of key press
FC14      E7 80          STB     ,X+    ;
->
FC16      9F 80          STX     $80    ;(DP$80);
FC18      86 9F          LDA     #$9F   ;			write $9F to keyboard controller
FC1A      B7 E0 0C       STA     $E00C  ;			do the write
FC1D }    7D E0 08       TST     $E008  ;			read from the keyboard controller
FC20 +    2B 0A          BMI     $FC2C  ;			if the hight bit is set return
->
FC22      B7 E0 0C       STA     $E00C  ;			write $9F to the keyboard controller
FC25      F6 E0 08       LDB     $E008  ;			load form the keyboard
FC28      C4 20          ANDB    #$20   ;			check for bit #$20
FC2A &    26 F6          BNE     $FC22  ;			repeat
->
FC2C 5    35 BE          PULS    PC,Y,X,DP,D;		Return
->
;
;	SCROLL UP
;	---------
;
Routine:
FC2E 4t   34 74          PSHS    U,Y,X,B;				Save registers
FC30      9E 82          LDX     $82    ;(DP$82);		X = Start of TEXT screen
;
FC32   @  A6 88 40       LDA     $40,X  ;				get A from the next line
FC35      A7 80          STA     ,X+    ;				store it in the current line
FC37  c   AC 63          CMPX    $03,S  ;				until done
FC39 &    26 F7          BNE     $FC32  ;				copy the next byye
;
FC3B      DC 88          LDD     $88    ;(DP$88);
FC3D   @  83 00 40       SUBD    #$0040 ;				subtract 1 line from DP:$88
FC40      DD 88          STD     $88    ;(DP$88);
;
FC42      CE 00 00       LDU     #$0000 ;				write a line of 0s at X (bottom of the screen?)
FC45      C6 20          LDB     #$20   ;				$20 lots of 2 bytes is one screen line
FC47      EF 81          STU     ,X++   ;				write the 0
FC49 Z    5A             DECB           ;				dec the number of writes needed
FC4A &    26 FB          BNE     $FC47  ;				do more writes
;
FC4C 5    35 F4          PULS    PC,U,Y,X,B;			Return
->
;
;	SCROLL DOWN
;	-----------
;
Routine:
FC4E 4t   34 74          PSHS    U,Y,X,B;				Save registers
FC50      9E 84          LDX     $84    ;(DP$84);		Start of last line of the screen
FC52 0    30 88 C1       LEAX    $-3F,X ;				the line above that
->
FC55      A6 82          LDA     ,-X    ;				get the characer from this line
FC57   @  A7 88 40       STA     $40,X  ;				store it on the next line
FC5A  c   AC 63          CMPX    $03,S  ;				until we're done
FC5C &    26 F7          BNE     $FC55  ;				copy more characters
;
FC5E      DC 88          LDD     $88    ;(DP$88);
FC60      20 DE          BRA     $FC40  ;				insert a line of spaces
;
;
;
FC62      10 9E 82       LDY     $82    ;(DP$82);		Y = Start of text screen
FC65      8D E7          BSR     $FC4E  ;				scroll TEXT screen down
FC67 0 @  30 88 40       LEAX    $40,X  ;				next line
FC6A      20 11          BRA     $FC7D  ;
->
FC6C      10 9E 84       LDY     $84    ;(DP$84);		start of last line of text screen
FC6F 1    31 A8 C1       LEAY    $-3F,Y ;
FC72      8D BA          BSR     $FC2E  ;				CALL scroll up one line
FC74 0    30 88 C0       LEAX    $-40,X ;
FC77      20 04          BRA     $FC7D  ;
->
;
;
;
;
Routine:
FC79      9E 80          LDX     $80    ;(DP$80);
FC7B 4    34 20          PSHS    Y      ;
->
FC7D      9C 82          CMPX    $82    ;(DP$82);		Start of TEXT screen
FC7F %    25 E1          BCS     $FC62  ;				scroll
FC81      9C 84          CMPX    $84    ;(DP$84);		last line of TEXT screen
FC83 "    22 E7          BHI     $FC6C  ;				scroll
FC85      9F 80          STX     $80    ;(DP$80);
FC87 5    35 A0          PULS    PC,Y   ;				Return
->
FC89      C1 7F          CMPB    #$7F   ;
FC8B '2   27 32          BEQ     $FCBF  ;
FC8D      C1 1A          CMPB    #$1A   ;
FC8F "    22 10          BHI     $FCA1  ;
FC91 1    31 8C 10       LEAY    $10,PC ;
FC94 1    31 A5          LEAY    B,Y    ;
FC96      E6 A4          LDB     ,Y     ;
FC98 1    31 8D 00 8B    LEAY    $008B,PC;
FC9C      AD A5          JSR     B,Y    ;
FC9E      1A 01          ORCC    #$01   ;
FCA0 9    39             RTS            ;			Return
->
FCA1      1C FE          ANDCC   #$FE   ;
FCA3 9    39             RTS            ;
->
FCA4 00 0B 57 00 A9 AE 00 00 A7 A9 B1 AE CB D8 00 00 ..W.............   ;
FCB4 08 01 DF A7 F2 EA 05 00 B1 00 00                ...........        ;
->
FCBF      1F 12          TFR     X,Y    ;
->
FCC1      A6 A0          LDA     ,Y+    ;
FCC3  >   A7 3E          STA     $-02,Y ;
FCC5 '    27 07          BEQ     $FCCE  ;
FCC7      10 9C 84       CMPY    $84    ;(DP$84);
FCCA #    23 F5          BLS     $FCC1  ;
FCCC o?   6F 3F          CLR     $-01,Y ;
->
FCCE 0    30 1E          LEAX    $-02,X ;
FCD0 0    30 01          LEAX    $01,X  ;
FCD2      1A 01          ORCC    #$01   ;
FCD4 9    39             RTS            ;
->
Routine:
FCD5 0    30 88 80       LEAX    $-80,X ;
FCD8 0 @  30 88 40       LEAX    $40,X  ;
->
FCDB      1F 10          TFR     X,D    ;
FCDD      C4 C0          ANDB    #$C0   ;
FCDF      1F 02          TFR     D,Y    ;
->
FCE1 1?   31 3F          LEAY    $-01,Y ;
FCE3      10 9C 82       CMPY    $82    ;(DP$82);
FCE6 %    25 04          BCS     $FCEC  ;
FCE8 m    6D A4          TST     ,Y     ;
FCEA &    26 F5          BNE     $FCE1  ;
->
FCEC 1!   31 21          LEAY    $01,Y  ;
FCEE      10 9F 88       STY     $88    ;(DP$88);
FCF1 9    39             RTS            ;				Return
->
;
;	ZERO then do something else
;	----
;	Zero all memory locations between those specified in DP$82..DP$84 (inclusive of both)
;
Routine:
FCF2      9E 84          LDX     $84    ;(DP$84);		load the end address
FCF4 0    30 01          LEAX    $01,X  ;				add 1
FCF6 O    4F             CLRA           ;				A = 0
->
FCF7      A7 82          STA     ,-X    ;				store 0
FCF9      9C 82          CMPX    $82    ;(DP$82);		are we done?
FCFB &    26 FA          BNE     $FCF7  ;				do more writes
FCFD      20 DC          BRA     $FCDB  ;
->
Routine:
FCFF      1F 10          TFR     X,D    ;
FD01      C4 C0          ANDB    #$C0   ;
FD03      1F 01          TFR     D,X    ;
FD05 9    39             RTS            ;
->
;
;	SET SCREEN ADDRESS
;	------------------
;
Routine:
FD06      CC E8 00       LDD     #$E800 ;				Start of the TEXT screen
FD09      DD 82          STD     $82    ;(DP$82);		is stored at E082
FD0B      CC ED FF       LDD     #$EDFF ;				Start of the last line of the TEXT screen
FD0E      DD 84          STD     $84    ;(DP$84);		is stores at E084
FD10 9    39             RTS            ;				Return
->
Routine:
FD11 0    30 1F          LEAX    $-01,X ;
FD13      9F 84          STX     $84    ;(DP$84);
FD15      9F 88          STX     $88    ;(DP$88);
FD17      20 02          BRA     $FD1B  ;
->
FD19 9F 82                                           ..                 ;
->
FD1B      DC 82          LDD     $82    ;(DP$82);
FD1D      C3 00 80       ADDD    #$0080 ;
FD20      10 93 84       CMPD    $84    ;(DP$84);
FD23 %    25 02          BCS     $FD27  ;
FD25      DD 84          STD     $84    ;(DP$84);
->
FD27 9    39             RTS            ;				Return
->
Routine:
FD28      9E 82          LDX     $82    ;(DP$82);
FD2A      20 AF          BRA     $FCDB  ;
->
FD2C 03 86 39 03 8A 39 C6 20 34 16 9C 84 27 32 6D 80 ..9..9. 4...'2m.   ;
FD3C 26 F8 1F 10 C5 3F 26 02 8D 3A 30 1F A6 1F A7 84 &....?&..:0.....   ;
FD4C AC 62 26 F6 35 16 E7 84 1F 12 10 9C 82 23 10 1E .b&.5........#..   ;
FD5C 02 C5 3F 27 0A 1E 02 6D A2 26 04 E7 A4 20 EB 39 ..?'...m.&... .9   ;
FD6C 31 88 C1 17 FE BC EC 62 83 00 40 ED 62 30 88 C0 1......b..@.b0..   ;
FD7C 20 CA DC 80 C4 C0 1F 02 DC 84 C4 C0 34 06 10 AC  ...........4...   ;
FD8C E1 10 26 FE BD 34 74 16 FE AA                                      .~..               ;
;
;
;	FIRQ Interrupt Handler
;	----------------------
;
FD96 z    7A EF 8D       DEC     $EF8D  ;
FD99 .    2E 12          BGT     $FDAD  ;		RTI (chain to an alternative interrupt handler)
FD9B 4    34 12          PSHS    X,A    ;		save X and A
FD9D  2   86 32          LDA     #$32   ;
FD9F      8E EF 91       LDX     #$EF91 ;
FDA2      A7 1C          STA     $-04,X ;
FDA4 l    6C 82          INC     ,-X    ;
FDA6 '    27 FC          BEQ     $FDA4  ;
FDA8      BD EF C1       JSR     $EFC1  ;
FDAB 5    35 12          PULS    X,A    ;		restore X and A
FDAD ~    7E EF B2       JMP     $EFB2  ;		EFB2 holds an RTI instruction
;
->
;
;	SWAP ENDIANNESS OF $EFC0
;
Routine:
FDB0 4    34 06          PSHS    D      ;
FDB2      FC EF C0       LDD     $EFC0  ;
FDB5      1E 89          EXG     A,B    ;
FDB7      FD EF C0       STD     $EFC0  ;
FDBA 5    35 86          PULS    PC,D   ;
;
;
;
Routine:
FDBC 4    34 10          PSHS    X      ;
FDBE      EC C4          LDD     ,U     ;
FDC0      B6 E0 00       LDA     $E000  ;		PIA?
FDC3      84 FE          ANDA    #$FE   ;
FDC5      B7 E0 00       STA     $E000  ;
FDC8      8E 00 00       LDX     #$0000 ;
->
FDCB      F5 E0 00       BITB    $E000  ;
FDCE '    27 04          BEQ     $FDD4  ;
FDD0 0    30 01          LEAX    $01,X  ;
FDD2      20 F7          BRA     $FDCB  ;
->
FDD4      8A 01          ORA     #$01   ;
FDD6      B7 E0 00       STA     $E000  ;
FDD9      AF C4          STX     ,U     ;
FDDB 0    30 01          LEAX    $01,X  ;
->
FDDD 0    30 1F          LEAX    $-01,X ;
FDDF &    26 FC          BNE     $FDDD  ;
FDE1 5    35 90          PULS    PC,X   ;
->
Rountine:
FDE3 4    34 16          PSHS    X,D    ;		save X and D
FDE5      1C FE          ANDCC   #$FE   ;		clear the carry flag
FDE7      C6 0A          LDB     #$0A   ;		B = $0A
FDE9 4    34 04          PSHS    B		;		Push $0A onto stack
FDEB F    46             RORA           ;
->
FDEC      F6 E0 00       LDB     $E000  ;		Read a byte from the PIA
FDEF M    4D             TSTA           ;
FDF0 *    2A 04          BPL     $FDF6  ;		if A > 0 goto $FDF6 (high bit not set)
FDF2      CA 80          ORB     #$80   ;		turn the high bit on
FDF4      20 02          BRA     $FDF8  ;
->
FDF6      C4 7F          ANDB    #$7F   ;		turn top bit off
->
FDF8      F7 E0 00       STB     $E000  ;		store it in the data register
;
FDFB      BE EF A4       LDX     $EFA4  ;		timing loop
FDFE 0    30 1F          LEAX    $-01,X ;		X = X - 1
FE00 &    26 FC          BNE     $FDFE  ;		if (X != 0) loop
;
FE02 F    46             RORA           ;
FE03  @   8A 40          ORA     #$40   ;
FE05 j    6A E4          DEC     ,S     ;		dec the byte count
FE07 &    26 E3          BNE     $FDEC  ;		read more data
FE09 5    35 04          PULS    B      ;		remove the count
FE0B 5    35 96          PULS    PC,X,D ;		return
->
Routine:
FE0D 4T   34 54          PSHS    U,X,B  ;
->
FE0F      FC EF A4       LDD     $EFA4  ;
FE12 D    44             LSRA           ;
FE13 V    56             RORB           ;
FE14      1F 01          TFR     D,X    ;
FE16      B6 E0 00       LDA     $E000  ;
FE19  @   84 40          ANDA    #$40   ;
FE1B &    26 F2          BNE     $FE0F  ;
->
FE1D 0    30 1F          LEAX    $-01,X ;		timing loop
FE1F &    26 FC          BNE     $FE1D  ;		timing loop
;
FE21      B6 E0 00       LDA     $E000  ;
FE24  @   84 40          ANDA    #$40   ;
FE26 &    26 E7          BNE     $FE0F  ;
FE28      C6 09          LDB     #$09   ;
FE2A 4    34 04          PSHS    B      ;
->
FE2C      BE EF A4       LDX     $EFA4  ;		timing loop
FE2F 0    30 1F          LEAX    $-01,X ;		timing loop
FE31 &    26 FC          BNE     $FE2F  ;		timing loop
;
FE33      F6 E0 00       LDB     $E000  ;
FE36 Y    59             ROLB           ;
FE37 Y    59             ROLB           ;
FE38 F    46             RORA           ;
FE39 j    6A E4          DEC     ,S     ;
FE3B &    26 EF          BNE     $FE2C  ;
FE3D I    49             ROLA           ;
FE3E 2a   32 61          LEAS    $01,S  ;
FE40 5    35 D4          PULS    PC,U,X,B;
;
FE42      B6 E0 00       LDA     $E000  ;
FE45  @   84 40          ANDA    #$40   ;
FE47  @   88 40          EORA    #$40   ;
FE49 9    39             RTS            ;
->
FE4A C6 A5 F1 EF C8 27 23 F7 EF C8 8E 00 00 96 00 34 .....'#........4   ;
FE5A 02 30 01 A6 01 E7 01 0F 00 E1 01 34 01 A7 01 35 .0.........4...5   ;
FE6A 01 27 EE BF EF C6 35 02 97 00 BE EF C6 1F 10 39 .'....5........9   ;
->
;
;	INIT
;	----
;	Called after power on but before calling $F000
;	Sets up a branch table at EF80
;	EF80:	E800
;	EF82:	E800			// start of TEXT screen
;	EF84:	EDFF			// end of TEXT screen
;	EF86:	FFFF
;	EF88:	XX XX
;	EF8A:	XX 0C
;	EF8C:	XX XX
;	EF8E:	XX XX
;	EF90:   XX XX
;	EF92:   XX 00
;	EF94:   0C 00
;	EF96:   00 XX
;	EF98:   XX XX
;	EF9A:   XX XX
;	EF9C:   XX XX
;	EF9E:   XX XX
;
FE7A      8E EF 80       LDX     #$EF80 ;	Set up branch table
FE7D      CC E8 00       LDD     #$E800 ;
FE80      ED 81          STD     ,X++   ;
FE82      ED 81          STD     ,X++   ;
FE84      CC ED FF       LDD     #$EDFF ;
FE87      ED 81          STD     ,X++   ;
FE89      C6 FF          LDB     #$FF   ;
FE8B O    4F             CLRA           ;
FE8C      A7 04          STA     $04,X  ;
FE8E C    43             COMA           ;
FE8F      ED 81          STD     ,X++   ;	Store FFFF at the end of the list
FE91      86 0C          LDA     #$0C   ;	A = 0C
FE93   f  17 FD 66       LBSR    $FBFC  ;	print character		(print Form Feed character)
FE96      A7 03          STA     $03,X  ;
FE98      A7 0C          STA     $0C,X  ;
FE9A o    6F 0B          CLR     $0B,X  ;
FE9C }    7D E0 08       TST     $E008  ;
FE9F *    2A 02          BPL     $FEA3  ;
FEA1 j    6A 0B          DEC     $0B,X  ;
->
FEA3 o    6F 0D          CLR     $0D,X  ;
FEA5 o    6F 0E          CLR     $0E,X  ;
FEA7      8E E0 00       LDX     #$E000 ;
FEAA o    6F 01          CLR     $01,X  ;			E001 = 0
FEAC   4  CC B9 34       LDD     #$B934 ;
FEAF      ED 84          STD     ,X     ;			E000 = B9  E001 = 34
FEB1      84 C7          ANDA    #$C7   ;
FEB3      AA 84          ORA     ,X     ;			read from E000
FEB5      A7 84          STA     ,X     ;			write it back to E000
FEB7      86 18          LDA     #$18   ;
FEB9      B7 EF 9E       STA     $EF9E  ;
FEBC   q  CC 02 71       LDD     #$0271 ;			value used in timing loop for device at $E000
FEBF      FD EF A4       STD     $EFA4  ;			timing loop counter address
FEC2      8D 86          BSR     $FE4A  ;
FEC4  ;   86 3B          LDA     #$3B   ;		RTI instruction (return from interrupt)
FEC6      B7 EF B2       STA     $EFB2  ;		FIRQ handler (RTI instruction)
FEC9      B7 EF BA       STA     $EFBA  ;		NMI handler (RTI instruction)
FECC      FC FF FE       LDD     $FFFE  ;		read the RESET vector address
FECF      FD EF C4       STD     $EFC4  ;		EFC4 = Reset vector
FED2  9~  CC 39 7E       LDD     #$397E ;
FED5      FD EF C0       STD     $EFC0  ;		EFC0 = 397E
FED8      CC FE EA       LDD     #$FEEA ;
FEDB      FD EF C2       STD     $EFC2  ;		EFC2 = FEEA
FEDE      1C BF          ANDCC   #$BF   ;
FEE0 9    39             RTS            ;		Return
;
;
;	FFF0 FFF1		Reserved	FFFF
;	FFF2 FFF3		SWI3		EFA6
;	FFF4 FFF5		SWI2		EFAA
;	EFB2		FIRQ
;	FFF8 FFF9		IRQ			EFB6
;	FFFA FFFB		SWI			EFAE
;	EFBA		NMI
;	EFC4		RESET
;
->
Routine:
;
;	PRINT STRING
;	------------
;	Print a '\0' terminated string pointed to by X, interpreting <CR> and (presumably) other special characters
;
FEE1      A6 80          LDA     ,X+    ;		Read the first character
FEE3      17 FD 16       LBSR    $FBFC  ;		print the character
FEE6 M    4D             TSTA           ;		is A == 0 ('\0' termination)
FEE7 &    26 F8          BNE     $FEE1  ;		Loop back around for the next character
FEE9 9    39             RTS            ;		Return

->
Routine;
FEEA      86 FB          LDA     #$FB   ;
FEEC      B7 E0 0C       STA     $E00C  ;		write $FB to the keyboard
FEEF }    7D E0 08       TST     $E008  ;		read from the keyboard
FEF2 +    2B 0A          BMI     $FEFE  ;		if the high bit is set then return
FEF4      10 CE EF 00    LDS     #$EF00 ;		put the stack at EF00 (is this a keyboard buffer?)
FEF8      1C BF          ANDCC   #$BF   ;		clear the 'F' flag (the FIRQ flag)
FEFA n    6E 9F EF C4    JMP     [$EFC4];		call what ever is here (written to by the menu choice)
FEFE 9    39             RTS            ;		Return
->
Routine:
;
;	ROM Entry point
;	---------------
;
FEFF      10 CE EF 00    LDS     #$EF00 ;	Load the stack
FF03      AD 9F FF EE    JSR     [$FFEE];	call INIT at FE7A
FF07 ~    7E F0 00       JMP     $F000  ;	Start the ROM
->
FF0A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF1A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF2A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF3A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF4A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF5A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF6A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF7A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF8A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF9A FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFAA FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFBA FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFCA FF FF FF FF FF FF
;
;	BIOS Function Table
;
FFD0		FE0D
FFD2		FDE3
FFD4		FE42
FFD6		F885
FFD8		FDBC
FFDA	 	F800
FFDC		FE4A
FFDE		FDB0
FFE0		FA76
FFE2		FBFC		; Print character
FFE4		FAC8		; get character or 0 if none is awaiting
FFE6		FBB8
FFE8		FEE1		; Print string
FFEA 		F904
FFEC		F98E
FFEE		FE7A		; INIT before F000 is called

;;	6809 Interrupts Meaning		Value

	FFF0 FFF1		Reserved	FFFF
	FFF2 FFF3		SWI3		EFA6
	FFF4 FFF5		SWI2		EFAA
	FFF6 FFF7		FIRQ		FD96
	FFF8 FFF9		IRQ			EFB6
	FFFA FFFB		SWI			EFAE
	FFFC FFFD		NMI			EFBA
	FFFE FFFF		RESET		FEFF
