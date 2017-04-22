(in-package #:ld38)

(define-widget ld38 (QGLWidget main fullscreenable)
  ()
  (:default-initargs
    :resolution (list 800 600)
    :clear-color (vec 0.0 0.0 0.0)))

(defmethod paint :before ((pipeline pipeline) (ld38 ld38))
  (gl:viewport 0 0 800 600)
  (reset-matrix (view-matrix))
  (scale-by 1/800 1/600 1 (view-matrix))
  (let ((player (unit :player (scene ld38))))
    (when player
      (translate (v- (location player)) (view-matrix)))))

(progn
  (defmethod setup-scene ((ld38 ld38))
    (let ((scene (scene ld38)))
      (enter (make-instance 'player) scene)
      (enter (make-instance 'world) scene)))
  (maybe-reload-scene))

(progn
  (defmethod setup-pipeline ((ld38 ld38))
    (let ((pipeline (pipeline ld38))
          (pass1 (make-instance 'per-object-pass))
          ;; (pass2 (make-instance 'fxaa-pass))
          )
      (register pass1 pipeline)
      ;; (connect-pass pass1 pass2 "previousPass" pipeline)
      ))
  (maybe-reload-scene))

(defun ld38 ()
  (launch 'ld38 :application-name "LD38"))
