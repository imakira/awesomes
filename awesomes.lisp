(defpackage :awesomes
  (:use :common-lisp :alexandria)
  (:local-nicknames  (:sp :serapeum)
                     (:re :cl-ppcre)
                     (:jzon :com.inuoe.jzon)
                     (:http :dexador)
                     (:lp :lparallel)
                     (:log :log4cl)
                     (:h :spinneret)
                     (:t :trivia))
  (:export :*awesomes-status*
           #:home-page
           #:fetch-status))
(in-package :awesomes)

(sp:toggle-pretty-print-hash-table t)

(defvar *debugger-p* (symbol-value (uiop:find-symbol* '*global-debugger* (find-package :slynk) nil)))

(defun fetch-github-status (repo author)
  (let* ((result (jzon:parse (http:get (sp:concat
                                        "https://api.github.com/repos/" repo "/" author))
                             :key-fn (lambda (key)
                                       (make-keyword (string-upcase key)))))
         (owner (sp:href result :owner)))
    (sp:dict :type :github
             :full-name (sp:concat repo "/" author)
             :name (sp:href result :name)
             :url (sp:concat "https://github.com/" repo "/" author)
             :owner (sp:dict :name (sp:href owner :login)
                             :url (sp:href owner :html_url))
             :description (sp:href result :description)
             :stars-count (sp:href result :stargazers_count))))

(defun fetch-general-link-status (link)
  (sp:dict :type :link
           :url link))

(defun github-link-p (link)
  (sp:true (parse-github-link link)))

(defun parse-github-link (link)
  (re:register-groups-bind (repo name) ("^https://github\\.com/([^\\s/]+)/([^\\s/]+)$" link)
    (sp:dict :repo repo :name name)))

(defun fetch-status (awesomes)
  (let*  ((normalized-links
            (mapcan (lambda (section)
                      (mapcar (lambda (link)
                                (list (car section) link))
                              (cdr section)))
                    awesomes))
          (result (lp:pmapcar (lambda (link-tuple)
                                (block blk
                                  (let ((section (first link-tuple))
                                        (link (second link-tuple)))
                                    (handler-bind
                                        ((error (lambda (c)
                                                  (log:log-warn "fetch link " link " failed, error: " c)
                                                  (unless *debugger-p*
                                                    (return-from blk)))))
                                      (list section
                                            (progn
                                              (if (github-link-p link)
                                                  (let ((tmp (parse-github-link link)))
                                                    (fetch-github-status
                                                     (sp:href tmp :repo)
                                                     (sp:href tmp :name)))
                                                  (fetch-general-link-status (second link-tuple)))))))))
                              :parts 8
                              normalized-links)))
    (mapcar (lambda (section)
              (list (caar section)
                    (mapcar #'second section)))
            (sp:assort (sp:filter #'identity result) :key #'first))))


(defvar *awesomes-status* (if *debugger-p* (fetch-status config:*awesomes*)))

(defmacro with-template-string (&body body)
  `(h:with-html-string
     (:doctype)
     (:html
      (:head
       (:meta :attrs '(:name "viewport"
                       :content "width=device-width, initial-scale=1.0"))
       (:link :attrs (list :href (sp:concat "./src/output.css?timestamp=" (princ-to-string (sp:get-unix-time)))
                           :rel "stylesheet"))
       (:raw "<link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=star\" />")
       (:title "Personal Awesome Lists"))
      (:body :attrs (list :class "w-full min-h-full")
             ,@body))))

(defun humanize-number (number)
  (cond ((>= number 1000000)
         (format nil "~,2Fm" (/ number 1000000.0)))
        ((>= number 1000)
         (format nil "~,1Fk" (/ number 1000.0)))
        (t
         (format nil "~D" (round number)))))

(defmacro prologue ()
  `(h:with-html
     (:div :attrs (list :class "bg-white mt-8 sm:mt-12 text-xl font-medium text-slate-700 p-4")
           (:p "Hello! This is an awesome list made by me showing projects I'm interested in or using all the time."))))

(defmacro epilogue (config)
  `(h:with-html
     (:div :attrs (list :class "epilogue bg-white mt-12 text-lg font-medium text-slate-700 p-4 mb-10")
           (:p "This site is powered by "
               (:a :attrs (list :href "https://en.wikipedia.org/wiki/Common_Lisp")
                   "Common Lisp")
               " and the "
               (:a :attrs (list :href (sp:href ,config :project-url))
                   "source code")
               " is released under "
               (:a :attrs (list :href "https://unlicense.org/")
                   "Public Domain."))
           (:p :attrs (list :class "mt-2") "Last updated time "
               (:span :attrs (list :class "border-dotted border-b-2 text-slate-600") (format nil "~a" (local-time:now)))))))

(defun home-page (status config)
  (with-template-string
    (:div :attrs (list :class "w-full flex justify-center px-4")
          (:div :attrs (list :class "w-[48rem]")
                (prologue)
                (loop :for (section-name items) :in status
                      :collect
                      (:div :attrs (list :class "mt-12")
                            (:div
                             (:h2 :attrs (list :class "text-3xl border-l-2 border-sky-700 text-slate-700 mb-4 pl-2") section-name))
                            (:div :attrs (list :class "flex flex-col gap-5")
                                  (loop :for item :in items
                                        :collect
                                        (t:match item
                                          ((t:hash-table-entries :type _
                                                                 :full-name _
                                                                 :name name
                                                                 :url url
                                                                 :owner (t:hash-table-entries
                                                                         :name owner-name
                                                                         :url _)
                                                                 :description description
                                                                 :stars-count stars-count)
                                           (:div :attrs (list :class "h-28 sm:h-24 bg-white grid grid-rows-[1fr_1.3fr] sm:grid-rows-[1fr_1.1fr]")
                                                 (:div :attrs (list :class "flex bg-sky-700 items-stretch justify-between pl-4")
                                                       (:div :attrs (list :class "flex items-center ")
                                                             (:a :attrs (list :href url)
                                                                 (:span :attrs (list :class "text-white text-lg sm:text-xl font-medium leading-1")
                                                                        (:span :attrs (list :class "text-slate-200") owner-name)
                                                                        " "
                                                                        (:span :attrs (list :class "text-slate-400") "/")
                                                                        " "
                                                                        (:span name))))
                                                       (:a :attrs (list :href url
                                                                        :class "block h-full")
                                                           (:div :attrs
                                                                 (list :class "flex h-full relative items-center w-24 bg-sky-800 pr-3 justify-end gap-0.5")
                                                                 (:span :attrs (list :class "text-slate-100") (humanize-number stars-count))
                                                                 (:span :attrs (list :class "relative -top-[1px] text-slate-100 material-symbols-outlined")
                                                                        "star"))))
                                                 (:div :attrs (list :class "px-3.5 min-h-0 h-full overflow-hidden flex items-center")
                                                       (:p :attrs (list :class "line-clamp-2 sm:line-clamp-1 text-slate-800 font-medium") description)))))))))
                (epilogue config)))))
