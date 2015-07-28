module Client
( connect
, send
, nextTime
) where

import Network
import System.IO

connect :: HostName -> PortNumber -> IO Handle
connect host port = do
        handle <- connectTo host (PortNumber port)
        return handle

send :: Handle -> String -> IO ()
send handle xs = do
        hPutStr handle ( xs ++ "\n" )
        hFlush handle

nextTime :: Handle -> IO String
nextTime handle = do
        resp <- hGetLine $ handle
        putStrLn $ "The device asked for frame for time: " ++ resp
        return resp
