module AppSpec (main, spec) where

import Test.Hspec
import Test.Hspec.Wai

import App (app)

main :: IO ()
main = hspec spec

spec :: Spec
spec = with app $ do
  describe "POST /user/register" $ do
    it "should create a new user" $ do
      let body = "{\"username\": \"samuel\", \"password\": \"randompass123\"}"
      let expected = "{\"message\":\"User successfully registered!\",\"token\":null,\"user\":{\"name\":\"samuel\"}}"
      post "/user/register" body `shouldRespondWith` expected {matchStatus = 201}

    it "shouldn't create a new user because is with the wrong request body" $ do
      let wrong_body = "{\"username\": \"samuel\", \"passwor\": \"randompass123\"}"
      let expected = "{\"message\":\"Request body malformed!\",\"token\":null,\"user\":null}"
      post "/user/register" wrong_body `shouldRespondWith` expected {matchStatus = 400}
