module Fiapo.Modules.User.UseCases.Login where

import Control.Monad.Trans                  (MonadIO)

import Fiapo.Modules.User.Entities.Password (verifyPassword)
import Fiapo.Modules.User.Entities.User     (User (..))
import Fiapo.Modules.User.Error             (Error (IncorrectPassword, UserNotExists))
import Fiapo.Modules.User.Repository        (Query, findUserByUsername)

import Database.MongoDB                     (look, typed)
import Database.MongoDB                     qualified as Mongo

userLogin :: (MonadIO m, MonadFail m)
             => Query m a (Maybe Mongo.Document)
             -> User -> m (Either Error User)
userLogin runConn user = do
    u <- runConn $ findUserByUsername user.username
    case u of
        Just userStored -> do
            hashedPassword <- look "password" userStored
            if verifyPassword (typed hashedPassword) user.password
                then pure (Right user)
                else pure (Left IncorrectPassword)
        Nothing -> pure (Left (UserNotExists user))
