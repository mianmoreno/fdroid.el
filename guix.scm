(define-module (emacs-fdroid)
  #:use-module (gnu packages android)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (guix build utils)
  #:use-module (guix build-system emacs)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim))

(define %source-dir (dirname (current-filename)))

(define (emacs-fdroid-git-version)
  (let* ((port (with-directory-excursion
                %source-dir
                (open-input-pipe "git describe --always --tags")))
         (version (read-line port)))
    (close-pipe port)
    version))

(define-public emacs-fdroid
  (package
    (name "emacs-fdroid")
    (version (emacs-fdroid-git-version))
    (source
     (local-file %source-dir
                 #:recursive? #t
                 #:select? (git-predicate %source-dir)))
    (build-system emacs-build-system)
    (inputs
     (list fdroidcl))
    (propagated-inputs
     (list emacs-embark))
    (home-page "https://git.sr.ht/~conses/fdroid.el")
    (synopsis "An Emacs interface to manage F-Droid repositories")
    (description "fdroid.el is an Emacs interface to fdroidcl.  Its purpose
is to aid the management of F-Droid packages from the comfort of Emacs.")
    (license license:gpl3+)))

emacs-fdroid
