module Fiapo.Modules.User.Routes (routes) where

import Web.Scotty (post)
import Fiapo.Modules.User.Controller (login)

routes runConn = do
  post "/user/login" (login runConn)
