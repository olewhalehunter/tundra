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

(define-easy-handler (repl :uri "/repl") ()
  (with-html-output-to-string (s)
    (:html
     (:head 
      (:meta :http-equiv "Content-Type" 
                      :content "text/html;charset=utf-8")
      (:title "AM Tundra")

      (:link :type "text/css" 
	     :rel "stylesheet"
	     :href "/tundra.css"))     

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
     (:div :id "frame-outside"
      "[]")
     (:p
      (:input :id "data" :type "text"))
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
