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
   (text :initform (make-instance 'text :text "" :font (asset 'fonts 'dialogue)) :accessor text)
   (diag-stack :initform NIL :accessor diag-stack)
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
  (setf (diag-stack dialogue) (list (dialogue (entity ev))))
  (diag-process-actions dialogue))

(defun diag-current (dialogue)
  (first (first (diag-stack dialogue))))

(defun diag-advance (dialogue)
  (case (first (diag-current dialogue))
    (choice
     (let ((choice (pop (first (diag-stack dialogue)))))
       (push (rest (nth (1+ (choice dialogue)) choice))
             (diag-stack dialogue))
       (setf (choice dialogue) 0)))
    (T
     (pop (first (diag-stack dialogue)))
     (unless (first (diag-stack dialogue))
       (pop (diag-stack dialogue))))))

(defun diag-process-actions (dialogue)
  (loop (let* ((current (diag-current dialogue)))
          (ecase (first current)
            ((end NIL)
             (issue *loop* 'end-dialogue)
             (return))
            ((say choice)
             (return))
            (mood ;; FIXME: Update mood
             (diag-advance dialogue))
            (affect
             (case (second current)
               (goal (story-inc-goal (third current)))
               (ending (story-disable-ending (third current)
                                             :others (eql 'others (fourth current)))))
             (diag-advance dialogue))
            (try
             (case (second current)
               (ending (unless (story-ending-p (third current)) (story-bad-ending))))
             (diag-advance dialogue))
            (accuse
             (setf (first (diag-stack dialogue))
                   (dialogue (if (story-attempt-ending (second current))
                                 (third current) (fourth current)))))
            (change
             (case (second current)
               (dialogue (setf (dialogue (partner dialogue))
                               (dialogue (third current))))
               (chapter (story-change-chapter))) ;; This changes the partner's dialogue
             (diag-advance dialogue))
            (jump
             (setf (first (diag-stack dialogue))
                   (dialogue (second current))))))))

(define-handler (dialogue advance-dialogue advance-dialogue 10) (ev)
  (when (partner dialogue)
    (diag-advance dialogue)
    (diag-process-actions dialogue)))

(define-handler (dialogue next-choice) (ev)
  (let ((diag (diag-current dialogue)))
    (when (eql 'choice (first diag))
      (setf (choice dialogue) (mod (1+ (choice dialogue)) (length (rest diag)))))))

(define-handler (dialogue prev-choice) (ev)
  (let ((diag (diag-current dialogue)))
    (when (eql 'choice (first diag))
      (setf (choice dialogue) (mod (1- (choice dialogue)) (length (rest diag)))))))

(define-handler (dialogue end-dialogue) (ev)
  (setf (partner dialogue) NIL))

(defmethod paint :around ((dialogue dialogue) target)
  (let ((partner (partner dialogue))
        (text (text dialogue))
        (diag (diag-current dialogue)))
    (when partner
      (with-pushed-matrix
        (reset-matrix)
        (translate-by 0 0 -3)
        (case (first diag)
          (choice
           (with-pushed-matrix
             (translate-by -270 120 0)
             (rotate +vy+ PI)
             (setf (texture dialogue) (profile (unit :player (scene *context*))))
             (call-next-method))
           (with-pushed-matrix
             (rotate +vy+ PI)
             (setf (texture dialogue) (asset 'sprites 'textbox))
             (call-next-method))
           (with-pushed-matrix
             (translate-by 180 -75 0)
             (setf (text text) "YOU")
             (setf (color text) (vec 0 0 0))
             (paint text target))
           (with-pushed-matrix
             (translate-by -420 -140 -1)
             (loop for choice in (cdr diag)
                   for i from 0
                   do (setf (color text)
                            (if (= i (choice dialogue))
                                (vec 1 1 1)
                                (vec 0.7 0.7 0.7)))
                      (setf (text text) (first choice))
                      (paint text target)
                      (translate-by 0 -40 0))))
          (say
           (with-pushed-matrix
             (translate-by 280 120 0)
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
             (setf (text text) (break-lines (format NIL (second diag))))
             (setf (color text) (vec 1 1 1))
             (paint text target))))))))

(defun break-lines (text &optional (limit 50))
  ;; FIXME: This does unnecessary line-breaks if the given text already has line-breaks in it
  (if (<= (length text) limit)
      text
      (let ((pos (position #\  text :from-end T :end limit)))
        (format NIL "~a~%~a"
                (subseq text 0 pos) (break-lines (subseq text (1+ pos)))))))
