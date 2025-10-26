(defpackage :config
  (:use :common-lisp :alexandria)
  (:local-nicknames  (:sp :serapeum)
                     (:re :cl-ppcre)
                     (:jzon :com.inuoe.jzon)
                     (:http :dexador)
                     (:lp :lparallel)
                     (:log :log4cl)
                     (:h :spinneret)
                     (:t :trivia))
  (:export :*config*))

(in-package config)

(defparameter *config*
  (sp:dict
   :output "./docs/"
   :cname nil
   :project-url "random"))
