
module Repositories.PersonRepository where
  
import Repositories.SqliteDb
import DomainModels.Person

--TODO getAllPersons
getAllPersons :: SqliteM [Person]
getAllPersons = return []