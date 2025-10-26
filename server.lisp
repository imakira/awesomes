(defpackage :server
  (:use :common-lisp :alexandria)
  (:local-nicknames  (:sp :serapeum)
                     (:re :cl-ppcre)
                     (:h :spinneret)))
(in-package :server)

(defparameter *inst* (make-instance 'hunchentoot:easy-acceptor
                                    :port 8080))

(hunchentoot:define-easy-handler (home :uri "/") ()
  (let ((*print-pretty* nil))
    (funcall #'awesomes:home-page awesomes:*awesomes-status*
             config:*config*)))

(defun start-server ()
  (unless (hunchentoot:started-p *inst*)
    (hunchentoot:start *inst*))
  (setq hunchentoot:*dispatch-table*
        (concatenate 'list hunchentoot:*dispatch-table* (list (hunchentoot:create-folder-dispatcher-and-handler "/" "./resources/")))))

(defun stop-server ()
  (if (hunchentoot:started-p *inst*)
      (hunchentoot:stop *inst*)))

