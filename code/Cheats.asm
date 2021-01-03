bank 1
// Can't be hurt
org $b3aa
    rts

// Infinite bombs
org $a976
    nop
    nop
    nop

bank 5
// Can always attack as if you have magic sword (even with no sword).
org $8e00
    lda #$03
    nop
bank 7
org $f7ec
    adc #$02
    nop

bank 7
// can throw sword without full hp
org $f874
    nop
    nop
org $f87b
    nop
    nop

bank 4
// Can push blocks without power bracelet
org $8e52
    nop
    nop

// Can use raft without owning it
org $8f79
    nop
    nop

bank 7
// Can use step ladder without owning it
org $f284
    nop
    nop

bank 5
// Can use magic key without owning it (infinte keys)
org $9275
    lda #$01
    nop


bank 1
// Can buy items even if you don't have enough
org $88ed
    nop
    nop
// Don't subtract rupees when buying items
org $89de
    rts
