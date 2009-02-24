;
; .emacs (-*-Emacs-Lisp-*-)
;
; Brad Merrill
; mailto:zbrad@cybercom.net
; Last updated: 6-Jan-2003
;

;
; Key Bindings
;
(add-to-list 'load-path "~/.emacs.d/site-lisp")
;
; most of these strange key bindings are from the original Tops-20 Emacs
; my fingers are still wired the old way
;
(fset 'kill-to-beg-of-line "0")
(global-set-key "\C-u" 'kill-to-beg-of-line)		; old ^U behavior
;(global-unset-key "\C-x\C-c")				; no exiting accidently
(setq kill-emacs-query-functions
      (cons (lambda () (yes-or-no-p "Really kill Emacs? "))
	    kill-emacs-query-functions))

(global-set-key "\C-w" 'backward-kill-word)		; old ^W behavior
(define-key esc-map "w" 'kill-region)			; old meta-w
(define-key esc-map "?" 'command-apropos)
(define-key esc-map "s" 'center-line)
(define-key esc-map "." 'set-mark-command)

(define-key ctl-x-map "s" 'save-buffer)
(define-key ctl-x-map "w" 'copy-region-as-kill)
(define-key ctl-x-map "c" 'compile)
(define-key ctl-x-map "g" 'goto-line)

(global-set-key "\C-h" 'quoted-insert)    

;(global-set-key "\C-_" 'help-command)
;(setq help-char "?C-_)

(define-key isearch-mode-map "\C-h" 'isearch-quote-char)
(define-key isearch-mode-map "\C-\\" 'isearch-repeat-forward)
(global-set-key "\C-r" 'isearch-backward)
(global-set-key "\C-\\" 'isearch-forward)

;(global-unset-key "\C-q")				; unbind xoff
;(global-unset-key "\C-s")				; unbind xon

;(global-unset-key "\C-x\C-q")				; unbind xoff
;(global-unset-key "\C-x\C-s")				; unbind xon

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; HTML mode
;
(setq html-helper-do-write-file-hooks t)
(setq html-helper-build-new-buffer t)
(setq html-helper-address-string "
<a href=\"http://project7/bmerrill\">Brad Merrill</a>
<a href=\"mailto:bmerrill@microsoft.com\">&lt;bmerrill@microsoft.com&gt;</a>
")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; extension to mode mapping
;
(setq auto-mode-alist
      (append '(
		("\\.s?html?\\'" . html-helper-mode)
		("\\.asp$" . html-helper-mode)
		("\\.as[phm]x$" . html-helper-mode)
		("\\.html$" . html-helper-mode)
		("\\.htm$" . html-helper-mode)
                ("\\.md$" . emacs-lisp-mode)
		("\\.txt$" . text-mode)
		("\\.cs$" . csharp-mode)
		) auto-mode-alist ))


(setq-default compile-command "nmake")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Misc
;
(setq max-specpdl-size 1000)
(setq auto-save-interval 200)
(setq-default case-fold-search t)
(setq-default comment-column 40)
(setq completion-auto-help nil)
(setq enable-recursive-minibuffers t)
(setq-default fill-column 64)
(setq inhibit-startup-message t)
(setq insert-default-directory nil)
(setq-default indent-tabs-mode nil)


(load "font-lock")
(setq font-lock-maximum-decoration t)
(global-font-lock-mode t)

;
; html helper
;
(autoload 'html-helper-mode "html-helper-mode" "HTML Helper Mode" t)

(setq-default compilation-error-regexp-alist
 '(
 ; Microsoft JVC:
 ;sample.java(6,1) : error J0020: Expected 'class' or 'interface'
 ("\\(\\([a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)[,]\\([0-9]+\\)) : \\(error\\|warning\\) J[0-9]+:" 1 3 4)

 ; Microsoft C/C++:
 ;  keyboard.c(537) : warning C4005: 'min' : macro redefinition
 ;  d:\tmp\test.c(23) : error C2143: syntax error : missing ';' before 'if'
 ;VC EEi
 ;e:\projects\myce40\tok.h(85) : error C2236: unexpected 'class' '$S1'
 ;myc.cpp(14) : error C3149: 'class System::String' : illegal use of managed type 'String'; did you forget a '*'?
    ("\\(\\([a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) \
: \\(error\\|warning\\) C[0-9]+:" 1 3)
 ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;              C# Mode support
;;;
(autoload 'csharp-mode "cc-mode")

(c-add-style "myC#Style"
  '("C#"
  (c-basic-offset . 2)
  (c-comment-only-line-offset . (0 . 0))
  (c-offsets-alist . (
    (c                     . c-lineup-C-comments)
    (inclass		   . 0)
    (namespace-open	   . +)
    (namespace-close	   . +)
    (innamespace	   . 0)
    (class-open		   . +)
    (class-close	   . +)
    (inclass		   . 0)
    (defun-open		   . +)
    (defun-block-intro     . 0)
    (inline-open	   . +)
    (inline-close	   . 0)
    (statement-block-intro . 0)
    (statement-cont	   . +)
    (brace-list-intro      . +)
    (topmost-intro-cont    . 0)
    (block-open		   . +)
    (block-close	   . 0)
    (arglist-intro	   . +)
;    (arglist-cont	   . 0)
    (arglist-close	   . 0)
    ))
  ))

(defun my-csharp-mode-hook ()
  (cond (window-system
	 (turn-on-font-lock)
	 (c-set-style "myC#Style")
	 )))
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)
(setq auto-mode-alist
      (append '(
		("\\.cs$" . csharp-mode)
		) auto-mode-alist ))

(setq compilation-error-regexp-alist
	(append '(
;C# Compiler
;t.cs(6,18): error SC1006: Name of constructor must match name of class
;
("\\(\\([a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)[,]\\([0-9]+\\)): \\(error\\|warning\\) CS[0-9]+:" 1 3 4)
        )
	compilation-error-regexp-alist))

