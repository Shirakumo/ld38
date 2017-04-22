(in-package #:ld38)

(define-shader-subject player (world-entity sprite)
  ((velocity :initform 0 :accessor velocity))
  (:default-initargs
   :texture (asset 'sprites 'player)
   :name :player))

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

(define-action perform (movement)
  (key-press (one-of key :e :space))
  (gamepad-press (eql button :a)))

(define-action start-run (movement)
  (key-press (one-of key :shift))
  (gamepad-press (one-of button :r1 :l1)))

(define-action stop-run (movement)
  (key-release (one-of key :shift))
  (gamepad-release (one-of button :r1 :l1)))

(define-retention movement (ev)
  (typecase ev
    (start-left (setf (retained 'movement :left) T))
    (start-right (setf (retained 'movement :right) T))
    (stop-left (setf (retained 'movement :left) NIL))
    (stop-right (setf (retained 'movement :right) NIL))
    (start-run (setf (retained 'movement :run) T))
    (stop-run (setf (retained 'movement :run) NIL))))

(define-handler (player tick) (ev)
  (let ((vel (if (retained 'movement :run)
                 0.6 0.2)))
    (cond ((retained 'movement :left)  (incf (angle player) vel))
          ((retained 'movement :right) (decf (angle player) vel)))))

(define-handler (player perform) (ev)
  )
