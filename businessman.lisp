(in-package #:ld38)

(define-dialogue businessman-hello
  (affect goal)
  (say "(You run into awfully sharp dressed man with leather shoes polished to glint in the sunlight.)")
  (say "Greetings there, young miss.")
  (say "Say, would you happen to have a moment?")
  (say "Say, would you happen to have a moment? We have been making great progress here!")
  (choice
   ("Certainly, sir."
    (say "Marvellous choice, miss!")
    (say "This is now my fourth start-up and I have a really good feeling about this!")
    (change flag)
    (jump businessman-excited))
   ("I'd rather not.."
    (say "Perhaps later then. I shall be here!"))
   ("No. Not now. Not ever."
    (say "That is very disappointing, miss. But I shall not bother you any longer.")
    (affect ending businessman)
    (change dialogue businessman-disappointed))))

(define-dialogue businessman-excited
  (mood excited)
  (say "My organisation believes in deconstructed management mobility.")
  (say "My organisation believes in deconstructed management mobility. Today just happens to mark the 20th anniversary celebrations of our millennial monitored contingencies.")
  (say "A you may know, we need a more contemporary reimagining of our global transitional processing.")
  (say "A you may know, we need a more contemporary reimagining of our global transitional processing. Our bleeding edge exploratory research points to optional monitored matrix approaches.")
  (say "It's time that we became uber-efficient with our three-dimensional organisational time-phases!")
  (say "It's time that we became uber-efficient with our three-dimensional organisational time-phases! Would you like to hear more?")
  (choice
   ("I'd rather not right now."
    (say "That is fine, time is money as they say.")
    (say "I do not recall coming to it last week but I shall expect you to visit us at the symposium this spring."))
   ("I'm sorry but I need to go."
    (say "That is too bad, miss. I hope to see you again.")))
  (change dialogue businessman-idle))

(define-dialogue businessman-idle
  (say "(The businessman has begun to work on something on his phone. Better not disturb him.)"))

(define-dialogue businessman-disappointed
  (say "You again?")
  (say "If you don't mind, I have important business to attend to.")
  (say "(The businessman has begun to work on something on his phone. Better not disturb him.)"))

(define-dialogue businessman-innocent
  (affect-goal)
  (say "(The businessman seems to be enjoying the chill breeze that runs through here.)")
  (say "Hello again. This is a lovely little world, isn't it?")
  (choice
   ("I think so too."
    (say "(The man gives you an approving nod.)"))
   ("Not really?"
    (say "Ahh, perhaps it just takes a certain kind of a mind then."))
   ("What makes you say that?"))
  (say "One end of chill, feeding the river that runs to the other side.")
  (say "Other end.. perfect for hm...")
  (say "Other end.. perfect for hm... ...")
  (say "Other end.. perfect for hm... ... Life.")
  (say "(He falls into thought. Better leave him to them.)")
  (change dialogue businessman-thoughtful))

(define-dialogue businessman-thoughtful
  (say "(The businessman is deep in thought.)"))

(define-dialogue businessman-suspect
  (affect goal)
  (say "(The businessman keeps taking his phone out of his pocket, fidgeting with it nervously for a time, and then returns it back into his pocket.)")
  (say "(He keeps repeating this motion and refuses to acknowledge you. Completely unlike his earlier appearance.)")
  (say "(Curiously, his previously well polished shoes are now muddy.)"))

(define-dialogue businessman-accusation
  (say "(The businessman is listening intently to someone on his phone and keeps trying to wave you away.)")
  (say "Would you like to accuse him?")
  (choice
   ("Yes."
    (affect goal)
    (accuse businessman businessman-true businessman-false))
   ("No.")))

(define-dialogue businessman-true
  (affect goal)
  (say "Ah.. You're back.")
  (say "(He puts his phone away with a click.)")
  (say "I knew someone would find out eventually. Did not expect it'd be this quickly.")
  (say "But perhaps it is for the best.")
  (say "Would you like to hear this poor man's story?")
  (choice
   ("Yes."
    (say "(TODO: blah blah blah debtors blah blah must succeed blah blah previous startups)"))
   ("No."
    (say "As you wish then.")))
  (say "Go back to the poor ghost. I will hand myself over to the authorities of this world.")
  (change dialogue businessman-gone))

(define-dialogue businessman-false
  (say "Hold on a moment.")
  (say "Hold on a moment. (He puts his phone away with a click.)")
  (say "Did you just accuse me of a MURDER?")
  (say "(The businessman looks flabbergasted.)")
  (say "Ohhh, I see what's going on in here. That farmer put you up to this, didn't she?")
  (say "Well that won't do at all! She'll see what's coming to her!")
  (say "And here I was going to offer her a partnership in my organisation!")
  (say "JUSTICE SHALL PREVAIL!")
  (say "(He storms off.)")
  (change dialogue businessman-gone)
  (affect ending bad others))

(define-dialogue businessman-gone
  (say "(He's gone! Nothing here!)"))
