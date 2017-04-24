(in-package #:ld38)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass world-character ()
    ((profile :initarg :profile :accessor profile)
     (dialogue :initarg :dialogue :accessor dialogue))
    (:default-initargs
     :location (vec 0 0 2)
     :profile (asset 'sprites 'whatever)
     :dialogue NIL)))

(defmethod load progn ((character world-character))
  (load (profile character)))

(define-shader-subject ghost (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'ghost)
   :profile (asset 'sprites 'ghost-profile)
   :dialogue (dialogue 'ghost-hello)
   :name :ghost
   :angle 93))

(define-asset (sprites ghost) texture-asset
    (#P"ghost.png"))

(define-asset (sprites ghost-profile) texture-asset
    (#P"ghost-profile.png"))

(define-shader-subject pincers (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'pincers)
   :profile (asset 'sprites 'pincers-profile)
   :dialogue (dialogue 'pincers-hello)
   :name :pincers
   :angle 45))

(define-asset (sprites pincers) texture-asset
    (#P"pincers.png"))

(define-asset (sprites pincers-profile) texture-asset
    (#p"pincers-profile.png"))

(define-shader-subject businessman (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'businessman)
   :profile (asset 'sprites 'businessman-profile)
   :dialogue (dialogue 'businessman-hello)
   :name :businessman
   :angle 135))

(define-asset (sprites businessman) texture-asset
    (#P"businessman.png"))

(define-asset (sprites businessman-profile) texture-asset
    (#P"businessman-profile.png"))

(define-shader-subject farmer (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'farmer)
   :profile (asset 'sprites 'farmer-profile)
   :dialogue (dialogue 'farmer-hello)
   :name :farmer
   :angle 225))

(define-asset (sprites farmer) texture-asset
    (#P"farmer.png"))

(define-asset (sprites farmer-profile) texture-asset
    (#p"farmer-profile.png"))

(define-shader-subject niece (world-entity world-character sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'niece)
   :profile (asset 'sprites 'niece-profile)
   :dialogue (dialogue 'niece-hello)
   :name :niece
   :angle 30))

(define-asset (sprites niece) texture-asset
    (#P"niece.png"))

(define-asset (sprites niece-profile) texture-asset
    (#p"niece-profile.png"))
