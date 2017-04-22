(in-package #:ld38)

(defclass world-character (world-entity sprite)
  ((velocity :initform 0 :accessor velocity)))

(defclass pincers (world-character) ()
  (:default-initargs
   :texture (asset 'sprites 'pincers)
   :name :pincers
   :angle 45))

(define-asset (sprites pincers) texture-asset
    (#P"whatever.png"))
