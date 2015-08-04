module Colors
( rainbow
, std_rainbow
, dot
, transition
, slide
) where

import Data.Colour
import Data.Colour.RGBSpace.HSL
import Data.Colour.SRGB

-- Distance metric
d :: Num a => a -> a -> a
d x y = abs (x-y)


-- Rainbow
rainbow :: Double -> Double -> Colour Double
rainbow l x = sRGB (channelRed c) (channelGreen c) (channelBlue c)
    where c = hsl (360*x) 1 l

std_rainbow :: Double -> Colour Double
std_rainbow = rainbow 0.5

-- Dot
dot :: Double -> Colour Double -> Double -> Double -> AlphaColour Double
dot size col pos x
    | d pos x < size = dissolve (1-((d pos x)/size)) (opaque col)
    | otherwise = transparent


-- Operators
-- Timify
timify :: a -> Double -> a
timify f = (\t -> f)

-- Dissolve from f to g with t
transition :: (Num t, AffineSpace c) => (a -> c t) -> (a -> c t) -> t -> a -> c t
transition f g t x = blend t (g x) (f x)

-- Reveal g from "under" f with t
slide :: (Ord t, Fractional t, AffineSpace c) => t -> (t -> c t) -> (t -> c t) -> t -> t -> c t
slide size f g t x
    | x < t-margin = g x
    | x > t+margin = f x
    | otherwise = transition f g ((x-t)/size) x
    where margin = size/2
