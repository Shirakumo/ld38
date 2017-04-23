(in-package #:ld38)

(defvar *story* NIL)

(defun initialize-story ()
  (setf (getf *story* :phase) :start))
