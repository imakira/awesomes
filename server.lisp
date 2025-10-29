(defpackage :server
  (:use :common-lisp :alexandria)
  (:local-nicknames  (:sp :serapeum)
                     (:re :cl-ppcre)
                     (:h :spinneret)))
(in-package :server)

(defvar *inst* (make-instance 'hunchentoot:easy-acceptor
                              :port 8080))

(defvar *config* (config:load-config-from-json))

(defvar *awesome-status* (when awesomes:*debugger-p* (awesomes:fetch-status (sp:href *config* :awesomes))))

(hunchentoot:define-easy-handler (home :uri "/") ()
  (let ((*print-pretty* nil))
    (funcall #'awesomes:home-page *awesome-status*
             *config*)))

(defun start-server ()
  (unless (hunchentoot:started-p *inst*)
    (hunchentoot:start *inst*))
  (setq hunchentoot:*dispatch-table*
        (concatenate 'list hunchentoot:*dispatch-table* (list (hunchentoot:create-folder-dispatcher-and-handler "/" "./resources/")))))

(defun stop-server ()
  (if (hunchentoot:started-p *inst*)
      (hunchentoot:stop *inst*)))

