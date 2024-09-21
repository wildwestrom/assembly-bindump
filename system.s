org 0x7E00 ; the address of the sector after the boot sector

Main:

    mov si,TextHelloWorld ; point the si register at the string to display
    mov ah,0x0E           ; for int 0x10: write chars in teletype mode

    ForEachChar:          ; begin loop

        lodsb             ; load al with what si points to, increment si
        cmp al,0x00       ; if char is null...
        je EndForEachChar ; .. then break out of the loop
        int 0x10          ; call interrupt 0x10 (BIOS: print char)

    jmp ForEachChar       ; jump back to beginning of loop
    EndForEachChar:       ; end of the loop

    ret                   ; quit the program

    ; data to display
    TextHelloWorld: db 'Hello, world!',0

PadOutSectorTwoWithZeroes:
    times ((0x200) - ($ - $$)) db 0x00   
