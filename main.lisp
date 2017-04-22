(in-package #:ld38)

(define-widget ld38 (QGLWidget main)
  ())

(defmethod setup-scene ((ld38 ld38))
  )

(defmethod setup-pipeline ((ld38 ld38))
  (let ((pipeline (pipeline ld38))
        (pass1 (make-instance 'per-object-pass))
        (pass2 (make-instance 'fxaa-pass)))
    (connect-pass pass1 pass2 "previousPass" pipeline)))

(defun ld38 ()
  (launch 'ld38 :application-name "LD38"))
