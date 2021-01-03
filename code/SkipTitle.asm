bank 2
// skip title
org $903f
    lda #$01
    sta $11
    lda #$00
    sta $12
    lda #$01
    sta $13
    rts
// remove title music (it carries over when skipping title)
org $9545
   lda #$00

