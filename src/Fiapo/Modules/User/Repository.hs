module Fiapo.Modules.User.Repository
  ( insertUser,
    findUserByUsername,
    Query
  )
where

import Control.Monad.IO.Class               (MonadIO (liftIO))
import Data.Maybe                           (fromJust)
import Data.Text                            (Text)

import Fiapo.Modules.User.Entities.Password (hashPassword)
import Fiapo.Modules.User.Entities.User     (User (..))

import Database.MongoDB                     qualified as MongoDB

type Query m a d = MongoDB.Action m d -> m d

insertUser :: (MonadIO m) => User -> MongoDB.Action m MongoDB.Value
insertUser user = do
  hashedPassword <- liftIO $ hashPassword user.password
  MongoDB.insert
    "User"
    [ "username" MongoDB.=: user.username,
      "password" MongoDB.=: fromJust hashedPassword
    ]

findUserByUsername :: (MonadIO m) => Text -> MongoDB.Action m (Maybe MongoDB.Document)
findUserByUsername username =
    MongoDB.findOne (MongoDB.select ["username" MongoDB.=: username] "User")
