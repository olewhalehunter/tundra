
(defun ctavset () (setq corner-y cur-ctav-h))

(defun ctrok-letter (letter)
  (case letter
    (#\a (ctrok-a))
    (#\b (ctrok-b))
    (#\c (ctrok-c))    
    (#\d (ctrok-d))
    (#\e (ctrok-e))
    (#\f (ctrok-f))
    (#\g (ctrok-g))
    (#\h (ctrok-h))
    (#\i (ctrok-i))
    (#\j (ctrok-j))
    (#\k (ctrok-k))
    (#\l (ctrok-l))
    (#\m (ctrok-m))
    (#\n (ctrok-n))
    (#\o (ctrok-o))
    (#\p (ctrok-p))
    (#\q (ctrok-q))
    (#\r (ctrok-r))
    (#\s (ctrok-s))
    (#\t (ctrok-t))
    (#\u (ctrok-u))
    (#\v (ctrok-v))
    (#\w (ctrok-w))
    (#\x (ctrok-x))
    (#\y (ctrok-y))
    (#\z (ctrok-z)))
  
  (corner-last 'CTAV-END) (-> letter-space)
  (ctavset))


(defun c3 ()
  (corner-last 'CWNG-0)
  (cida-ctrok ro (+ (- ft ro) r))
  (^ ro)
  (t-cwng fd ro) (V ro)) ;; truncated bars

(defun c4 (&optional k)
  (corner-last 'CTAV-0)  
  (<- ro) (cwng-z fd)
  (t-cwng ro fd) (-> ro)
  (cida-ctrok ro (+ (- ft ro) r))
  (^ ro2)
  (save-point 'CTAV-END))

(defun c0 () ;; |   
  (flood-serif-radius fd)
  (save-point 'CWNG-0)
  (block-height ro tc :right)  
  (save-point 'CTAV-0))

(defun c1 () ;; ---\
  (corner-last 'CWNG-0)
  (block-radius-length ro tc)
  (^ ro)
  (block-radius-height fd ro) (V ro) (flood-serif-radius fd)
  (save-point 'CTAV-1))

(defun c2 (&optional k) ;; ___/
  (corner-last 'CTAV-0) (<- ro)
  (cwng-z fd)
  (block-radius-height ro fd) 
  (-> ro)
  (cida-ctrok ro tcl)
  (^ ro2) 
  (cwng-z fd)
  (corner-ctav) 
  (save-point 'CTAV-END))

(defun c5 () ;; \|
  (corner-last 'CTAV-0) (<- ro)
  (lower-serif-radius fd)
  (block-radius-height ro fd) (-> ro)  
  (corner-ctav) (save-point 'CTAV-END))



(defun cf ()
  (corner-last 'CWNG-0)
  (-> ft)
  (block-height r tc :right)
  (save-point 'CF))

(defun ca () "thin right side"
  (corner-last 'CWNG-0)
  (-> (+ tc ro))  
  (block-height r (+ tc ro) :right)  
  (save-point 'CTAV-END))



(defun ce () "thwartline A"
  (corner-last 'CWNG-0)
  (V (+ (floor (- tc (* fd 2))) ro))
  (block-height (+ ro tc) r :left)  
  (save-point 'CTAV-END))

(defun cb () "thwartline B, E"
  (corner-last 'CWNG-0)
  (V (+ (floor (/ tc 2.0)) (floor (/ fd 2.0))))  
  (block-height (+ ro tc) r :left)  
  (save-point 'CTAV-END))

(defun ctrok-l ()
  (c0) (c2))


(defun ctrok-o ()
  (c0) (c1) (ca) (c2))

(defun ctrok-q ()
  (c0) (c1) (ca) (c2)
  (<- (+ fd fd))
  (V (+ thalf fd -4))
  (loop for y from corner-y upto (+ corner-y thalf) do
       (gro y corner-x)))
  

(defun ctrok-b ()
  (c0) (c1) (c2) (cb) (ca))

(defun ctrok-h ()
  (c0) (cb) (ca))

(defun ctrok-p ()
  (c0) (c1)
  (cb)  
  (c1) ;; reset to ol
  (loop for y from corner-y to (+ corner-y thalf) do
       (gro y corner-x))
  (save-point 'CTAV-END))

(defun ctrok-f ()
  (c0) (c1)
  (cb)
  (c1) ;; reset to ol
  (save-point 'CTAV-END))
(defun ctrok-g ()
  (c0) (c1)  
  (c1) ;; reset to ol
  (save-point 'CTAV-END))

(defun ctrok-e ()
  (c0) (c1) (cb) (c2))

(defun ctrok-i ()
  (c0) (save-point 'CTAV-END))

(defun ctrok-a ()
  (c0)
  (c1) (c5) (ce) (ca))

(defun ctrok-j ()
  (c0) (c5)    
  (save-point 'CTAV-END))

(defun ctrok-k ()
  (c0) (c5)
  (corner-last 'CWNG-0)
  (v thalf) (-> fd)  
  (flood-serif-radius (* fd 2))
  (loop for y from (+ (* fd 2) corner-y)
     to (+ corner-y fd thalf)
     do (gro y corner-x))

  (^ thalf)
  (lower-serif-radius (* 2 fd))  
  (save-point 'CTAV-END))

(defun ctrok-d ()
  (c0) (c3) (c4)
  (cf))
(defun ctrok-c ()
  (c0) (c1) (cf) (c2))  
  
