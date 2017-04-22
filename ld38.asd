(in-package #:cl-user)
(asdf:defsystem ld38
  :serial T
  :components ((:file "package")
               (:file "sprite")
               (:file "character")
               (:file "player")
               (:file "world")
               (:file "main"))
  :depends-on (:trial))
