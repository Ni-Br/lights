module Projections 
( wrap
, alt
, sliding_wave
, bounded_sin
, scale
, shift
, affine
) where
import Data.Fixed

-- Wraps
wrap :: (Fractional a, Real a) => a -> a
wrap x = x `mod'` 1.0

alt :: Num a => a -> a
alt x = 1 - abs(1-2*x)

-- Wave
sliding_wave :: (Fractional a, Floating a) => a -> a -> a -> a -> a
sliding_wave wvl per t x = x + bounded_sin wvl (shift (t*wvl/per) x)

bounded_sin :: (Fractional a, Floating a) => a -> a -> a 
bounded_sin p x = (1/factor) * sin (factor*x)
    where factor = 2*pi/p

-- Affine
scale :: Num a => a -> a -> a
scale = (*)

shift :: Num a => a -> a -> a
shift = (+)

affine :: (Num c) => c -> c -> c -> c
affine a b = shift b . scale a
