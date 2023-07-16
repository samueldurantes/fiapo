module Modules.User.Model (User(..)) where

import GHC.Generics (Generic)

import Data.Aeson
import Data.Text (Text)

data User = User
  { username :: Text
  , password :: Text
  } deriving (Generic, Show)

instance FromJSON User where
    parseJSON (Object v) = User
        <$> v .: "username"
        <*> v .: "password"
    parseJSON _ = fail "Invalid User"

instance ToJSON User where
  toEncoding = genericToEncoding defaultOptions
