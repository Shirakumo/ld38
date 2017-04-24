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
  (say "(The crab clicks its pincers at you)")
  (choice
   ("Hello, little fellow."
    (say "(The crab stares at you intently)"))
   ("What is a crab doing here?"
    (say "(The crab waves its pincers at you)"))
   ("It's a crab."
    (say "(The crab ignores you)")))
  (choice
   ("(Leave it alone)")
   ("(Pet it)"
    (change dialogue pincers-clicks)
    (jump pincers-clicks))
   ("Boo!"
    (change dialogue pincers-scream)
    (jump pincers-scream))))

(define-dialogue pincers-clicks
  (say "(The crab clickety clicks its pincers affectionately)"))

(define-dialogue pincers-scream
  (say "AAAAAAAAAAAAAAAA"))

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
