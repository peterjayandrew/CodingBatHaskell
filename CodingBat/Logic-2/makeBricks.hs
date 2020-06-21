{-From https://codingbat.com/prob/p183562
We want to make a row of bricks that is goal inches long. We have a number of small
bricks (1 inch each) and big bricks (5 inches each). Return true if it is possible to
make the goal by choosing from the given bricks. This is a little harder than it looks
and can be done without any loops. See also: Introduction to MakeBricks
-}
import Control.Exception (assert)


makeBricks :: Int -> Int -> Int -> Boolean
makeBricks small big goal = undefined

main = do
    assert (makeBricks 3 1 8 == true) (putStrLn "Test passed")
    assert (makeBricks 3 1 9 == false) (putStrLn "Test passed")
    assert (makeBricks 3 2 10 == true) (putStrLn "Test passed")
    assert (makeBricks 3 1 8 == true) (putStrLn "Test passed")
    assert (makeBricks 3 1 9 == false) (putStrLn "Test passed")
    assert (makeBricks 3 2 10 == true) (putStrLn "Test passed")

