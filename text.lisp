(in-package #:ld38)

(define-shader-subject text (textured-subject)
  ((font :initarg :font :accessor font)
   (text :initarg :text :accessor text)
   (vertex-array :initarg :vertex-array :initform NIL :accessor vertex-array)))

(defmethod load progn ((text text))
  (setf (vertex-array text) (cl-fond:compute-text (font text) (text text))))

(defmethod offload progn ((text text))
  (when (vertex-array text)
    (gl:delete-vertex-arrays (vertex-array text))))

(defmethod paint ((text text) (pass shader-pass))
  (let ((shader (shader-program-for-pass pass text)))
    (setf (uniform shader "model_matrix") (model-matrix))
    (setf (uniform shader "view_matrix") (view-matrix))
    (setf (uniform shader "projection_matrix") (projection-matrix)))
  (let ((vao (vertex-array text)))
    (gl:bind-vertex-array (resource vao))
    (%gl:draw-elements :triangles (* 6 (length (text text))) :unsigned-int 0)
    (gl:bind-vertex-array 0)))

(define-class-shader text :vertex-shader
  "layout (location = 0) in vec2 position;

uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

void main(){
  gl_Position = projection_matrix * view_matrix * model_matrix * vec4(position, 0.0f, 1.0f);
}")
