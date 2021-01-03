//***********************************************************
//	Zelda 1 Credits Text
//***********************************************************

//****************************************
// Table file
//****************************************
table code/text/text.tbl,ltr

//****************************************
// Control codes
//****************************************
define	nextline	$40	// Jump to next line
define	endline		$C0	// End line parsing
define	end		$FF 	// End

//***********************************************************
//	"Saving Zelda" text pointers
//***********************************************************
bank 2;
// Pointers for text that appears right after saving Zelda
org $A9B4	// 0x0A9C4
	lda.b #end_text1
	sta.b $00
	lda.b #end_text1>>8
	sta.b $01

// Horizontal starting position for "THANKS LINK..."
org $A94A	// 0x0A95A
	lda.b #$A6	// Originally LDA #$A4
// Horizontal starting position for "THE HERO..."
org $A992	// 0x0A9A2
	db $C4,$E7	// Originally C4 E4
//This is an LDA $AB67,Y (B9 07 AB in Hex starting at $AB56)
org $AB56	// 0x0AB66
	lda.w end_text2,y	// Originally LDA $AB07,Y
// The table here tells the game what position each character in the "PEACE RETURNS TO HYRULE" text is placed in the Credits
org $AB6C	// 0x0AB7C

	lda.w layout_text2,y	// Originally LDA $AAD3,Y

//***********************************************************
//	Credits roll text pointers
//***********************************************************

// The credits pointers are stored in a very odd way ($17 entries)
// For the first entry in the credits, "STAFF" located at $AC5C (or 0x0AC6C), the pointer is $AC5C.
// The 2 byte pointers are separated into two different addresses. The lower bytes for each pointer begin at $AC2E (or 0x0AC3E) with $5C. and the second/high byte of the pointers begin at $AC45 (or 0x0AC55) with $AC. The two bytes combined form the pointer for the "STAFF" text. Code related to the credits begins at $AE13.

bank 2;
// Credits roll low and high byte pointers tables
org $AE8A	// 0x0AE9A
// LDA for the pointer lower bytes table
	lda.w low_bytes,y	// LDA $AC2E,Y
org $AE8F	// 0x0AE9F
// LDA for the pointer lower bytes table
	lda.w high_bytes,y	// LDA $AC45,Y


org $ac16
PPUDestLow:
db $28,$29,$2A,$2B,$20,$21,$22,$23,$28,$29,$2A,$2B
org $ac22
PPUDestOffset:		//LineBreaks
db $46,$10,$90,$84,$24,$30,$01,$48,$03,$25

// Pointer low byte for each entry
org $AC2E	// 0x0AC3E
low_bytes:
	db credits_00,credits_01,credits_02,credits_03
	db credits_04,credits_05,credits_06,credits_07
	db credits_08,credits_09,credits_10,credits_11
	db credits_12,credits_13,credits_14,credits_15
	db credits_16,credits_17,credits_18,credits_19
	db credits_20,credits_21,credits_22

// Pointer high byte for each entry
org $AC45	// 0x0AC55
high_bytes:
	db credits_00>>8,credits_01>>8,credits_02>>8,credits_03>>8
	db credits_04>>8,credits_05>>8,credits_06>>8,credits_07>>8
	db credits_08>>8,credits_09>>8,credits_10>>8,credits_11>>8
	db credits_12>>8,credits_13>>8,credits_14>>8,credits_15>>8
	db credits_16>>8,credits_17>>8,credits_18>>8,credits_19>>8
	db credits_20>>8,credits_21>>8,credits_22>>8


org $AC5C	// 0x0AC6C
// Blank out all of the original Credits text previous data (for extra free space in case it`s needed). This gives 0x19E bytes of free space!
	fillto $ADFA,$FF

//***********************************************************
//   "Saving Zelda" 1st and 2nd text
//***********************************************************

// First text after saving Zelda
org $A860	// 0x0A870
// The table found here determines the position of each character in the 'end_text2' text table. Each value corresponds to each text character (one by one). If said text is extended (or shortened), so should this table to account for the new (or reduced) characters, as well as their position in the screen.

layout_text2:
// FINALLY,
	db $AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4
// PEACE RETURNS TO HYRULE.
	db $E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF,$F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$F9,$FA,$FB
// THIS ENDS THE STORY.
	db $4C,$4D,$4E,$4F,$50,$51,$52,$53

end_text1:	// $A8A0 - Originally $A959, 0x0A969
	db "THANKS, LINK, YOU'RE",	' '|{nextline}
	db "THE HERO OF HYRULE",	'!'|{endline}
// Second text after saving Zelda
end_text2:	// $A8C8 - Originally $AB07, 0x0AB17
	db "AND THUS,"			//24 0A 17 0D 24 1C 18 28
	db "PEACE RETURNS TO HYRULE."	//19 0E 0A 0C 0E 24 1B 0E 1D 1E 1B 17 1C 24 1D 18 24 11 22 1B 1E 15 0E 2C
	db "THE END.",{end}//24 24 24 24 FF
	fillto $A900,$FF

//***********************************************************
//  Credits Roll and Post-credits text
//***********************************************************

org $B050	// 0x0B060 - Originally $AC60, 0x0AC70
// Length, X Position, "Text"
// Hiroshi Yamauchi, Shigeru Miyamoto, Takashi Tezuka, Toshihiko Nakago, Yasunari Soejima, Tatsuo Nishiyama, Koji Kondo
credits_00:
	db $07,$0C," STAFF "			// STAFF
credits_01:
	db $13,$07,"EXECUTIVE PRODUCER:"	// Executive Producer:
credits_02:
	db $10,$08,"HIROSHI YAMAUCHI"		// Hiroshi Yamauchi
credits_03:
	db $16,$05,"PRODUCER... S.MIYAMOTO"	// Producer... Shigeru Miyamoto
credits_04:
	db $16,$05,"DIRECTOR... S.MIYAMOTO"	// Director... Shigeru Miyamoto
credits_05:
	db $0E,$09,"TAKASHI TEZUKA"		// ..... Takashi Tezuka
credits_06:
	db $16,$05,"DESIGNER..... T.TEZUKA"	// Designer... Toshihiko Nakago
credits_07:
	db $16,$05,"PROGRAMMER... T.NAKAGO"	// Programmer... Yasunari Soejima
credits_08:
	db $10,$08,"YASUNARI SOEJIMA"		// Yasunari Soejima
credits_09:
	db $10,$08,"TATSUO NISHIYAMA"		// Tatsuo Nishiyama
credits_10:
	db $0F,$09,"SOUND COMPOSER:"		// Sound Composer:
credits_11:
	db $0A,$0B,"KOJI KONDO"			// Koji Kondo

credits_12:
	db $18,$04,"ANOTHER QUEST WILL START"	// Another quest will start
credits_13:
	db $0A,$0B,"FROM HERE."			// from here.
credits_14:
	db $17,$05,"PRESS THE START BUTTON."	// Press the START button
credits_15:
	db $0E,$09,$FC,"1986 NINTENDO"		// (C)1986 Nintendo

credits_16:
	db $0E,$09,"YOU ARE GREAT!"		// You are great!
credits_17:
	db $0D,$09,"         -   "		// "         -   "
credits_18:
	db $13,$06,"YOU HAVE AN AMAZING"	// You have an amazing
credits_19:
	db $11,$08,"WISDOM AND POWER!"		// Wisdom and Power!
credits_20:
	db $07,$0C,"THE END"			// The End
credits_21:
	db $15,$05,$2D,"THE LEGEND OF ZELDA",$2D// "The Legend of Zelda"
credits_22:
	db $0E,$09,$FC,"1986 NINTENDO",{end}	// (C)1986 Nintendo

org $abc0
db $02,$03,$78,$00	//Timer how long to scroll 02 78 lines first quest. 03 00 line second quest.

//$E2 + $FC TimerLine count 
//$50C	? Where to update nametable?
//$50D	? Steps 00 to 07
//$50E TextPointer ID

//302 PPU Highbyte. $FF will not run it. $22 is also the high_byte of the destination?
//303 PPU Lowbyte? Followed by nametable data


org $ae13
	LDY #$1F   	//Stores 2 lines of $24 probably empty space              
	LDA #$24                 
LoopEmptySpace:  	
	STA $0305,y 	//$305+ Will be the table that will update the ppu with one line of nametable data             
	DEY                      
	BPL LoopEmptySpace               
	
	LDA $050A  	//Flag for text pointer load              
	BEQ SetEndDataTable                
	CMP #$01                 
	BEQ DrawBorder                
	CMP #$2E                 
	BCC DrawBorder2               
	BNE SetEndDataTable                

DrawBorder:	
	LDY #$19                 	
	LDA #$FA   	//BorderTile (bricks)              

LoopBorderTop:	
	STA $0308,y              
	DEY                      
	BPL LoopBorderTop              

DrawBorder2:	
	LDA #$FA                 
	STA $0308                
	STA $0321                

SetEndDataTable:	
	LDA #$FF 				//?              
	STA $0325                
	STA $0330                
	LDA #$20                 
	STA $0304                
	LDX $050C                
	LDA PPUDestLow,x 	//$ac16             
	STA $0302                
	LDA $050D                
	TAY                      
	ASL                   
	ASL                    
	ASL                    
	ASL                    
	ASL                    
	
	STA $0303                
	LDA PPUDestOffset,x 	//$ac22 	//LineBreaks            
BitCheck:	
	ASL                   
	DEY                      
	BPL BitCheck                
	BCC $79
	
	LDY $050E   		//Load Text Pointer ID             
	CPY #$17			//Compare if the end of the table is reached? SecondQuest? $17                 
	BCS LineStepper            
	LDX $16                  
	LDA $062D,x            
	BNE TextCheck              
	CPY #$10                 
	BCS IncreaseTexpointerID            
	
TextCheck:	
	LDX $16                  
	LDA $062D,x              
	BEQ LoadTextPointer                
	CPY #$0C                 
	BCC LoadTextPointer           
	CPY #$10                 
	BCC IncreaseTexpointerID           

LoadTextPointer:	
	LDA low_bytes,y        	//$AC2E      
	STA $00                  
	LDA high_bytes,y        	//$AC45      
	STA $01                  
	LDY #$00                 
	LDA ($00),y         			//copy pointer from $00 to $02 too     
	STA $02                  
	INY                      
	LDA ($00),y              
	TAX                      
	INY                      

WriteTextLoop:	
	LDA ($00),y              	
	STA $0305,x              
	INY                      
	INX                      
	DEC $02                  
	BNE WriteTextLoop
	
	LDY $050E                
	CPY #$0C 					//EmptyLine?                
	BCC IncreaseTexpointerID                
	CPY #$11          			//EmptyLine?         
	BNE IncreaseTexpointerID                
	
	LDA $16                  
	ASL                   
	ASL                   
	ASL                   
	TAY                      
	LDX #$00                 

LoopFor:	
	LDA $0638,y   		//Updates stuff in RAM to PPU nametable data           
	STA $030E,x              
	INY                      
	INX                      
	CPX #$08                 
	BCC LoopFor                
	
	LDY $0016                
	LDA $0630,y              
	JSR $6E55 			//?          
	LDX #$02                 
LoopFor2:	
	LDA $01,x                
	STA $0318,x              
	DEX                      
	BPL LoopFor2               

	LDY $050E                
IncreaseTexpointerID:	
	INC $050E                
LineStepper:	
	INC $050D                
	LDA $050C                
	AND #$03                 
	CMP #$03                 
	LDA #$08                 
	BCC Check  	//?            
	LDA #$06                 
Check:	
	CMP $050D                
	BNE LineWhatEver               
	LDA #$00                 
	
UpdateLineStepper:	
	STA $050D                
	LDY $050C                
	INY                      
	CPY #$0C                 
	BCC LineWhat               
	TAY                      
LineWhat:
	STY $050C                	
LineWhatEver:	
	LDA $050A                
	LSR                   
	BCS EndLine               
	LSR                   
	BCS EndLine                
	LDX #$00                 
	STX $0328                
	STX $032F                
	TAY                      
	LDA $ADFA,y              
	LDY #$05                 

LoopWhat:	
	STA $0329,y              
	DEY                      
	BPL LoopWhat                
	
	LDY #$23                 
	LDA $0302                
	AND #$08                 
	BEQ $AF30                
	LDY #$2B                 

EndFlag:	
	STY $0325                
	LDA $050A                
	AND #$1F                 
	ASL                   
	ADC #$C0                 
	STA $0326                
	LDA #$08                 
	STA $0327                

EndLine:	
	LDY $050A                
	INY                      
	TYA                      
	AND #$1F                 
	CMP #$1E                 
	BCC EndEver              
	INY                      
	INY                      
EndEver:	
	STY $050A                
	RTS                      
	

