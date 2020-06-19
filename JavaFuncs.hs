-- The goal of this is to convert Java method declarations to Haskell ones
-- This is built for converting CodingBat problems
-- Also it DOES NOT DO ERROR HANDLING
-- If your method would not compile in real life, it will either not compile here or it will become a mess
-- A java method needs to be in this format:
-- returnType funcName(DataType1 arg1, DataType2 arg2)

module JavaFuncs
    ( DataType
    , mkType
    , mkContainer
    , dataTypeToHaskell
    , dataTypeToJava
    , javaToDataType

    , Function (funcName,retType,arguments)
    , mkFunction
    , funcToHaskell
    , funcToJava
    , javaToFunc
    , javaToHaskell
    , stripJava
    ) where

import Control.Arrow ((***),first)
import Data.Char (toUpper,isAlphaNum)
import Data.List (intercalate)
import Text.Printf
import Text.Regex.PCRE

-- utility functions for splitting declarations
containContainer :: Int -> String -> (String,String)
containContainer _ [] = ([],[])
containContainer 0 (' ':xs) = ([],xs)
containContainer carrots ('<':xs) = (('<' :) *** id) $ containContainer (carrots + 1) xs
containContainer carrots ('>':xs) = (('>' :) *** id) $ containContainer (carrots - 1) xs
containContainer carrots (x:xs) = ((x :) *** id) $ containContainer carrots xs

typeSplitter :: Int -> String -> String -> [String]
typeSplitter _ current [] = [current]
typeSplitter 0 current (',':' ':xs) = current : typeSplitter 0 "" xs -- splitting with space
typeSplitter 0 current (',':xs) = current : typeSplitter 0 "" xs -- splitting without space
typeSplitter carrots current ('<':xs) = typeSplitter (carrots + 1) (current ++ "<") xs
typeSplitter carrots current ('>':xs) = typeSplitter (carrots - 1) (current ++ ">") xs
typeSplitter carrots current (x:xs) = typeSplitter carrots (current ++ [x]) xs


data DataType = Type String
              | Container String [DataType]
                deriving (Eq,Show)

mkType :: String -> DataType
mkType (x:xs) = Type $ toUpper x : xs

mkContainer :: String -> [DataType] -> DataType
mkContainer s@(_:_) dts = Container s dts 

dataTypeToHaskell :: DataType -> String
dataTypeToHaskell (Type "void") = "IO ()"
dataTypeToHaskell (Type (x:xs)) = toUpper x : xs -- all types in Haskell need to start with a capital letter
dataTypeToHaskell (Container "Array" [dt]) = "[" ++ (dataTypeToHaskell dt) ++ "]"
dataTypeToHaskell (Container "List" [dt]) = "[" ++ (dataTypeToHaskell dt) ++ "]"
dataTypeToHaskell (Container "Map" dts) = dataTypeToHaskell (Container "Map.Map" dts) -- qualified import
dataTypeToHaskell (Container t dts) = t ++ " " ++ unwords (map eval dts) where
    -- this part is a bit messy :/
    -- all it does is handle nested Containers
    eval c@(Container "Array" [dt]) = dataTypeToHaskell c
    eval c@(Container "List" [dt]) = dataTypeToHaskell c
    eval c@(Container _ _) = "(" ++ dataTypeToHaskell c ++ ")" -- nested containers need to be in parentheses
    eval dt = dataTypeToHaskell dt

dataTypeToJava :: DataType -> String
dataTypeToJava (Type t) = t
dataTypeToJava (Container "Array" [dt]) = dataTypeToJava dt ++ "[]"
dataTypeToJava (Container t dts) = t ++ "<" ++ intercalate ", " (map dataTypeToJava dts) ++ ">"

javaToDataType :: String -> DataType
javaToDataType s =
    let (name,container) = break (\x -> x == '[' || x == '<') s
    in if null container
        then Type name
    else if head container == '['
        then Container "Array" [javaToDataType $ name ++ drop 2 container]
    else Container name (map javaToDataType $ typeSplitter 0 "" (init $ tail container))

data Function = Function { funcName :: String
                         , retType :: DataType
                         , arguments :: [(DataType,String)]
                         } deriving (Eq, Show)

mkFunction fn rt args | all (\x -> isAlphaNum x || x `elem` "'_") fn = Function fn rt args

-- creates a Haskell function declaration
funcToHaskell :: Function -> String
funcToHaskell (Function fn rt args) = printf "%s :: %s\n%s %s = undefined" fn arrows fn argnames where
    arrows = intercalate " -> " $ map (dataTypeToHaskell . fst) args ++ [dataTypeToHaskell rt]
    argnames = unwords $ map snd args

-- creates a Java function declaration
-- not really necessary for my purposes but I like the symmetry
funcToJava :: Function -> String
funcToJava f = printf "%s %s(%s)" (dataTypeToJava $ retType f) (funcName f) args' where
    args' = intercalate ", " $ map (\(dt,s) -> unwords [dataTypeToJava dt,s]) $ arguments f

javaToFunc :: String -> Function
javaToFunc funcstr = Function fn (javaToDataType rt) args where
    -- distinguishes containers in a string
    (rt,funcstr') = containContainer 0 funcstr
    (fn,args') = break (== '(') funcstr'
    args = map (first javaToDataType . containContainer 0) $ typeSplitter 0 "" $ init $ tail args'

javaToHaskell :: String -> String
javaToHaskell = funcToHaskell . javaToFunc . stripJava

-- strips the "public static final protected oblong juice" prefixes and the "{ " suffix
-- from method declarations
stripJava :: String -> String
stripJava funcstr = fix body ++ ")" where
    (body,_) = break (== ')') funcstr
    fix s = let (prefix,suffix) = containContainer 0 s
        in if (suffix =~ "^\\S+\\(" :: Bool)
            then unwords [prefix,suffix]
        else fix suffix