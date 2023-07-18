-- Use case for registering users into the system.
module Fiapo.Modules.User.UseCases.Register where

import Control.Monad.Trans              (MonadIO)
import Data.Text.Internal.Lazy          (Text)
import Web.Scotty.Trans                 (ActionT)

import Fiapo.Modules.User.Entities.User (User)
import Fiapo.Modules.User.Error         (Error)
import Fiapo.Modules.User.Repository    (insertUser)

import Database.MongoDB                 qualified as Mongo
import Database.MongoDB.Query           qualified as Query

type Action = ActionT Text IO

type Database m a = Query.Action m Mongo.Value -> m a

userRegister :: MonadIO m => Database m a -> User -> m (Either Error User)
userRegister runConn user = do
  _ <- runConn $ insertUser user
  pure (Right user)
