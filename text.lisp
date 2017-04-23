(in-package #:ld38)

(defvar *charset*
  #.(format NIL "~
abcdefghijklnopqrstuvwxyz~
ABCDEFGHIJKLNOPQRSTUVWXYZ~
0123456789 .,;:!?_-/()[]"))

(define-pool fonts
  :base 'ld38)

(defclass font-asset (asset)
  ((size :initarg :size :accessor size))
  (:default-initargs
   :size 20))

(defmethod coerce-input ((asset font-asset) (font pathname))
  font)

(defmethod load progn ((asset font-asset))
  (let ((inputs (coerced-inputs asset)))
    (setf (resource asset) (cl-fond:make-font (first inputs) (or (second inputs) *charset*)
                                              :size (size asset) :oversample 2))))

(defmethod finalize-resource ((asset (eql 'font-asset)) font)
  (cl-fond:free font))

(define-shader-subject text ()
  ((font :initarg :font :accessor font)
   (text :initarg :text :accessor text)
   (vertex-array :initarg :vertex-array :initform NIL :accessor vertex-array))
  (:default-initargs
   :font (asset 'fonts 'default)
   :text ""))

(defmethod load progn ((text text))
  (load (font text))
  (setf (vertex-array text) (cl-fond:compute-text (resource (font text)) (text text))))

(defmethod (setf text) :after (string (text text))
  (when (resource text)
    (offload text)
    (load text)))

(defmethod offload progn ((text text))
  (when (vertex-array text)
    (gl:delete-vertex-arrays (list (vertex-array text)))
    (setf (vertex-array text) NIL)))

(defmethod paint ((text text) (pass shader-pass))
  (let ((shader (shader-program-for-pass pass text)))
    (setf (uniform shader "model_matrix") (model-matrix))
    (setf (uniform shader "view_matrix") (view-matrix))
    (setf (uniform shader "projection_matrix") (projection-matrix)))
  (let ((vao (vertex-array text)))
    (when vao
      (gl:bind-texture :texture-2d (cl-fond:atlas (resource (font text))))
      (gl:bind-vertex-array vao)
      (%gl:draw-elements :triangles (* 6 (length (text text))) :unsigned-int 0)
      (gl:bind-vertex-array 0))))

(define-class-shader text :vertex-shader
  "layout (location = 0) in vec2 position;
layout (location = 1) in vec2 _texcoord;
out vec2 texcoord;

uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

void main(){
  gl_Position = projection_matrix * view_matrix * model_matrix * vec4(position, 0.0f, 1.0f);
  texcoord = _texcoord;
}")

(define-class-shader text :fragment-shader
  "in vec2 texcoord;
out vec4 color;

uniform sampler2D atlas;

void main(){
  float intensity = texture(atlas, texcoord).r;
  color = vec4(intensity, intensity, intensity, intensity);
}")
