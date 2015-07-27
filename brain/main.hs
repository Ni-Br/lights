import Data.Fixed
import Data.Colour
import Data.Colour.RGBSpace.HSL
import Data.Colour.Names
import Data.Colour.SRGB

main = putStrLn . show $ return_array (wrap.shift 0.3) std_rainbow strip

-- Distance metric
d :: Num a => a -> a -> a
d x y = abs (x-y)

-- Strip details
strip :: [Double]
strip = map (/49) [0..49]

return_array :: (a -> b) -> (b -> c) -> [a] -> [c]
return_array projection f = map (f . projection)

-- Rainbow
rainbow :: RealFrac a => a -> a -> RGB a
rainbow l x = hsl (360.0*x) 1 l

std_rainbow :: Double -> RGB Double
std_rainbow = rainbow 0.5

-- Dot
dot :: (Fractional a, Ord a) => a -> AlphaColour a -> a -> a -> AlphaColour a
dot size col pos x
    | d pos x < size = dissolve (1-((d pos x)/size)) col
    | otherwise = transparent

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

-- Projections
-- Wraps
wrap :: (Fractional a, Real a) => a -> a
wrap x = x `mod'` 1.0

alt :: Num a => a -> a
alt x = 1 - abs(1-2*x)

-- Wave

-- Affine
scale :: Num a => a -> a -> a
scale = (*)

shift :: Num a => a -> a -> a
shift = (+)

affine :: (Num c) => c -> c -> c -> c
affine a b = shift b . scale a
