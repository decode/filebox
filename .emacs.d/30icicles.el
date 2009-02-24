;;;
;; $Id: 30icicles.el,v 1.21 2007/01/09 04:59:34 rubikitch Exp rubikitch $
;; (eeindex)
;;  INDEX 
;; (to "describe-keymaps")
;; (to "testing icicles config")
;; (to "icicle-self-insert and icicle-exit-minibuffer")
;; (to "locate")
;; (to "icicle-locate-file-by-project")
;; (to "icicle-remap-example")

;;  describe-keymaps 
;; help (view-memofile "icicles-help.txt")

;; (find-ekeymapdescr icicle-mode-map)
;; (find-ekeymapdescr minibuffer-local-completion-map)
;; (find-ekeymapdescr minibuffer-local-must-match-map)
;; (find-ekeymapdescr minibuffer-local-filename-completion-map)

;;  testing icicles config 
;; (eevnow "emacs-snapshot -no-site-file -q -L ~/emacs/lisp/ -L ~/emacs/lisp/icicles -l ~/emacs/init.d/30icicles.el")

(add-to-list 'load-path (expand-file-name "~/.emacs.d/icicles/"))
(require 'icicles)

;;; I prefer modal cycling.
(setq icicle-cycling-respects-completion-mode-flag t)
;;  I HATE arrow keys.
(setq icicle-modal-cycle-up-key "\C-p")
(setq icicle-modal-cycle-down-key "\C-n")


;;; Key bindings
(add-hook 'icicle-mode-hook 'bind-my-icicles-keys)
;; (to "describe-keymaps")
;; Refactored the code in `Icicles - Customizing Key Bindings' at EmacsWiki.
(defun bind-my-icicles-keys ()
  "Replace some default Icicles bindings with others I prefer."
  (when icicle-mode
    (dolist (map (append (list minibuffer-local-completion-map
                               minibuffer-local-must-match-map)
                         (and (boundp 'minibuffer-local-filename-completion-map)
                              (list minibuffer-local-filename-completion-map))))
      (bind-my-icicles-keys--for-completion-map map)
      (bind-my-icicles-keys--for-all-minibuffer-map map))
    (let ((map minibuffer-local-map))
      (bind-my-icicles-keys--for-all-minibuffer-map map))
    (bind-my-icicles-keys--for-icicle-mode-map icicle-mode-map)))
;; test bind-my-icicles-keys -> (bind-my-icicles-keys)

;; [2006/12/25]
;; (to "describe-keymaps")
(defun bind-my-icicles-keys--for-all-minibuffer-map (map)
  (define-key map "\C-e" 'icicle-guess-file-at-point-or-end-of-line)
  (define-key map "\C-k" 'icicle-erase-minibuffer-or-kill-line)  ; M-k or C-k
  )
;; I think default icicles key bindings are hard to type.
(defun bind-my-icicles-keys--for-completion-map (map)
;; (to "icicle-remap-example")
  ;; C-o is next to C-i.
  (define-key map "\C-o" 'icicle-apropos-complete)      ; S-Tab
  ;; Narrowing is isearch in a sense. C-s in minibuffer is rarely used.
  (define-key map "\C-s" 'icicle-narrow-candidates)     ; M-*
  ;; History search is isearch-backward chronologically:-)
  (define-key map "\C-r" 'icicle-history)               ; M-h

  (define-key map "\M-{" 'icicle-previous-prefix-candidate-action) ; C-up
  (define-key map "\M-}" 'icicle-next-prefix-candidate-action) ; C-down
  (define-key map "\C-z" 'icicle-help-on-candidate)            ; C-M-Ret

  ;; I do not use icicles' C-v M-C-v anymore.
  (define-key map "\C-v" 'scroll-other-window) ; M-C-v
  (define-key map "\M-v" 'scroll-other-window-down)
  )
(defun bind-my-icicles-keys--for-icicle-mode-map (map)
  ;; These are already bound in global-map. I'll remap them.
  (define-key map [f5] nil)             ; icicle-kmacro
  (define-key map [pause] nil)          ; 
  )


;; [2006/12/28]  icicle-self-insert and icicle-exit-minibuffer 
;; it is placed BEFORE icy-mode.
(defvar icicle-symbol-keys "!\"#$%&'()~=~|`{}*+<>?_-^\\@[]:;,./ ")
(defvar icicle-exit-minibuffer-and-self-insert-keys nil)
(defvar icicle-exit-minibuffer-and-self-insert-keys-except nil)

(defun icicle-exit-minibuffer-key-p (key)
  (setq key (regexp-quote key))
  (and (string-match key icicle-symbol-keys)
       (cond ((and icicle-exit-minibuffer-and-self-insert-keys
                   icicle-exit-minibuffer-and-self-insert-keys-except))
             (icicle-exit-minibuffer-and-self-insert-keys
              (string-match key icicle-exit-minibuffer-and-self-insert-keys))
             (icicle-exit-minibuffer-and-self-insert-keys-except
              (not (string-match key icicle-exit-minibuffer-and-self-insert-keys-except))))))

;; tests
;; (not (or (icicle-exit-minibuffer-key-p "a") (icicle-exit-minibuffer-key-p "!")))
;; (let ((icicle-exit-minibuffer-and-self-insert-keys "!")) (icicle-exit-minibuffer-key-p "!"))
;; (let ((icicle-exit-minibuffer-and-self-insert-keys "!")) (not (icicle-exit-minibuffer-key-p "#")))
;; (let ((icicle-exit-minibuffer-and-self-insert-keys-except "!")) (not (icicle-exit-minibuffer-key-p "!")))
;; (let ((icicle-exit-minibuffer-and-self-insert-keys-except "!")) (icicle-exit-minibuffer-key-p "#"))

; minibuffer-exit-hook
(defvar icicle-minibuffer-post-exit-insert nil)
(defadvice icicle-self-insert (around icicle-auto-exit-minibuffer activate)
  ""
  (let ((k (this-command-keys)))
    (cond ((icicle-exit-minibuffer-key-p k)
           (setq icicle-minibuffer-post-exit-insert k)
           (icicle-exit-minibuffer)
           )
          (t
           ad-do-it))))
;; (progn (ad-disable-advice 'icicle-self-insert 'around 'icicle-auto-exit-minibuffer) (ad-update 'icicle-self-insert)) 

(defadvice icicle-lisp-complete-symbol (around icicle-auto-exit-minibuffer activate)
  ""
  (setq icicle-exit-minibuffer-and-self-insert-keys "() ")
  ad-do-it
  (and icicle-minibuffer-post-exit-insert (insert icicle-minibuffer-post-exit-insert))
  )
;; (progn (ad-disable-advice 'icicle-lisp-complete-symbol 'around 'icicle-auto-exit-minibuffer) (ad-update 'icicle-lisp-complete-symbol)) 

(defadvice icicle-completing-read (around icicle-auto-exit-minibuffer activate)
  ""
  (unwind-protect
      ad-do-it
    (setq icicle-exit-minibuffer-and-self-insert-keys nil
          icicle-exit-minibuffer-and-self-insert-keys-except nil)))
;; (progn (ad-disable-advice 'icicle-completing-read 'around 'icicle-auto-exit-minibuffer) (ad-update 'icicle-completing-read)) 

;;;; enable icy-mode.
(icicle-mode 1)


;; Historical first: I think it should be the default.
(setq icicle-sort-function 'icicle-historical-alphabetic-p
      icicle-alternative-sort-function 'string-lessp)

(require 'icicles-menu)

;;; [2006/12/25]
;; I had used `ffap' for years, and used ffap's guessing feature.
(defun icicle-guess-file-at-point ()
  "Guess filename at point by the context and insert it."
  (interactive)
  (require 'ffap-)
  (let ((guessed (with-current-buffer icicle-pre-minibuffer-buffer
                   (ffap-guesser))))
    (when guessed
      (icicle-erase-minibuffer)
      (insert guessed))))

(defun icicle-guess-file-at-point-or-end-of-line ()
"This command inserts default filename if point is at the EOL, Because C-e at the EOL is meaningless,"
  (interactive)
  (if (eolp) (icicle-guess-file-at-point))
  (end-of-line))

(defun icicle-erase-minibuffer-or-kill-line ()
  "C-k at the EOL erases whole minibuffer, otherwise do the default."
  (interactive)
  (if (eolp)
      (icicle-erase-minibuffer)
    (kill-line)))

;; I feel yucky if pressing C-g is not notified.
(defadvice icicle-abort-minibuffer-input (before ding activate)
  "Notify when C-g is pressed."
  (ding))
;; (progn (ad-disable-advice 'icicle-abort-minibuffer-input 'before 'ding) (ad-update 'icicle-abort-minibuffer-input)) 

;; [2006/12/28] I do not SELECT other frame.
;; I do not like opening many frames.
;; I do one-on-one by windows.el that is like GnuScreen.
(defalias 'icicle-other-window-or-frame 'other-window)

;; [2007/01/04] same color as transient-mark-mode
(setq icicle-region-background "blue")

;; [2007/01/04] I already know basic usage. The minibuffer width is too short.
(setq icicle-reminder-prompt-flag nil)

;; [2007/01/05] I feel annoying with ding when wrapping candidates.
(defadvice icicle-increment-cand-nb+signal-end (around no-ding activate)
  "Disable `ding' when wrapping candidates."
  (flet ((ding ()))
    ad-do-it))
;; (progn (ad-disable-advice 'icicle-increment-cand-nb+signal-end 'around 'no-ding) (ad-update 'icicle-increment-cand-nb+signal-end)) 

;; [2007/01/09]  locate 
(require 'locate)
(icicle-define-command icicle-locate ; Command name
  "Run the program `locate', then visit files.
Unlike `icicle-locate-file' this command is a wrapper for the program `locate'." ; Doc string
  find-file                             ; Function to perform the action
  "File: " (mapcar #'list (split-string (shell-command-to-string (format "%s '%s'" locate-command query)) "\n" t))
  nil t nil 'locate-history-list nil nil
  ((query (read-string "Locate: "))))

;; [2007/01/09]  icicle-locate-file-by-project 

;; TODO windows-tab, define-key
(defvar project-directory-regexp "^.+/\\(src\\|compile\\)/[^/]+/")
(defvar project-file-ignore-regexp "/\\(RCS\\|.svn\\|_darcs\\)/")
(defun icicle-locate-file-by-project ()
  "Visit a file in current project."
  (interactive)
  (cond ((string-match project-directory-regexp default-directory)
         (let (( default-directory (match-string 0 default-directory))
               ( icicle-show-Completions-initially-flag t)
               ( icicle-expand-input-to-common-match-flag nil)
               ( icicle-must-not-match-regexp project-file-ignore-regexp))
           (call-interactively 'icicle-locate-file)))
        (t
         (error "%s is not a project directory." default-directory))))

;;  icicle-remap-example 
;;       (icicle-remap 'previous-line 'previous-history-element map)
;;       (icicle-remap 'next-line 'next-history-element map)
;;       (define-key map [?\M-p] 'icicle-previous-prefix-candidate)
;;       (define-key map [?\M-n] 'icicle-next-prefix-candidate)

;; How to save (DO NOT REMOVE!!)
;; (let ((oddmuse-wiki "EmacsWiki")(oddmuse-page-name "RubikitchIciclesConfiguration")) (call-interactively 'oddmuse-post))

(provide '30icicles)
