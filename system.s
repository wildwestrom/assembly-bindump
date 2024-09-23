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

    ; data to display
    ; Good, now I want to display a binary representation of myself

define ASCII_0 48

    mov si,0x7DFE
    printloop:
        lodsb
        mov [ByteStorage],al
    printbyte:
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,7
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,6
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,5
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,4
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,3
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,2
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,1
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        mov al,[ByteStorage]
        and al,[Mask]
        shr al,0
        add al,ASCII_0
        int 0x10
        shr byte [Mask],1
        ;
        ;
        mov al,0x20
        int 0x10
        mov byte [Mask],128
    endloop:
        cmp si,0x7E10
        jle printloop

    EndProg:
    ret                   ; quit the program

Mask: db 128
ShiftBy: db 7
ByteStorage: db 0

TextHelloWorld: db 'Welcome to my program!',0xD,0xA,'Displaying myself in binary now...',0xD,0xA,0xA,0

