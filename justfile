# Create necessary directories

# Recipe to launch the emulator
launch-emulator: assemble
    qemu-system-x86_64 -drive file=bin/drive.img,index=0,if=floppy,format=raw -boot a

assemble:
    mkdir -p bin bin/dest
    dd if=/dev/zero of=bin/drive.img bs=512 count=2880 status=none
    # assemble bootloader 
    fasm boot.s bin/boot
    dd if=bin/boot of=bin/drive.img bs=512 count=1 conv=notrunc status=none
    # assemble system
    fasm system.s bin/dest/system
    dd if=bin/dest/system of=bin/drive.img bs=512 seek=1 conv=notrunc status=none
    if [ $(wc -c <bin/dest/system) -ge 32768 ]; then \
        echo "System too large (more than 32KB)."; \
        exit 1; \
    fi

