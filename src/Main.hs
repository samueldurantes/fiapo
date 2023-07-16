module Main where

import Web.Scotty (middleware, post, scotty)
import Database.MongoDB (connect, host, access, master, Pipe, Action)
import Control.Monad.IO.Class (MonadIO)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)

import Modules.User.Controllers (userRegister, userLogin)

run :: (MonadIO m) => Pipe -> Action m a -> m a
run conn = access conn master "fiapo"

main :: IO ()
main = do
  conn <- connect (host "127.0.0.1")

  scotty 3000 $ do
    middleware logStdoutDev

    post "/user/register" (userRegister (run conn))
    post "/user/login" (userLogin (run conn))
