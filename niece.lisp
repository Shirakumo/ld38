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
    (say "(You approach the young girl sternly.)")
    (affect goal)
    (accuse niece niece-true niece-false))
   ("No.")))

(define-dialogue niece-true
  (affect goal)
  (say "(The girl freezes as you approach her with determination.)")
  (choice
   ("(Try to greet her.)")
   ("(Grab her from shoulders and lower yourself to her eye level.)"))
  (say "(She refuses to look you directly in the eye.)")
  (choice
   ("So what happened?"
    (jump niece-what-happened))
   ("You're in trouble now."
    (say "...")))
  (choice
   ("We need to clear this all up.")
   ("What was that? Out with it."
    (say "(The girl is starting to tremble.)")))
  (jump niece-what-happened))

(define-dialogue niece-what-happened
  (say "...")
  (say "... ...")
  (say "It was an accident...")
  (say "Auntie was playing with Mr Fancypants and...")
  (say "She was going to shoot him...")
  (choose
   ("Who was?")
   ("Your auntie had a gun?"
    (say "No!")))
  (say "The new lady. The dead one...")
  (say "(She finally looks you square in the eyes.)")
  (say "So I pushed her, and it went off.")
  (change flag))

(define-dialogue niece-what-now
  (say "So what happens now?")
  (choice
   ("You're going to jail."
    (say "(The girl falls down into tears.)")
    (change dialogue niece-crying))
   ("Now I go to the ghost and tell her what happened."
    (say "Oh.."))))

(define-dialogue niece-crying
  (say "(She's on the ground. Crying. Good job.)"))

(define-dialogue niece-false
  (affect ending bad others)
  (choice
   ("So, it was you all along."
    (say "Um.. I was what? Am I in trouble?"))
   ("You will have long years in prison."
    (say "(The girl immediately freezes and stares at you with wide eyes.)"))
   ("What do you have to defend yourself?"
    (say "Huh?")))
  (say "(You inform the girl of her crime.)")
  (say "What? No! I didn't do it!")
  (say "I haven't hurt anyone!")
  (say "(She starts to back away.)")
  (choice
   ("Take a step closer.")
   ("Glare at her sternly."
    (change dialogue niece-crying)
    (jump niece-crying)))
  (say "You've got it all wrong!")
  (say "(The girl suddenly sprints off.)")
  (change dialogue niece-gone))

(define-dialogue niece-gone
  (say "(She's gone!)"))
