
module Config where

import Data.Aeson
import Data.Aeson.TH

data Config = Config
{
  database :: !Text,
  srvPort :: !Int
}

deriveJSON defaultOptions ''Config