{-From https://codingbat.com/prob/p134022
Given two arrays of ints sorted in increasing order, outer and inner, return true if all
of the numbers in inner appear in outer. The best solution makes only a single "linear"
pass of both arrays, taking advantage of the fact that both arrays are already in sorted
order.
-}
import Control.Exception (assert)


linearIn :: [Int] -> [Int] -> Bool
linearIn outer inner = undefined

main :: IO ()
main = do
    assert (linearIn [1,2,4,6] [2,4] == True) (putStrLn "Test passed")
    assert (linearIn [1,2,4,6] [2,3,4] == False) (putStrLn "Test passed")
    assert (linearIn [1,2,4,4,6] [2,4] == True) (putStrLn "Test passed")
    assert (linearIn [1,2,4,6] [2,4] == True) (putStrLn "Test passed")
    assert (linearIn [1,2,4,6] [2,3,4] == False) (putStrLn "Test passed")
    assert (linearIn [1,2,4,4,6] [2,4] == True) (putStrLn "Test passed")
