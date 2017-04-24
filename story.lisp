(in-package #:ld38)

(defvar *story* NIL)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass story-chapter ()
    ((name :initarg :name :reader name)
     (goal :initarg :goal :reader goal)
     (dialogues :initarg :dialogues :reader dialogues))))

(defmethod meet-goal ((chapter story-chapter)))

(defmethod start-chapter ((chapter story-chapter)))

(defmacro define-chapter (name (goal) dialogues)
`(defclass ,name (story-chapter)
   ()
   (:default-initargs
    :name ',name
    :goal ,goal
    :dialogues ',dialogues)))

(define-chapter chapter-1 (4)
  ())

(defmethod meet-goal ((chapter chapter-1))
  (let ((ghost (unit :ghost (scene *context*))))
    (setf (dialogue ghost) (dialogue 'ghost-progress-1))))

(define-chapter chapter-2 (3)
  ((:ghost ghost-start-2)))

(defmethod meet-goal ((chapter chapter-2))
  (let ((ghost (unit :ghost (scene *context*))))
    (setf (dialogue ghost) (dialogue 'ghost-progress-2))))

(defmethod start-chapter ((chapter chapter-2))
  (let ((b-man (unit :businessman (scene *context*)))
        (farmer (unit :farmer (scene *context*)))
        (niece (unit :niece (scene *context*)))
        (crab (unit :crab (scene *context*))))
    (setf (dialogue b-man) (dialogue (if (story-flag-p 'businessman)
                                         'businessman-suspect
                                         'businessman-innocent))
          (dialogue farmer) (dialogue (if (story-flag-p 'farmer)
                                          'farmer-suspect
                                          'farmer-innocent))
          (dialogue niece) (dialogue (if (story-flag-p 'niece)
                                         'niece-suspect
                                         'niece-innocent))
          (dialogue crab) (dialogue (if (story-flag-p 'crab)
                                        'crab-suspect
                                        'crab-innocent))))
  (unless (story-flag-p 'businessman)
    (story-disable-ending 'businessman))
  (unless (story-flag-p 'farmer)
    (story-disable-ending 'farmer))
  (unless (story-flag-p 'niece)
    (story-disable-ending 'niece))
  (unless (story-flag-p 'crab)
    (story-disable-ending 'crab))
  (unless (or (story-flag-p 'businessman)
              (story-flag-p 'farmer)
              (story-flag-p 'niece))
    (story-disable-ending 'suicide))
  (unless (and (story-flag-p 'businessman)
               (story-flag-p 'farmer)
               (story-flag-p 'niece))
    (story-disable-ending 'all)))

(define-chapter chapter-3 (1)
  ((:ghost ghost-idle-3)))

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
    (start-chapter chapter)
    (setf (getf *story* :chapter) chapter
          (getf *story* :progress) 0
          (getf *story* :flags) NIL)
    chapter))

(defun story-disable-ending (ending &key others)
  (cond
    (others
     (loop for (end . NIL) in (getf *story* :endings)
           when (not (eql end ending)) collect end))
    ((story-ending-p ending)
     (append (list ending) (getf *story* :disabled-endings)))))

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

(defun story-flag-p (flag)
  (when (find flag (getf *story* :flags))))

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
