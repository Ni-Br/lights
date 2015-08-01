import Data.Fixed
import Data.Time.Clock
import System.Environment
import Control.Concurrent
import Data.Colour
import Data.Colour.RGBSpace.HSL
-- import Data.Colour.Names
import Network
import Data.Colour.SRGB
import System.IO

--
import Client (connect, send, nextTime)

main = do
    [host, port] <- getArgs
    handle <- connect host (fromIntegral . read $ port)
    putStrLn "Connected"
    loop handle (w) (timify std_rainbow) strip

w t x = x + wave 0.1 (scale 0.2 t)

-- Main loop
loop :: Read t => Handle -> (t -> x -> y) -> (t -> y -> Colour Double) -> [x] -> IO c
loop handle s f display = do
    wait <- getCurrentTime
    t <- nextTime handle

    start <- getCurrentTime
    send handle (rgbs (read t))
    end <- getCurrentTime

    putStrLn "--"
    print $ diffUTCTime start wait
    print $ diffUTCTime end start

    loop handle s f display
    where rgbs t = concatMap colToStr (return_array (s t) (f t) display)

-- send handle = putStrLn 

colToStr :: Colour Double -> String
colToStr rgb = sRGB24show rgb


-- Distance metric
d :: Num a => a -> a -> a
d x y = abs (x-y)


-- Strip details
strip :: [Double]
strip = map (/49) [0..49]

return_array :: (a -> b) -> (b -> c) -> [a] -> [c]
return_array projection f = map (f . projection)


-- Functions
off :: [a] -> String
off xs = concatMap colToStr (map (\ _ -> black) xs)

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


-- Projections
-- Wraps
wrap :: (Fractional a, Real a) => a -> a
wrap x = x `mod'` 1.0

alt :: Num a => a -> a
alt x = 1 - abs(1-2*x)

-- Wave
wave :: (Fractional a, Floating a) => a -> a -> a 
wave p x = (1/factor) * sin (factor*x)
    where factor = 2*pi*p

-- Affine
scale :: Num a => a -> a -> a
scale = (*)

shift :: Num a => a -> a -> a
shift = (+)

affine :: (Num c) => c -> c -> c -> c
affine a b = shift b . scale a
