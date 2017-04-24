(in-package #:ld38)

(define-widget ld38 (QGLWidget main fullscreenable)
  ((zoom :initform 1 :accessor zoom)
   (started :initform NIL :accessor started)
   (soloud :initform (make-instance 'cl-soloud:soloud) :accessor soloud))
  (:default-initargs
    :resolution (list 1024 768)
    :clear-color (vec 0 0 0)))

(define-finalizer (ld38 clear-soloud) ()
  (cl-soloud:stop (soloud ld38))
  (cl-soloud:free (soloud ld38)))

(define-asset (fonts default) font-asset
    (#p"forced-square.ttf"))

(define-asset (music background) audio-asset
    (#p"comfortable-mystery-4.mp3")
  :loop T)

(defmethod paint :before ((pipeline pipeline) (ld38 ld38))
  (let ((player (unit :player (scene ld38))))
    (unless (started ld38)
      (setf (zoom ld38) (ease (/ (clock (scene ld38)) 5) 'flare:expo-out 500 0.5))
      (when (<= 5 (clock (scene ld38)))
        (cl-soloud:play (resource (asset 'music 'background)) (soloud ld38))
        (setf (zoom ld38) 1)
        (setf (started ld38) T)
        (setf (state player) :walking)))
    (let ((w (width ld38)) (h (height ld38))
          (z (zoom ld38)))
      (reset-matrix)
      (gl:viewport 0 0 w h)
      (reset-matrix (view-matrix))
      (scale-by (/ 2 w z) (/ 2 h z) 1 (view-matrix))
      (when player
        (rotate +vz+ (/ (* PI (- (angle player) 90)) -180))
        (translate (v- (location player)))))))

(progn
  (defmethod setup-scene ((ld38 ld38))
    (let ((scene (scene ld38)))
      (setf (started ld38) NIL)
      (cl-soloud:stop (soloud ld38))
      (setf (cl-soloud:volume (soloud ld38)) 0.1)
      (load (asset 'music 'background))
      ;; Must be first
      (initialize-story)
      (for:for ((npc in '(ghost pincers businessman farmer niece)))
        (enter (make-instance npc) scene))
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
