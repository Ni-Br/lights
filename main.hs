import Data.Fixed
import Data.Colour
import Data.Colour.RGBSpace.HSL

main = putStrLn . show $ return_array (wrap.shift 0.3) std_rainbow strip

-- Distance metric
d x y = abs (x-y)

-- Strip details
strip = map (/49) [0..49]
return_array projection f = map (f . projection)

-- Rainbow
rainbow l x = hsl (360.0*x) 1 l

std_rainbow = rainbow 0.5

-- Dot
dot size col pos x
    | d pos x < size = dissolve (1-((d pos x)/size)) col
    | otherwise = transparent

-- Dissolve from f to g with t
transition f g t x = blend t (g x) (f x)

-- Reveal g from "under" f with t
slide size f g t x
    | x < t-margin = g x
    | x > t+margin = f x
    | otherwise = transition f g ((x-t)/size) x
    where margin = size/2

-- Projections
-- Wraps
wrap x = x `mod'` 1.0
alt x = 1 - abs(1-2*x)

-- Affine
scale a = (*a)
shift b = (+b)
affine a b = shift b . scale a
