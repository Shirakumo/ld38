(in-package #:ld38)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass world-character ()
    ((profile :initarg :profile :accessor profile))
    (:default-initargs
     :location (vec 0 0 2)
     :profile (asset 'sprites 'whatever))))

(defmethod load progn ((character world-character))
  (load (profile character)))

(define-shader-subject pincers (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'pincers)
   :profile (asset 'sprites 'pincers-profile)
   :name :pincers
   :angle 45))

(define-asset (sprites pincers) texture-asset
    (#P"pincers.png"))

(define-asset (sprites pincers-profile) texture-asset
    (#p"pincers-profile.png"))

(define-shader-subject attorney (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'attorney)
   :name :attorney
   :angle 135))

(define-asset (sprites attorney) texture-asset
    (#P"mystery.png"))


(define-shader-subject janitor (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'janitor)
   :name :janitor
   :angle 225))

(define-asset (sprites janitor) texture-asset
    (#P"mystery.png"))


(define-shader-subject cheery (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'cheery)
   :name :cheery
   :angle 30))

(define-asset (sprites cheery) texture-asset
    (#P"mystery.png"))
