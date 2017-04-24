(in-package #:ld38)

(define-pool sprites
  :base 'ld38)

(define-shader-subject sprite (vertex-subject textured-subject located-entity)
  ((direction :initarg :direction :initform :right :accessor direction)
   (frame-index :initform 0 :accessor frame-index)
   (frame-count :initform 1 :accessor frame-count))
  (:default-initargs
   :vertex-array (asset 'geometry 'fullscreen-square)))

(defmethod paint ((sprite sprite) (pass shader-pass))
  (with-pushed-matrix
    (case (direction sprite)
      (:left (rotate +vy+ PI)))
    (let ((shader (shader-program-for-pass pass sprite)))
      (setf (uniform shader "frame_index") (frame-index sprite))
      (setf (uniform shader "frame_count") (frame-count sprite)))
    (call-next-method)))

(define-class-shader sprite :vertex-shader
  "
layout (location = 0) in vec3 position;
layout (location = 1) in vec2 in_texcoord;
out vec2 texcoord;

uniform int frame_index;
uniform int frame_count;
uniform sampler2D texture_image;
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

void main(){
  ivec2 size = textureSize(texture_image, 0);
  size.y /= frame_count;
  gl_Position = projection_matrix * view_matrix * model_matrix
                * vec4(size.x/2, size.y/2, 1.0, 1.0) * vec4(position, 1.0f);
  texcoord = vec2(in_texcoord.x, (frame_index+in_texcoord.y)/frame_count);
}")
