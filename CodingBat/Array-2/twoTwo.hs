{-From https://codingbat.com/prob/p102145
Given an array of ints, return true if every 2 that appears in the array is next to
another 2.
-}
import Test.Hspec


twoTwo :: [Int] -> Bool
twoTwo nums = undefined

main :: IO ()
main = hspec $ describe "Tests:" $ do
   it "True" $ twoTwo [4,2,2,3] `shouldBe` True
   it "True" $ twoTwo [2,2,4] `shouldBe` True
   it "False" $ twoTwo [2,2,4,2] `shouldBe` False

