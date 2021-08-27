--Julia set example
module Main(main) where
    import Hasdl

    type Point = (Float, Float)

    width :: Int
    height :: Int
    maxIter :: Int

    (width, height) = (600, 600)
    maxIter = 100

    makePlane :: Int -> Int -> Float -> [Point]
    makePlane wd hg scale = [(x / scale, y / scale) | y <- [- halfHg .. halfHg - 1], x <- [- halfWd .. halfWd - 1]]
        where halfWd = (fromIntegral wd) / 2
              halfHg = (fromIntegral hg) / 2

    sqLen :: Point -> Float
    sqLen pt = (fst pt) ^ 2 + (snd pt) ^ 2

    complexSq :: Point -> Point
    complexSq c = (r ^ 2 - i ^ 2, 2 * r * i)
        where r = fst c
              i = snd c

    complexAdd :: Point -> Point -> Point
    complexAdd a b = (fst a + fst b, snd a + snd b)

    --Implement HSL for this one as well.
    colourPixel :: Int -> Pixel
    colourPixel iter = if iter == maxIter then [0, 0, 0] else [255 - iterAsByte 255.0, green, iterAsByte 255.0]
        where iterf = fromIntegral iter
              iterAsByte max = fromInteger $ floor (max * (fromIntegral maxIter) / iterf)
              green = if iter > 80 then iterAsByte 150.0 else iterAsByte 30.0

    juliaProc :: Point -> Point -> Point
    juliaProc c pt =  complexAdd c $ complexSq pt

    juliaIter :: Point -> Point -> Int -> Int
    juliaIter pt c iter
        | (sqLen pt) < 4.0 && iter < maxIter    = juliaIter (juliaProc c pt) c (iter + 1)
        | otherwise                             = iter

    applyJulia :: Point -> [Point] -> [Int]
    applyJulia c plane = map (\x -> juliaIter x c 0) plane

    planeToTexture :: [Int] -> Texture
    planeToTexture plane = map colourPixel plane

    juliaSet :: Int -> Int -> Float -> Point -> Texture
    juliaSet x y scale c = planeToTexture $ applyJulia c $ makePlane x y scale

    main :: IO()
    main = do
        hasdlInit

        putStrLn "Real component:"
        x <- getLine

        putStrLn "Imaginary component:"
        y <- getLine

        let crds = (read x::Float, read y::Float)

        wnd <- hasdlCreateWindow "Julia set" width height
        txt <- hasdlCreateTexture (juliaSet width height 250.0 crds) width height

        hasdlOpenWindow wnd txt