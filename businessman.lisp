(in-package #:ld38)

(define-dialogue businessman-hello
  (say "Greetings there, young miss.")
  (say "We have been having great progress here!")
  (say "Say, would you happen to have a moment?")
  (choice
   ("Certainly, sir."
    (jump businessman-excited))
   ("I'd rather not.."
    (say "Perhaps later then. I shall be here!"))
   ("No. Not now. Not ever."
    (say "That is very disappointing, miss. But I shall not bother you any longer.")
    (change dialogue businessman-disappointed))))

(define-dialogue businessman-excited
  (mood excited)
  (say "Marvellous choice, miss!")
  (say "My organisation believes in deconstructed management mobility.")
  (say "Today just happens to mark the 20th anniversary celebrations of our millennial monitored contingencies.")
  (say "A you may know, we need a more contemporary reimagining of our global transitional processing.")
  (say "Our bleeding edge exploratory research points to optional monitored matrix approaches.")
  (say "It's time that we became uber-efficient with our three-dimensional organisational time-phases!")
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
