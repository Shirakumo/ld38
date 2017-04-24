(in-package #:ld38)

(define-shader-subject world (sprite)
  ()
  (:default-initargs
   :texture (asset 'sprites 'world)))

(define-asset (sprites world) texture-asset
    (#p"world.png"))

(defclass world-entity (located-entity)
  ((angle :initarg :angle :initform 90 :accessor angle)
   (radius :initarg :radius :initform 2013 :accessor radius)))

(defmethod initialize-instance :after ((entity world-entity) &key)
  (setf (angle entity) (angle entity)))

(defmethod (setf angle) :around (value (entity world-entity))
  (if (<= 0 value 360)
      (call-next-method)
      (setf (angle entity) (mod value 360))))

(defmethod (setf angle) :after (value (entity world-entity))
  (let ((phi (/ (* PI value) 180)))
    (setf (vx (location entity)) (* (radius entity) (cos phi))
          (vy (location entity)) (* (radius entity) (sin phi)))))

(defmethod paint :before ((entity world-entity) target)
  (rotate +vz+ (/ (* PI (- (angle entity) 90)) 180)))
