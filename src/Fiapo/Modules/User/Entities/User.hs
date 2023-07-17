module Fiapo.Modules.User.Entities.User where

import Data.Aeson
import Data.Text    (Text)
import GHC.Generics (Generic)

data User = User
  { username :: Text,
    password :: Text
  }
  deriving (Generic, Show)

instance FromJSON User where
  parseJSON (Object v) =
    User
      <$> v .: "username"
      <*> v .: "password"
  parseJSON _ = fail "Invalid User"

instance ToJSON User where
  toEncoding = genericToEncoding defaultOptions
