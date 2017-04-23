(in-package #:cl-user)
(defpackage #:ld38
  (:use #:cl+qt #:trial)
  (:shadow #:dialogue #:remove-dialogue #:define-dialogue)
  (:shadowing-import-from #:flare #:slot)
  (:shadowing-import-from #:trial #:load)
  (:export
   #:ld38))
