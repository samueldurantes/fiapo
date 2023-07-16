module AppSpec (main, spec) where

import Test.Hspec
import Test.Hspec.Wai
-- import Test.Hspec.Wai.JSON

import App (app)

main :: IO ()
main = hspec spec

spec :: Spec
spec = with app $ do
  describe "GET /" $ do
    it "responds with 200" $ do
      get "/" `shouldRespondWith` 200
