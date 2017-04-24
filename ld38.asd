(in-package #:cl-user)
(asdf:defsystem ld38
  :serial T
  :components ((:file "package")
               (:file "audio")
               (:file "sprite")
               (:file "text")
               (:file "dialogue")
               (:file "world")
               (:file "character")
               (:file "dialogs")
               (:file "ghost")
               (:file "businessman")
               (:file "farmer")
               (:file "niece")
               (:file "player")
               (:file "story")
               (:file "chicken")
               (:file "main"))
  :depends-on (:trial
               :cl-fond
               :cl-soloud)
  :defsystem-depends-on (:qtools)
  :build-operation "qt-program-op"
  :build-pathname "ld38"
  :entry-point "ld38:ld38")
