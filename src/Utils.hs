module Utils where

import Data.Text (Text)
import Data.Text.Encoding (encodeUtf8, decodeUtf8)
import Crypto.BCrypt (hashPasswordUsingPolicy, slowerBcryptHashingPolicy, validatePassword)

hashPassword :: Text -> IO (Maybe Text)
hashPassword password = do
  hashedPassword <- hashPasswordUsingPolicy slowerBcryptHashingPolicy (encodeUtf8 password)
  case hashedPassword of
    Just hs -> pure $ Just (decodeUtf8 hs)
    Nothing -> pure Nothing

verifyPassword :: Text -> Text -> Bool
verifyPassword hashedPassword password =
  validatePassword (encodeUtf8 hashedPassword) (encodeUtf8 password)
