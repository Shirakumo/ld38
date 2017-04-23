(in-package #:cl-user)
(asdf:defsystem ld38
  :serial T
  :components ((:file "package")
               (:file "sprite")
               (:file "text")
               (:file "dialogue")
               (:file "world")
               (:file "character")
               (:file "dialogs")
               (:file "ghost")
               (:file "player")
               (:file "story")
               (:file "chicken")
               (:file "main"))
  :depends-on (:trial
               :cl-fond))
