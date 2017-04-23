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
  :size 30)

(define-asset (sprites textbox) texture-asset
    (#p"textbox.png"))

(define-shader-subject dialogue (sprite)
  ((partner :initform NIL :accessor partner)
   (text :initform (make-instance 'text :text "AAAAAAA" :font (asset 'fonts 'dialogue)) :accessor text)
   (dialogue :initform NIL :accessor dialogue)
   (choice :initform 0 :accessor choice))
  (:default-initargs
   :texture (asset 'sprites 'textbox)))

(defmethod load progn ((dialogue dialogue))
  (load (text dialogue)))

(defmethod offload progn ((dialogue dialogue))
  (offload (text dialogue)))

(defmethod register-object-for-pass :after (pass (dialogue dialogue))
  (register-object-for-pass pass (text dialogue)))

(define-handler (dialogue start-dialogue) (ev)
  (setf (partner dialogue) (entity ev))
  (setf (dialogue dialogue)
        (dialogue-next (dialogue (dialogue (entity ev))))))

(define-handler (dialogue advance-dialogue advance-dialogue 10) (ev)
  (when (partner dialogue)
    (setf (dialogue dialogue) (if (getf (dialogue dialogue) :choice)
                                  (dialogue-next (dialogue dialogue) (choice dialogue))
                                  (dialogue-next (dialogue dialogue))))
    (unless (dialogue dialogue)
      (issue *loop* 'end-dialogue))))

(define-handler (dialogue next-choice) (ev)
  (let ((choice (getf (dialogue dialogue) :choice)))
    (when choice
      (setf (choice dialogue) (mod (1+ (choice dialogue)) (length choice))))))

(define-handler (dialogue prev-choice) (ev)
  (let ((choice (getf (dialogue dialogue) :choice)))
    (when choice
      (setf (choice dialogue) (mod (1- (choice dialogue)) (length choice))))))

(define-handler (dialogue end-dialogue) (ev)
  (setf (partner dialogue) NIL))

(defmethod paint :around ((dialogue dialogue) target)
  (let ((partner (partner dialogue))
        (text (text dialogue))
        (diag (dialogue dialogue)))
    (when partner
      (with-pushed-matrix
        (reset-matrix)
        (translate-by 0 0 -1)
        (with-pushed-matrix
          (translate-by 300 50 0)
          (setf (texture dialogue) (profile partner))
          (call-next-method))
        (with-pushed-matrix
          (setf (texture dialogue) (asset 'sprites 'textbox))
          (call-next-method))
        (with-pushed-matrix
          (translate-by -440 -75 0)
          (setf (text text) (string (name partner)))
          (setf (color text) (vec 0 0 0))
          (paint text target))
        (with-pushed-matrix
          (translate-by -460 -140 -1)
          (setf (color text) (vec 1 1 1))
          (cond ((getf diag :choice)
                 (loop for choice in (getf diag :choice)
                       for i from 0
                       do (setf (color text)
                                (if (= i (choice dialogue))
                                    (vec 1 1 1)
                                    (vec 0.7 0.7 0.7)))
                          (setf (text text) (getf choice :text))
                          (paint text target)
                          (translate-by 0 -40 0)))
                ((getf diag :text)
                 (setf (text text) (getf diag :text))
                 (paint text target))))))))
