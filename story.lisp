(in-package #:ld38)

(defvar *story* NIL)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defclass story-chapter ()
    ((name :initarg :name :reader name)
     (branches :initarg :branches :reader branches)
     (dialogues :initarg :dialogues :reader dialogues))))

(defmacro define-chapter (name () dialogues branches)
  (let ((diag-table (make-hash-table)))
    (loop for (actor dialogue) in dialogues
          do (setf (gethash actor diag-table) dialogue))
    `(defclass ,name (story-chapter)
       ()
       (:default-initargs
        :name ',name
        :dialogues ,diag-table
        :branches ',branches))))

(define-chapter first-chapter ()
  ()
  ((:name chapter-2a :weight 0)
   (:name chapter-2b :weight 0)
   (:name chapter-2c :weight 0)))

(define-chapter chapter-2a ()
  ((ghost ghost-start-2)
   (pincers pincers-clicks))
  ((:name chapter-3a :weight 0)
   (:name chapter-3ab :weight 0)
   (:name chapter-3ac :weight 0)))

(define-chapter chapter-3a ()
  ((ghost ghost-start-3a))
  ())

(define-chapter chapter-3ab ()
  ((ghost ghost-start-3b))
  ())

(define-chapter chapter-3ac ()
  ((ghost ghost-start-3ac))
  ())

(define-chapter chapter-2b ()
  ((ghost ghost-start-2b)
   (pincers pincers-clicks))
  ((:name chapter-3ba :weight 0)
   (:name chapter-3b :weight 0)
   (:name chapter-3bc :weight 0)))

(define-chapter chapter-3ba ()
  ((ghost ghost-start-3ba))
  ())

(define-chapter chapter-3b ()
  ((ghost ghost-start-3b))
  ())

(define-chapter chapter-3bc ()
  ((ghost ghost-start-3bc))
  ())

(defun story-current-chapter ()
  (getf *story* :chapter))

(defun story-next-chapter ()
  (loop for branch in (branches (story-current-chapter))
        for weight = (getf branch :weight 0)
        with next-branch = NIL
        maximizing (getf branch :weight 0) into max-weight
        when (or (null next-branch) (< (getf next-branch :weight 0) weight))
        do (setf next-branch branch)
        finally (return next-branch)))

(defun story-change-chapter ()
  (let ((chapter (story-next-chapter)))
    (loop for actor-name in (alexandria:hash-table-keys (dialogues chapter))
          for actor = (unit actor-name (scene *context*))
          do (setf (dialogue actor) (gethash actor-name (dialogues chapter))))
    (setf (getf *story* :chapter) chapter)))

(defun story-weight-branch (branch-number &optional (delta 1))
  (incf (getf (nth branch-number (branches (story-current-chapter))) :weight) delta))

(defun initialize-story ()
  (setf (getf *story* :chapter) (make-instance 'first-chapter)))
