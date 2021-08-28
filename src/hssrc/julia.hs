--Julia set example
module Main(main) where
    import Hasdl
    import Data.Fixed

    type Point = (Float, Float)
    type Hsl head = (head, Float, Float)

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

    --Make HSL work with floats too.
    calcCXM :: Hsl Float -> Hsl Float
    calcCXM col = (c, x, m)
        where (h, s, l) = col
              c = (1 - abs (2 * l - 1)) * s
              x = c * (1 - abs((mod' (h / 60.0) 2.0) - 1))
              m = l - c / 2

    hslToRgb :: Hsl Float -> [Integer]
    hslToRgb col = map round [(r' + m) * 255, (g' + m) * 255, (b' + m) * 255]
        where (h, _, _) = col
              (c, x, m) = calcCXM col
              rgb' = [(c, x, 0), (x, c, 0), (0, c, x), (0, x, c), (x, 0, c), (c, 0, x)]
              (r', g', b') = (rgb' !! floor (h / 60.0))

    colourPixelHsl :: Int -> Pixel
    colourPixelHsl iter = if iter == maxIter then [0, 0, 0] else map fromInteger hsl
        where iterf = fromIntegral iter
              iterRng max = max * iterf / (fromIntegral maxIter)
              hsl = hslToRgb (iterRng 359.9, 0.7, 0.5)


    colourPixelRgb :: Int -> Pixel
    colourPixelRgb iter = if iter == maxIter then [0, 0, 0] else [255 - iterAsByte 255.0, green, iterAsByte 255.0]
        where iterf = fromIntegral iter
              iterAsByte max = floor (max * (fromIntegral maxIter) / iterf)
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
    planeToTexture plane = map colourPixelHsl plane

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