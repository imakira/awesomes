(require 'asdf)
(asdf:defsystem "awesomes"
  :depends-on (#:alexandria
               #:serapeum
               #:cl-ppcre
               #:hunchentoot
               #:spinneret
               #:dexador
               #:com.inuoe.jzon
               #:lparallel
               #:log4cl
               #:trivia
               #:local-time)
  :components ((:file "config")
               (:file "awesomes" :depends-on ("config"))
               (:file "server" :depends-on ("awesomes" "config"))
               (:file "generate" :depends-on ("awesomes" "config")))
  :build-operation "program-op"
  :build-pathname "awesomes"
  :entry-point "generate:generate")



