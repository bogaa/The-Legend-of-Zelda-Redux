//-------------------------------------------------------------------------------
// Bank6 $18 000
//-------------------------------------------------------------------------------

bank 6;
org $8070
	jsr CHRSwaping	//Hijack without disableing old PPU load routine since it is used for multiple things..


//Hijack (same as "waterfall.asm" but this will not work with mmc5 anyway)
org $a08c				//PRG 1a08c Here the routine just change to bank 6 and is about to go to the hud update (Donno what the table at 1a000 is for!)
	jsr CHRanimation	//Hijack (Orginal jsr $a0f6)

//FreeSpace
org $b000		//FreeSpace?
//RAM $700 Current bank
//RAM $701 Buffer
//RAM $702 Current bank SpritePage 1/4
//RAM $703 BufferSprite

//RAM $704 Is a buffer for the Waterfall.asm. To keep files compatible this is skipped.

//RAM $706 Current bank SpritePage 2/4
//RAM $707 BufferSprite

//RAM $70a Current bank Dungeon
//RAM $70b BufferSprite

//Link $781f
//link $f33b

CHRanimation:
	lda $10
	bne EndCHRAnimation
	lda $12
	cmp #$05
	bne EndCHRAnimation
	

	inc $700
	lda $700
	cmp #$10		//Set to run all 10 Frames
	bne EndCHRAnimation
	lda #$00		//Reset Counter of 10 Frames
	sta $700
	
	inc $701
	lda $701
	cmp #$04		//Check if max Bank Frame is reached. 
	bne AnimationOverworld
	lda #$00		//Reset Bank Frame
	sta $701
	
AnimationOverworld:
	tax
	
	lda AnimationBankOverworld,x
	tay
	
	sty $5128		//Tiles 1/4
	lda $702
	sta	$5124		//Unused SpritPage
	iny
	sty $5129		//Tiles 2/4
	lda $706
	sta $5125		//Unused SpritPage? Tree, Doors?
	iny				
	sty $512a		//Tiles 3/4			
	iny	
	sty $512b		//Tiles 4/4
	
EndCHRAnimation:	
//------------------Lake Drain--------------------------------------	
	lda $51a		//LakeDrain active on that screen. $0c=Fully Drained
	beq SkipLake
	cmp #$0c
	bne DrainSpeed
	lda #$00		//Stop Animation
	sta $700
DrainSpeed:
	lda $700
	cmp #$04		//Check max frame. So it will animate every 4 frames
	bne SkipLake
	lda #$0F		//Set to trigger next frame
	sta $700		
SkipLake:
//------------------------------------------------------------------	
	
	jsr $a0f6	//Hijackfix
	rts
	
AnimationBankOverworld:
db $24,$28,$2c,$30

	

SetCHRStart: 			//Title Screen
		ldy #$00		
		
		sty $5120		//Link			Sprite 1/8
		iny
		sty $5121		//Items		Sprite 2/8
		iny
		sty $5122		//Enemy1		Sprite 3/8			
		iny
		sty $5123		//Enemy2		Sprite 4/8	
		iny
		sty $5124		//Fonts 		Sprite 5/8		NOT USED
		sty $5128		//This is the page for Tiles 1/4
		iny
		sty $5125		//				Sprite 6/8		Trees,Doors
		sty $5129		//Tiles 2/4	
		iny				
		sty $5126		//				Sprite 7/8		Rocks
		sty $512a		//Tiles 3/4			
		iny
		sty $5127		//				Sprite 8/8		Rocks	
		sty $512b		//Tiles 4/4
		
		rts

CHRSwaping:			//Levels
		ldy $10		//Current Level
		lda CHRBankTableSprite,y
		tay
						//Link and the Items are permanent avalible. No need to swap $5120 and $5121
		sty $5122		//Enemy1 Sprite 3/8					
		iny
		sty $5123		//Enemy2 Sprite 3/8		
		
		
		ldy $10
		lda CHRBankTableTiles,y
		tay
		
		sty $5128		//Tiles 1/4
		sty $702		//Init Frame to animate for Sprites
		iny
		sty $5129		//Tiles 2/4
		sty $706		//Init Frame to animate for Sprites
		iny				
		sty $512a		//Tiles 3/4
		sty $5126		//				Sprite 7/8	Movable Block Sprites
		iny	
		sty $512b		//Tiles 4/4
		sty $5127		//				Sprite 8/8	Movable Block Sprites
		
		LDA $10		//Hijack Fix               
		ASL                   
		TAX        				
		
		rts
//LVL	00, 01, 02, 03, 04, 05, 06, 07, 08, 09	// 00=overworld
CHRBankTableSprite:
	db $08,$0e,$14,$16,$18,$1a,$1c,$1e,$20,$22
CHRBankTableTiles:
	db $0a,$10,$10,$10,$10,$10,$10,$10,$10,$10