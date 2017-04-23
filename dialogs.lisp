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

(define-dialogue janitor-hello
  :tag start
  janitor "Hey there, kid. Wha brings ya here?"
  :choice (("Just exploring."
            janitor "Hmph.. Well stay away from the ice fields."
            janitor "Tha blasted 'torney is yapping his gums at any poor sod thar.")
           ("Nothing."
            janitor "Noffin? Figures ya kids have too much time these days.")
           ("Came to see you, actually"
            janitor "An old fella like me?"
            :dialogue janitor-curious))
  janitor "Be seein' ya, lass.")

(define-dialogue janitor-curious
  janitor "Well what d'ya need then?"
  :choice (("Just a chat."
            janitor "Hrm, yar better off yapping to others here than me.")
           ("I'd like to know where I am."
            janitor "Yer at the land between wasteland and the plains."
            janitor "Warmest spot on tha forsaken planet."))
  janitor "Run along now, lass."
  :end all)


(define-dialogue cheery-hello
  :tag start
  cheery "You there! Welcome to the best spot on the planet! Everyone who's who is here!"
  cheery "So welcome welcome welcome!!!"
  :choice (("What's...")
           ("I...")
           ("Hello..?"))
  cheery "Yeah! You! You are a ball of fire. You are a flaming, feisty, bold ball of fire."
  cheery "You may feel like you get extinguished a lot, but you are set ablaze more times than you are drowned."
  :choice (("Um...")
           ("Okay...?")
           ("Thanks, I guess."))
  cheery "Yeah! You are smart, you are unique, you are interesting, you are creative, you are capable and you are important."
  cheery "You can kick ass when you set your mind to it. There is no obstacle you can't overcome. Don't stop believing in your ass kicking skills, ever!"
  :choice (("I'm going to go now."))
  cheery "Yeah!!")


