(in-package #:ld38)

(define-shader-subject world (sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'world)))

(define-asset (sprites world) texture-asset
    (#p"world.png"))
