(in-package #:ld38)

(define-shader-subject player (world-entity sprite)
  ((velocity :initform 0 :accessor velocity))
  (:default-initargs
   :texture (asset 'sprites 'player)
   :name :player
   :location (vec 0 2048 0)))

(define-asset (sprites player) texture-asset
    (#p"whatever.png"))

(define-action movement ())

(define-action start-left (movement)
  (key-press (one-of key :a :left))
  (gamepad-press (eql button :dpad-left))
  (gamepad-move (one-of axis :left-h :dpad-h) (< pos -0.2 old-pos)))

(define-action start-right (movement)
  (key-press (one-of key :d :right))
  (gamepad-press (eql button :dpad-right))
  (gamepad-move (one-of axis :left-h :dpad-h) (< old-pos 0.2 pos)))

(define-action stop-left (movement)
  (key-release (one-of key :a :left))
  (gamepad-release (eql button :dpad-left))
  (gamepad-move (one-of axis :left-h :dpad-h) (< old-pos -0.2 pos)))

(define-action stop-right (movement)
  (key-release (one-of key :d :right))
  (gamepad-release (eql button :dpad-right))
  (gamepad-move (one-of axis :left-h :dpad-h) (< pos 0.2 old-pos)))

(define-action perform (player-action)
  (key-press (one-of key :e :space))
  (gamepad-press (eql button :a)))

(define-retention movement (ev)
  (typecase ev
    (start-left (setf (retained 'movement :left) T))
    (start-right (setf (retained 'movement :right) T))
    (stop-left (setf (retained 'movement :left) NIL))
    (stop-right (setf (retained 'movement :right) NIL))))

(define-handler (player tick) (ev)
  (setf (velocity player)
        (cond ((retained 'movement :left)   1)
              ((retained 'movement :right) -1)
              (T 0)))

  (incf (angle player) (velocity player)))

(define-handler (player perform) (ev)
  )
