(in-package #:ld38)

(define-dialogue niece-hello
  (affect goal)
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))

(define-dialogue niece-suspect-1
  (affect goal)
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))

(define-dialogue niece-suspect-2
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (say "Would you like to accuse him?")
  (choice
   ("Yes."
    (affect goal)
    (accuse niece niece-true niece-false))
   ("No.")))

(define-dialogue niece-true
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (affect goal))

(define-dialogue niece-false
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))
