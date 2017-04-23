(in-package #:ld38)

(defclass start-dialogue (event)
  ((entity :initarg :entity :accessor entity)))

(defclass end-dialogue (event)
  ((entity :initarg :entity :accessor entity)))

(define-action advance-dialogue ()
  (key-press (one-of key :e :space :enter))
  (gamepad-press (eql button :a)))

(define-action next-choice ()
  (key-press (one-of key :s :down))
  (gamepad-press (eql button :dpad-down))
  (gamepad-move (one-of axis :left-v :dpad-v) (< pos -0.2 old-pos)))

(define-action prev-choice ()
  (key-press (one-of key :w :up))
  (gamepad-press (eql button :dpad-up))
  (gamepad-move (one-of axis :left-v :dpad-v) (< pos 0.2 old-pos)))

(define-asset (fonts dialogue) font-asset
    (#p"forced-square.ttf")
  :size 50)

(define-asset (sprites textbox) texture-asset
    (#p"textbox.png"))

(define-shader-subject dialogue (sprite)
  ((partner :initform NIL :accessor partner)
   (text :initform (make-instance 'text :text "AAAAAAA" :font (asset 'fonts 'dialogue)) :accessor text))
  (:default-initargs
   :texture (asset 'sprites 'textbox)))

(defmethod load progn ((dialogue dialogue))
  (load (text dialogue)))

(defmethod offload progn ((dialogue dialogue))
  (offload (text dialogue)))

(defmethod register-object-for-pass :after (pass (dialogue dialogue))
  (register-object-for-pass pass (text dialogue)))

(define-handler (dialogue start-dialogue) (ev)
  (setf (partner dialogue) (entity ev)))

(define-handler (dialogue advance-dialogue advance-dialogue 10) (ev)
  (when (partner dialogue)
    (issue *loop* 'end-dialogue)))

(define-handler (dialogue next-choice) (ev)
  )

(define-handler (dialogue prev-choice) (ev)
  )

(define-handler (dialogue end-dialogue) (ev)
  (setf (partner dialogue) NIL))

(defmethod paint :around ((dialogue dialogue) target)
  (when (partner dialogue)
    (with-pushed-matrix
      (reset-matrix)
      (translate-by 0 0 -1)
      (with-pushed-matrix
        (translate-by 300 50 0)
        (setf (texture dialogue) (profile (partner dialogue)))
        (call-next-method))
      (with-pushed-matrix
        (setf (texture dialogue) (asset 'sprites 'textbox))
        (call-next-method))
      (with-pushed-matrix
        (translate-by -460 -130 0)
        (paint (text dialogue) target)))))
