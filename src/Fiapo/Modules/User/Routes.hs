module Fiapo.Modules.User.Routes (routes) where

import Web.Scotty (post)
import Fiapo.Modules.User.Controller (register, login)

routes runConn = do
  post "/user/register" (register runConn)
  post "/user/login"    (login runConn)
