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
               (:file "player")
               (:file "story")
               (:file "main"))
  :depends-on (:trial
               :cl-fond))
