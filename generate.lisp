(defpackage :generate
  (:use :common-lisp :alexandria)
  (:local-nicknames  (:sp :serapeum)
                     (:re :cl-ppcre)
                     (:jzon :com.inuoe.jzon)
                     (:http :dexador)
                     (:lp :lparallel)
                     (:log :log4cl)
                     (:h :spinneret)
                     (:t :trivia))
  (:export :generate))

(in-package :generate)

(defun copy-directory (source dest)
  (let ((source (uiop:directory-exists-p (uiop:merge-pathnames* (uiop:ensure-directory-pathname source))))
        (dest (uiop:directory-exists-p (uiop:merge-pathnames* (uiop:ensure-directory-pathname dest)))))
    (assert source)
    (assert dest)
    (fad:walk-directory source
                        (lambda (file)
                          (let* ((subpath (uiop:enough-pathname file
                                                                source))
                                 (dest-file (sp:~>> dest
                                                    (uiop:merge-pathnames* (uiop:ensure-directory-pathname
                                                                            (car (last (pathname-directory source)))))
                                                    (uiop:merge-pathnames* subpath))))
                            (ensure-directories-exist dest-file)
                            (uiop:copy-file file dest-file))))))

(defun generate ()

  ;; FIXME move it to somewhere more sensisble
  (unless lp:*kernel*
    (setf lp:*kernel* (lp:make-kernel 8)))

  (t:match config:*config*
    ((t:hash-table-entries :output-dir output-dir
                           :cname cname)
     (ensure-directories-exist output-dir)
     (let ((status (awesomes:fetch-status config:*awesomes*))
           (path (uiop:merge-pathnames* (uiop:ensure-directory-pathname output-dir))))
       (write-string-into-file (awesomes:home-page status config:*config*)
                               (uiop:merge-pathnames* path "index.html"))
       (when cname (write-string-into-file cname (uiop:merge-pathnames* path "CNAME")))
       (copy-directory "./resources/src/" "./docs/")))))

