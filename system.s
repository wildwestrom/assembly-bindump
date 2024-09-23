define AFTER_BOOT 0x7E00
org AFTER_BOOT ; the address of the sector after the boot sector

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
define FIRST_SECTOR 0x7C00
define COLUMNS 8
define ROWS 20

    mov si,AFTER_BOOT

    printloop:
        mov cl,7               ; set a shifting register
        lodsb                  ; load from what si points to, increment si
        mov [ByteStorage],al   ; put the data into a byte storage so we don't corrupt it

        cmp byte [ByteColumn],COLUMNS ; If we've reached the number of columns
        jne printbit                  ; Just start printing bits

    printbyte:         ; Otherwise gimme a nice newline
        mov al,0xD     ; nice lil newline
        int 0x10
        mov al,0xA
        int 0x10

        mov byte [ByteColumn],0  ; Reset the column count

    printbit:
        mov al,[ByteStorage]
        and al,[Mask]     ; mask out the most significant bit
        shr al,cl         ; shift so that we get what we masked

        add al,ASCII_0    ; add it to ASCII 0
        int 0x10          ; print a 1 or 0

        shr byte [Mask],1 ; shift the mask
        dec cl            ; subtract the shifter

        cmp cl,-1         ; if we've not reached the last bit
        jne printbit      ; then print another bit

        mov cl,7          ; reset the shifter and mask
        mov byte [Mask],128

        mov al,0x20       ; print a nice lil space
        int 0x10          
        inc byte [ByteColumn]

    ; // printbyte

    endloop:
        cmp si,(AFTER_BOOT + (COLUMNS*ROWS))
        jl printloop

    EndProg:
    ret                   ; quit the program

Mask: db 128
ShiftBy: db 7
ByteStorage: db 0
ByteColumn: db 0

TextHelloWorld: db 0xD,0xA,'Welcome to my program!',0xD,0xA,'Displaying myself in binary now...',0xD,0xA,0xD,0xA
