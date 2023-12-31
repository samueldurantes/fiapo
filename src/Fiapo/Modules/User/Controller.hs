module Fiapo.Modules.User.Controller (register, login) where

import Data.Aeson                        (decode)
import Data.Aeson.Types                  (ToJSON)
import Data.Text                         (Text)
import Fiapo.Modules.User.Entities.User  (User)
import GHC.Generics                      (Generic)
import Fiapo.Modules.User.UseCases.Login (userLogin)
import Fiapo.Shared.Monad.Controller     (run)
import Fiapo.Modules.User.Error          (Error(..))
import Control.Monad.Except              (throwError)
import Web.Scotty                        (body, json, status)
import Network.HTTP.Types                (created201)

import qualified Fiapo.Modules.User.Entities.User as User

newtype UserResponse = UserResponse
  { username :: Text
  }
  deriving (Generic, Show)

data Response = Response
  { message :: String,
    user    :: UserResponse,
    token   :: Maybe Text
  }
  deriving (Generic, Show)

instance ToJSON UserResponse
instance ToJSON Response

register runConn = do
  b <- body
  case decode b of
    Just (user :: User) -> do
      r <- userLogin runConn user
      case r of
        Left e  -> run (throwError e)
        -- TODO: improve this
        Right u -> do
          status created201
          json $ Response
            { message = "User successfully registered!"
            , user = UserResponse { username = User.username u }
            , token = Nothing
            }
    Nothing -> run (throwError RequestBodyMalformed)

login runConn = do
  b <- body
  case decode b of
    Just (user :: User) -> do
      l <- userLogin runConn user
      case l of
        Left e  -> run (throwError e)
        -- TODO: improve this
        Right u -> json $ Response
          { message = "User logged in successfully!"
          , user = UserResponse { username = User.username u }
          , token = Nothing
          }
    Nothing -> run (throwError RequestBodyMalformed)
