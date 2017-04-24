(in-package #:ld38)

(define-dialogue niece-hello
  (affect goal)
  (say "You there! Welcome to the best spot on the planet! Everyone who's who is here!")
  (say "So welcome welcome welcome!!!")
  (choice
   ("What's...")
   ("I...")
   ("Hello..?"))
  (say "Yeah! You! You are a ball of fire. You are a flaming, feisty, bold ball of fire.")
  (say "You may feel like you get extinguished a lot, but you are set ablaze more times than you are drowned.")
  (choice
   ("Um...")
   ("Okay...?")
   ("Thanks, I guess."))
  (say "Yeah! You are smart, you are unique, you are interesting, you are creative, you are capable and you are important.")
  (say "You can kick ass when you set your mind to it. There is no obstacle you can't overcome. Don't stop believing in your ass kicking skills, ever!")
  (choice
   ("I'm going to go now."))
  (say "Yeah!!"))

(define-dialogue niece-suspect-1
  (affect goal)
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))

(define-dialogue niece-suspect-2
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (say "Would you like to accuse him?")
  (choice
   ("Yes."
    (affect goal)
    (accuse niece niece-true niece-false))
   ("No.")))

(define-dialogue niece-true
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (affect goal))

(define-dialogue niece-false
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))
