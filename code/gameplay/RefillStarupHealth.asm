//bank 5; org $b1e6 part fary of refilling health routine

bank 2;		
org $a635	//PRG $a635
jmp RefillHealth


org $a830
RefillHealth:
lda $66f		//Make halth container equal to current health
and #$f0
sta $66f
lsr
lsr 
lsr
lsr
adc $66f
sta $66f

jmp $eba1
