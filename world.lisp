(in-package #:ld38)

(define-shader-subject world (sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'world)))

(define-asset (sprites world) texture-asset
    (#p"world.png"))

(defclass world-entity (located-entity)
  ((angle :initarg :angle :initform 90 :accessor angle)))

(defmethod initialize-instance :after ((entity world-entity) &key)
  (setf (angle entity) (angle entity)))

(defmethod (setf angle) :after (value (entity world-entity))
  (let ((phi (/ (* PI value) 180))
        (r 2048))
    (setf (vx (location entity)) (* r (cos phi))
          (vy (location entity)) (* r (sin phi)))))

(defmethod paint :before ((entity world-entity) target)
  (rotate +vz+ (/ (* PI (angle entity)) 180)))
