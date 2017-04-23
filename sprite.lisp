(in-package #:ld38)

(define-pool sprites
  :base 'ld38)

(define-shader-subject sprite (vertex-subject textured-subject located-entity)
  ((direction :initform :right :accessor direction))
  (:default-initargs
   :vertex-array (asset 'geometry 'fullscreen-square)))

(defmethod paint ((sprite sprite) target)
  (with-pushed-matrix
    (case (direction sprite)
      (:left (rotate +vy+ PI)))
    (call-next-method)))

(define-class-shader sprite :vertex-shader
  "
layout (location = 0) in vec3 position;
uniform sampler2D texture_image;

uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

void main(){
  ivec2 size = textureSize(texture_image, 0);
  gl_Position = projection_matrix * view_matrix * model_matrix
                * vec4(size/2, 1.0, 1.0) * vec4(position, 1.0f);
}")
