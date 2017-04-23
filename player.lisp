(in-package #:ld38)

(define-shader-subject player (world-entity sprite)
  ((velocity :initform 0 :accessor velocity)
   (state :initform :walking :accessor state)
   (text :initform (make-instance 'text :text "Talk") :accessor text))
  (:default-initargs
   :texture (asset 'sprites 'player)
   :name :player
   :location (vec 0 0 1)
   :angle 90))

(defmethod load progn ((player player))
  (load (text player)))

(defmethod offload progn ((player player))
  (offload (text player)))

(defmethod register-object-for-pass :after (pass (player player))
  (register-object-for-pass pass (text player)))

(define-asset (sprites player) texture-asset
    (#p"player.png"))

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

(define-action start-run (movement)
  (key-press (one-of key :shift))
  (gamepad-press (one-of button :r1 :l1)))

(define-action stop-run (movement)
  (key-release (one-of key :shift))
  (gamepad-release (one-of button :r1 :l1)))

(define-action perform (movement)
  (key-press (one-of key :e :space))
  (gamepad-press (eql button :a)))

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
    (case (state player)
      (:walking
       (cond ((retained 'movement :left)
              (setf (velocity player) vel)
              (setf (direction player) :left))
             ((retained 'movement :right)
              (setf (velocity player) (- vel))
              (setf (direction player) :right))
             (T (setf (velocity player) 0)))
       (incf (angle player) (velocity player))))))

(defmethod paint :after ((player player) target)
  (case (state player)
    (:walking
     (for:for ((entity over (scene *context*)))
       (when (and (typep entity 'world-character)
                  (<= (abs (- (angle entity) (angle player))) 1)
                  (dialogue entity))
         (translate-by -20 20 -1)
         (paint (text player) target))))))

(define-handler (player perform) (ev)
  (case (state player)
    (:walking
     (for:for ((entity over (scene *context*)))
       (when (and (typep entity 'world-character)
                  (<= (abs (- (angle entity) (angle player))) 1)
                  (dialogue entity))
         (setf (state player) :talking)
         (issue *loop* 'start-dialogue :entity entity))))))

(define-handler (player end-dialogue end-dialogue -100) (ev)
  (setf (state player) :walking))
