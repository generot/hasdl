@echo off
gcc -o bin/test.exe src/csrc/*.c -D__HASDL_TEST__ -I "%SDL2%\\include\\SDL2" -L "%SDL2%\\lib" -lmingw32 -lSDL2main -lSDL2