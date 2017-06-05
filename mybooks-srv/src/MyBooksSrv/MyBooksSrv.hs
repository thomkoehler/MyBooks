
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.MyBooksSrv where

import Yesod

import MyBooksSrv.DbModels


data MyBooksSrv = MyBooksSrv


mkYesod "MyBooksSrv" [parseRoutes|
  / HomeR GET
|]


instance Yesod MyBooksSrv


getHomeR :: Handler Value
getHomeR = returnJson $ Person "Sabine"

