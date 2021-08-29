NAME=stivale2
CFILE=$(NAME).c
LFILE=$(NAME).lua
NFILE=$(NAME).nelua
TFILE=$(NAME)-test.nelua
GCCPLUGIN=-fplugin=gcc-lua/gcc/gcclua.so
LUA_PATH=LUA_PATH_5_4="nelua-decl/?.lua;;" LUA_PATH_5_3="nelua-decl/?.lua;;" LUA_PATH="nelua-decl/?.lua;;"
NELUA=nelua
CC=gcc

gcc-lua:
	make -C gcc-lua

generate: gcc-lua download
	$(LUA_PATH) $(CC) $(GCCPLUGIN) -S $(CFILE) -fplugin-arg-gcclua-script=$(LFILE) > $(NFILE)

download:
	wget -O stivale2.h https://github.com/stivale/stivale/raw/master/stivale2.h

test:
	$(NELUA) $(TFILE)
