;;;
;; $Id: 99anything.el,v 1.128 2008/01/16 17:35:13 rubikitch Exp $
;; (eeindex)
;; <<<INDEX>>>
;; (to "keymaps")
;; (to "candidate cache by buffer")
;; (to "skk")
;; (to "migemo")
;; (to "candidate-transformer for buffers")
;; (to "candidate-transformer for files")
;; (to "action extension")
;; (to "my extension: select other actions by key")
;; (to "my sources")
;; (to " switch commands")
;; (to " candidates from file")
;; (to "  rubylib")
;; (to "  rubylib-18")
;; (to "  rubylib-19")
;; (to " find-library")
;; (to " directory-files")
;; (to "  ruby18-source")
;; (to "  ruby19-source")
;; (to "  elinit")
;; (to " extended-command-history")
;; (to " escript-link")
;; (to "  dynamic-escript-link")
;; (to "   rtb")
;; (to "   langhelp-ruby")
;; (to "  static-escript-link")
;; (to "   refe2x")
;; (to "   music")
;; (to " imenu (improved)")
;; (to " rake-task")
;; (to " tvavi")
;; (to " eev-anchor")
;; (to " bm")
;; (to " test source")
;; (to " frequently used commands")
;; (to "  frequently used commands - keymap")
;; (to " abbrev")
;; (to " edit abbrev files")
;; (to " dummy source")
;; (to "  buffer not found")
;; (to "  bookmark-set")
;; (to "  define-global-abbrev")
;; (to "  define-mode-abbrev")
;; (to "  M-x")
;; (to " winconf-pop")
;; (to " commands for current buffer")
;; (to " commands for insertion")
;; (to " KYR")
;; (to "  KYR vars")
;; (to " registers")
;; (to "new sources")
;; (to "persistent-action")
;; (to "type attribute helper")
;; (to "type attributes")
;; (to "anything-set-source-filter")
;; (to "anything-insert-buffer-name")
;; (to "anything-current-buffer")
;; (to "anything for current-buffer")
;; (to "anything for insert")
;; (to "abbrev or anything-for-insertion")
;; (to "sources")
;; (to " anything-for-insertion-sources")
;; (to " anything-for-current-buffer-sources")
;; (to " anything-sources")
;; (to "%s")

;; [2007/07/25]
(require 'anything-config)
(require 'anything)
(setq anything-idle-delay 0.3)
(setq anything-candidate-number-limit 100)
(setq anything-c-locate-db-file "/log/home.simple.locatedb")
(setq anything-c-locate-options `("locate" "-d" ,anything-c-locate-db-file "-i" "-r" "--"))
;; [2008/01/02]
;;(view-elinit "sticky" "anything-map")

;; [2008/01/14]
(require 'anything-dabbrev-expand)
(define-key anything-dabbrev-map [(control ?@)] 'anything-dabbrev-find-all-buffers)


;; <<<keymaps>>>
;; (find-ekeymapdescr anything-map)
;;(define-key anything-map "\C-k" 'anything-select-action-in-minibuffer)
;;(define-key anything-map "\C-k" (lambda () (interactive) (delete-minibuffer-contents)))
(setq anything-map-C-j-binding 'anything-select-3rd-action)
(define-key anything-map "\C-j" anything-map-C-j-binding)
(define-key anything-map "\C-e" 'anything-select-2nd-action-or-end-of-line)
(define-key anything-map "\M-N" 'anything-next-source)
(define-key anything-map "\M-P" 'anything-previous-source)
(define-key anything-map "\C-\M-n" 'anything-next-source)
(define-key anything-map "\C-\M-p" 'anything-previous-source)
(define-key anything-map "\C-s" 'anything-isearch)
(define-key anything-map "\C-p" 'anything-previous-line)
(define-key anything-map "\C-n" 'anything-next-line)
(define-key anything-map "\C-v" 'anything-next-page)
(define-key anything-map "\M-v" 'anything-previous-page)
(define-key anything-map "\C-z" 'anything-execute-persistent-action)
(define-key anything-map "\C-i" 'anything-select-action)
(define-key anything-map "B" 'anything-insert-buffer-name)
(define-key anything-map "R" 'anything-show/rubyref)
(define-key anything-map "C" 'anything-show/create)
(define-key anything-map "\C-k" 'anything-show/create)
(define-key anything-map "\C-b" 'anything-backward-char-or-insert-buffer-name)
(define-key anything-map "\C-o" 'anything-next-source)
;; (to " frequently used commands - keymap")

;; [2008/01/16] <<<candidate cache by buffer>>>
(defvar anything-candidate-cache-by-buffer nil)
(make-variable-buffer-local 'anything-candidate-cache-by-buffer)
(defun anything-get-cached-candidates (source)
  "Return the cached value of candidates for SOURCE.
Cache the candidates if there is not yet a cached value."
  (let* ((name (assoc-default 'name source))
         (candidate-cache (assoc name anything-candidate-cache))
         candidates cached-tick tick)

    (if candidate-cache
        (setq candidates (cdr candidate-cache))
      (unless (with-current-buffer anything-current-buffer
                (and (assoc 'invariant source)
                     (eq (setq tick (buffer-modified-tick))
                         (setq cached-tick (assoc-default 'tick anything-candidate-cache-by-buffer)))
                     (setq candidates (assoc-default name anything-candidate-cache-by-buffer))))
               
        (setq candidates (anything-get-candidates source))

        (if (processp candidates)
            (progn
              (push (cons candidates
                          (append source 
                                  (list (cons 'item-count 0)
                                        (cons 'incomplete-line ""))))
                    anything-async-processes)
              (set-process-filter candidates 'anything-output-filter)
              (setq candidates nil))

          (unless (assoc 'volatile source)
            (setq candidate-cache (cons name candidates))
            (push candidate-cache anything-candidate-cache)
            (with-current-buffer anything-current-buffer
              (unless (eq tick cached-tick)
                (setq anything-candidate-cache-by-buffer
                      `((tick . ,tick))))
              (push candidate-cache anything-candidate-cache-by-buffer)))))
      candidates)))
(byte-compile 'anything-get-cached-candidates)

;; [2007/09/28] <<<skk>>>
;; (view-elinit "skk" "(defvar minibuffer-use-skk nil")
(defun anything-skk (with-skk)
  (interactive "P")
  (let ((minibuffer-use-skk with-skk))
    (define-key anything-map "\C-j" anything-map-C-j-binding)
    (anything)))

;; <<<migemo>>>
(require 'anything-migemo)

;; <<<candidate-transformer for buffers>>>
(defvar anything-c-boring-buffer-regexp
  (rx (or
       ;; because of switch commands (to "switch commands")
       "tvprog-keyword.txt" "tvprog.html" ".crontab" "+inbox"
       ;; internal use only
       "*windows-tab*"
       ;; caching purpose
       "*refe2x:" "*refe2:" "ri `")))

(defun anything-c-skip-boring-buffers (buffers)
  (remove-if (lambda (buf) (and (stringp buf) (string-match anything-c-boring-buffer-regexp buf)))
             buffers))

(defun anything-c-skip-current-buffer (buffers)
  (remove (buffer-name anything-current-buffer) buffers))

(defun anything-c-transform-navi2ch-article (buffers)
  (loop for buf in buffers collect
        (if (string-match "^\\*navi2ch article" buf)
            (cons (with-current-buffer buf
                    (format "[navi2ch:%s]%s" 
                            (cdr (assq 'id navi2ch-article-current-board))
                            (navi2ch-article-get-current-subject)))
                  buf)
          buf)))

;; <<<candidate-transformer for files>>>
(defun anything-c-skip-opened-files (files)
  (set-difference files
                  (mapcan (lambda (file) (list file (abbreviate-file-name file)))
                          (delq nil (mapcar #'buffer-file-name (buffer-list))))
                  :test #'string=))

(add-to-list 'anything-c-source-file-cache '(candidate-transformer . anything-c-skip-opened-files))

;; [2007/12/25] <<<action extension>>>
(defun anything-c-action-replace (source new-action)
  (setf (cdr (assq 'action (symbol-value source))) new-action)
  (symbol-value source))

(defun anything-c-action-extend (description function)
  `((,(concat description " (new window)") . (lambda (c) (with-new-window (,function c))))
    (,description . ,function)
    (,(concat description " (other window)") . (lambda (c)
                                                 (when (one-window-p)
                                                   (select-window (split-window)))
                                                 (,function c)))))

(anything-c-action-replace
 'anything-c-source-man-pages
 (anything-c-action-extend "Show with Woman" 'woman))

;; (setq anything-sources (list anything-c-source-man-pages))

(defun anything-c-info (node-str)
  (info (replace-regexp-in-string "^[^:]+: " "" node-str)))

(anything-c-action-replace
 'anything-c-source-info-pages
 (anything-c-action-extend "Show with Info" 'anything-c-info))
;; (setq anything-sources (list anything-c-source-info-pages))

(anything-c-action-replace
 'anything-c-source-bookmarks
 (append                                ;[2007/12/30]
  (anything-c-action-extend "Jump to Bookmark" 'bookmark-jump)
  '(("Update Bookmark" . bookmark-set)
    ("Delete Bookmark" . bookmark-delete))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  <<<my extension: select other actions by key>>>                   ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar anything-select-in-minibuffer-keys "\C-m\C-a\C-s\C-k\C-d\C-f\C-j\C-l")
(defvar anything-saved-action nil
  "Saved value of the currently selected action by key.")

;; It is based on anything-select-action, so it needs refactoring.
(defun anything-select-action-in-minibuffer ()
  "Select an action for the currently selected candidate in minibuffer."
  (interactive)
  (if anything-saved-sources
      (error "Already showing the action list"))

  (setq anything-saved-selection (anything-get-selection))
  (unless anything-saved-selection
    (error "Nothing is selected."))

  (let ((actions (anything-get-action)))
    (message "%s" (apply #'concat
                         (loop for action in actions
                               for i from 0 collecting
                               (format "[%c]%s\n"
                                       (elt anything-select-in-minibuffer-keys i)
                                       (car action)))))
    (let* ((key (read-char))
           (idx (rindex anything-select-in-minibuffer-keys key)))
      (or idx (error "bad selection"))
      (setq anything-saved-action (cdr (elt actions idx)))
      (anything-exit-minibuffer))))

(defun anything-select-nth-action (n)
  (setq anything-saved-selection (anything-get-selection))
  (unless anything-saved-selection
    (error "Nothing is selected."))
  (setq anything-saved-action (cdr (elt (anything-get-action) n)))
  (anything-exit-minibuffer))

(defun anything-select-2nd-action-or-end-of-line ()
  (interactive)
  (if (eolp)
      (anything-select-nth-action 1)
    (end-of-line)))

(defun anything-select-3rd-action ()
  (interactive)
  (anything-select-nth-action 2))

;; Redefined
(defun anything-execute-selection-action ()
  "If a candidate was selected then perform the associated
action."
  (let* ((selection (if anything-saved-sources
                        ;; the action list is shown
                        anything-saved-selection
                      (anything-get-selection)))
         (action (or anything-saved-action
                     (if anything-saved-sources
                         ;; the action list is shown
                         (anything-get-selection)
                       (anything-get-action)))))

    (if (and (listp action)
             (not (functionp action))) ; lambda
        ;;select the default action
        (setq action (cdar action)))
    (setq anything-saved-action nil)
    (if (and selection action)
        (funcall action selection))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; [2007/12/25] <<<my sources>>>                                      ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; [2007/08/05] <<< switch commands>>>
(defvar anything-c-switch-commands nil)
(defvar anything-c-source-switch-commands
  '((name . "Switch Commands")
    (candidates . anything-c-switch-commands)
    (type . command-ext)))

(defmacro define-switch-command (command &rest body)
  `(progn
     (defun ,command ()
       (interactive)
       ,@body)
     (defun ,(intern (concat "win-" (symbol-name command))) ()
       (interactive)
       (with-new-window (,command)))
     (add-to-list 'anything-c-switch-commands (symbol-name ',command))))

(define-switch-command tvprog-cron-all
  (find-file "/log/tvprog.html")
  (find-file-other-window "~/.crontab")
  (other-window 1))

(define-switch-command tvprog-cron
  (find-file "/log/tvprog-keyword.txt")
  (find-file-other-window "~/.crontab")
  (other-window 1))

(define-switch-command inbox
  (mew))

(define-switch-command navi2ch-session
  (unless navi2ch-opened-urls-loaded
    (navi2ch-load-opened-urls)
    (setq navi2ch-opened-urls-loaded t))
  (setq anything-c-switch-commands
        (delete "navi2ch-session" anything-c-switch-commands)))

(add-to-list 'anything-c-switch-commands "hatena")
(add-to-list 'anything-c-switch-commands "emacswiki")
(add-to-list 'anything-c-switch-commands "add-mode-specific-abbrev")
(add-to-list 'anything-c-switch-commands "add-global-abbrev")


;; [2008/01/07] <<< candidates from file>>>
;; TODO rewrite anything-c-source-escript with it
(defvar anything-c-cached-candidates nil)
(defvar anything-c-cached-tick nil)
(make-variable-buffer-local 'anything-c-cached-candidates)
(make-variable-buffer-local 'anything-c-cached-tick)
(defun anything-c-source-from-file (desc filename &rest other-attrib)
  `((name . ,desc)
    (candidates
     . (lambda ()
         (unless (get-file-buffer ,filename)
           (with-current-buffer (find-file-noselect ,filename)
           (auto-revert-mode 1)))
         (with-current-buffer (get-file-buffer ,filename)
           (if (eq anything-c-cached-tick (buffer-modified-tick))
               anything-c-cached-candidates
             (setq anything-c-cached-tick (buffer-modified-tick)
                   anything-c-cached-candidates
                   (mapcar (lambda (line)
                             (let ((pair (split-string line "\t" t)))
                               (if (cdr pair) (cons (car pair) (cadr pair)) line)))
                           (split-string
                            (buffer-substring-no-properties (point-min) (point-max))
                            "\n" t)))))))
    ;; candidate-transformer is not needed because the file is auto-generated.
    (candidate-transformer)
    ,@other-attrib))


;; deprecated <<<  rubylib>>>
(defvar anything-c-source-rubylib
  `((name . "Ruby libraries")
    (requires-pattern . 3)
    (match (lambda (candidate) t))
    (candidates  "find rubylib")
    (filtered-candidate-transformer
     . (lambda (candidates source)
         `((,(concat "Find rubylib: " anything-pattern) . ,anything-pattern))))
    (volatile)
    (action ,@(anything-c-action-extend "Find Ruby Library" 'find-rubylib))))
;; [2008/01/07] <<<  rubylib-18>>>
(defvar anything-c-source-rubylib-18
  (anything-c-source-from-file "Ruby 1.8 libraries" "/log/ruby-libraries.18"
                               '(requires-pattern . 4)
                               '(type . file)))
;; [2008/01/07] <<<  rubylib-19>>>
(defvar anything-c-source-rubylib-19
  (anything-c-source-from-file "Ruby 1.9 libraries" "/log/ruby-libraries.19"
                               '(requires-pattern . 4)
                               '(type . file)))
;; (setq anything-sources (list anything-c-source-rubylib))
;; <<< find-library>>>
(defvar anything-c-source-find-library
  `((name . "Elisp libraries")
    (requires-pattern . 3)
    (match (lambda (candidate) t))
    (candidates  "find elisp")
    (filtered-candidate-transformer
     . (lambda (candidates source)
         (let ((lib (locate-library anything-pattern)))
           (and lib (list lib)))))
    (volatile)
    (requires-pattern . 2)
    (action ,@(anything-c-action-extend "Find Elisp Library" 'find-library))))
;; (setq anything-sources (list anything-c-source-find-library))

;; <<< directory-files>>>
(defun anything-c-transform-file-name-nondirectory (files)
  (mapcar (lambda (f) (cons (file-name-nondirectory f) f)) files))
(defun anything-c-source-files-in-dir (desc dir &optional match skip-opened-file)
  `((name . ,desc)
    (candidates . (lambda () (directory-files ,dir t ,match)))
    (candidate-transformer
     . (lambda (candidates)
         (anything-c-compose (list candidates)
                             '(,@(if skip-opened-file (list 'anything-c-skip-opened-files))
                               anything-c-transform-file-name-nondirectory))))
    (type . file)))

(progn
  ;; <<<  ruby18-source>>>
  (setq anything-c-source-ruby18-source
        (anything-c-source-files-in-dir
         "Ruby 1.8 Source" "~/compile/ruby-1.8.6-p111/" "\\.[ch]$" t))
  ;; <<<  ruby19-source>>>
  (setq anything-c-source-ruby19-source
        (anything-c-source-files-in-dir
         "Ruby 1.9 Source" "~/compile/ruby-1.9.0-0/" "\\.[ch]$" t))
  ;; <<<  elinit>>>
  (setq anything-c-source-elinit
        (anything-c-source-files-in-dir
         "Emacs init files" "~/emacs/init.d/" "^_?[0-9]+.+\.el$"))
  ;; (setq anything-sources (list anything-c-source-elinit))
  )
;; <<< extended-command-history>>>
(defvar anything-c-source-extended-command-history
  '((name . "Emacs Commands History")
    (candidates . extended-command-history)
    (type . command)))
;; (setq anything-sources (list anything-c-source-extended-command-history))

;; <<< escript-link>>>
;; <<<  dynamic-escript-link>>>
(defun anything-c-action-escript (filename)
  '(with-current-buffer (find-file-noselect filename)
    (goto-char (point-min))
    (when (search-forward cand nil t)
      (eek-eval-last-sexp))))

(defun anything-c-source-escript (desc filename &rest other-attrib)
  `((name . ,desc)
    (invariant)
    (candidates
     . (lambda ()
         (remove-if-not (lambda (line) (string-match "^#" line))
                        (split-string
                         (with-current-buffer (find-file-noselect ,filename)
                           (buffer-substring-no-properties (point-min) (point-max)))
                         "\n" t))))
    ,@other-attrib
    (action
     ("Eval it"
      . (lambda (cand) (with-current-buffer (find-file-noselect ,filename)
                         (goto-char (point-min))
                         (when (search-forward cand nil t)
                           (eek-eval-last-sexp))))))
    (persistent-action
     . (lambda (cand) (with-current-buffer (find-file-noselect ,filename)
                        (goto-char (point-min))
                        (when (search-forward cand nil t)
                          (let ( ( max-mini-window-height 1)
                                 special-display-buffer-names special-display-regexps)
                            (eek-eval-last-sexp))))))))
;; <<<   rtb>>>
(defvar anything-c-source-rtb
      (anything-c-source-escript "RTB" "~/src/rtb/index.e"))
;; <<<   langhelp-ruby>>>
(defvar anything-c-source-langhelp-ruby
      (anything-c-source-escript "Langhelp ruby" "~/.langhelp/ruby.e"
                                 '(delayed) '(requires-pattern . 3) '(category rubyref)))
(setq anything-c-source-langhelp-ruby
      (anything-c-source-escript "Langhelp ruby" "/tmp/test.e"
                                 '(category rubyref)))
;; (setq anything-sources (list anything-c-source-rtb))
;; (setq anything-sources (list anything-c-source-langhelp-ruby))

;; <<<  static-escript-link>>>
(defun anything-c-source-static-escript (symbol desc filename &rest other-attrib)
  `((name . ,desc)
    (candidates . ,symbol)
    ,@other-attrib
    (init
     . (lambda ()
         (unless (and (boundp ',symbol) ,symbol)
           (with-current-buffer (find-file-noselect ,filename)
             (setq ,symbol (split-string (buffer-string) "\n" t))))))
    (action
     ("Eval it"
      . (lambda (cand)
          (with-temp-buffer
            (insert cand)
            (cd ,(file-name-directory filename))
            (backward-sexp 1)
            (eval (read (current-buffer)))))))))

;; <<<   refe2x>>>
;; (setq anything-sources (list anything-c-source-refe2))
(defvar anything-c-source-refe2x
      (anything-c-source-static-escript
       'anything-c-refe2x-candidates "ReFe2x"
       "~/compile/ruby-refm-1.9.0-dynamic/bitclust/refe2x.e"
       '(requires-pattern . 3)
       '(category rubyref)))
;; <<<   music>>>
(defvar anything-c-source-music
      (anything-c-source-static-escript
       'anything-c-music-candidates "Music"
       "~/music/list"
       '(delayed)
       '(requires-pattern . 4)))
;; (setq anything-sources (list anything-c-source-music))


;; [2008/01/07] <<< imenu (improved)>>>
(defvar anything-c-imenu-delimiter " -> ")
(defvar anything-c-cached-imenu-alist nil)
(defvar anything-c-cached-imenu-candidates nil)
(defvar anything-c-cached-imenu-tick nil)
(make-variable-buffer-local 'anything-c-cached-imenu-alist)
(make-variable-buffer-local 'anything-c-cached-imenu-candidates)
(make-variable-buffer-local 'anything-c-cached-imenu-tick)
;; (setq anything-c-source-imenu
;;       '((name . "Imenu")
;;         (init . (lambda ()
;;                   (setq anything-c-imenu-current-buffer
;;                         (current-buffer))))
;;         (candidates
;;          . (lambda ()
;;              (with-current-buffer anything-c-imenu-current-buffer
;;                (let ((tick (buffer-modified-tick)))
;;                  (if (eq anything-c-cached-imenu-tick tick)
;;                      anything-c-cached-imenu-candidates
;;                    (setq anything-c-cached-imenu-tick tick
;;                          anything-c-cached-imenu-candidates
;;                          (condition-case nil
;;                              (mapcan
;;                               (lambda (entry)
;;                                 (if (listp (cdr entry))
;;                                     (mapcar (lambda (sub)
;;                                               (concat (car entry) anything-c-imenu-delimiter (car sub)))
;;                                             (cdr entry))
;;                                   (list (car entry))))
;;                               (setq anything-c-cached-imenu-alist (imenu--make-index-alist)))
;;                            (error nil))))))))
;;         (action
;;          . anything-c-imenu)
;;         (persistent-action
;;          . (lambda (entry)
;;              (anything-c-imenu entry)
;;              (set-window-start (get-buffer-window anything-current-buffer) (point))))))

;; [2008/01/16] invariant
(setq anything-c-source-imenu
      '((name . "Imenu")
        (candidates
         . (lambda ()
             (with-current-buffer anything-current-buffer
               (setq anything-c-cached-imenu-candidates
                     (condition-case nil
                         (mapcan
                          (lambda (entry)
                            (if (listp (cdr entry))
                                (mapcar (lambda (sub)
                                          (concat (car entry) anything-c-imenu-delimiter (car sub)))
                                        (cdr entry))
                              (list (car entry))))
                          (setq anything-c-cached-imenu-alist (imenu--make-index-alist)))
                       (error nil))))))
        (invariant)
        (action . anything-c-imenu)
        (persistent-action
         . (lambda (entry)
             (anything-c-imenu entry)
             (set-window-start (get-buffer-window anything-current-buffer) (point))))))

(defun anything-c-imenu (entry)
  (let* ((pair (split-string entry anything-c-imenu-delimiter))
         (first (car pair))
         (second (cadr pair)))
    (imenu
     (if second
         (assoc second (cdr (assoc first anything-c-cached-imenu-alist)))
       (assoc entry anything-c-cached-imenu-alist)))))

;; (f "Variables/anything-c-boring-buffer-regexp")


;; [2007/12/31] <<< rake-task>>>
(defvar anything-c-source-rake-task
  '((name . "Rake Task")
    (candidates
     . (lambda ()
         (when (string-match "^rake" anything-pattern)
           (cons '("rake" . "rake")
                 (mapcar (lambda (line)
                           (cons line (car (split-string line " +#"))))
                         (with-current-buffer anything-current-buffer
                           (split-string (shell-command-to-string "rake -T") "\n" t)))))))
    (action ("Compile" . compile)
            ("Compile with command-line edit"
             . (lambda (c) (let ((compile-command (concat c " ")))
                             (call-interactively 'compile)))))
    (requires-pattern . 4)))
;; (setq anything-sources (list anything-c-source-rake-task))

;; [2007/12/31] <<< tvavi>>>
(defvar anything-c-source-tvavi
  '((name . "TV avi")
    (candidates "tvavi" "tvavi:dvdr" "tvavi:dvdram")
    (action . identity)
    (action-transformer . anything-c-tvavi-get-actions)
    (requires-pattern . 4)))
(defun anything-c-tvavi-get-actions (actions candidates)
  (case (intern (anything-get-selection))
    ('tvavi (anything-c-tvavi-get-actions/tv "/tv/"))
    ('tvavi:dvdr (anything-c-tvavi-get-actions/filelist "~/filelist/dvdr/" "/dvdr/"))
    ('tvavi:dvdram (anything-c-tvavi-get-actions/filelist "~/filelist/dvdram/" "/d/"))))
(defun anything-c-tvavi-get-actions/tv (dir)
  (mapcar (lambda (avi)
            (let* ((attrib (file-attributes avi))
                   (mtime (nth 5 attrib))
                   (size (nth 7 attrib))
                   (basename (file-name-nondirectory avi)))
            `(,(format "%s %s %s" (format-time-string "%m/%d" mtime) size basename)
              . (lambda (c)
                  (start-process-shell-command "*tvavi*" "*tvavi*" 
                                               ,(format "m '%s' > /dev/null 2>&1" avi))))))
          (directory-files dir t ".avi$")))
(defun anything-c-tvavi-get-actions/filelist (dir mountdir)
  (loop for file in (directory-files dir t "[^.]$")
        append
        (with-current-buffer (find-file-noselect file)
          (goto-char 1)
          (let ((id (and (re-search-forward "^## id:\\(.+\\)$")
                         (match-string-no-properties 1)))
                actions)
            (while (re-search-forward "^ *\\([0-9]+\\) \\(.+avi\\)$" nil t)
              (push 
               `(,(format "#%s %s %s" id
                          (match-string-no-properties 1)
                          (match-string-no-properties  2))
                 . (lambda (c)
                     (start-process-shell-command
                      "*tvavi*" "*tvavi*" 
                      ,(format "mount %s ; m '%s%s' > /dev/null 2>&1; umount %s"
                               mountdir mountdir (match-string-no-properties 2) mountdir))))
               actions))
            actions))))
;; (anything-c-tvavi-get-actions/tv "/tv/")
;; (anything-c-tvavi-get-actions/filelist "~/filelist/dvdram/" "/d/")
;; (length (anything-c-tvavi-get-actions/filelist "~/filelist/dvdram/" "/dvdr/"))
;; (setq anything-sources (list anything-c-source-tvavi))

;; [2008/01/04] <<< eev-anchor>>>
(defvar anything-c-source-eev-anchor
  '((name . "Anchors")
    (invariant)
    (candidates . (lambda ()
                    (save-excursion
                      (set-buffer anything-current-buffer)
                      (goto-char (point-min))
                      (let (anchors)
                        (while (re-search-forward (format ee-anchor-format "\\(.+\\)") nil t)
                          (push (match-string-no-properties 1) anchors))
                        (nreverse anchors)))))

    (action . ee-to)))
;; (setq anything-sources (list anything-c-source-eev-anchor))

;; [2008/01/04] by Matsuyama <<< bm>>>
(require 'bm)
(defvar anything-c-source-bm
  '((name . "Visible Bookmarks")
    (invariant)
    (init . (lambda ()
              (let ((bookmarks (bm-lists)))
                (setq anything-bm-marks
                      (delq nil
                            (mapcar (lambda (bm)
                                      (let ((start (overlay-start bm))
                                            (end (overlay-end bm)))
                                        (if (< (- end start) 2)
                                            nil
                                          (format "%7d: %s"
                                                  (line-number-at-pos start)
                                                  (buffer-substring start (1- end))))))
                                    (append (car bookmarks) (cdr bookmarks))))))))
    (candidates . (lambda ()
                    anything-bm-marks))
    (action . (("Goto line" . (lambda (candidate)
                                (goto-line (string-to-number candidate))))))))




;; [2008/01/07] <<< test source>>>
;; REDEFINED!
(defvar anything-c-source-test
  '((name . "Test Source")
    (candidates
     . (lambda ()
         (with-current-buffer anything-current-buffer
           (p "in candidates function")
           '("a" "b"))))
    (action . print)
    (invariant)))

;; (setq anything-sources (list anything-c-source-test))

;; [2008/01/12] <<< frequently used commands>>>
(defvar anything-c-frequently-used-commands
  '("anything-update-vars" "icicle-execute-extended-command"))
(defvar anything-c-source-frequently-used-commands
  '((name . "Frequently used commands")
    (candidates
     . (lambda ()
         (when (member anything-pattern anything-c-frequently-used-commands)
           (list anything-pattern))))
    (volatile)
    (action
     . (lambda (candidate)
         (call-interactively (intern candidate))))))
;; (setq anything-sources (list anything-c-source-frequently-used-commands))
;; [2008/01/12] <<<  frequently used commands - keymap>>>
(loop for (command . key)
      in '(("anything-update-vars" . "U")
           ("icicle-execute-extended-command" . "\C-x"))
      do (define-key anything-map key
           `(lambda ()
              (interactive)
              (delete-minibuffer-contents)
              (insert ,command)
              (anything-check-minibuffer-input)
              (anything-exit-minibuffer))))

;; [2008/01/12] <<< abbrev>>>
;; It depends on  structure of `insert-abbrev-table-description' output.
(defun anything-c-abbrev-candidates (table-sym)
  (with-temp-buffer
    (let ((table (with-current-buffer anything-current-buffer
                   (symbol-value table-sym))))
      (insert-abbrev-table-description
       (abbrev-table-name  table)
       nil)
      (goto-char 0)
      (let ((abbrevs (car (cdaddr (read (current-buffer))))))
        (mapcar
         (lambda (abb)
           (let ((name (car abb))
                 (desc (if (and (equal "" (cadr abb)) )
                           (setq desc (format "%s" (cadadr (caddr (caddr abb)))))
                         (setq desc (cadr abb)))))
             (list (format "%s: %s" name
                           (replace-regexp-in-string
                            "\n" " "
                            (truncate-string-to-width desc (- (window-width) 15))))
                   name table)))
         abbrevs)))))
;; (equal a (anything-c-abbrev-candidates 'local-abbrev-table))

(defvar anything-c-source-abbrev-local nil)
(defvar anything-c-source-abbrev-global nil)
(let ((actions '(action ("expand" . (lambda (c)
                                      (let ((p (point)))
                                        (insert " " (car c))
                                        (expand-abbrev)
                                        (save-excursion
                                          (goto-char p)
                                          (delete-char 1))
                                      )))
                        ("undefine" . (lambda (c)
                                        (define-abbrev (cadr c) (car c) nil))))))
  (setq anything-c-source-abbrev-local
    `((name . "Local Abbrev")
      (candidates . (lambda () (anything-c-abbrev-candidates 'local-abbrev-table)))
      ,actions))
  ;; (setq anything-sources (list anything-c-source-abbrev-local))
  (setq anything-c-source-abbrev-global
    `((name . "Global Abbrev")
      (candidates . (lambda () (anything-c-abbrev-candidates 'global-abbrev-table)))
      ,actions))
  ;; (setq anything-sources (list anything-c-source-abbrev-global))
  )
;; [2008/01/13] <<< edit abbrev files>>>
(defvar anything-c-source-find-abbrev-file
  '((name . "Abbrev file")
    (init
     . (lambda ()
         (setq anything-c-abbrev-dir
               (expand-file-name
                (with-current-buffer anything-current-buffer
                  (symbol-name major-mode))
                abbrev-files-directory))))
    (candidates
     . (lambda ()
         (let ((abbrev-dir anything-c-abbrev-dir))
           (and (file-directory-p abbrev-dir)
                (directory-files abbrev-dir t "^[^\\.]")))))
    (filtered-candidate-transformer
     . (lambda (candidates source)
         `(,@candidates
           (,(concat "*New abbrev file* '" anything-input "'") .
            ,(expand-file-name (concat anything-input ".abbrev") anything-c-abbrev-dir)))))
    (type . file)))
;; (setq anything-sources (list anything-c-source-find-abbrev-file))

;; [2008/01/13] <<< dummy source>>>
(defun anything-c-define-dummy-source (name func &rest other-attrib)
  `((name . ,name)
    (candidates "dummy")
    ,@other-attrib
    (filtered-candidate-transformer
     . (lambda (candidates source)
         (funcall ',func)))
    (requires-pattern . 1)
    (volatile)
    (category create)))

(defun anything-c-dummy-candidate ()
  ;; `source' is defined in filtered-candidate-transformer
  (list (cons (concat (assoc-default 'name source) 
                      " '" anything-input "'")
              anything-input)))  

;; [2007/12/28] <<<  buffer not found>>>
(defvar anything-c-source-buffer-not-found
  (anything-c-define-dummy-source
   "Create buffer"
   (lambda () (unless (get-buffer anything-input)
                (anything-c-dummy-candidate)))
   '(type . buffer)))
;; (setq anything-sources (list anything-c-source-buffer-not-found))

;; [2007/12/30] <<<  bookmark-set>>>
(defvar anything-c-source-bookmark-set
  (anything-c-define-dummy-source
   "Set Bookmark"
   #'anything-c-dummy-candidate
   '(action . bookmark-set)))
;; (setq anything-sources (list anything-c-source-bookmark-set))

;; [2008/01/15] <<<  define-global-abbrev>>>
(defun define-abbrev-interactively (abbrev &optional table)
  (let ((expansion (read-string (format "abbrev(%s) expansion: " abbrev))))
    (define-abbrev (or table global-abbrev-table) abbrev expansion)
    (insert expansion)))
(defun define-mode-abbrev-interactively (abbrev)
  (define-abbrev-interactively abbrev local-abbrev-table))

(defvar anything-c-source-define-global-abbrev
  (anything-c-define-dummy-source
   "Define Global Abbrev"
   #'anything-c-dummy-candidate
   '(action . define-abbrev-interactively)))
;; (setq anything-sources (list anything-c-source-define-global-abbrev))

;; [2008/01/15] <<<  define-mode-abbrev>>>
(defvar anything-c-source-define-mode-abbrev
  (anything-c-define-dummy-source
   "Define Mode-specific Abbrev"
   #'anything-c-dummy-candidate
   '(action . define-mode-abbrev-interactively)))
;; (setq anything-sources (list anything-c-source-define-mode-abbrev))

;; [2008/01/15] <<<  M-x>>>
(defvar anything-c-source-M-x
  (anything-c-define-dummy-source
   "M-x"
   #'anything-c-dummy-candidate
   '(type . command)))
;; (setq anything-sources (list anything-c-source-M-x))

;; [2008/01/14] <<< winconf-pop>>>
(defvar anything-c-source-winconf-pop
  '((name . "winconf-pop")
    (candidates . ("winconf-pop"))
    (type . command))
  "This source is intended to display `winconf-pop' command at the top of candidates.")
;; (setq anything-sources (list anything-c-source-winconf-pop))


;; [2008/01/14] helper
(defun anything-c-create-format-commands-with-description (alist)
  (loop for (cmd . desc) in alist
        collect (cons (format "%s: %s" cmd desc) cmd)))

;; [2008/01/14] <<< commands for current buffer>>>
(defvar anything-c-commands-for-current-buffer
  (anything-c-create-format-commands-with-description
   '(;; column-marker
     ("column-marker-1" . "Highlight column with green")
     ("column-marker-2" . "Highlight column with blue")
     ("column-marker-3" . "Highlight column with red")
     ("column-marker-turn-off-all" . "Remove all highlight by column-marker")

     ;; markerpen
     ("markerpen-clear-all-marks" . "Clear all markerpens")
     ("markerpen-clear-region" . "Clear markerpen of region")
     ("markerpen-mark-region-1" . "Highlight region with color")
     ("markerpen-mark-region-2" . "Highlight region with color")
     ("markerpen-mark-region-3" . "Highlight region with color")
     ("markerpen-mark-region-4" . "Highlight region with color")
     ("markerpen-mark-region-5" . "Highlight region with color")
     ("markerpen-mark-region-6" . "Highlight region with color")
     ("markerpen-mark-region-7" . "Highlight region with color")
     ("markerpen-mark-region-8" . "Highlight region with color")
     ("markerpen-mark-region-9" . "Highlight region with color")
     ("markerpen-mark-region-10" . "Highlight region with color")

     )))
  
(defvar anything-c-source-commands-for-current-buffer
  '((name . "Commands for current buffer")
    (candidates . anything-c-commands-for-current-buffer)
    (type . command)))

;; [2008/01/14] <<< commands for insertion>>>
(defvar anything-c-commands-for-current-insertion
  (anything-c-create-format-commands-with-description
   '()))
(defvar anything-c-source-commands-for-insertion
  '((name . "Commands for current buffer")
    (candidates . anything-c-commands-for-current-insertion)
    (type . command)))

;; [2008/01/14] <<< KYR>>>
(defvar anything-kyr-candidates nil)
(defvar anything-kyr-functions nil)
(defvar anything-c-source-kyr
  '((name . "Context-aware Commands")
    (candidates . anything-kyr-candidates)
    (type . command)))
(defvar anything-kyr-commands-by-major-mode nil)
;; (setq anything-sources (list anything-c-source-kyr))
(defun anything-kyr-candidates ()
  (loop for func in anything-kyr-functions
        append (with-current-buffer anything-current-buffer (funcall func))))
(defun anything-kyr-commands-by-major-mode ()
  (assoc-default major-mode anything-kyr-commands-by-major-mode))

(define-switch-command add-kyr-command
  (interactive)
  (find-elinit "anything" '(anchor . "  KYR vars")))
;; <<<  KYR vars>>>
(setq anything-kyr-commands-by-major-mode
      '((ruby-mode "rdefs" "rcov" "rbtest")
        (emacs-lisp-mode "byte-compile-file"))
      ;;
      anything-kyr-functions
      '((lambda ()
          (save-excursion
            (when (and (re-search-backward (format ee-anchor-format "\\(.+\\)") nil t)
                       (string= (match-string-no-properties 1) "abbrevs"))
              (list "make-skeleton"))))
        anything-kyr-commands-by-major-mode
        ))

;; <<< registers>>>
(defvar anything-c-source-register
  '((name . "Registers")
    (candidates . anything-c-registers)
    (action ("insert" . insert))))

;; based on list-register.el
(defun anything-c-registers ()
  (loop for (char . val) in register-alist
        collect
        (let ((key (single-key-description char))
              (string (cond
                       ((numberp val)
                        (int-to-string val))
                       ((markerp val)
                         (let ((buf (marker-buffer val)))
                           (if (null buf)
                               "a marker in no buffer"
                             (concat
                              "a buffer position:"
                              (buffer-name buf)
                              ", position "
                              (int-to-string (marker-position val))))))
                        ((and (consp val) (window-configuration-p (car val)))
                         "conf:a window configuration.")
                        ((and (consp val) (frame-configuration-p (car val)))
                         "conf:a frame configuration.")
                        ((and (consp val) (eq (car val) 'file))
                         (concat "file:"
                                 (prin1-to-string (cdr val))
                                 "."))
                        ((and (consp val) (eq (car val) 'file-query))
                         (concat "file:a file-query reference: file "
                                 (car (cdr val))
                                 ", position "
                                 (int-to-string (car (cdr (cdr val))))
                                 "."))
                        ((consp val)
                         (let ((lines (format "%4d" (length val))))
                           (format "%s: %s\n" lines
                                   (truncate-string
                                    (mapconcat (lambda (y) y) val
                                               "^J") (- (window-width) 15)))))
                        ((stringp val)
                         val)
                        (t
                         "GARBAGE!"))))
          (cons (format "register %3s: %s" key string) string))))

;; (setq anything-sources (list anything-c-source-register))

;; << rdefs>>
(defvar rdefs-keyword-regexp
  (rx (or "def" "class" "module" "include" "extend" "alias"
          "attr" "attr_reader" "attr_writer" "attr_accessor"
          "public" "private" "private_class_method" "public_class_method"
          "module_function" "protected" "def_delegators")
      (1+ space)
      (? ":")
      (group (1+ (or alnum "_" "!" "?")))))
(defvar anything-c-source-rdefs
  '((name . "Ruby Defines")
    (candidates
     . (lambda ()
         (with-current-buffer anything-current-buffer
           (when (and buffer-file-name (eq major-mode 'ruby-mode))
             (split-string (shell-command-to-string
                            (format "rdefs.rb -n %s"  buffer-file-name))
                           "\n")))))
    (invariant)
    (action
     ("Goto line" .
      (lambda (candidate)
        (and (string-match "^\\([0-9]+\\)" candidate)
             (goto-line (string-to-int (match-string 1 candidate))))))
     ("Insert method" .
      (lambda (candidate)
        (when (string-match rdefs-keyword-regexp candidate)
          (insert (match-string 1 candidate))))))
    (action-transformer
     . (lambda (actions candidate)
         (if (eq anything-sources anything-for-insertion-sources)
             (list (cadr actions) (car actions))
           (p "NG")
           actions)))
    (persistent-action
     . (lambda (candidate)
         (when (string-match "^\\([0-9]+\\)" candidate)
           (goto-line (string-to-int (match-string 1 candidate)))
           (set-window-start (get-buffer-window anything-current-buffer) (point)))))))
;; (setq anything-sources (list anything-c-source-rdefs))

;; <<<new sources>>>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  [2007/12/27] <<<persistent-action>>>                              ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun anything-execute-persistent-action ()
  "If a candidate was selected then perform the associated action without quitting anything."
  (interactive)
  (save-selected-window
    (select-window (get-buffer-window anything-buffer))
    (select-window (setq minibuffer-scroll-window
                         (if (one-window-p t) (split-window) (next-window (selected-window) 1))))
    (let* ((anything-window (get-buffer-window anything-buffer))
           ;;(same-window-regexps '("."))
           (selection (if anything-saved-sources
                          ;; the action list is shown
                          anything-saved-selection
                        (anything-get-selection)))
           (default-action (anything-get-action))
           (action (assoc-default 'persistent-action (anything-get-current-source))))
      (setq action (or action default-action))
      (if (and (listp action)
               (not (functionp action)))  ; lambda
        ;; select the default action
          (setq action (cdar action)))
      (set-window-dedicated-p anything-window t)
      (unwind-protect
          (and action selection (funcall action selection))
        (set-window-dedicated-p anything-window nil)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  <<<type attribute helper>>>                                       ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun anything-c-call-interactively-from-string (command-name)
  (add-to-list 'extended-command-history command-name)
  (call-interactively (intern command-name)))
(defvar anything-type-attribute/command-local
  '((action 
     ("Call interactively" . anything-c-call-interactively-from-string))
    ;; Sort commands according to their usage count.
    (filtered-candidate-transformer . anything-c-adaptive-sort)
    (persistent-action . anything-c-call-interactively-from-string)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  <<<type attributes>>>                                             ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq anything-type-attributes
      `((buffer
         (action
          ("Switch to Buffer (next curwin)" . win-switch-to-buffer)
          ("Switch to buffer" . switch-to-buffer)
          ("Switch to buffer other window" . switch-to-buffer-other-window)
          ("Kill buffer"      . kill-buffer)
          ("Switch to buffer other frame" . switch-to-buffer-other-frame)
          ("Display buffer"   . display-buffer))
         (candidate-transformer . (lambda (candidates)
                                    (anything-c-compose
                                     (list candidates)
                                     '(anything-c-skip-boring-buffers
                                       anything-c-skip-current-buffer
                                       anything-c-transform-navi2ch-article))))
         (persistent-action . switch-to-buffer))
        (file
         (action
          ("Find File (next curwin)" . win-find-file)
          ("Find file" . find-file)
          ("Find file other window" . find-file-other-window)
          ("Delete File" . anything-c-delete-file)
          ("Find file other frame" . find-file-other-frame)
          ("Open dired in file's directory" . anything-c-open-dired)
          ("Delete file" . anything-c-delete-file)
          ("Open file externally" . anything-c-open-file-externally)
          ("Open file with default tool" . anything-c-open-file-with-default-tool))
         (action-transformer . (lambda (actions candidate)
                                 (anything-c-compose
                                  (list actions candidate)
                                  '(anything-c-transform-file-load-el
                                    anything-c-transform-file-browse-url))))
         (candidate-transformer . (lambda (candidates)
                                    (anything-c-compose
                                     (list candidates)
                                     '(anything-c-shadow-boring-files
                                       anything-c-shorten-home-path))))
         (persistent-action . find-file))
        (command-ext (action ("Call Interactively (new window)"
                              . (lambda (command-name)
                                  (with-new-window (anything-c-call-interactively-from-string command-name))))
                             ("Call interactively" . anything-c-call-interactively-from-string)
                             ("Describe command"
                              . (lambda (command-name)
                                  (describe-function (intern command-name))))
                             ("Add command to kill ring" . kill-new)
                             ("Go to command's definition"
                              . (lambda (command-name)
                                  (find-function
                                   (intern command-name)))))
                     ;; Sort commands according to their usage count.
                     (filtered-candidate-transformer . anything-c-adaptive-sort)
                     (persistent-action . anything-c-call-interactively-from-string))
        (command-local  ,@anything-type-attribute/command-local)
        (command  ,@anything-type-attribute/command-local)
        (function (action ("Describe function" . (lambda (function-name)
                                                   (describe-function (intern function-name))))
                          ("Add function to kill ring" . kill-new)
                          ("Go to function's definition" . (lambda (function-name)
                                                             (find-function
                                                              (intern function-name)))))
                  (action-transformer . (lambda (actions candidate)
                                          (anything-c-compose
                                           (list actions candidate)
                                           '(anything-c-transform-function-call-interactively)))))
        (sexp (action ("Eval s-expression" . (lambda (c)
                                               (eval (read c))))
                      ("Add s-expression to kill ring" . kill-new))
              (action-transformer . (lambda (actions candidate)
                                      (anything-c-compose
                                       (list actions candidate)
                                       '(anything-c-transform-sexp-eval-command-sexp)))))))

;; <<<anything-set-source-filter>>>
(defvar anything-c-categories '(rubyref create))
(dolist (category anything-c-categories)
  (let ((funcsym (intern (format "anything-show/%s" category))))
    (eval `(defun ,funcsym ()
             (interactive)
             (anything-set-source-filter
              (mapcar (lambda (src) (assoc-default 'name src))
                      (remove-if-not (lambda (src) (memq ',category (assoc-default 'category src)))
                                     anything-sources)))))))


;; [2007/12/30] <<<anything-insert-buffer-name>>>
(defun anything-insert-buffer-name ()
  (interactive)
  (delete-minibuffer-contents)
  (insert (with-current-buffer anything-current-buffer
            (if buffer-file-name (file-name-nondirectory buffer-file-name)
              (buffer-name)))))
;; [2007/12/30]
(defun anything-backward-char-or-show/create ()
  (interactive)
  (if (string= "" anything-pattern)
      (anything-show/create)
    (call-interactively 'backward-char)))
(defun anything-backward-char-or-insert-buffer-name ()
  (interactive)
  (if (string= "" anything-pattern)
      (anything-insert-buffer-name)
    (call-interactively 'backward-char)))

;; <<<anything-current-buffer>>>
(defvar anything-current-buffer nil)
(defadvice anything (before get-current-buffer activate)
  (setq anything-current-buffer (current-buffer)))

;; [2008/01/04] <<<anything for current-buffer>>>
(defvar anything-function 'anything-migemo)
(defvar anything-for-current-buffer-sources nil)
(defun anything-for-current-buffer ()
  (interactive)
  (let ((anything-sources anything-for-current-buffer-sources)
        (anything-candidate-number-limit 2000))
    (call-interactively anything-function)))

;; [2008/01/12] <<<anything for insert>>>
(defvar anything-for-insertion-sources nil)
(defun anything-for-insertion ()
  (interactive)
  (let ((anything-sources anything-for-insertion-sources)
        (anything-candidate-number-limit 200))
    (call-interactively anything-function)))

;; [2008/01/15] <<<abbrev or anything-for-insertion>>>
(defun expand-abbrev-or-anything-for-insertion ()
  (interactive)
  (or (expand-abbrev) (anything-for-insertion)))
                                                

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  <<<sources>>>                                                     ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(progn
  (defun anything-update-vars ()
    (interactive)
    ;; <<< anything-for-insertion-sources>>>
    (setq anything-for-insertion-sources
          (list anything-c-source-frequently-used-commands
                anything-c-source-kyr
                anything-c-source-abbrev-local
                anything-c-source-abbrev-global
                anything-c-source-rdefs
                anything-c-source-register
                anything-c-source-extended-command-history
                anything-c-source-M-x
                anything-c-source-commands-for-insertion
                anything-c-source-define-mode-abbrev
                anything-c-source-define-global-abbrev
                ))
    ;; <<< anything-for-current-buffer-sources>>>
    (setq anything-for-current-buffer-sources
          (list anything-c-source-frequently-used-commands
                anything-c-source-kyr
                anything-c-source-bm
                anything-c-source-eev-anchor
                anything-c-source-rdefs
                anything-c-source-imenu
                anything-c-source-commands-for-current-buffer
                anything-c-source-define-mode-abbrev
                anything-c-source-define-global-abbrev
                ))
    ;; <<< anything-sources>>>
    (setq anything-sources (list anything-c-source-frequently-used-commands
                                 anything-c-source-rake-task
                                 anything-c-source-tvavi
                                 anything-c-source-buffers
                                 anything-c-source-switch-commands
                                 anything-c-source-file-cache
                                 anything-c-source-elinit
                                 anything-c-source-bookmarks
                                 anything-c-source-kyr
                                 anything-c-source-rtb
                                 anything-c-source-ruby18-source
                                 anything-c-source-ruby19-source
                                 anything-c-source-find-library
                                 anything-c-source-refe2x
                                 anything-c-source-info-pages
                                 anything-c-source-man-pages
                                 anything-c-source-extended-command-history
                                 anything-c-source-rubylib-18
                                 anything-c-source-rubylib-19
                                 ;; create
                                 anything-c-source-bookmark-set
                                 anything-c-source-define-mode-abbrev
                                 anything-c-source-define-global-abbrev
                                 anything-c-source-buffer-not-found
                                 anything-c-source-music
                                 anything-c-source-find-abbrev-file
                                 anything-c-source-locate)
          anything-sources-orig anything-sources)
    (if (interactive-p) (message "Updated anything-sources.")))
  (anything-update-vars))

(defun anything-revert-vars ()
  (interactive)
  (setq anything-sources anything-sources-orig))

(defun anything-update-vars-and-exit ()
  (interactive)
  (anything-update-vars)
  (exit-minibuffer))

(provide '99anything)
;; (emacswiki-post "RubikitchAnythingConfiguration")
;; Local Variables:
;; ee-anchor-format: "<<<%s>>>"
;; End:

