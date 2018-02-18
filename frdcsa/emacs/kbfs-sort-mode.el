;; (define-derived-mode kbfs-sort-mode
;;  kbfs-mode "KBFS Sort"
;;  "Major mode for sorting files with KBFS.
;; \\{kbfs-sort-mode-map}"
;;  (setq case-fold-search nil)

;;  (define-key kbfs-sort-mode-map "n" 'kbfs-sort-categorize-files)

;;  (kbfs-define-keys-for-mode kbfs-image-mode-map)

;;  (make-local-variable 'default-buffer)
;;  (setq default-buffer (current-buffer))

;;  (make-local-variable 'font-lock-defaults)
;;  (setq font-lock-defaults '(subl-font-lock-keywords nil nil))
;;  (re-font-lock))

;; (defun kbfs-sort-categorize-files ()
;;  ""
;;  (interactive)
;;  (kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open t)
;;  (kbfs-move-file-to-codebase-special-dir)
;;  (switch-to-buffer nil)
;;  (kmax-kill-buffer-no-ask (current-buffer))
;;  (switch-to-buffer nil)
;;  )

(provide 'kbfs-sort-mode)
