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
     "https://github.com/emacs-evil/evil"
     "https://github.com/minad/vertico"
     "https://github.com/magit/magit"
     "https://github.com/minad/org-modern"
     "https://github.com/karthink/gptel"
     "https://github.com/emacs-lsp/lsp-mode"
     "https://github.com/mohkale/projection"
     "https://github.com/minad/consult")
    ("Shell & Terminal"
     "https://github.com/ohmyzsh/ohmyzsh"
     "https://github.com/tmux/tmux"
     "https://github.com/tmux-plugins/tmux-resurrect"
     "https://github.com/KDE/konsole")
    ("NixOS"
     "https://github.com/NixOS/nix"
     "https://github.com/nix-community/home-manager"
     "https://github.com/nix-community/nixos-generators")
    ("Clojure & ClojureScript"
     "https://github.com/clojure-emacs/cider"
     "https://github.com/ring-clojure/ring"
     "https://github.com/thheller/shadow-cljs"
     "https://github.com/pitch-io/uix"
     "https://github.com/weavejester/hiccup")
    ("Common Lisp"
     "https://github.com/ruricolist/serapeum"
     "https://github.com/edicl/hunchentoot"
     "https://github.com/ruricolist/spinneret"
     "https://github.com/Zulu-Inuoe/jzon"
     "https://github.com/guicho271828/trivia")
    ("JavaScript & TypeScript"
     "https://github.com/angular/angular"
     "https://github.com/ReactiveX/rxjs")))

(defparameter *config*
  (sp:dict
   :output-dir "./docs/"
   :cname nil
   :project-url "random"))
