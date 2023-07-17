module Fiapo.Modules.User.Controller where

import Data.Aeson.Types                 (ToJSON)
import Data.Text                        (Text)
import Fiapo.Modules.User.Entities.User (User)
import GHC.Generics                     (Generic)

newtype UserResponse = UserResponse
  { name :: Text
  }
  deriving (Generic, Show)

data Response = Response
  { message :: String,
    user    :: Maybe UserResponse,
    token   :: Maybe Text
  }
  deriving (Generic, Show)

instance ToJSON UserResponse
instance ToJSON Response
