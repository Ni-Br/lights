import System.Environment
import Data.Colour
import Data.Colour.RGBSpace.HSL
import Data.Colour.SRGB
import System.IO

--
import Client (connect, send, nextTime)
import Colors (std_rainbow)
import Projections (wrap, shift, scale, sliding_wave)

main = do
    [host, port] <- getArgs
    handle <- connect host (fromIntegral . read $ port)
    putStrLn "Connected"
    loop handle (sliding_wave 1 7) (\ t x -> std_rainbow . wrap $ shift (0.08*t) x) strip


-- Main loop
loop :: Read t => Handle -> (t -> x -> y) -> (t -> y -> Colour Double) -> [x] -> IO c
loop handle s f display = do
    t <- nextTime handle
    send handle (rgbs (read t))

    loop handle s f display
    where rgbs t = concatMap colToStr (return_array (s t) (f t) display)

-- send handle = putStrLn 

colToStr :: Colour Double -> String
colToStr rgb = sRGB24show rgb

strip = map (/49) [0..49]

return_array :: (a -> b) -> (b -> Colour Double) -> [a] -> [Colour Double]
return_array proj f = map (f . proj)

-- Operators
-- Timify
timify :: a -> Double -> a
timify f = (\t -> f)
