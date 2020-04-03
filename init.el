(require 'package)

;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize) 
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package diminish :ensure t)
(use-package bind-key :ensure t)

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; cl - Common Lisp Extension
(require 'cl)
;; Find Executable Path on OS X
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
;;change meta from option to command
;;(setq mac-command-modifier 'meta
;;      mac-option-modifier 'none)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;;--------------------------------------init-emacs : start -----------------------------------
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; --- modeline : start ---
(column-number-mode t)
(line-number-mode t)
(add-hook 'prog-mode-hook (lambda()(global-linum-mode 1)))
(add-hook 'org-mode-hook (lambda()(global-linum-mode nil)))
(add-hook 'markdown-mode-hook (lambda()(global-linum-mode nil)))
;; 标题栏显示缓冲区名
;;(setq frame-title-format "%b")

;;  Emacs title bar to reflect file name -----------------------------------------------
(defun frame-title-string ()
   "Return the file name of current buffer, using ~ if under home directory"
   (let
      ((fname (or
                 (buffer-file-name (current-buffer))
                 (buffer-name))))
      ;;let body
      (when (string-match (getenv "HOME") fname)
        (setq fname (replace-match "~" t t fname))        )
      fname))
;; Title = 'system-name foo.bar'
;;(setq frame-title-format '("<<" "%b" ">>" system-name "  "(:eval (frame-title-string))))
;;; Title = 'system-name File: foo.bar'
(setq frame-title-format '("" system-name "  "(:eval (frame-title-string))))
;; ------------------------------------------------------------------------------------

;;Faces
(set-face-attribute 'mode-line           nil :background "light blue")
;;(set-face-attribute 'mode-line-buffer-id nil :background "blue" :foreground "white")
(defface mode-line-directory
  '((t :background "light blue" :foreground "black"))
;;  '((t :background "blue" :foreground "gray"))  
  "Face used for buffer identification parts of the mode line."
  :group 'mode-line-faces
  :group 'basic-faces)
(set-face-attribute 'mode-line-highlight nil :box nil :background "deep sky blue")
(set-face-attribute 'mode-line-inactive  nil :inherit 'default)
;;Simplify the cursor position
(setq mode-line-position
      '(;; %p print percent of buffer above top of window, o Top, Bot or All
        ;; (-3 "%p")
        ;; %I print the size of the buffer, with kmG etc
        ;; (size-indication-mode ("/" (-4 "%I")))
        ;; " "
        ;; %l print the current line number
        ;; %c print the current column
        (line-number-mode ("%l" (column-number-mode ":%c")))))
;;Directory shortening
(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))
;;Directory name
(defvar mode-line-directory
  '(:propertize
    (:eval (if (buffer-file-name) (concat " " (shorten-directory default-directory 20)) " "))
    face mode-line-directory)
  "Formats the current directory.")
(put 'mode-line-directory 'risky-local-variable t)
(setq-default mode-line-buffer-identification
              (propertized-buffer-identification "%b "))

(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-mule-info  ;; -- I'm always on utf-8
                mode-line-client
                mode-line-modified
                ;; mode-line-remote -- no need to indicate this specially
                ;; mode-line-frame-identification -- this is for text-mode emacs only
                " "
                mode-line-directory
                mode-line-buffer-identification
                " "
                mode-line-position
                (vc-mode vc-mode);;  -- I use magit, not vc-mode
                (flycheck-mode flycheck-mode-line)
                " "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces))
;;mode-line-modes rename
(require 'diminish)
(diminish 'abbrev-mode "Abv")
(diminish 'eldoc-mode)
(diminish 'projectile-rails-mode)

;; --- modeline :  end  ---
(global-hl-line-mode t)

(show-paren-mode t)
(electric-pair-mode t)
(setq electric-pair-pairs '(
 			    (?\' . ?\')
 			    ))
(setq-default indent-tabs-mode nil)

;;窗口快速切换过去/回来
(winner-mode t)

;;
(use-package multiple-cursors
  :ensure t
  :bind (
         ("C-h C-n" . mc/mark-next-like-this)
         ("C-h C-p" . mc/mark-previous-like-this)
         ))

;;可以禁止自动生成备份文件
(setq make-backup-files nil)
;;关闭自己生产的保存文件
(setq auto-save-default nil)
;;自动加载外部修改过的文件。
(global-auto-revert-mode t)
;;设置为开启默认全屏
(setq initial-frame-alist (quote ((fullscreen . maximized))))
;;关闭 Emacs 中的警告音
(setq ring-bell-function 'ignore)
;; 更改光标的样式（不能生效，解决方案见第二集）
(setq cursor-type 'bar)
;; 关闭启动帮助画面
(setq inhibit-splash-screen 1)
;; 更改显示字体大小 16pt
(set-face-attribute 'default nil :height 160)

;;(require 'window-numbering)
;;(window-numbering-mode t)
;; --- undo-tree ---
(use-package undo-tree
  :ensure t
  :diminish (undo-tree-mode . "udo")
  :config
  (global-undo-tree-mode t)
  )

(use-package ivy
  :ensure t
  :diminish (ivy-mode . "ivy")
  :config
  (ivy-mode 1)
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
;;小缓冲区高度
  (setq ivy-height 30)
;;设定初始list为空
  (setq ivy-initial-inputs-alist nil)
;;如何顯示總共符合的數目以及目前的位置
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
	;;當用 regex 可以不管次序
        '((t . ivy--regex-ignore-order)))
  )

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
         ("C-x C-r" . counsel-recentf)))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper))
  )

(global-unset-key (kbd "C-j"))
(define-prefix-command 'ctl-j-map)
(global-set-key (kbd "C-j") 'ctl-j-map)
;;(local-set-key (kbd "C-j C-b") 'ivy-switch-buffer)
(define-key key-translation-map (kbd "C-j C-b") (kbd "C-x b"))

(add-hook 'org-mode-hook
          (lambda () (
                      (local-set-key (kbd "C-0") #'run-latexmk)
                      
                      )))


(global-set-key (kbd "C-j C-j") 'ace-jump-mode)
(global-set-key (kbd "C-j C-w") 'ace-jump-word-mode)
(global-set-key (kbd "C-j C-l") 'ace-jump-line-mode)
(global-set-key (kbd "C-j C-c") 'ace-jump-char-mode)

(use-package projectile
  :ensure t
  :diminish (projectile-mode . "pjf")
  :bind-keymap("C-l" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq project-completion-system 'ivy)
  (use-package counsel-projectile
    :ensure t
    :config
    (counsel-projectile-mode t)
    )
  )

;; --- hs-minor-mode ---
(add-hook 'prog-mode-hook #'hs-minor-mode)

(global-set-key (kbd "C-j C-h") 'hs-toggle-hiding)

(global-set-key (kbd "C-h C-m") 'comment-or-uncomment-region)
(global-set-key (kbd "C-h C-h") 'counsel-M-x)
(global-set-key (kbd "C-h C-u") 'undo-tree-visualize)
(global-set-key (kbd "C-h h") 'help-for-help)

(global-unset-key (kbd "C-h w"))
(global-set-key (kbd "C-h w f") 'toggle-frame-fullscreen)

(global-unset-key (kbd "C-r"))
(global-set-key (kbd "C-r") 'backward-delete-char-untabify)

(global-set-key (kbd "<f2>") 'open-init-file)
(global-unset-key (kbd "C-x i"))
(global-set-key "\C-xid" 'insert-current-date)
(global-set-key "\C-xit" 'insert-current-datetime)

(global-set-key (kbd "C-q") (kbd "C-x 1"))
(global-set-key (kbd "C-j C-f") 'counsel-find-file)

;; ---------- test ---------------------

;;-------------------------------------- emacs : end -----------------------------------

;;-------------------------------------- abbrev-config : start -----------------------------------
(setq-default abbrev-mode t)
(read-abbrev-file "~/.emacs.d/abbrev_defs")
(setq save-abbrevs t)
;;-------------------------------------- abbrev-config : end -----------------------------------

;;-------------------------------------- magit : start -----------------------------------
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  )

;;-------------------------------------- magit : end -----------------------------------

;;-------------------------------------- markdown-mode : start -----------------------------------
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
;;-------------------------------------- markdown-mode : end -----------------------------------

;;-------------------------------------- neotree : start -----------------------------------
;;(require 'neotree)
;;(global-set-key [f8] 'neotree-toggle)
(use-package neotree
  :ensure t
  :bind ([f8] . 'neotree-toggle)
  )
;;-------------------------------------- neotree : end -----------------------------------

;;--------------------- 自分でdefined functions : start -----------------------------------
(require 'funcs-cfg)
;;--------------------- 自分でdefined functions : end -----------------------------------

;;--------------------- abbrev-config : start -----------------------------------
(require 'org-mode-cfg)
;;--------------------- abbrev-config : end -----------------------------------

;; -------------------- company : start --------------------
(use-package company
  :ensure t
  :diminish (company-mode . "cpy")  
  :config
  (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-backends
	'((company-files
	   company-yasnippet
	   company-capf
	   company-keywords)
	  (company-abbrev
	   company-dabbrev)))
  )
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "\C-n") #'company-select-next)
  (define-key company-active-map (kbd "\C-p") #'company-select-previous))
(add-hook 'emacs-lisp-mode-hook (lambda()
				  (add-to-list (make-local-variable 'company-backends)
					       'company-elisp)))
(advice-add 'company-complete-common :before (lambda () (setq my-company-point (point))))
(advice-add 'company-complete-common :after (lambda ()
  		  				(when (equal my-company-point (point))
  			  			  (yas-expand))))
;; -------------------- company :  end  --------------------

;; -------------------- yasnippet : start --------------------
(use-package yasnippet
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config
  (yas-reload-all)
  (use-package yasnippet-snippets
    :ensure t))
;; -------------------- yasnippet :  end  --------------------

;; -------------------- flycheck : start  --------------------
;; (use-package flycheck
;;   :ensure t
;;   :init
;;   (global-flycheck-mode t))
;; -------------------- flycheck :  end  --------------------

;; -------------------- web-mode : start  --------------------
(use-package web-mode
  :ensure t
  :init
   ;; .js, .jsx を web-mode で開く
  (add-to-list 'auto-mode-alist '("\\.js[x]?$" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx$" . web-mode))
  ;; 拡張子 .js でもJSX編集モードに
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'")))
  :config
  ;; インデント
  (add-hook 'web-mode-hook
          '(lambda ()
             (setq web-mode-attr-indent-offset nil)
             (setq web-mode-markup-indent-offset 2)
             (setq web-mode-css-indent-offset 2)
             (setq web-mode-code-indent-offset 2)
             (setq web-mode-sql-indent-offset 2)
             (setq indent-tabs-mode nil)
             (setq tab-width 2)
             ))
  ;; 色
  ;; (custom-set-faces
  ;;  '(web-mode-doctype-face           ((t (:foreground "#4A8ACA"))))
  ;;  '(web-mode-html-tag-face          ((t (:foreground "#4A8ACA"))))
  ;;  '(web-mode-html-tag-bracket-face  ((t (:foreground "#4A8ACA"))))
  ;;  '(web-mode-html-attr-name-face    ((t (:foreground "#87CEEB"))))
  ;;  '(web-mode-html-attr-equal-face   ((t (:foreground "#FFFFFF"))))
  ;;  '(web-mode-html-attr-value-face   ((t (:foreground "#D78181"))))
  ;;  '(web-mode-comment-face           ((t (:foreground "#587F35"))))
  ;;  '(web-mode-server-comment-face    ((t (:foreground "#587F35"))))
   
  ;;  '(web-mode-css-at-rule-face       ((t (:foreground "#DFCF44"))))
  ;;  '(web-mode-comment-face           ((t (:foreground "#587F35"))))
  ;;  '(web-mode-css-selector-face      ((t (:foreground "#DFCF44"))))
  ;;  '(web-mode-css-pseudo-class       ((t (:foreground "#DFCF44"))))
  ;;  '(web-mode-css-property-name-face ((t (:foreground "#87CEEB"))))
  ;;  '(web-mode-css-string-face        ((t (:foreground "#D78181"))))
  ;;  )
  )
;; -------------------- web-mode :  end  --------------------

;; -------------------- ruby-config :  end  --------------------
;;(load "~/.emacs.d/lisp/ruby.el")
;; -------------------- ruby-config :  end  --------------------

;;-------------------------------------- theme-config : start -----------------------------------
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;(load-theme 'zenburn t)
;;-------------------------------------- theme-config : end -----------------------------------

;; --- org-journal ---
(use-package org-journal
  :ensure t
  :bind (("C-c t" . journal-file-today)
         ("C-c y" . journal-file-yesterday))
  :custom
  (org-journal-dir "~/Documents/shinko/.journal/2019/")
  (org-journal-file-format "%Y%m%d.org")
  (org-journal-date-format "%e %b %Y (%A)")
  (org-journal-time-format "")
  :preface
  (defun get-journal-file-today ()
    "Gets filename for today's journal entry."
    (let ((daily-name (format-time-string "%Y%m%d.org")))
      (expand-file-name (concat org-journal-dir daily-name))))
  
  (defun journal-file-today ()
    "Creates and load a journal file based on today's date."
    (interactive)
    (find-file (get-journal-file-today)))
  
  (defun get-journal-file-yesterday ()
    "Gets filename for yesterday's journal entry."
    (let* ((yesterday (time-subtract (current-time) (days-to-time 1)))
           (daily-name (format-time-string "%Y%m%d.org" yesterday)))
      (expand-file-name (concat org-journal-dir daily-name))))
  
  (defun journal-file-yesterday ()
    "Creates and load a file based on yesterday's date."
    (interactive)
    (find-file (get-journal-file-yesterday))))

(add-hook 'markdown-mode-hook (lambda()(global-linum-mode nil)))
  
;; -------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yaml-mode coffee-mode org-journal hs-minor hs-minor-mode web-mode abbrev multiple-cursors auto-package-update diminish projectile-rails projectile-railse rufo rubocop ruby-electric robe rvm inf-ruby flycheck yasnippet-snippets yasnippet company swiper counsel smartparens window-numbering neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
