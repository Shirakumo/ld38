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
