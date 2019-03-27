;;; ruby.el

;;; Commentary

;;

;;; code
(use-package ruby-mode
  :ensure t
  :mode ("\\.rb\\'" "Rakefile\\'" "Gemfile\\'" "Berksfile\\'" "Vagrantfile\\'")
  :interpreter "ruby"
  :bind (:map ruby-mode-map
	      ("\C-c r v m" . rvm-activate-corresponding-ruby))
  :config
  (use-package rvm
    :ensure t
    :config
    (rvm-use-default))
  (add-hook 'ruby-mode-hook (lambda ()
			      (add-to-list (make-local-variable 'company-backends)
					   '(company-robe))))
  )

(use-package inf-ruby
  :ensure t
  :hook (ruby-mode . inf-ruby-minor-mode)
  )

(use-package ruby-electric
  :ensure t)

(use-package robe
  :ensure t
  :hook (ruby-mode . robe-mode)
  :config
  (defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
    (rvm-activate-corresponding-ruby)
    )
  )

(use-package rubocop
  :ensure t
  :hook (ruby-mode . rubocop-mode)
  )

;; --- auto-format ---
(use-package rufo
  :ensure t
  :hook (ruby-mode . rufo-minor-mode)
  )

;; --- rails ---
(use-package projectile-rails
  :ensure t
  :hook (ruby-mode . projectile-rails-on)
  )

(provide 'ruby)
;;; ruby.el ends here
