;;insert-current-date
(defun insert-current-date ()
    "Insert the current date"
    (interactive "*")
    ;(insert (format-time-string "%Y/%m/%d %H:%M:%S" (current-time))))
    (insert (format-time-string " [%Y/%m/%d]" (current-time))))

;;insert-current-datetime
(defun insert-current-datetime ()
    "Insert the current date"
    (interactive "*")
    (insert (format-time-string " [%Y/%m/%d %H:%M]" (current-time))))
    
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
Move point to beginning-of-line ,if point was already at that position,
  move point to first non-whitespace character. "
  (interactive)
  (let ((oldpos (point)))
    (beginning-of-line)
    (and (= oldpos (point))
         (back-to-indentation) )))
(global-set-key (kbd "C-a") 'smart-beginning-of-line)

;;直接把当前buffer 关闭
;; (autoload 'server-edit "server")
;; ;;;###autoload
;; (defun kill-buffer-or-server-edit()
;;   (interactive)
;;   (message "kill buffer %s" (buffer-name))
;;   (when (equal (buffer-name) "*scratch*")
;;     (copy-region-as-kill (point-min)(point-max)))
;;   (if (and (featurep 'server) server-buffer-clients)
;;       (server-edit)
;;     (kill-this-buffer)
;;     )
;;   )
;; (global-set-key (kbd "C-x k") 'kill-buffer-or-server-edit)

;; 快速打开配置文件
(defun open-init-file()
  "open file init.el "
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(provide 'funcs-cfg)
;;; funcs-cfg.el ends here
