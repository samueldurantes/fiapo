module Fiapo.Modules.User.Error where

import Data.Aeson                       (ToJSON (..))
import Data.Aeson.Types                 (object)
import Data.Text                        (Text)
import Fiapo.Modules.User.Entities.User
import Fiapo.Shared.Monad.Controller    (Failable (..))
import GHC.Generics                     (Generic)
import Network.HTTP.Types

data Error
  = RequestBody
  | IncorrectPassword
  | UserNotExists User
  | RequestBodyMalformed
  deriving (Generic, Show)

toResponse :: Error -> String
toResponse = \case
    RequestBody          -> "Request body is empty"
    IncorrectPassword    -> "Incorrect password"
    UserNotExists user   -> "User " <> show user <> " not exists"
    RequestBodyMalformed -> "Request body is malformed"

instance Failable Error where
  statusCode = \case
    RequestBody          -> badRequest400
    IncorrectPassword    -> unauthorized401
    UserNotExists _      -> notFound404
    RequestBodyMalformed -> badRequest400
