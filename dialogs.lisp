(in-package #:ld38)

(define-dialogue pincers-hello
  :tag start
  pincers "How's it going?"
  :choice (("It is what it is."
            :dialogue pincers-disappointed)
           ("Life is hard and everything is terrible.")
           ("Eh, I don't know."
            pincers "Well try to figure out."
            :go start))
  pincers "Word.")

(define-dialogue pincers-disappointed
  :action (pincers depressed)
  pincers "I was just trying to be nice."
  pincers "Anyway, go away."
  :end all)

(define-dialogue pincers-happy
  :action (pincers greeting)
  pincers "Hello again, I hope you've enjoyed the planet.")

(define-dialogue pincers-unhappy
  :action (pincers depressed)
  pincer "...")

(define-dialogue attorney-hello
  :tag start
  attorney "Greetings there, young miss. Would you have a moment?"
  :choice (("Certainly, sir."
            :dialogue attorney-excited)
           ("I'd rather not.."
            attorney "Perhaps later then. I shall be here!")
           ("No. Not now. Not ever."
            attorney "That is very disappointing, miss. But I shall not bother you any longer.")))

(define-dialogue attorney-excited
  :action (attorney excited)
  attorney "Marvellous choice, miss!"
  attorney "My organisation believes in deconstructed management mobility."
  attorney "Today just happens to mark the 20th anniversary celebrations of our millennial monitored contingencies."
  attorney "A you may know, we need a more contemporary reimagining of our global transitional processing."
  attorney "Our bleeding edge exploratory research points to optional monitored matrix approaches."
  attorney "It's time that we became uber-efficient with our three-dimensional organisational time-phases!"
  attorney "Would you like to hear more?"
  :choice (("I'd rather not right now."
            attorney "That is fine, time is money as they say. I shall expect you to visit us at the symposium this spring.")
           ("I'm sorry but I need to go."
            attorney "That is too bad, miss. I hope to see you again."))
  :end all)
