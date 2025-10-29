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
  (:export
   :load-config-from-json))

(in-package :config)

(defun string-not-empty (str)
  (if (or (not str)
          (equal str 'null)
          (and (stringp str) (emptyp str)))
      nil
      str))

(defun load-config-from-json (&optional location)
  (when (uiop:file-exists-p (or location "config.json"))
    (t:match (jzon:parse (read-file-into-string "config.json"))
      ((t:hash-table-entries!
        "prologue" prologue
        "epilogue" epilogue
        "awesomes" awesomes
        "cname" cname
        "output_dir" output-dir)
       (let ((awesomes
               (map 'list (lambda (section)
                            (cons (sp:href section "section")
                                  (map 'list #'identity (sp:href section "links"))))
                    awesomes)))
         (sp:dict :prologue prologue
                  :epilogue epilogue
                  :awesomes awesomes
                  :cname (string-not-empty cname)
                  :output-dir (string-not-empty output-dir)))))))
