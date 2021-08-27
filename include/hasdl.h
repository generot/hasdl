#ifndef __HASDL_H__
#define __HASDL_H__

#include <SDL.h>

#define HASDL_WNDX_DEF 30
#define HASDL_WNDY_DEF 30

#define HASDL_PIXEL_FIELDS 3

typedef unsigned char HASDL_Byte, *HASDL_Handle;
typedef unsigned long long HASDL_Size;

enum {
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
    HASDL_RED_MASK   = 0xff0000,
    HASDL_GREEN_MASK = 0x00ff00,
    HASDL_BLUE_MASK  = 0x0000ff
#else
    HASDL_RED_MASK   = 0x0000ff,
    HASDL_GREEN_MASK = 0x00ff00,
    HASDL_BLUE_MASK  = 0xff0000
#endif
};

int          hasdl_init(void);
HASDL_Handle hasdl_pixel_texture(HASDL_Handle pixel_data, int width, int height);
HASDL_Handle hasdl_create_window(const char *title, int width, int height);
void         hasdl_open_window(HASDL_Handle window_handle, HASDL_Handle srf_texture);

//LibC prototypes
int atexit(void (*func)(void));
void exit(int);

#endif //__HASDL_H__