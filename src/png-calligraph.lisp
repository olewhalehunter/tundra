;; PNG Typeset Functions
;;

"Geometry functions for PNG Typesetting and Calligraphy with Lisp"

;;;;
(ql:quickload 'zpng)
(use-package 'zpng)
;;;;

;;;; Layout
;;

(defun distance (x0 y0 x1 y1)
  (sqrt (+ (expt (- x1 x0) 2)
	   (expt (- y1 y0) 2))))

(defparameter w 500)
(defparameter h 500)

(defparameter pixel-buf
  (make-array (list (* w h) 3)))

(defun pixel-r (x y)  
  (aref pixel-buf (+ x (* w y)) 0) )

(defun pixel-g (x y)  
  (aref pixel-buf (+ x (* w y)) 1) )

(defun pixel-b (x y)  
  (aref pixel-buf (+ x (* w y)) 2) )

(defun coord (x y)
  (+ x (* w y)))

(defun white (x y)
  (setf (aref pixel-buf (coord x y) 0) 255)
  (setf (aref pixel-buf (coord x y) 1) 255)
  (setf (aref pixel-buf (coord x y) 2) 255))

(defun black (x y)  
  (setf (aref pixel-buf (coord x y) 2) 194))

(defun green (x y)  
  (setf (aref pixel-buf (coord x y) 1) 255)
  (setf (aref pixel-buf (coord x y) 2) 200))




;;;; Stroke Drafting Tool
;;

;; Top Left Corners of Meter
;;
(defparameter corner-x 0)
(defparameter corner-y 0)

(defun corner (x y &optional save)
  (setq corner-x x corner-y y)
  (if save
      (set save (list x y))))

(defun save-point (sym)
  (set sym (list corner-x corner-y)))

(defun corner-last (sym)
  (setq corner-x (first (eval sym))
	corner-y (second (eval sym))))

(defun corner-ctav () (setq corner-y ctav-h))

(defun <- (x) (setq corner-x (- corner-x x)))
(defun -> (x) (setq corner-x (+ corner-x x)))
(defun v (y) (setq corner-y (+ corner-y y)))
(defun ^ (y) (setq corner-y (- corner-y y)))

(defun block-radius-height (r h)
  (loop for x from corner-x to (+ corner-x r) do
       (loop for y from corner-y to (+ corner-y h) do
	    (white y x))))

(defun flood-serif-radius (r)
  (loop for x from corner-x to (+ corner-x r) do
       (loop for y from corner-y to (+ corner-y r) do
	    (if (> (distance corner-x (+ corner-y r) x y) r)
		(white y x) )))
  (setq corner-x (+ corner-x r)))

(defun block-height (r h left)
  (loop for x from corner-x to (+ corner-x r) do
       (loop for y from corner-y to (+ corner-y h) do
	    (white y x)))
  (setq corner-x (if (eq left :right) (+ corner-x r) corner-x)
	corner-y (+ corner-y h)))

(defun block-radius-length (r l)
  (loop for x from corner-x to (+ corner-x l) do
       (loop for y from corner-y to (+ corner-y r) do
	    (white y x)))
  (setq corner-x (+ corner-x l)		     
	corner-y (+ corner-y r)))

(defun lower-serif-radius (r)
  (loop for x from corner-x downto (- corner-x r) do
       (loop for y from corner-y to (+ corner-y r) do
	    (if (> (distance (- corner-x r) corner-y x y) r)
		(white y x) ))))




;;;; Letter Drafting
;;
(load "letters.lisp")


;; Letter Parametrics
;; 18 90 default
;; 8 44 smal

(setq ctav-h 30
      letter-space 6
      ctav-n 20)

(corner ctav-h ctav-h 'CSTART)

(setq ro 8 tc 44 fd ro
      ft (* ro 3)
      r (floor (* ro 0.1)) ro2 (* ro 2)
      thalf (floor (/ tc 2.0))
      tcl (floor (* 1.0 tc)))

(setq cur-ctav-h ctav-h)



(defun ctav-next ()
  (setq corner-y (+ corner-y ctav-h tc)
	cur-ctav-h corner-y
	corner-x ctav-h))

(defun ctrok-str (in-str)
  (setq counter 0)
  (with-input-from-string (in in-str)
    (do ((c (read-char in) (read-char in nil 'the-end)))
        ((not (characterp c)))
      (if (> counter 6)
	  (progn (setq counter 0)
		 (ctav-next)))
      (case c
	(#\ (progn (-> tc) (incf counter)))
	(otherwise
	 (progn (ctrok-letter c)
		(incf counter)		
		)))))) 

;; Width guides
;;
(loop for x from 0 to 480 by 25 do
     (loop for y from 0 to 480
	do (black y x)))


(defun paint-pixels-mem! (png w h)
  (loop for x from 0 below w do
       (loop for y from 0 below h do		
	    (write-pixel
	     `(,(pixel-r x y)
	       ,(pixel-g x y)
	       ,(pixel-b x y)
	       255) ;; alph
	     png))))
       

(defun draw-png-file (filename width height)
"with current pixels in buffers, draw to FILENAME of WIDTH and HEIGHT"
  (let ((png (make-instance 'pixel-streamed-png
			    :color-type :truecolor-alpha
			    :width width
			    :height height )))    
    (with-open-file (stream file :direction :output
			    :if-exists :supersede
			    :if-does-not-exist :create
			    :element-type '(unsigned-byte 8))
      (start-png png stream)      
      (paint-pixels-mem! png width height)
      (finish-png png)))
  (print "Portable Network Graphic drawn."))

(defun png-chat-draw (str)
  (ctrok-str str)
  (draw-png-file "out.png" w h))

(png-chat-draw "cale")
