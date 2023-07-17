module Fiapo.Modules.User.Routes (routes) where

import Web.Scotty (ScottyM, get, text)

routes :: ScottyM ()
routes = do
  get "/users" (text "users")