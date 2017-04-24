(in-package #:ld38)

(define-dialogue niece-hello
  (affect goal)
  (say "You there! Welcome to the best spot in the world! Everyone who's who is here!")
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
   ("Who even are you?"
    (say "I'm the amazing niece of that good farmer over yonder there!")
    (say "Isn't \"yonder\" just the BEST word?"))
   ("I'm going to go now."))
  (say "Yeah!!")
  (change dialogue niece-busy))

(define-dialogue niece-busy
  (change flag)
  (say "(The young girl is busy doing.. whatever it is.)")
  (say "(It seems to involve cartwheels and running around carefully looking absolutely anything except you.)"))

(define-dialogue niece-suspect
  (change flag)
  (say "(The young girl is running around the meadow and jumping on rocks in the stream, back and forth.)")
  (say "(She appears to be paying attention to the smallest bits of flora and fauna of the land.)")
  (say "(Even so, she seems completely unaware of your presence.)")
  (say "(Wait, did she just start whistling?)"))

(define-dialogue niece-innocent
  (say "Hellooooo again!")
  (say "Did you meet my auntie and the fancypants?")
  (choice
   ("Sure did."
    (say "Wanna know what I think?")
    (say "I think they're in looooove!")
    (say "Ma always used to say that even the horse kicks out of love! It's gotta be true!"))
   ("No idea who you mean."
    (say "Woooow, you're not very smart are you?"))
   (change dialogue niece-hibye)))

(define-dialogue niece-hibye
  (say "Hi!")
  (choice ("Bye." (say "Bye!"))))

(define-dialogue niece-accuse
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
