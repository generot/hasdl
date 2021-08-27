{-# LANGUAGE ForeignFunctionInterface, CApiFFI #-}

module Hasdl(hasdlInit, hasdlCreateWindow, hasdlCreateTexture, hasdlOpenWindow, HasdlHandle, Pixel, Texture) where
    --Imports(BEGIN)
    import Foreign.C.String
    import Foreign.C.Types
    import Foreign.Marshal.Array
    import Foreign.Ptr
    --Imports(END)

    --HASDL Bindings(BEGIN)
    type Byte = CUChar
    type HasdlHandle = Ptr Byte
    type Pixel = [Byte]
    type Texture = [Pixel]

    foreign import capi "../../include/hasdl.h hasdl_init" hasdlInit :: IO()
    foreign import capi "../../include/hasdl.h hasdl_pixel_texture" hasdlPxTexture :: HasdlHandle -> Int -> Int -> IO HasdlHandle
    foreign import capi "../../include/hasdl.h hasdl_create_window" hasdlCWnd :: CString -> Int -> Int -> IO HasdlHandle
    foreign import capi "../../include/hasdl.h hasdl_open_window" hasdlOpenWindow :: HasdlHandle -> HasdlHandle -> IO()

    hasdlCreateWindow :: String -> Int -> Int -> IO HasdlHandle
    hasdlCreateWindow title width height = withCString title (\tlt -> hasdlCWnd tlt width height)

    hasdlCreateTexture :: Texture -> Int -> Int -> IO HasdlHandle
    hasdlCreateTexture pxinfo width height = withArray pxlinear (\arr -> hasdlPxTexture arr width height)
        where pxlinear = concat pxinfo
    
    --HASDL Bindings(END)