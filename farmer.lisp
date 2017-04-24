(in-package #:ld38)

(define-dialogue farmer-hello
  (affect goal)
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))

(define-dialogue farmer-suspect-1
  (affect goal)
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)"))

(define-dialogue farmer-suspect-2
  (say "(Note to self, REMEMBER TO WRITE THIS OUT.)")
  (say "Would you like to accuse him?")
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
