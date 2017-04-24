(in-package #:ld38)
(in-readtable :qtools)

(define-widget ld38 (QGLWidget main)
  ((zoom :initform 1 :accessor zoom)
   (state :initform :loading :accessor state)
   (soloud :initform (make-instance 'cl-soloud:soloud) :accessor soloud))
  (:default-initargs
    :clear-color (vec 0 0 0)))

(define-initializer (ld38 set-resolution) ()
  (q+:set-fixed-size ld38 1024 768))

(define-finalizer (ld38 clear-soloud) ()
  (cl-soloud:stop (soloud ld38)))

(define-asset (fonts default) font-asset
    (#p"forced-square.ttf"))

(define-asset (music background) audio-asset
    (#p"comfortable-mystery-4.mp3")
  :loop T)

(defmethod paint :before ((pipeline pipeline) (ld38 ld38))
  (let ((player (unit :player (scene ld38)))
        (w (width ld38)) (h (height ld38))
        (z (zoom ld38)))
    (reset-matrix)
    (gl:viewport 0 0 w h)
    (reset-matrix (view-matrix)) 
    (when player
      (when (eql :intro (state ld38))
        (setf (zoom ld38) (ease (/ (clock (scene ld38)) 5) 'flare:expo-out 500 0.5))
        (when (<= 5 (clock (scene ld38)))
          #-windows (cl-soloud:play (resource (asset 'music 'background)) (soloud ld38))
          (setf (zoom ld38) 1)
          (setf (state ld38) :play)
          (setf (state player) :walking)))
      (scale-by (/ 2 w z) (/ 2 h z) 1 (view-matrix))   
      (rotate +vz+ (/ (* PI (- (angle player) 90)) -180))
      (translate (v- (location player))))
    (when (and (eql :loading (state ld38)) (<= 1 (clock (scene ld38))))
      (issue (scene ld38) 'load-everything))))

;; This is a very inconvenient way of getting a load screen.
(defclass load-everything (event)
  ())

(define-handler (controller load-everything) (ev)
  (let* ((ld38 *context*)
         (scene (scene ld38))
         (pipeline (pipeline ld38)))
    (setf (zoom ld38) 500)
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
    (enter (make-instance 'dialogue) scene)
    ;; Pack it, sonny!
    (dolist (pass (passes pipeline))
      (for:for ((element over scene))
        (register-object-for-pass pass element)))
    (load scene)
    (load pipeline)
    (reset scene)
    (setf (state ld38) :intro)))

(defmethod setup-scene ((ld38 ld38))
  (let ((scene (scene ld38)))
    (setf (state ld38) :loading)
    (cl-soloud:stop (soloud ld38))
    (setf (cl-soloud:volume (soloud ld38)) 0.1)
    (enter (make-instance 'screen) scene)))

(defmethod setup-pipeline ((ld38 ld38))
  (let ((pipeline (pipeline ld38))
        (pass1 (make-instance 'per-object-pass)))
    (register pass1 pipeline)))

(defun ld38 ()
  (launch 'ld38 :application-name "LD38"))
