{-- This module exposes a controller monad that is useful to send messages and errors to the client. --}
module Fiapo.Shared.Monad.Controller (MonadUseCase, Failable (..), run) where

import Control.Monad.Except (MonadError, MonadIO, runExceptT)
import Data.Aeson           (ToJSON)
import Network.HTTP.Types   (Status)
import Web.Scotty           (ActionM, json, status)

-- The controller monad. It is responsible for failures and IO.
type MonadUseCase m e = (MonadIO m, MonadError e m, ToJSON e, Failable e)

-- Type class for errors that can be sent to the client. It is useful so we can send different error
-- messages from different modules throught the same controller monad.
class Failable e where
  statusCode :: e -> Status

run :: (Failable e, ToJSON e) => (forall m. (MonadUseCase m e) => m a) -> ActionM ()
run a = do
  res <- runExceptT a
  case res of
    Left e -> do
      status $ statusCode e
      json e
    Right _ -> pure ()
