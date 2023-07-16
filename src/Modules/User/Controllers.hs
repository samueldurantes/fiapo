module Modules.User.Controllers
  ( userRegister
  , userLogin
  ) where

import GHC.Generics (Generic)

import Web.Scotty
import Modules.User.Model (User(..))
import Data.Text (Text)
import Data.Aeson (ToJSON, decode)
import Modules.User.Repository (insertUser, findUserByUsername)
import Network.HTTP.Types (created201, badRequest400, unauthorized401)
import Database.MongoDB (look, typed)

import qualified Utils

newtype UserResponse = UserResponse
  { name :: Text
  } deriving (Generic, Show)

instance ToJSON UserResponse where

data Response = Response
  { message :: String
  , user :: Maybe UserResponse
  , token :: Maybe Text
  } deriving (Generic, Show)

instance ToJSON Response where

jsonResponse :: String -> Maybe User -> Maybe Text -> ActionM ()
jsonResponse message user token =
  case user of
    Just us ->
      json $ Response
        { message
        , user = Just (UserResponse { name = us.username })
        , token
        }
    Nothing ->
      json $ Response
        { message
        , user = Nothing
        , token
        }

userRegister runConn = do
  b <- body
  case decode b of
    Just (user :: User) -> do
      _ <- runConn $ insertUser user
      status created201
      jsonResponse "User successfully registered!" (pure user) Nothing
    Nothing -> do
      status badRequest400
      jsonResponse "Request body malformed!" Nothing Nothing

userLogin runConn = do
    b <- body
    case decode b of
      Just (user :: User) -> do
        u <- runConn $ findUserByUsername user.username
        case u of
          Just userStored -> do
            hashedPassword <- look "password" userStored
            if Utils.verifyPassword (typed hashedPassword) user.password
              then jsonResponse "User logged in successfully!" (pure user) Nothing
              else do
                status unauthorized401
                jsonResponse "Incorrect password!" Nothing Nothing
          Nothing -> do
            status badRequest400
            jsonResponse "User not exists!" (pure user) Nothing
      Nothing -> do
        status badRequest400
        jsonResponse "Request body malformed!" Nothing Nothing
