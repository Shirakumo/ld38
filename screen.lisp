(in-package #:ld38)

(defclass gameover (event)
  ())

(define-shader-subject screen (vertex-subject textured-subject)
  ((opacity :initform 1.0 :accessor opacity)
   (state :initform :visible :accessor state))
  (:default-initargs
   :texture (asset 'sprites 'gamestart)
   :vertex-array (asset 'geometry 'fullscreen-square)
   :name :screen))

(define-asset (sprites gamestart) texture-asset
    (#p"gamestart.png"))

(define-asset (sprites gameover) texture-asset
    (#p"gameover.png"))

(define-handler (screen gameover) (ev)
  (clear (scene *context*))
  (enter screen (scene *context*))
  (setf (state *context*) :gameover)
  (setf (texture screen) (load (asset 'sprites 'gameover)))
  (setf (state screen) :fade-in))

(define-handler (screen tick) (ev)
  (case (state screen)
    (:fade-in
     (incf (opacity screen) 1/30)
     (when (<= 1.0 (opacity screen))
       (setf (opacity screen) 1.0)
       (setf (state screen) :visible)))
    (:fade-out
     (decf (opacity screen) 1/30)
     (when (<= (opacity screen) 0.0)
       (setf (opacity screen) 0.0)
       (setf (state screen) :invisible)))
    (:visible)
    (:invisible)))

(defmethod paint ((screen screen) (pass shader-pass))
  (unless (eql :invisible (state screen))
    (with-pushed-matrix
      (reset-matrix)
      (translate-by 0 0 -4)
      (let ((shader (shader-program-for-pass pass screen)))
        (setf (uniform shader "opacity") (max 0.0 (min 1.0 (opacity screen)))))
      (call-next-method))))

(define-class-shader screen :fragment-shader
  "
uniform float opacity;
out vec4 color;

void main(){
  color *= vec4(opacity);
}")
