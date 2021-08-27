--Plotter example
module Main(main) where
    import Hasdl

    type Function a = (a -> a)

    width :: Int
    height :: Int

    (width, height) = (800, 600)

    utilFill :: Int -> Pixel -> Texture
    utilFill size model = take size $ repeat model

    --Everything being plotted is zoomed in 10x, hence "x / 10".
    plotFunc :: Int -> Int -> Function Double -> Pixel -> Pixel -> Texture
    plotFunc width height f bCol pCol = [if y == (fOut !! x) then pCol else bCol | y <- reverse [-halfH .. halfH - 1], x <- [0 .. width - 1]]
        where fOut = [fromIntegral $ floor $ f (x / 10)  | x <- [- halfW .. halfW - 1]]
              halfW = (fromIntegral width) / 2
              halfH = (fromIntegral height) / 2

    f :: Function Double
    f x = 30 * sin x

    --Entry point(BEGIN)
    main :: IO()
    main = do
        hasdlInit

        wnd <- hasdlCreateWindow "(Non)Functional Graphik" width height
        txt <- hasdlCreateTexture (plotFunc width height f [0, 0, 0] [255, 0, 0]) width height

        hasdlOpenWindow wnd txt
    --Entry point(END)