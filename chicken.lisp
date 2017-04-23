(in-package #:ld38)

(define-asset (sprites chicken) texture-asset
    (#p"chicken.png"))

(define-shader-subject chicken (world-entity sprite)
  ((state :initform :walking :accessor state))
  (:default-initargs
   :texture (asset 'sprites 'chicken)
   :location (vec 0 0 0.5)
   :angle 250))

(define-handler (chicken tick) (ev)
  (when (<= (random 100) 1)
    (setf (state chicken)
          (case (random 4)
            (0 (setf (direction chicken) :left) :walking)
            (1 (setf (direction chicken) :right) :walking)
            (2 :sitting)
            (3 :standing))))
  (case (state chicken)
    (:walking
     (case (direction chicken)
       (:left (decf (angle chicken) 0.05))
       (:right (incf (angle chicken) 0.05))))))

(defmethod paint :before ((chicken chicken) target)
  (when (eql :sitting (state chicken))
    (translate-by 0 -5 0)))
