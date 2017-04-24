(in-package #:ld38)

(define-dialogue businessman-hello
  (affect goal)
  (say "Greetings there, young miss.")
  (say "Say, would you happen to have a moment?")
  (say "We have been having great progress here!")
  (choice
   ("Certainly, sir."
    (say "Marvellous choice, miss!")
    (jump businessman-excited))
   ("I'd rather not.."
    (say "Perhaps later then. I shall be here!"))
   ("No. Not now. Not ever."
    (say "That is very disappointing, miss. But I shall not bother you any longer.")
    (change dialogue businessman-disappointed))))

(define-dialogue businessman-excited
  (affect branch 1)
  (mood excited)
  (say "My organisation believes in deconstructed management mobility.~%
Today just happens to mark the 20th anniversary celebrations of our millennial monitored contingencies.")
  (say "A you may know, we need a more contemporary reimagining of our global transitional processing.~%
Our bleeding edge exploratory research points to optional monitored matrix approaches.~%
It's time that we became uber-efficient with our three-dimensional organisational time-phases!")
  (say "Would you like to hear more?")
  (choice
   ("I'd rather not right now."
    (say "That is fine, time is money as they say.")
    (say "I do not recall coming to it last week but I shall expect you to visit us at the symposium this spring."))
   ("I'm sorry but I need to go."
    (say "That is too bad, miss. I hope to see you again."))))

(define-dialogue businessman-disappointed
  (say "You again?")
  (say "If you don't mind, I have important business to attend to."))

(define-dialogue businessman-suspect-1
  (affect goal)
  (say "The businessman keeps taking his phone out of his pocket, fidgeting with it nervously for a time, and then returns it back into his pocket.")
  (say "He keeps repeating this motion and refuses to acknowledge you. Completely unlike his earlier appearance."))

(define-dialogue businessman-suspect-2
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (say "Would you like to accuse him?")
  (choice
   ("Yes."
    (affect goal)
    (accuse businessman businessman-true businessman-false))
   ("No.")))

(define-dialogue businessman-true
  (affect goal)
  (say "Ah.. You're back.")
  (say "I knew someone would find out eventually. Did not expect it'd be this quickly.")
  (say "But perhaps it is for the best.")
  (say "Would you like to hear this poor man's story?")
  (choice
   ("Yes."
    (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))
   ("No."
    (say "As you wish then.")))
  (say "Go back to the poor ghost. I will hand myself over to the authorities of this world."))

(define-dialogue businessman-false
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))
