(in-package #:ld38)

(defclass world-character (world-entity sprite)
  ((velocity :initform 0 :accessor velocity)
   (dialogues :initarg :dialogues :accessor dialogues)
   (asset-file :initarg :asset-file :accessor asset-file)))

(defmacro define-character (name (asset-file angle) &rest dialogues)
  `(defclass ,name (world-character) ()
     (:default-initargs
      :texture (asset 'sprites ',name)
      :name ',name
      :angle ,angle
      :asset-file ,asset-file
      :dialogues ',dialogues)))

(defmethod initialize-instance :after ((chara world-character) &key)
  (unless (asset 'sprites (slot-value chara 'name))
    (define-asset (sprites (name chara)) texture-asset
        ((slot-value chara 'asset-file)))))

(indent:define-indentation define-character (2 4 (&whole 2 &rest 1)))

(define-character pincers (#P"whatever.png" 45)
  (define-dialogue pincers-hello
   :tag start
   pincers "How's it going?"
   :choice (("It is what it is."
             :dialogue pincers-disappointed)
            ("Life is hard and everything is terrible.")
            ("Eh, I don't know."
             pincers "Well try to figure out."
             :go start))
   pincers "Word.")

  (define-dialogue system-not-good
    :action (pincers depressed)
    pincers "I was just trying to be nice."
    pincers "Anyway, I guess do whatever you want."
    :end all))
