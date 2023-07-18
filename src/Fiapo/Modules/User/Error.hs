module Fiapo.Modules.User.Error where

import Fiapo.Modules.User.Entities.User (User)
import Fiapo.Shared.Monad.Controller    (Failable (..))
import GHC.Generics                     (Generic)
import Data.Aeson                       (ToJSON(toJSON), object, KeyValue((.=)) )
import Network.HTTP.Types               (badRequest400, notFound404, unauthorized401)

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

instance ToJSON Error where
  toJSON t = object [ "message" .= toResponse t ]

instance Failable Error where
  statusCode = \case
    RequestBody          -> badRequest400
    IncorrectPassword    -> unauthorized401
    UserNotExists _      -> notFound404
    RequestBodyMalformed -> badRequest400
