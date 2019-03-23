(require 'package)
(package-initialize)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			  ("melpa" . "https://melpa.org/packages/")))

;; cl - Common Lisp Extension
(require 'cl)

;;Add Packages
;; (defvar my/packages '(
;; 		      ;; --- Auto-completion ---
;; 		      ;company
;; 		      ;; --- Better Editor ---
;; 		      ;hungry-delete
;; 		      ivy
;; 		      swiper
;; 		      counsel
;; 		      smartparens
;; 		      ace-jump-mode
;; 		      use-package
;; 		      undo-tree
;; 		      ;;auto-save
;; 		      ;web-mode
;; 		      neotree
;; 		      js2-mode
;; 		      rjsx-mode
;; 		      ;;magit
;;
;; 		      window-numbering
;; 		      ;; --- Themes ---

;; 		      ;; --- Major  ---
;; 		      markdown-mode
;; 		      ) "Default packages")

;; (setq package-selected-packages my/packages)

;; (defun my/packages-installed-p ()
;;     (loop for pkg in my/packages
;; 	  when (not (package-installed-p pkg)) do (return nil)
;; 	  finally (return t)))

;; (unless (my/packages-installed-p)
;;   (message "%s" "Refreshing package database...")
;;   (package-refresh-contents)
;;   (dolist (pkg my/packages)
;;     (when (not (package-installed-p pkg))
;;       (package-install pkg))))

;; Find Executable Path on OS X
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
;;change meta from option to command
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;;--------------------------------------init-emacs : start -----------------------------------
(tool-bar-mode -1)
(scroll-bar-mode -1)
;;(global-linum-mode 1)
(column-number-mode t)
(line-number-mode t)
(global-hl-line-mode t)
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)
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
;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)
;;加入最近打开过文件的选项让我们更快捷的在图形界面的菜单中打开最近 编辑过的文件。
(require 'window-numbering)
(window-numbering-mode t)
(require 'undo-tree)
(global-undo-tree-mode)

(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
;;小缓冲区高度
  (setq ivy-height 10)
;;设定初始list为空
  (setq ivy-initial-inputs-alist nil)
;;如何顯示總共符合的數目以及目前的位置
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
	;;當用 regex 可以不管次序
        `((t . ivy--regex-ignore-order)))
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

(use-package projectile
  :ensure t
  :bind-keymap("\C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq project-completion-system 'ivy)
  (use-package counsel-projectile
    :ensure t)
  )

(global-set-key (kbd "C-h C-j") 'ace-jump-mode)
(global-set-key (kbd "C-h C-l") 'ace-jump-line-mode)
(global-set-key (kbd "C-h C-t") 'ace-jump-char-mode)
(global-set-key (kbd "C-h C-m") 'comment-or-uncomment-region)
(global-set-key (kbd "C-h h") 'help-for-help)
(global-set-key (kbd "C-h C-h") 'counsel-M-x)
(global-set-key (kbd "C-h C-u") 'undo-tree-visualize)

(global-unset-key (kbd "C-h w"))
(global-set-key (kbd "C-h w f") 'toggle-frame-fullscreen)

(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-j") 'backward-delete-char-untabify)

(global-unset-key (kbd "C-r"))
(define-prefix-command 'ctl-r-map)
(global-set-key (kbd "C-r") 'ctl-r-map)
(global-unset-key (kbd "C-x i"))

;; ---------- test ---------------------

;;一、key-translation-map，优先级最高,注销方式：把这个key重新映射为它自己。
;;(define-key key-translation-map (kbd "your-key") (kbd "target-key"))
;;二、minor-mode-map，优先级第二.注销方式：绑定为nil。
;;(define-key some-minor-mode-map (kbd "your-key") 'your-command)
;;三、local-set-key，优先级第三.注销方式：绑定为nil，或者(local-unset-key (kbd "your-key"))
;;(local-set-key (kbd "your-key") 'your-command)
;;local-set-key主要是在各种major-mode下使用，一般是通过hook设置
;;(add-hook 'some-major-mode-hook '(lambda () (local-set-key ...)))
;;四、global-set-key，优先级最低.注销方式：绑定为nil，或者(global-unset-key (kbd "your-key"))
;;(global-set-key (kbd "your-key") 'your-command)
;;-------------------------------------- emacs : end -----------------------------------

;;-------------------------------------- abbrev-config : start -----------------------------------
(require 'abbrev-mode-cfg)
;;-------------------------------------- abbrev-config : end -----------------------------------

;;-------------------------------------- markdown-mode-config : start -----------------------------------
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
;;-------------------------------------- markdown-mode-config : end -----------------------------------

;;-------------------------------------- neotree-config : start -----------------------------------
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
;;-------------------------------------- neotree-config : end -----------------------------------

;;-------------------------------------- 自分でdefined functions : start -----------------------------------
(require 'funcs-cfg)
;;-------------------------------------- 自分でdefined functions : end -----------------------------------

;;-------------------------------------- abbrev-config : start -----------------------------------
(require 'org-mode-cfg)
;;-------------------------------------- abbrev-config : end -----------------------------------

;;-------------------------------------- theme-config : start -----------------------------------
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;(load-theme 'zenburn t)
;;-------------------------------------- theme-config : end -----------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (swiper counsel smartparens window-numbering neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
