//-------------------------------------------------------------------------------
// iNES Header
//-------------------------------------------------------------------------------
           db $4e,$45,$53,$1A    	// Header (NES $1A)
           db 8             		// 8 x 16k PRG banks
           db 8	            		// 8 x 8k CHR banks
           db %01010010      		// Mirroring: Vertical
									// SRAM: Yes
									// 512k Trainer: Not used
									// 4 Screen VRAM: Not used
									// Mapper: 5
           db %00000000      		// RomType: NES
           db $00,$00,$00,$00  		// iNES Tail 
           db $00,$00,$00,$00    
//-------------------------------------------------------------------------------
// ROM Start		PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 2;
org $8000		         
//org $a5e4
//		lda #$00	//load overworld
//		sta $10		
//		sta $656

bank 3;				////PRG c000

//org $abfc				
//	jsr $8091			//Load GFX No Loads are disabled. Might be usefull to free some space.
		
bank 5;				
org $b489			//This is run to go to a other level
//	ldy	$eb			//Y is based on maplocation
//	lda $68fe,y		//Load Dungeon 01 store calculated value to $10. 
//	
//	AND #$FC                 
//	CMP #$40                 
//	BCC StoreCurrentLevel                
//	LDY #$0B                 
//	CMP #$50                 
//	BNE DoElse     	//used for single rooms?           
//	INY                      
//DoElse:	
//	TYA                      
//	JMP $B44C                
//StoreCurrentLevel:	
//	LSR         
//	LSR               
//	STA $10                  

//-------------------------------------------------------------------------------
// Bank6 $18 000
//-------------------------------------------------------------------------------
bank 6;
org $8000		

org $8070
//	jsr CHRSwaping	//Hijack without disableing old PPU load routine since it is used for multiple things.. used in MMC5features.asm

//	LDA $10			//LoadCurrentLevel                  
//	ASL                   
//	TAX                      
//	LDA $8014,x    	//Loda graphic pointer based on Level 	     	
//	STA $00                  
//	INX                      
//	LDA $8014,x            
//	STA $01                  
//	JSR $80B5                
//	JSR $80D7                
//	LDA #$00                 
//	STA $13                  
//	INC $11                  
//	RTS                      


//-------------------------------------------------------------------------------
// Bank7 $1c 000 	
//-------------------------------------------------------------------------------
bank 7;
org $c000

	org $e45b				//Jump waiting for interupt. After RTI waiting for NMI

	org $e9bb
		bne $05
		lda #%01000100	// #$44 Vertical Scrolling
		sta $5105		//NametableSetting
		rts
	
	org $e9cb
		nop
		nop
		nop
		nop
		nop
		
	org $eb70
		nop
		nop
		nop
		nop
		nop
		rts
		
	org $ebb1
		nop
		nop
		nop
		nop
		nop

	org $ff43		//Orginal VectorStart
VectorStart:				//MMC5 Vector Initial Settings
		LDA #$01			//Set 16kb ($4000) segment Bank	
		STA $5100
		LDA #%00000011		//Set CHR mode 00=8KB pages 03=1KB pages
		STA $5101
		LDA #%00000010		//Enable PRG RAM=02
		STA $5102
		LDA #%00000001		//Enable PRG RAM=01	
		STA $5103
		LDA #%01010000		//$50 NameTable Setting Horizontal Scrolling
		STA $5105

InitialSet:				//It will set everything to default. Not sure if this is needed or even right in here.
//		LDA #$00			//PRG BankSwitch Setting (PRG RAM Mode 1 {Mode is set in $5100})
//		STA $5113
//		LDA #$0F			//PRG BankSwitch (PRG RAM Mode l) 16kb sould ignore lower bits
//		STA $5015
//		LDA #$80			//PRG BankSwitch $8000-$bfff (PRG Mode l) 16kb sould ignore lower bits
//		STA $5115
//		LDA #$8E			//PRG BankSwitch $c000-$ffff (PRG Mode l) 16kb sould ignore lower bits
//		STA $5117

		LDA #$06			//SwapBank 06
		JSR BankSwapPRG
		JSR SetCHRStart

OrginalVectorStart:                      
		CLD                      
		LDA #$00                 
		STA $2000                
		LDX #$FF                 
		TXS                      
PPUReady:
		LDA $2002                
		AND #$80                 
		BEQ PPUReady                
PPUReady2:	
		LDA $2002                
		AND #$80                 
		BEQ PPUReady2                
		RTS
	
org $ffac				//Orginal PRG swap start will make it more compatible with other patches I hope..
	BankSwapPRG:
		PHA					
		ASL
		ADC #$80		//Add base to the bank offset
		STA $5115		//Swap PRG Bank $8000-$bfff
		PLA
		RTS
	fillbyte $ff
	fillto $ffe2

	
org $ffe2	
	SetHorizontalScroll:
		STA $0302			//HudUpdateTable will be off when FF
		LDA #%01010000		//$50 NameTable Setting Horizontal Scrolling
		STA $5105
		RTS
		
	org $fffc
		dw VectorStart		//Vector Reset Pointer
//-------------------------------------------------------------------------------
// Bank8 $20 000
//-------------------------------------------------------------------------------
bank 8;
	org $8000
		incbin Code/gfx/NewCHR.bin

//---------------------------------------------------------------------------------		
//Notes
//PRG $8000 Graphic pointer 7F80 7F87 7F8E Link, Font, Key // 3 enteries Source Leangth PPUDestination
//	  $b496 Title
//	  $c028 Main	

//  PRG ROM
//	4dc4 Puff Letter Magic
//	808f Link Main
//	878f Sprites
//	c12b Dungeon Sprite

//  4d38 Title Screen
//  c010 Sprite Pinter Dungeon (10 Index??)
//  c030 Graphic Pointer 	xxxx 		yyyy
//  						DestTile	DestSprit
//  
//  c05e index 0 overwold 1 title?	
//  
//  c028
//  00 = Dungeon Doors covers Map
//  01 = Monster Dungeon 1
//  03 = Overworld
//  04 = Enemy set Overworld
//

//	c026 Ganon
//
//	c014


//PRG $18000 Dungeon Pointer

//18000	18013	Ten 2-byte pointers specifying which PPU Spriteblock to use for levels 0 (overworld) and 1 - 9.
//18014	18027	Ten 2-byte pointers specifying location of level data blocks.
//1802A	1803D	Ten 2-byte pointers specifying which PPU Spriteblock to use for levels 0 - 9 for second quest.

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// PRG Bank Swap Replacment  till end of file.
//-------------------------------------------------------------------------------
// ROM Start		PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 0;
org $8000
	
	org $bf7b
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDA #$07
		JSR $BFAC
		JMP $E440
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		JSR BankSwapPRG
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		
	
	
//-------------------------------------------------------------------------------
// Bank1 $4000			PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 1;	         
org $8000
	
org $bf7b
	
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDA #$07
		JSR $BFAC
		JMP $E440
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		JSR BankSwapPRG
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS

//-------------------------------------------------------------------------------
// Bank2 $8000		PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 2;
org $8000		         
	org $bf7b
	
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDA #$07
		JSR $BFAC
		JMP $E440
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		JSR BankSwapPRG
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
	
	
//-------------------------------------------------------------------------------
// Bank3 $c000		PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 3;
org $8000	
	
	org $bf7b
	
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDA #$07
		JSR $BFAC
		JMP $E440
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		JSR BankSwapPRG
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
	
//-------------------------------------------------------------------------------
// Bank4 $10 000		PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 4;
org $8000		
	
	org $bf7b
	
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDA #$07
		JSR $BFAC
		JMP $E440
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		JSR BankSwapPRG
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS	

//-------------------------------------------------------------------------------
// Bank5 $14 000		PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 5;
org $8000		
	
	org $bf7b
	
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDA #$07
		JSR $BFAC
		JMP $E440
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		JSR BankSwapPRG
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS	         	

//-------------------------------------------------------------------------------
// Bank6 $18 000	PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 6;
	org $bf7b	
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDA #$07
		JSR $BFAC
		JMP $E440
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS
		JSR BankSwapPRG
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RTS

//-------------------------------------------------------------------------------
// Bank7 $1c 000 	PRG Bank Swap Replacment 
//-------------------------------------------------------------------------------
bank 7;
	org $e440
	lda #$00
	
	org $e446
	jsr BankSwapPRG
	
	org $e4be
	jsr BankSwapPRG
	
	org $e4e4
	jsr BankSwapPRG
	
	org $e55e
	jsr BankSwapPRG
	
	org $e621
	jsr SetHorizontalScroll
	
	org $e67f
	jsr BankSwapPRG
	
	org $e699
	jsr BankSwapPRG
	
	org $e7ac
	jsr BankSwapPRG
	
	org $e7cf
	jsr BankSwapPRG
	
	org $e7e8
	jsr BankSwapPRG
	
	org $e8c4
	jsr BankSwapPRG
	
	org $e8d0
	jsr BankSwapPRG
	
	org $e8da
	jsr BankSwapPRG
	
	org $e8fe
	jsr BankSwapPRG
	
	org $e906
	jsr BankSwapPRG
	
	org $e91b
	jsr BankSwapPRG
	
	org $e953
	jsr BankSwapPRG
	
	org $e961
	jsr BankSwapPRG
	
	org $e969
	jsr BankSwapPRG
	
	org $e971
	jsr BankSwapPRG
	
	org $e98b
	jsr BankSwapPRG
	
	org $e993
	jsr BankSwapPRG
	
	org $e99b
	jsr BankSwapPRG
	
	org $e9a3
	jsr BankSwapPRG
	
	org $e9c5
	jsr BankSwapPRG	
	
	org $e9d2
	jsr BankSwapPRG
	
	org $e9da
	jsr BankSwapPRG
	
	org $ea48
	jsr BankSwapPRG
	
	org $eacd
	jsr BankSwapPRG
	
	org $eadf
	jsr BankSwapPRG

	org $eb19
	jsr BankSwapPRG


	org $eb24
	jsr BankSwapPRG
	
	org $eb32
	jsr BankSwapPRG
	
	org $eb64
	jsr BankSwapPRG


	org $eb78
	jsr BankSwapPRG
	
	org $eb80
	jsr BankSwapPRG
	
	org $eb88
	jsr BankSwapPRG
	
	org $eb90
	jsr BankSwapPRG
	
	org $eb9b
	jsr BankSwapPRG


	org $ec05
	jsr BankSwapPRG	
	
	org $ec26
	jsr BankSwapPRG
	
	org $ec4f
	jsr BankSwapPRG
	
	org $ec68
	jsr BankSwapPRG
	
	org $ed2d
	jsr BankSwapPRG
	
	org $ed38
	jsr BankSwapPRG
	
	org $ed46
	jsr BankSwapPRG
	
	org $ed64
	jsr BankSwapPRG
	
	org $ed8b
	jsr BankSwapPRG
	
	org $edbc
	jsr BankSwapPRG
	
	org $efbc
	jsr BankSwapPRG
	
	org $efc4
	jmp BankSwapPRG
	
	org $f023
	jsr BankSwapPRG
	
	org $f04f
	jsr BankSwapPRG
	
	org $f076
	jsr BankSwapPRG
	
	org $f087
	jsr BankSwapPRG
	
	org $f139
	jsr BankSwapPRG
	
	org $f218
	jmp BankSwapPRG
	
	org $f220
	jmp BankSwapPRG
	
	org $f22e
	jmp BankSwapPRG
	
	org $f2f1
	jsr BankSwapPRG
	
	org $f8bd
	jsr BankSwapPRG
	
	org $f99c
	jsr BankSwapPRG
	
	org $fb77
	jsr BankSwapPRG
	
	org $fbab
	jsr BankSwapPRG
	
	org $fd0c
	jsr BankSwapPRG
	
	org $fd2f
	jsr BankSwapPRG
	
	org $fd3e
	jsr BankSwapPRG
	
	org $fd72
	jsr BankSwapPRG
	
	org $fe42
	jsr BankSwapPRG
	
	org $fe4a
	jsr BankSwapPRG
	
	org $fe52
	jsr BankSwapPRG
	
	org $fe5a
	jsr BankSwapPRG
	
	org $fe62
	jsr BankSwapPRG
	
	org $fe6a
	jsr BankSwapPRG
	
	org $fe72
	jsr BankSwapPRG
	
	org $fe7a
	jsr BankSwapPRG
	
	org $fe82
	jsr BankSwapPRG
	
	org $fe8a
	jsr BankSwapPRG
	
	org $fe92
	jsr BankSwapPRG
	
	org $ff7b				//This should be at $ff78 but the addictional PPU check for the initial setup seems not to hurt? Some more space at one block.. thanks to that change..
	jmp LoadBank7
	fillbyte $ff			//Clear out old routines
	fillto $ff90
	
	
	org $ff90	
	LoadBank7:
		LDA #$07			//Loade Bank 7
		JSR BankSwapPRG
		JMP $E440			//Bankswaping D tour? Grab value $00 store it at $f4 then swap to bank 5 and contines with routines.
	fillbyte $ff			//Clear out old routines
	fillto $ffac
	