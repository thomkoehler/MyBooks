
module Repositories.SqliteM where

import Control.Monad.Reader
import qualified Data.Text.IO as TIO
import Database.SQLite.Simple
import MyBooksSrv.Config

type SqliteM a = ReaderT Connection IO a

runSqliteM :: Config -> SqliteM a -> IO a
runSqliteM cfg action = withConnection (database cfg) $ \conn -> do
  setTrace conn $ Just TIO.putStrLn
  runReaderT action conn
