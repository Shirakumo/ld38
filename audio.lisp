(in-package #:ld38)

(define-pool music
  :base 'ld38)

(defclass audio-asset (asset)
  ((looping-p :initarg :loop :accessor looping-p))
  (:default-initargs :loop NIL))

(defmethod coerce-input ((asset audio-asset) (file pathname))
  file)

(defmethod load progn ((asset audio-asset))
  (let* ((file (first (coerced-inputs asset)))
         (source (cond ((string= "mp3" (pathname-type file))
                        (make-instance 'cl-soloud:mp3-source))
                       ((string= "wav" (pathname-type file))
                        (make-instance 'cl-soloud:wav-source)))))
    (setf (cl-soloud:looping-p source) (looping-p asset))
    (cl-soloud:load-file source file)
    (setf (resource asset) source)))

(defmethod finalize-resource ((asset (eql 'audio-asset)) source)
  (cl-soloud:free source))
