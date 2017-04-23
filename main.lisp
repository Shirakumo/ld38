(in-package #:ld38)

(define-widget ld38 (QGLWidget main fullscreenable)
  ()
  (:default-initargs
    :resolution (list 1024 768)
    :clear-color (vec 0 0 0)))

(define-asset (fonts default) font-asset
    (#p"forced-square.ttf"))

(defmethod paint :before ((pipeline pipeline) (ld38 ld38))
  (let ((w (width ld38)) (h (height ld38)))
    (reset-matrix)
    (gl:viewport 0 0 w h)
    (reset-matrix (view-matrix))
    (scale-by (/ 2 w) (/ 2 h) 1 (view-matrix))
    (let ((player (unit :player (scene ld38))))
      (when player
        (rotate +vz+ (/ (* PI (- (angle player) 90)) -180) (view-matrix))
        (translate (v- (location player)) (view-matrix))))))

(progn
  (defmethod setup-scene ((ld38 ld38))
    (let ((scene (scene ld38)))
      (enter (make-instance 'cheery) scene)
      (enter (make-instance 'janitor) scene)
      (enter (make-instance 'attorney) scene)
      (enter (make-instance 'pincers) scene)
      (enter (make-instance 'player) scene)
      (enter (make-instance 'world) scene)))
  (maybe-reload-scene))

(progn
  (defmethod setup-pipeline ((ld38 ld38))
    (let ((pipeline (pipeline ld38))
          (pass1 (make-instance 'per-object-pass))
          (pass2 (make-instance 'fxaa-pass)))
      (connect-pass pass1 pass2 "previousPass" pipeline)))
  (maybe-reload-scene))

(defun ld38 ()
  (launch 'ld38 :application-name "LD38"))
