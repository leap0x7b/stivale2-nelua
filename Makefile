NAME=stivale2
CFILE=$(NAME).c
LFILE=$(NAME).lua
NFILE=$(NAME).nelua
TFILE=$(NAME)-test.nelua
GCCPLUGIN=-fplugin=gcc-lua/gcc/gcclua.so
LUA_PATH=LUA_PATH_5_4="nelua-decl/?.lua;;" LUA_PATH_5_3="nelua-decl/?.lua;;" LUA_PATH="nelua-decl/?.lua;;"
NELUA=nelua
CC=gcc
LD=ld

gcc-lua:
	make -C gcc-lua

generate: gcc-lua download
	$(LUA_PATH) $(CC) $(GCCPLUGIN) -S $(CFILE) -fplugin-arg-gcclua-script=$(LFILE) > $(NFILE)

download:
	wget -O stivale2.h https://github.com/stivale/stivale/raw/master/stivale2.h

test:
	$(NELUA) $(TFILE) -bo build/kernel.elf
	make -C limine
	rm -rf build/sysroot
	mkdir -p build/sysroot
	cp build/kernel.elf \
		limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-eltorito-efi.bin build/sysroot/
	xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-eltorito-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		build/sysroot -o build/disk.iso
	limine/limine-install build/disk.iso
	rm -rf iso_root
