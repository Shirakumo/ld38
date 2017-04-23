(in-package #:ld38)

(define-dialogue ghost-hello
  (say "...")
  (say "... ...")
  (say "Who is it I sense near this poor creature?")
  (choice
   ("Hello? I was just passing by."
    (say "Hello yourself."))
   ("Ack! A ghost!"
    (say "No need to shout. I can hear you just fine as it is."))
   ("Spoopy."
    (say "I suppose it is, isn't it?")))
  (say "Could this sad case of spirits bother you with a small request?")
  (say "I would really like to know who killed me.")
  (choice
   ("Yes, of course. But what could I do?"
    (say "There is quite plenty."))
   ("You don't know how you died?"
    (say "Well, no. But I would not be haunting here if I had passed peacefully now would I?"))
   ("A murder mystery? I'm in!"
    (say "That's the spirit, lass."))
   ("What? No."
    (say "Please...?")
    (choice
     ("Fine."
      (say "Thank you."))
     ("I said no."
      (check ending bad)
      (end dialogue)))))
  (say "Now, this world we inhabit is quite small. You can easily traverse it within moments.")
  (say "There are a few persons of interest here. If you could go see what you can find out from them.")
  (say "And thank you most kindly for doing this.")
  (change dialogue ghost-idle-1))

(define-dialogue ghost-idle-1
  (say "...")
  (say "... ...")
  (say "Oh, you're back already?")
  (say "If you don't know where to go try walking to a single direction for a while."))

(define-dialogue ghost-progress-1
  (say "Ah, you seem like you've found something.")
  (say "Please, do let me know what you've found.")
  (change chapter))

(define-dialogue ghost-start-2
  (say "So, any of the three could've done it.")
  (choice
   ("I'm a pretty good detective."
    (say "Now don't get so cocky just yet.")
    (say "We're only getting started."))
   ("So we're not any closer to the truth."
    (say "Quite the opposite! We've got our feet going.")
    (say "Now we just need to keep up the momentum."))
   ("What now?"
    (say "Now you get back there and poke around some more.")))
  (say "Go see if they've got anything new to say.")
  (change dialogue ghost-idle-2))

(define-dialogue ghost-idle-2
  (say "Come no, apprentice detective.")
  (say "There's more leg work to be done!"))

(define-dialogue ghost-progress-2
  (say "So, we're done! Now, tell me what do you think?")
  (choice
   ("I think it was the businessman."
    (check ending businessman))
   ("I think it was the farmer."
    (check ending farmer))
   ("I think it was the farmer's niece."
    (check ending niece))
   ("I think they all did it."
    (check ending all))
   ("That crab has been acting awfully suspicious."
    (check ending crab))
   ("I don't think it was any of them."
    (check ending suicide)
    (say "But that'd mean...!")
    (say "I... will have to think on that...")
    (end dialogue)))
  (say "I do feel like as if I've spent time with them just recently.")
  (say "But still.. I sure hope you're right..")
  (say "Well, go apprehend them!")
  (change chapter))

(define-dialogue ghost-good-ending
  (say "So it really was them.")
  (say "But why? Why would they just leave me dead in here?")
  (choice
   ("Tell her the truth.")
   ("Lie about it."))
  (say "...")
  (say "... ...")
  (say "... ... ...")
  (say "I see. Well, I shall head out there, beyond the light.")
  (say "Thank you.")
  (end story))

(define-dialogue ghost-bad-ending
  (say "...")
  (say "... ...")
  (say "Perhaps you thought this was going to be just a fun game.")
  (say "Or perhaps your best just was not enough this time.")
  (say "...")
  (say "I cannot hold my form clear any longer.")
  (say "This is where we bid farewell.")
  (end story))
