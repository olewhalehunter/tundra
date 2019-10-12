;;amdev.lisp
;;20191010Z
;;jpt4
;;SBCL
;;AM dev site

;TODO: How to direct ql to the correct library for ("/usr/lib/libssl.so.1.1")
;and ("/usr/lib/libcrypto.so.1.1"). 
;How to execute/repair from current
;buffer, rather than in repl?
;A: sl-ev-b, enter alternative library paths.
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
     (:title "AM Dev Test Site")
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
     (:p
      (:input :id "data" :type "text"))
     (:p
      (:button :type "button"
	       :onclick (ps-inline (on-click))
	       "Submit!")))))

(defparameter *ajax-processor*
  (make-instance 'ajax-processor :server-uri "/repl-api"))

(defun-ajax echo (data) (*ajax-processor* :callback-data :response-text)
  (concatenate 'string "echo: " data))

(setq *dispatch-table* (list 'dispatch-easy-handlers
			     (create-ajax-dispatcher *ajax-processor*)))

