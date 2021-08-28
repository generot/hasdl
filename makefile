#Honestly, this makefile is f*cking tragic!
CC=gcc
CH=ghc

MODDIR = "C:\Users\anoma\Desktop\Repos\Haskell\Hasdl\src\hssrc"

BIN=bin
INCLUDE=include

SRCC=src/csrc
SRCH=src/hssrc

SDLLIB=$(SDL2)/lib
SDLINC=$(SDL2)/include/SDL2

LIBOBJ=$(BIN)/hsbind.o $(BIN)/Hasdl.o
GGC=$(BIN)/ggc.o
JULIA=$(BIN)/julia.o

all: julia ggc

julia: $(LIBOBJ) $(JULIA)
	$(CH) -o $(BIN)/julia.exe $^ -optl -L"$(SDLLIB)" -optl -lSDL2

ggc: $(LIBOBJ) $(GGC)
	$(CH) -o $(BIN)/ggc.exe $^ -optl -L"$(SDLLIB)" -optl -lSDL2

#Libs
$(BIN)/hsbind.o: $(SRCC)/hsbind.c
	$(CC) -c $< -o $@ -I"$(SDLINC)"

$(BIN)/Hasdl.o: $(SRCH)/Hasdl.hs
	$(CH) -c $< -o $@ -optc -I"$(SDLINC)"

#Graphical calculator
$(GGC): $(SRCH)/ggc.hs
	$(CH) -O3 -c $< -o $@ -i$(MODDIR)

#Julia set
$(JULIA): $(SRCH)/julia.hs
	$(CH) -O3 -c $< -o $@ -i$(MODDIR)

.PHONY: rmobj rmexe

rmobj:
	rm $(BIN)/*.o

rmexe:
	rm $(BIN)/*.exe