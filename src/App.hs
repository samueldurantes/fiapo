module App (app) where

import Web.Scotty
import Database.MongoDB (connect, host, access, master, Pipe, Action)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Network.Wai.Middleware.RequestLogger (logStdoutDev)

import Modules.User.Controllers (userRegister, userLogin)
import Network.Wai (Application)

run :: (MonadIO m) => Pipe -> Action m a -> m a
run conn = access conn master "fiapo"

app :: (MonadIO m) => m Application
app = do
  conn <- liftIO $ connect (host "127.0.0.1")

  liftIO $ scottyApp $ do
    middleware logStdoutDev

    post "/user/register" (userRegister (run conn))
    post "/user/login" (userLogin (run conn))
