(asdf:defsystem "awesomes"
  :depends-on (#:alexandria
               #:arrow-macros
               #:serapeum
               #:defmain
               #:cl-ppcre
               #:hunchentoot
               #:spinneret
               #:dexador
               #:com.inuoe.jzon
               #:lparallel
               #:log4cl
               #:trivia
               #:local-time)
  :components ((:file "awesomes")
               (:file "server" :depends-on ("awesomes"))
               (:file "generate" :depends-on ("awesomes"))))



