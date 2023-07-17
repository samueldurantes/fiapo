module Fiapo.Modules.User.Entities.Password where

import Crypto.BCrypt      (hashPasswordUsingPolicy, slowerBcryptHashingPolicy,
                           validatePassword)
import Data.Function      (on)
import Data.Text          (Text)
import Data.Text.Encoding (decodeUtf8, encodeUtf8)

-- Hashes the password using bcrypt
hashPassword :: Text -> IO (Maybe Text)
hashPassword password = do
  hashedPassword <- hashPasswordUsingPolicy slowerBcryptHashingPolicy (encodeUtf8 password)
  pure (decodeUtf8 <$> hashedPassword)

-- Verifies if the password matches with a hashed password
verifyPassword :: Text -> Text -> Bool
verifyPassword = validatePassword `on` encodeUtf8

