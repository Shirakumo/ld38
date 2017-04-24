(in-package #:ld38)

(define-dialogue farmer-hello
  (affect goal)
  (say "Hey thar, lassie.")
  (say "Hey thar, lassie. Wha' brings ya to this part of tha worl'?")
  (choice
   ("Just getting familiar with the place."
    (change flag  businessman)
    (change flag)
    (jump farmer-chatty))
   ("I'm investigating a murder."
    (say "Oh dear. I haven't heard anything about such a thing.")
    (say "Nobody here knows about any murders.")
    (say "(The farmer seems to decide to back off and go to work.)")
    (say "(She glances yar way a few more times.)")
    (change flag)
    (change flag niece))
   ("Nothing."
    (say "A bit rude to be so blunt, don't ya think?")
    (say "But I get the idea. I'll head to work.")
    (affect ending niece)
    (affect ending farmer)))
  (change dialogue farmer-working))

(define-dialogue farmer-chatty
  (say "(The farmer seems happy to have someone to talk to.)")
  (say "Well ya came to the right person!")
  (say "If there's one thing I know it's this world here!")
  (say "And farming. Two things I know! This world, and farming!")
  (say "And the people here. Three things! Well you get the idea.")
  (say "Then again there ain't much to know about the world here. 'Tis just me and me niece.")
  (say "Our families have been living here since the beginning, ya know.")
  (say "Well it used ta be us two 'til that suited fellow came here.")
  (say "(The farmer's features tighten as she talks about the businessman at the ice fields.")
  (say "He comes here and kept yappin' about how perfect our world is and how he's going to make his \"big break\" here. And a whole bunch of gobbletalk.")
  (say "Chased him right off, I did! Me gradmommy's ol' pitchfork and all!")
  (say "(She leans on her pitchfork, her eyes glassy and staring at nothing.)")
  (say "(You hear her murmur about what a classic \"'lander-meet-suit\" scene it was.)")
  (change dialogue farmer-daydreaming))

(define-dialogue farmer-daydreaming
  (say "(She seems lost in her thoughts.)"))

(define-dialogue farmer-working
  (say "(The farmer is very obviously focused on her work. It's doubtful she'd pay you any mind even if ya called out.)"))

(define-dialogue farmer-innocent
  (affect goal)
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))

(define-dialogue farmer-suspect
  (affect goal)
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))

(define-dialogue farmer-accuse
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (say "Would you like to accuse her?")
  (choice
   ("Yes."
    (affect goal)
    (accuse farmer farmer-true farmer-false))
   ("No.")))

(define-dialogue farmer-true
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (affect goal))

(define-dialogue farmer-false
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))
