{-- The entrypoint of the application. It starts the server using the config module and a bunch of
    routes.
--}
module Fiapo.App where

import Control.Monad.IO.Class               (MonadIO (liftIO))
import Database.MongoDB                     (Action, Pipe, access, connect,
                                             host, master)
import Network.Wai                          (Application)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Web.Scotty                           (get, middleware, scottyApp, text)

import Fiapo.Modules.User.Routes            qualified as User

run :: (MonadIO m) => Pipe -> Action m a -> m a
run conn = access conn master "fiapo"

app :: (MonadIO m) => m Application
app = do
  _conn <- liftIO $ connect (host "127.0.0.1")

  liftIO $ scottyApp $ do
    middleware logStdoutDev

    get "/" $ do
      text "hello"

    User.routes
