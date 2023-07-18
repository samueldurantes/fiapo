module Main where

import Fiapo.App (app)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
  putStrLn "Server running on port 3000"
  run 3000 =<< app
