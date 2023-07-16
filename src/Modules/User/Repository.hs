module Modules.User.Repository
  ( insertUser
  , findUserByUsername
  ) where

import Data.Text (Text)
import Data.Maybe (fromJust)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Database.MongoDB((=:), findOne, insert, Document, Value, Action, Select(select))

import Utils (hashPassword)
import Modules.User.Model (User(..))

insertUser :: (MonadIO m) => User -> Action m Value
insertUser user = do
  hashedPassword <- liftIO $ hashPassword user.password
  insert "User"
    [ "username" =: user.username
    , "password" =: fromJust hashedPassword
    ]

findUserByUsername :: MonadIO m => Text -> Action m (Maybe Document)
findUserByUsername username = findOne (select ["username" =: username] "User")
