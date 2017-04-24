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
  (affect goal)
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
  (affect ending crab)
  (say "AAAAAAAAAAAAAAAA"))
