(define-derived-mode kbfs-image-mode
 image-mode "KBFS Image"
 "Major mode for images files with KBFS.
\\{image-mode-map}"
 (setq case-fold-search nil)

 (define-key kbfs-image-mode-map "dmA" 'kbfs-image-mode-declare-image-is-a-meme)
 (define-key kbfs-image-mode-map "dm?" 'kbfs-image-mode-image-is-a-meme-p)
 (define-key kbfs-image-mode-map "dcr" 'kbfs-image-mode-request-new-category)
 (define-key kbfs-image-mode-map "dci" 'kbfs-image-mode-declare-image-has-category)
 (define-key kbfs-image-mode-map "l" 'kbfs-image-mode-list-all-categories)
 (define-key kbfs-image-mode-map "Qic" 'kbfs-image-mode-image-has-categories)

 (kbfs-define-keys-for-mode kbfs-image-mode-map)

 (make-local-variable 'font-lock-defaults)
 (setq font-lock-defaults '(subl-font-lock-keywords nil nil))
 (re-font-lock))

(add-hook 'image-mode-hook 'turn-on-kbfs-image-mode)

(defun turn-on-kbfs-image-mode ()
 ""
 (interactive)
 (if (not (derived-mode-p 'kbfs-image-mode))
  (progn 
   (kbfs-image-mode)
   (eimp-mode)
   (eimp-fit-image-to-window nil))))

(defvar kbfs-image-default-context "Org::FRDCSA::KBFS::Image")

(defun kbfs-image-mode-declare-image-is-a-meme ()
 "Declare the image that is being visited in the current buffer is a meme"
 (interactive)
 (let* ((user (kmax-get-user))
	(context kbfs-image-default-context)
	(formula (list "isa"
		  (list "memeFileFn"
		   buffer-file-name)
		  "Meme")))
  (message (concat "Asserted " (prin1-to-string formula) " to " context))
  (freekbs2-assert-formula formula context)))

(defun kbfs-image-mode-image-is-a-meme-p ()
 "Declare the image that is being visited in the current buffer is a meme"
 (interactive)
 (let* ((user (kmax-get-user))
	(context kbfs-image-default-context)
	(formula (list "isa"
		  (list "memeFileFn"
		   buffer-file-name)
		  "Meme")))
  (see (freekbs2-query formula context))))

(defun kbfs-image-mode-request-new-category (&optional category-name)
 (interactive)
 (let* ((type "image")
	(category-name
	 (or
	  category-name
	  (read-from-minibuffer
	   (concat "New category for items of type " type "?: ")))))
  (kbfs-request-new-category-for-type type category-name kbfs-image-default-context)
  (if (yes-or-no-p "Mark current image as of this type?: ")
   (kbfs-image-mode-declare-image-has-category category-name))))

(defun kbfs-image-mode-list-all-categories ()
 ""
 (interactive)
 (see (kbfs-list-all-categories-for-type "image" kbfs-image-default-context) 0.1))

(defun kbfs-image-mode-declare-image-has-category (&optional category-name)
 (interactive)
 (let* ((type "image")
	(user (kmax-get-user))
	(context kbfs-image-default-context)
	(categories
	 (if category-name nil
	  (kbfs-image-mode-list-all-categories)))
	(category
	 (or category-name
	  (completing-read
	   "Category for image?: "
	   categories)))
	(formula (list "hasCategory"
		  (list "FileFn" buffer-file-name)
		  category)))
  (message (concat "Asserted " (prin1-to-string formula) " to " context))
  (freekbs2-assert-formula formula context)
  (if (non-nil categories)
   (if (null (cl-intersection categories (list category)))
    (kbfs-image-mode-request-new-category category)))))

(defun kbfs-image-mode-image-has-categories ()
 ""
 (interactive)
 (see
  (kbfs-convert-cycl-list-to-list
   (freekbs2-query
    (list "hasCategory"
     (list "FileFn" (kmax-get-buffer-file-name-all-modes))
     'var-category)
    kbfs-image-default-context))))

(provide 'kbfs-image-mode)
