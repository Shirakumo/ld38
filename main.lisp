(in-package #:ld38)

(define-widget ld38 (QGLWidget main fullscreenable)
  ((zoom :initform 1 :accessor zoom))
  (:default-initargs
    :resolution (list 1024 768)
    :clear-color (vec 0 0 0)))

(define-asset (fonts default) font-asset
    (#p"forced-square.ttf"))

(defmethod paint :before ((pipeline pipeline) (ld38 ld38))
  (when (<= (clock (scene ld38)) 5)
    (setf (zoom ld38) (ease (/ (clock (scene ld38)) 5) 'flare:expo-out 100 0.9)))
  (let ((w (width ld38)) (h (height ld38))
        (z (zoom ld38)))
    (reset-matrix)
    (gl:viewport 0 0 w h)
    (reset-matrix (view-matrix))
    (scale-by (/ 2 w z) (/ 2 h z) 1 (view-matrix))
    (let ((player (unit :player (scene ld38))))
      (when player
        (rotate +vz+ (/ (* PI (- (angle player) 90)) -180))
        (translate (v- (location player)))))))

(progn
  (defmethod setup-scene ((ld38 ld38))
    (let ((scene (scene ld38)))
      (enter (make-instance 'ghost) scene)
      (enter (make-instance 'cheery) scene)
      (enter (make-instance 'janitor) scene)
      (enter (make-instance 'attorney) scene)
      (enter (make-instance 'pincers) scene)
      (enter (make-instance 'player) scene)
      (dotimes (i 5)
        (enter (make-instance 'chicken :angle (+ 300 (random 10))
                                       :location (vec 0 0 (- 0.9 (/ i 40)))) scene))
      (enter (make-instance 'world) scene)
      ;; Must be last!
      (enter (make-instance 'dialogue) scene)))
  (maybe-reload-scene))

(progn
  (defmethod setup-pipeline ((ld38 ld38))
    (let ((pipeline (pipeline ld38))
          (pass1 (make-instance 'per-object-pass)))
      (register pass1 pipeline)))
  (maybe-reload-scene))

(defun ld38 ()
  (launch 'ld38 :application-name "LD38"))
