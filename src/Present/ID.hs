{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- | ID library.

module Present.ID
  (ID
  ,split
  ,fromList
  ,singleton
  ,cons
  ,snoc)
  where

import           Data.Aeson
import           Data.AttoLisp
import           Data.Data
import           Data.Default
import           Data.List
import           Data.List.NonEmpty (NonEmpty(..))
import qualified Data.List.NonEmpty as NE
import           Data.Semigroup

newtype ID =
  ID (NonEmpty Integer)
  deriving (Eq,Semigroup,Data,Typeable)

instance ToJSON ID where
  toJSON (ID (x :| xs)) = toJSON (x : xs)

instance ToLisp ID where
  toLisp (ID (x :| xs)) = toLisp (x : xs)

instance Default ID where
  def = singleton 0

instance Show ID where
  show (ID (x :| xs)) = "@" ++ intercalate "→" (map show (x : xs))

-- | Split off the first parent from the ID.
split :: ID -> (Integer,Maybe ID)
split (ID (x :| xs)) = (x,fromList xs)

-- | Try to convert from a  list.
fromList :: [Integer] -> Maybe ID
fromList = fmap ID . NE.nonEmpty

-- | Make a singleton ID.
singleton :: Integer -> ID
singleton = ID . nesingleton

-- | Construct an ID.
cons :: Integer -> [Integer] -> ID
cons x xs = ID (x :| xs)

-- | Construct an ID.
snoc :: ID -> Integer -> ID
snoc (ID xs) i = ID (xs <> nesingleton i)

-- | Should be in the library, isn't.
nesingleton :: a -> NonEmpty a
nesingleton = (:| [])
