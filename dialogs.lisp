(in-package #:ld38)

(defvar *dialogues* (make-hash-table :test 'eql))

(defmethod dialogue ((name symbol))
  (gethash name *dialogues*))

(defmethod (setf dialogue) (value (name symbol))
  (setf (gethash name *dialogues*) value))

(defun remove-dialogue (name)
  (remhash name *dialogues*))

(defmacro define-dialogue (name &body def)
  `(setf (dialogue ',name) ',def))

(define-dialogue pincers-hello
  (say "The crab clicks its pincers at you.")
  (choice
   ("Hello, little fellow."
    (say "The crab stares at you intently."))
   ("What is a crab doing here?"
    (say "The crab waves its pincers at you."))
   ("It's a crab."
    (say "The crab ignores you."))))

(define-dialogue pincers-clicks
  (say "The crab clickety clacks its pincers at your general direction."))

(define-dialogue attorney-hello
  (say "Greetings there, young miss. Would you have a moment?")
  (choice
   ("Certainly, sir."
    (jump attorney-excited))
   ("I'd rather not.."
    (say "Perhaps later then. I shall be here!"))
   ("No. Not now. Not ever."
    (say "That is very disappointing, miss. But I shall not bother you any longer."))))

(define-dialogue attorney-excited
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

(define-dialogue janitor-hello
  (say "Hey there, kid. Wha brings ya here?")
  (choice
   ("Just exploring."
    (say "Hmph.. Well stay away from the ice fields.")
    (say "Tha blasted 'torney is yapping his gums at any poor sod thar."))
   ("Nothing."
    (say "Noffin? Figures ya kids have too much time these days."))
   ("Came to see you, actually"
    (say "An old fella like me?")
    (jump janitor-curious)))
  (say "Be seein' ya, lass."))

(define-dialogue janitor-curious
  (say "Well what d'ya need then?")
  (choice
   ("Just a chat."
    (say "Hrm, yar better off yapping to others here than me."))
   ("I'd like to know where I am."
    (say "Yer at the land between wasteland and the plains.")
    (say "Warmest spot on tha forsaken planet.")))
  (say "Run along now, lass."))

(define-dialogue cheery-hello
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
