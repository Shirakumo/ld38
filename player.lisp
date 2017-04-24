(in-package #:ld38)

(define-shader-subject player (world-entity sprite)
  ((velocity :initform 0 :accessor velocity)
   (state :initform :talking :accessor state)
   (profile :initarg :profile :accessor profile)
   (text :initform (make-instance 'text :text "Talk") :accessor text)
   (animation :initform -1 :accessor animation)
   (start-clock :initform 0.0 :accessor start-clock))
  (:default-initargs
   :texture (asset 'sprites 'player-idle)
   :name :player
   :location (vec 0 0 1)
   :profile (asset 'sprites 'player-profile)
   :angle 90
   :radius 1988
   :direction :left))

(defmethod load progn ((player player))
  (load (text player))
  (load (asset 'sprites 'player-walking))
  (load (asset 'sprites 'player-idle))
  (load (asset 'sprites 'player-profile))
  (inc-anim player 0 0.0))

(defmethod offload progn ((player player))
  (offload (text player)))

(defmethod register-object-for-pass :after (pass (player player))
  (register-object-for-pass pass (text player)))

(define-asset (sprites player-idle) texture-asset
    (#p"colleen-idle.png"))
(define-asset (sprites player-walking) texture-asset
    (#p"colleen-walking.png"))
(define-asset (sprites player-profile) texture-asset
    (#p"colleen-profile.png"))

(defun inc-anim (player animation clock)
  (destructuring-bind (frames duration sprite) (nth animation
                                                    '((20 2 player-idle)
                                                      (20 1.08 player-walking)
                                                      (20 0.6 player-walking)))
    (cond ((= (animation player) animation)
           (let ((in-frame-clock (/ (mod (- clock (start-clock player)) duration) duration)))
             (setf (frame-index player) (- frames (floor (* in-frame-clock frames)) 1))))
          (T
           (setf (animation player) animation)
           (setf (frame-index player) 0)
           (setf (frame-count player) frames)
           (setf (texture player) (asset 'sprites sprite))
           (setf (start-clock player) clock)))))

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
       (cond ((or (retained 'movement :left)
                  (retained 'movement :right))
              (if (retained 'movement :run)
                  (inc-anim player 2 (clock *loop*))
                  (inc-anim player 1 (clock *loop*))))
             (T
              (inc-anim player 0 (clock *loop*))))
       (incf (angle player) (velocity player))))))

(define-handler (player gameover) (ev)
  (setf (state player) :nothing))

(defmethod paint :after ((player player) target)
  (case (state player)
    (:walking
     (for:for ((entity over (scene *context*)))
       (when (and (typep entity 'world-character)
                  (<= (abs (- (angle entity) (angle player))) 1)
                  (dialogue entity))
         (translate-by -20 60 -1)
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
