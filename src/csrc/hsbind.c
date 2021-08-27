#include "../../include/hasdl.h"

int hasdl_init(void) {
    SDL_Init(SDL_INIT_VIDEO);
    atexit(SDL_Quit);
}

HASDL_Handle hasdl_create_window(const char *title, int width, int height) {
    SDL_Window *wnd = SDL_CreateWindow(
        title, 
        HASDL_WNDX_DEF, 
        HASDL_WNDY_DEF, 
        width, 
        height, 
        SDL_WINDOW_OPENGL
    );

    return (HASDL_Handle)wnd;
}

HASDL_Handle hasdl_pixel_texture(HASDL_Handle pixel_data, int width, int height) {
    int pitch = width * HASDL_PIXEL_FIELDS;
    int depth = 24;

    SDL_Surface *srf = SDL_CreateRGBSurfaceFrom(
        (void*)pixel_data, 
        width, 
        height, 
        depth, 
        pitch, 
        HASDL_RED_MASK,
        HASDL_GREEN_MASK,
        HASDL_BLUE_MASK,
        0
    );

    return (HASDL_Handle)srf;
}

void hasdl_open_window(HASDL_Handle window_handle, HASDL_Handle srf_texture) {
    SDL_Window *wnd = (SDL_Window*)window_handle;
    SDL_Renderer *rnd = SDL_CreateRenderer(wnd, -1, SDL_RENDERER_TARGETTEXTURE);

    SDL_Event event;

    SDL_ShowWindow(wnd);

    SDL_Surface *srf = (SDL_Surface*)srf_texture;    
    SDL_Texture *target = srf ? SDL_CreateTextureFromSurface(rnd, srf) : NULL;

    if(target) {
        SDL_RenderClear(rnd);
        SDL_RenderCopy(rnd, target, NULL, NULL);
        SDL_RenderPresent(rnd);
    }

    while(SDL_TRUE) {
        while(SDL_WaitEvent(&event)) {
            switch(event.type) {
            case SDL_QUIT:
                if(target) {
                    SDL_FreeSurface(srf);
                    SDL_DestroyTexture(target);
                }
                
                SDL_DestroyRenderer(rnd);
                SDL_DestroyWindow(wnd);

                return;
            }
        }
    }
}

#ifdef __HASDL_TEST__
int SDL_main(int argc, char *argv[]) {
    hasdl_init();

    HASDL_Size width = 600, height = 600;
    HASDL_Size pdata_sz = width * height * 3;

    //This is an unresolvable memory leak.
    //It won't actually occur on the Haskell side of the API.
    HASDL_Byte *pdata = SDL_calloc(pdata_sz, sizeof(HASDL_Byte));
    for(HASDL_Size i = 0; i < pdata_sz - 3; i += 3) {
        pdata[i + 0] = 0;
        pdata[i + 1] = 98;
        pdata[i + 2] = 255;
    }

    HASDL_Handle wnd = hasdl_create_window("Test application", 600, 600);
    HASDL_Handle txt = hasdl_pixel_texture(pdata, width, height);

    hasdl_open_window(wnd, txt);

    return 0;
}
#endif