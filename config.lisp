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
   :*config*
   :*awesomes*))

(in-package :config)

(defparameter *awesomes*
  '(("Emacs"
     "https://github.com/emacs-lsp/lsp-mode"
     "https://github.com/emacs-evil/evil"
     "https://github.com/minad/vertico"
     "https://github.com/magit/magit"
     "https://github.com/minad/org-modern")
    ("NixOS"
     "https://github.com/NixOS/nix"
     "https://github.com/nix-community/home-manager")
    ("Shell"
     "https://github.com/ohmyzsh/ohmyzsh")))

(defparameter *config*
  (sp:dict
   :output-dir "./docs/"
   :cname nil
   :project-url "random"))
