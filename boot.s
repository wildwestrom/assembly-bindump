use16       ; 16-bit mode
org 0x7C00 ; this is the address of the boot sector

BootStageOne:
    ;
    mov ah,0x00 ; reset disk
    mov dl,0    ; drive number
    int 0x13    ; call BIOS interrupt routine
    ;
    ; load the sector from disk using BIOS interrupt 0x13
    mov ah,0x02 ; read sectors into memory
    mov al,0x08 ; number of sectors to read
    mov dl,0    ; drive number
    mov ch,0    ; cylinder number
    mov dh,0    ; head number
    mov cl,2    ; starting sector number
    mov bx,Main ; memory location to load to 
    int 0x13    ; call BIOS interrupt routine
    ;
    jmp Main    ; now that it's been loaded
    ;

    Main = 0x7E00

PadOutSectorOneWithZeroes:
    ; pad out all but the last two bytes of the sector with zeroes
    times ((0x200 - 2) - ($ - $$)) db 0x00

BootSectorSignature:
    dw 0xAA55 ; these must be the last two bytes in the boot sector

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
