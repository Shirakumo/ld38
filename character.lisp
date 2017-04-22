(in-package #:ld38)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass world-character ()
    ()))


(define-shader-subject pincers (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'pincers)
   :name :pincers
   :angle 45))

(define-asset (sprites pincers) texture-asset
    (#P"whatever.png"))


(define-shader-subject attorney (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'attorney)
   :name :attorney
   :angle 135))

(define-asset (sprites attorney) texture-asset
    (#P"whatever.png"))
