module Examples.Ch4_3 where

data Mood = Blah | Woot deriving Show

changeMood Blah = Woot
changeMood _ = Blah

awesome = ["Papuchon", "curry", ":)"]
alsoAwesome = ["Quake", "The Simons"]
allAwesome = [awesome, alsoAwesome]

length :: Num a => [t] -> a
length t = sum [1 | x <- t]

isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome x = x == reverse x
