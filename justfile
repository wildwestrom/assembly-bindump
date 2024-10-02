# Create necessary directories

launch-emulator: assemble
    cpulimit -l 25 -f -- qemu-system-x86_64 -drive file=bin/drive.img,index=0,if=floppy,format=raw -boot a

assemble:
    mkdir -p bin bin/dest

    @echo Create a drive
    dd if=/dev/zero of=bin/drive.img bs=512 count=1 status=none

    @echo Assemble bootloader
    fasm boot.s bin/boot

    @echo Add the bootloader to the first sector 
    dd if=bin/boot of=bin/drive.img bs=512 count=1 conv=notrunc status=none

    @echo Assemble system
    fasm system.s bin/dest/system

    @echo Check if the size is ok
    if [ $(wc -c <bin/dest/system) -ge 32768 ]; then \
        echo "System too large (more than 32KB)."; \
        exit 1; \
    fi

    @echo Append the system to the drive 
    dd if=bin/dest/system of=bin/drive.img bs=512 seek=1 conv=notrunc status=none oflag=append

dump: assemble
    objdump -b binary -m i386:x86-64 -D bin/drive.img
