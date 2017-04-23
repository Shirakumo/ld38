(in-package #:ld38)

(defvar *story* NIL)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass story-chapter ()
    ((name :initarg :name :reader name)
     (goals :initarg :goals :reader goals)
     (endings :initarg :endings :reader endings)
     (branches :initarg :branches :reader branches)
     (dialogues :initarg :dialogues :reader dialogues))))

(defmethod meet-goal ((chapter story-chapter)))

(defmethod ending-p ((chapter story-chapter) ending)
  (find ending (endings chapter)))

(defmacro define-chapter (name (goals) endings dialogues branches)
  (let ((diag-table (make-hash-table)))
    (loop for (actor dialogue) in dialogues
          do (setf (gethash actor diag-table) dialogue))
    `(defclass ,name (story-chapter)
       ()
       (:default-initargs
        :name ',name
        :goals ,goals
        :endings ',endings
        :dialogues ,diag-table
        :branches ',branches))))

(define-chapter first-chapter (4)
  () ()
  ((chapter-2a 0)
   (chapter-2b 0)
   (chapter-2c 0)))

(define-chapter chapter-2a (3)
  (businessman farmer niece all)
  ((:ghost ghost-start-2)
   (:pincers pincers-clicks))
  ((chapter-3a 0)
   (chapter-3ab 0)
   (chapter-3ac 0)))

(define-chapter chapter-3a (1)
  (businessman)
  ((:ghost ghost-good-ending))
  ())

(define-chapter chapter-3ab (1)
  (farmer)
  ((:ghost ghost-good-ending))
  ())

(define-chapter chapter-3ac (1)
  (niece)
  ((:ghost ghost-good-ending))
  ())

(define-chapter chapter-2b (1)
  (businessman farmer niece crab)
  ((:ghost ghost-start-2)
   (:pincers pincers-clicks))
  ((chapter-3ba 0)
   (chapter-3b 0)
   (chapter-3bc 0)))

(define-chapter chapter-3ba (1)
  (businessman)
  ((:ghost ghost-good-ending))
  ())

(define-chapter chapter-3b (1)
  (farmer)
  ((:ghost ghost-good-ending))
  ())

(define-chapter chapter-3bc (1)
  (niece)
  ((:ghost ghost-good-ending))
  ())

(define-chapter chapter-2c (3)
  (crab all suicide)
  ((:ghost ghost-start-2))
  (chapter-3))

(define-chapter bad-ending (1)
  ()
  ((:ghost ghost-bad-ending))
  ())

(defun story-current-chapter ()
  (getf *story* :chapter))

(defun story-next-chapter ()
  (loop for branch in (branches (story-current-chapter))
        for weight = (or (second branch) 0)
        with next-branch = NIL
        maximizing weight into max-weight
        when (or (null next-branch) (< (or (second next-branch) 0) weight))
        do (setf next-branch branch)
        finally (return (first next-branch))))

(defun story-set-chapter (chapter)
  (loop for actor-name in (alexandria:hash-table-keys (dialogues chapter))
        for actor = (unit actor-name (scene *context*))
        do (setf (dialogue actor) (gethash actor-name (dialogues chapter))))
  (setf (getf *story* :chapter) (make-instance chapter)
        (getf *story* :progress) 0))

(defun story-change-chapter ()
  (let ((chapter (story-next-chapter)))
    (story-set-chapter chapter)))

(defun story-attempt-ending (ending)
  (let ((ending-p (ending-p (story-current-chapter) ending)))
    (if ending-p (story-set-chapter (story-ending ending)) (story-bad-ending))
    ending-p))

(defun story-check-ending (ending)
  (ending-p (story-current-chapter) ending))

(defun story-set-ending (ending)
  (story-set-chapter (ecase ending
                       (businessman 'businessman-ending)
                       (farmer 'farmer-ending)
                       (niece 'niece-ending)
                       (crab 'crab-ending)
                       (all 'all-ending)
                       (suicide 'suicide-ending)
                       (bad 'bad-ending))))

(defun story-bad-ending ()
  (story-set-chapter 'bad-ending))

(defun story-weight-branch (branch-number delta)
  (unless (typep branch-number 'number)
    (setf branch-number (parse-integer (format NIL "~a" branch-number))))
  (unless (and delta (typep delta 'number))
    (setf delta (parse-integer (format NIL "~a" delta))))
  (incf (cadr (nth branch-number (branches (story-current-chapter)))) (or delta 1)))

(defun story-inc-goal (delta)
  (incf (getf *story* :progress) (or delta 1))
  (let ((chapter (story-current-chapter)))
    (when (<= (goal chapter) (getf *story* :progress))
      (meet-goal chapter))))

(defun initialize-story ()
  (setf (getf *story* :chapter) (make-instance 'first-chapter)
        (getf *story* :progress) 0))
