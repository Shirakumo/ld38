(in-package #:ld38)

(defvar *story* NIL)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass story-chapter ()
    ((name :initarg :name :reader name)
     (dialogues :initarg :dialogues :reader dialogues))))

(defmethod meet-goal ((chapter story-chapter)))

(defmacro define-chapter (name (goal) dialogues)
`(defclass ,name (story-chapter)
   ()
   (:default-initargs
    :name ',name
    :dialogues ',dialogues)))

(define-chapter chapter-1 (4)
  ())

(defmethod meet-goal ((chapter chapter-1))
  (let ((ghost (unit :ghost (scene *context*))))
    (setf (dialogue ghost) (dialogue 'ghost-progress-1))))

(define-chapter chapter-2 (3)
  ((:ghost ghost-start-2)
   (:pincers pincers-clicks)
   (:businessman businessman-suspect-1)))

(defmethod meet-goal ((chapter chapter-2))
  (let ((ghost (unit :ghost (scene *context*))))
    (setf (dialogue ghost) (dialogue 'ghost-progress-2))))

(define-chapter chapter-3 (1)
  ((:ghost ghost-idle-3)
   (:businessman businessman-suspect-2)))

(define-chapter good-ending (0)
  ((:ghost ghost-good-ending)))

(define-chapter bad-ending (1)
  ((:ghost ghost-bad-ending)))

(defun story-current-chapter ()
  (getf *story* :chapter))

(defun story-next-chapter ()
  (ecase (name (story-current-chapter))
    (chapter-1 (story-set-chapter 'chapter-2))
    (chapter-2 (story-set-chapter 'chapter-3))))

(defun story-set-chapter (chapter)
  (let ((chapter (if (typep chapter 'symbol) (make-instance chapter) chapter)))
    (loop for (actor-name dialogue) in (dialogues chapter)
          for actor = (unit actor-name (scene *context*))
          do (setf (dialogue actor) (dialogue dialogue)))
    (setf (getf *story* :chapter) chapter
          (getf *story* :progress) 0)
    chapter))

(defun story-disable-ending (ending &key others)
  (setf (getf *story* :disabled-endings)
        (if others
            (loop for (ending . NIL) in (getf *story* :endings)
                  collecting ending)
            (append ending (getf *story* :disabled-endings)))))

(defun story-change-chapter ()
  (let ((chapter (story-next-chapter)))
    (setf (getf *story* :flags) NIL)
    (story-set-chapter chapter)))

(defun story-attempt-ending (ending)
  (story-set-chapter
   (ecase (if (story-ending-p ending) ending 'bad)
     (businessman 'businessman-ending)
     (farmer 'farmer-ending)
     (niece 'niece-ending)
     (crab 'crab-ending)
     (all 'all-ending)
     (suicide 'suicide-ending)
     (bad 'bad-ending))))

(defun story-ending-p (ending)
  (not (find ending (getf *story* :disabled-endings))))

(defun story-valid-endings ()
  (loop for ending in (getf *story* :endings)
        when (story-ending-p ending) collect ending))

(defun story-trigger-ending ()
  (let ((valid (story-valid-endings)))
    (if (= 1 (length valid))
        (story-attempt-ending (first valid))
        (story-attempt-ending 'bad))))

(defun story-inc-goal (delta)
  (unless (typep delta 'number)
    (setf delta (parse-integer (format NIL "~a" delta) :junk-allowed T)))
  (let ((delta (or (when (typep delta 'number) delta) 1)))
    (incf (getf *story* :progress) delta))
  (let ((chapter (story-current-chapter)))
    (when (<= (goal chapter) (getf *story* :progress))
      (meet-goal chapter))))

(defun story-trigger-flag (flag)
  (unless (story-flag-p flag)
    (setf (getf *story* :flags) (append (getf *story* :flags) (list flag)))))

(defun story-flag-p (wanted-flag)
  (when (find flag (getf *story* flags))))

(defun initialize-story ()
  (setf (getf *story* :chapter) (make-instance 'chapter-1)
        (getf *story* :endings) '((businessman . businessman-ending)
                                  (farmer . farmer-ending)
                                  (niece . niece-ending)
                                  (crab . crab-ending)
                                  (all . all-ending)
                                  (suicide . suicide-ending)
                                  (bad . bad-ending))
        (getf *story* :disabled-endings) ()
        (getf *story* :flags) NIL
        (getf *story* :progress) 0))
