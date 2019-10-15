;; server.lisp
;; jpt4 and olewhalehunter
;; SBCL
;; Tundra digital arts development server

(ql:quickload '(:hunchentoot :cl-who :parenscript :smackjack))

(defpackage :test-site
  (:use :cl :hunchentoot :cl-who :parenscript :smackjack))
(in-package :test-site)

(defparameter *server*
  (start (make-instance 'easy-acceptor :address "localhost" :port 8082)))

(setf *js-string-delimiter* #\")

(defun shader-str () 
"<script id=\"3d-vertex-shader\" type=\"x-shader/x-vertex\">attribute vec4 a_position;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_matrix;
varying vec4 v_color;
varying vec2 v_texcoord;

void main() {
  gl_Position = u_matrix * a_position;

  // v_color = a_position / 10.0; // vertex coord gradient map
  v_color = a_color; // a_color Attribute pass
  v_texcoord = a_texcoord;
}</script>
<script id=\"3d-fragment-shader\" type=\"x-shader/x-fragment\">
precision mediump float;
varying vec4 v_color;
varying vec2 v_texcoord;

uniform vec4 u_colorMult;
uniform sampler2D u_texture;

void main() {
  vec4 hvit = vec4(1.0, 1.0, 1.0, 1.0); 

   gl_FragColor = texture2D(u_texture, v_texcoord); // * v_color
   // gl_FragColor = v_color * u_colorMult;
   
}</script>")

(define-easy-handler (repl :uri "/repl") ()
  (with-html-output-to-string (s)
    (:html
     (:head 
      (:meta :http-equiv "Content-Type" 
                      :content "text/html;charset=utf-8")

      (:title "AM Tundra")
            
      (str "<script src=\"webgl-utils.js\"></script>")
      (str "<script src=\"m4.js\"></script>")
      (str "<script src=\"primitives.js\"></script>")    
      (str "<script src=\"environ.js\"></script>")
      
      (:link :type "text/css" :rel "stylesheet" :href "/tundra.css"))
          
     (str (generate-prologue *ajax-processor*))     

          (:script :type "text/javascript"
	      (str
	       (ps
		 (defun callback (response)
		   (alert response))
		 (defun on-click ()
		   (chain smackjack (echo (chain document
						 (get-element-by-id "data")
						 value)
					  callback)))))))

    (:body
     
     (str (shader-str))
     (str "<script src=\"tundra-util.js\"></script>")
     (str "<script src=\"tundra-client.js\"></script>")
     
     (:div :id "frame-outside"	                         
	  (str "<canvas id='canvas' width=\"30px\" height=\"40px\"></canvas>") )	   
          
     (:p
      (:input :id "data" :type "text"))
(str "<script>document.onload = TundraMain();</script>")
     (:p
      (:button :type "button"
	       :onclick (ps-inline (on-click))
	       "Print")))))

(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/repl-api"))

(defun-ajax echo (data) (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "echo: " data))

(defvar tundra-js-files
  (list
   "tundra-client.js"
   "tundra-util.js"
   "environ.js"
   "primitives.js"
   "webgl-utils.js"
   "gl-matrix.js"            
   "m4.js"))

(defvar tundra-css-files
  (list
   "tundra.css"))

(defvar tundra-texture-files
  (list
   "bark.jpg"
   "ink.jpeg"
   "shade.jpg"))


(setq *dispatch-table* (list 'dispatch-easy-handlers
			     (create-ajax-dispatcher *ajax-processor*)))

(mapcar 
 (lambda (js-script)
   (push
    (hunchentoot:create-static-file-dispatcher-and-handler
     (concatenate 'string "/" js-script)
     (concatenate 'string (sb-posix:getcwd) "/js/" js-script))
    hunchentoot::*dispatch-table*))
 tundra-js-files)

(mapcar 
 (lambda (css-script)
   (push
    (hunchentoot:create-static-file-dispatcher-and-handler
     (concatenate 'string "/" css-script)
     (concatenate 'string (sb-posix:getcwd) "/css/" css-script))
    hunchentoot::*dispatch-table*))
 tundra-css-files)

(mapcar 
 (lambda (texture-file)
   (push
    (hunchentoot:create-static-file-dispatcher-and-handler
     (concatenate 'string "/" texture-file)
     (concatenate 'string (sb-posix:getcwd) "/img/" texture-file))
    hunchentoot::*dispatch-table*))
 tundra-texture-files)
