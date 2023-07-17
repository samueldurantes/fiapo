module Main where

import Network.Wai.Handler.Warp (run)

import App (app)

main :: IO ()
main = do
  putStrLn "Server running on port 3000"
  run 3000 =<< app
