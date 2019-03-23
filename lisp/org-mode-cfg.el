(setq org-todo-keywords
      '((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))
(defun unset-key-org-mode ()
;;  (local-unset-key (kbd "C-j"))
;;  (local-unset-key (kbd "M-g"))
  )
(add-hook 'org-mode-hook 'unset-key-org-mode)
(provide 'org-mode-cfg)
