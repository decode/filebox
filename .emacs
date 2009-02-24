(set-default-font "Bitstream Vera Sans Mono-9")
(set-fontset-font "fontset-default" 'han'("LiHei Pro" . "unicode-bmp"))

(setq load-path (cons "~/.emacs.d/" load-path))
(setq load-path (cons "~/.emacs.d/icicles" load-path))
(setq load-path (cons "~/.emacs.d/predictive" load-path))
(setq load-path (cons "~/.emacs.d/emacs-rails" load-path))
(setq load-path (cons "~/.emacs.d/ruby-mode" load-path))
(setq load-path (cons "~/.emacs.d/yaml-mode-0.0.3" load-path))

(require 'color-theme)
(require 'ecb-autoloads)
(require 'cedet)
(require 'haml-mode)
(require 'sass-mode)

(require 'psvn)

(require 'diminish)
   (diminish 'abbrev-mode "Abv")
(require 'linum)
(global-linum-mode t)

(require 'ido)
(ido-mode t)
;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)

;;Tabbar - Display a tab bar in the header line
(require 'tabbar)
(tabbar-mode) 
(global-set-key (kbd "C-=") 'tabbar-backward-group)
(global-set-key (kbd "C--") 'tabbar-forward-group)
(global-set-key (kbd "C-9") 'tabbar-backward)
(global-set-key (kbd "C-0") 'tabbar-forward) 

(global-set-key (kbd "C-c i") 'imenu)

;;Close the tool bar
(tool-bar-mode nil)
;;不要滚动栏
(scroll-bar-mode nil)

;;设置tab为4个空格的宽度
;;(setq default-tab-width 4)
;;(setq c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list ())

;;允许emacs和外部其他程序的粘贴
(setq x-select-enable-clipboard t)

;;Set color
(require 'color-theme)  
(color-theme-initialize)  
(color-theme-simple-1)

;;语法加亮
(global-font-lock-mode t)
;;高亮显示成对括号，但不来回弹跳
(show-paren-mode t)
(setq show-paren-style 'parentheses)
;;鼠标指针规避光标
(mouse-avoidance-mode 'animate)
;;粘贴于光标处，而不是鼠标指针处
(setq mouse-yank-at-point t)

;;WindMove, Use:shift+up,down,left,right. Conflict with org-mode.
;;you might want to disable the Org Mode keybindings for Shift+arrow keys:
(setq org-CUA-compatible t)
;;Enable windmove
(when (fboundp 'windmove-default-keybindings)
      (windmove-default-keybindings))

(autoload 'predictive-mode "~/.emacs.d/predictive"
            "Turn on Predictive Completion Mode." t)
;;(autoload 'predictive-setup-latex "~/.emacs.d/predictive-latex")
;;(autoload 'predictive-setup-html "~/.emacs.d/predictive-html")

(require 'pabbrev)
(global-pabbrev-mode)
(require 'icicles)
(require 'icicles-rcodetools)
(icomplete-mode)

(require 'anything-config)
(require 'anything-rcodetools)
;; Command to get all RI entries.
(setq rct-get-all-methods-command "PAGER=cat fri -l")
;; See docs
(define-key anything-map "\C-z" 'anything-execute-persistent-action)

(require 'yaml-mode)
(setq auto-mode-alist
            (append '(("\.yml\'" . yaml-mode))
		                  auto-mode-alist))


;;(add-to-list 'load-path "/home/home/.emacs.d/git-emacs") 
;;(require 'git-emacs)

;;=========================================================
;;Ruby on rail develop
;;(setq rails-using-ctags t)
;;(require 'haml-mode nil 't)
(require 'rails)
;;=========================================================
;; Format and auto indent
(defun iwb ()  
    "indent whole buffer"  
    (interactive)  
    (delete-trailing-whitespace)  
    (indent-region (point-min) (point-max) nil))  

;; ECB settings
(setq ecb-auto-activate t
	ecb-tip-of-the-day nil
	inhibit-startup-message t
	ecb-auto-compatibility-check nil
	ecb-version-check nil)
(setq ecb-tree-truncate-lines nil)
(setq ecb-truncate-long-names nil)
(setq ecb-truncate-lines nil)

;; -----------------------------------------------------------
;; Latex mode settings
;; -----------------------------------------------------------
(add-hook  'LaTeX-mode-hook  (lambda() 
	 (add-to-list  'TeX-command-list  '("XeLaTeX"  "%`xelatex%(mode)%'  %t"  TeX-run-TeX  nil  t)) 
	 (setq  TeX-command-default  "XeLaTeX") 
	 (setq  TeX-save-query  nil) 
	 (setq  TeX-show-compilation  t) 
)) 

;;(load "desktop")
;;(desktop-save-mode)
;;(desktop-load-default)
;;(desktop-read)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes (quote (("left8" (0.21287128712871287 . 0.2542372881355932) (0.21287128712871287 . 0.23728813559322035) (0.21287128712871287 . 0.2542372881355932) (0.21287128712871287 . 0.23728813559322035))))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
