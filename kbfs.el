;; here are functions to assert things about files into KBFS
;; kbfs should start using freekbs

;; (global-set-key "\C-xd" 'kbfs)

;; (defun kbfs (dirname &optional switches)
;;  ""
;;  (interactive (dired-read-dir-and-switches ""))
;;  ;; (dired dirname switches)
;;  ;; (kbfs-mode)
;;  (kbfs-mode dirname switches)
;;  (dired-build-subdir-alist))

(load-library "dired")
(define-key dired-mode-map "K" 'kbfs)
(add-hook 'dired-mode-hook 'kbfs)

(defun kbfs ()
 ""
 (interactive)
 (if (not (derived-mode-p 'kbfs-mode))
  (progn 
   (kbfs-mode)
   (dired-build-subdir-alist))))

(kmax-fixme "Need to reassign dired-to-print on 'P' which is being taken over by a kbfs command")

(define-derived-mode kbfs-mode
 dired-mode "KBFS"
 "Major mode for asserting knowledge about files.
\\{kbfs-mode-map}"
 (setq case-fold-search nil)
 (define-key kbfs-mode-map "KR" 'kbfs-view-randomized-list-of-files)
 (define-key kbfs-mode-map "Ko" 'kbfs-mode-open-file)
 (define-key kbfs-mode-map "KO" 'kbfs-mode-play-file-mplayer)
 (define-key kbfs-mode-map "KA" 'kbfs-mode-assert-knowledge-about-marked-files-file)
 (define-key kbfs-mode-map "Ka" 'kbfs-mode-assert-knowledge-about-marked-files-class)
 (define-key kbfs-mode-map "KV" 'kbfs-mode-view-knowledge-about-marked-files-file)
 (define-key kbfs-mode-map "Kv" 'kbfs-mode-view-knowledge-about-marked-files-class)
 ;; (define-key kbfs-mode-map "Kt" 'kbfs-mode-assert-knowledge-about-marked-files-using-tracker)
 (define-key kbfs-mode-map "Ktf" 'kbfs-mode-view-tracker-file-class-data)
 (define-key kbfs-mode-map "Ktc" 'kbfs-mode-view-tracker-file-class-data)
 (define-key kbfs-mode-map "Kd" 'kbfs-mode-distribute-files)
 (define-key kbfs-mode-map "n" 'dired-next-line)
 (define-key kbfs-mode-map "p" 'dired-previous-line)
 (define-key kbfs-mode-map "N" 'kbfs-interactively-walk-slash-traverse-dired-recursively-next)
 (define-key kbfs-mode-map "P" 'kbfs-interactively-walk-slash-traverse-dired-recursively-previous)
 (define-key kbfs-mode-map "\M-n" 'kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open)
 (define-key kbfs-mode-map "\M-p" 'kbfs-interactively-walk-slash-traverse-dired-recursively-previous-and-open)
 (define-key kbfs-mode-map "\C-\M-n" 'kbfs-sort-categorize-files)
 ;; (define-key kbfs-mode-map "n"  'kbfs-mode-next-line)
 ;; (define-key kbfs-mode-map "p"  'kbfs-mode-previous-line)
 (define-key kbfs-mode-map "K!" 'kbfs-mode-invoke-shell)
 (define-key kbfs-mode-map "Kk" 'kbfs-mode-assertion-interface)
 (define-key kbfs-mode-map "Kx" 'kbfs-mode-reload-kbfs)
 (define-key kbfs-mode-map "K+c" 'kbfs-mode-execute-clamscan)
 (define-key kbfs-mode-map "Kz" 'kbfs-mode-analyze-file)
 (define-key kbfs-mode-map "Kcnsdr" 'kbfs-mode-system-academician--declare-desire-to-read-document)
 (define-key kbfs-mode-map "Kcrdip" 'kbfs-mode-system-radar--declare-desire-to-package-file)
 

 (define-key kbfs-mode-map "Kw" 'kbfs-mode-copy-full-filename-as-kill)
 (define-key kbfs-mode-map "KW" 'kbfs-mode-search-for-next-image-file)

 (kbfs-define-keys-for-mode kbfs-mode-map)

 (define-key kbfs-mode-map "KC" 'kbfs-clean-emacs-backups)
 (define-key kbfs-mode-map "Kswp" 'kbfs-mode-set-image-as-background)
 (define-key kbfs-mode-map "KD" 'kbfs-search-dired)

 ;; (global-unset-key "Kr")
 (define-key kbfs-mode-map "Kri" 'kbfs-move-file-to-codebase-incoming)
 (define-key kbfs-mode-map "KrI" 'kbfs-move-file-to-codebase-incoming-dired)
 (define-key kbfs-mode-map "Krd" 'kbfs-move-file-to-codebase-special-dir)
 (define-key kbfs-mode-map "KrD" 'kbfs-move-file-to-codebase-documentation)

 )

(defun kbfs-define-keys-for-mode (mode)
 (define-key mode "Ksin" 'kbfs-mode-sort-file-to-incoming)
 (define-key mode "Ksir" 'kbfs-mode-sort-file-to-irish-directory)
 (define-key mode "Ksbe" 'kbfs-mode-sort-file-to-beauty-directory)
 (define-key mode "Ksto" 'kbfs-mode-sort-file-to-etourism-directory)
 (define-key mode "Ksfa" 'kbfs-mode-sort-file-to-fantasy-directory)
 (define-key mode "Ksfu" 'kbfs-mode-sort-file-to-fun-directory)
 (define-key mode "Ksga" 'kbfs-mode-sort-file-to-games-directory)
 (define-key mode "Kssc" 'kbfs-mode-sort-file-to-sci-fi-directory)
 (define-key mode "Kstr" 'kbfs-mode-sort-file-to-treasure-directory)

 (define-key mode "Ksai" 'kbfs-mode-sort-file-to-ai-directory)
 (define-key mode "Ksan" 'kbfs-mode-sort-file-to-animal-rights-directory)
 (define-key mode "Ksar" 'kbfs-mode-sort-file-to-art-directory)
 (define-key mode "Ksba" 'kbfs-mode-sort-file-to-backgrounds-directory)
 (define-key mode "Kscu" 'kbfs-mode-sort-file-to-culture-directory)
 (define-key mode "Ksda" 'kbfs-mode-sort-file-to-dating-directory)
 (define-key mode "Kshu" 'kbfs-mode-sort-file-to-humor-directory)
 (define-key mode "Ksir" 'kbfs-mode-sort-file-to-irish-directory)
 (define-key mode "Ksla" 'kbfs-mode-sort-file-to-lan-directory)
 (define-key mode "Ksme" 'kbfs-mode-sort-file-to-meredith-directory)
 (define-key mode "Ksmt" 'kbfs-mode-sort-file-to-miltech-directory)
 (define-key mode "Ksmi" 'kbfs-mode-sort-file-to-misc-directory)
 (define-key mode "Ksna" 'kbfs-mode-sort-file-to-nature-directory)
 (define-key mode "Kspa" 'kbfs-mode-sort-file-to-palestine-directory)
 (define-key mode "KspA" 'kbfs-mode-sort-file-to-pagan-directory)
 (define-key mode "Kspo" 'kbfs-mode-sort-file-to-politics-directory)
 (define-key mode "Ksse" 'kbfs-mode-sort-file-to-security-directory)
 (define-key mode "Kssl" 'kbfs-mode-sort-file-to-self-directory)
 (define-key mode "Ksso" 'kbfs-mode-sort-file-to-sophistication-directory)
 (define-key mode "Kste" 'kbfs-mode-sort-file-to-tech-directory)
 (define-key mode "Ksto" 'kbfs-mode-sort-file-to-tomes-directory)
 (define-key mode "Kscl" 'kbfs-mode-sort-file-to-classify-directory)
 (define-key mode "KstR" 'kbfs-mode-sort-file-to-tree-directory)
 (define-key mode "Kstg" 'kbfs-mode-sort-file-to-to-game-directory)

 (define-key mode "KSin" 'kbfs-mode-open-incoming-directory)
 (define-key mode "KSir" 'kbfs-mode-open-irish-directory)
 (define-key mode "KSbe" 'kbfs-mode-open-beauty-directory)
 (define-key mode "KSto" 'kbfs-mode-open-etourism-directory)
 (define-key mode "KSfa" 'kbfs-mode-open-fantasy-directory)
 (define-key mode "KSfu" 'kbfs-mode-open-fun-directory)
 (define-key mode "KSga" 'kbfs-mode-open-games-directory)
 (define-key mode "KSsc" 'kbfs-mode-open-sci-fi-directory)
 (define-key mode "KStr" 'kbfs-mode-open-treasure-directory)

 (define-key mode "KSai" 'kbfs-mode-open-ai-directory)
 (define-key mode "KSan" 'kbfs-mode-open-animal-rights-directory)
 (define-key mode "KSar" 'kbfs-mode-open-art-directory)
 (define-key mode "KSba" 'kbfs-mode-open-backgrounds-directory)
 (define-key mode "KScu" 'kbfs-mode-open-culture-directory)
 (define-key mode "KSda" 'kbfs-mode-open-dating-directory)
 (define-key mode "KShu" 'kbfs-mode-open-humor-directory)
 (define-key mode "KSir" 'kbfs-mode-open-irish-directory)
 (define-key mode "KSla" 'kbfs-mode-open-lan-directory)
 (define-key mode "KSme" 'kbfs-mode-open-meredith-directory)
 (define-key mode "KSmt" 'kbfs-mode-open-miltech-directory)
 (define-key mode "KSmi" 'kbfs-mode-open-misc-directory)
 (define-key mode "KSna" 'kbfs-mode-open-nature-directory)
 (define-key mode "KSpa" 'kbfs-mode-open-palestine-directory)
 (define-key mode "KSpA" 'kbfs-mode-open-pagan-directory)
 (define-key mode "KSpo" 'kbfs-mode-open-politics-directory)
 (define-key mode "KSse" 'kbfs-mode-open-security-directory)
 (define-key mode "KSsl" 'kbfs-mode-open-self-directory)
 (define-key mode "KSso" 'kbfs-mode-open-sophistication-directory)
 (define-key mode "KSte" 'kbfs-mode-open-tech-directory)
 (define-key mode "KSto" 'kbfs-mode-open-tomes-directory)
 (define-key mode "KScl" 'kbfs-mode-open-classify-directory)
 (define-key mode "KStR" 'kbfs-mode-open-tree-directory)
 (define-key mode "KStg" 'kbfs-mode-open-to-game-directory)

 )

(defun kbfs-mode-assert-knowledge-about-marked-files-file (&optional knowledge)
 ""
 (interactive)
 (kbfs-mode-assert-knowledge-about-marked-files knowledge nil 0 nil))

(defun kbfs-mode-assert-knowledge-about-marked-files-class (&optional knowledge)
 ""
 (interactive)
 (kbfs-mode-assert-knowledge-about-marked-files knowledge nil 1 nil))

(defun kbfs-mode-assert-knowledge-about-marked-files (&optional knowledge context class files)
 "Take the marked files and assert some piece of knowledge about them.
KNOWLEDGE is an emacs encoded knowledge, with 'var' for the document. Default is to
use freekbs2-stack.
CONTEXT is the FreeKBS2 Context to use. 
CLASS is either 0 for individual files  or 1 for files having the same contents.
FILES is a list of files to assert the knowledge about."
 (let*
  ((files2 (or files (dired-get-marked-files t current-prefix-arg)))
   (context2 (or context "Org::FRDCSA::KBFS::Tmp"))
   (knowledge2
    (prin1-to-string
     (kbfs-error-on-invalid-kbfs-knowledge 
      (if knowledge
       knowledge
       (if freekbs2-stack
	freekbs2-stack
	(read (concat "'" 
	       (read-from-minibuffer "Knowledge: (\"p\" var-_) ")))))))))
  (see
   (shell-command-to-string
    (concat "kbfs-tracker " (if class "-b " "-a ")
     (shell-quote-argument knowledge2) " -f "
     (join " "
      (mapcar (lambda (file) (shell-quote-argument (concat dired-directory file))) files2))
     " -x " (shell-quote-argument context2)
     )))))

(defun kbfs-error-on-invalid-kbfs-knowledge (knowledge)
 ""
 (if (freekbs2-formula-p knowledge)
  (if (freekbs2-verify-formula-has-a-free-default-variable-p knowledge)
   knowledge
   (error "error: formula does not have a free default variable (i.e. var-_) with which to bind the file."))
  (error "error: object is not a valid freekbs2 formula, and thus not valid kbfs knowledge.")))

(defun kbfs-mode-view-knowledge-about-marked-files-file (&optional no-buffer)
 ""
 (interactive)
 (kbfs-mode-view-knowledge-about-marked-files nil 0 nil no-buffer))

(defun kbfs-mode-view-knowledge-about-marked-files-class (&optional no-buffer)
 ""
 (interactive)
 (kbfs-mode-view-knowledge-about-marked-files nil 1 nil no-buffer))

(defun kbfs-mode-view-knowledge-about-marked-files (&optional context class files no-buffer)
 "Take the marked files and assert some piece of knowledge about them.
CONTEXT is the FreeKBS2 Context to use. 
CLASS is either 0 for individual files  or 1 for files having the same contents.
FILES is a list of files to assert the knowledge about."
 (let*
  ((files2 (or files (dired-get-marked-files t current-prefix-arg)))
   (context2 (or context "Org::FRDCSA::KBFS::Tmp"))
   (buffer (get-buffer-create (kbfs-mode-get-buffername-for-files context2 files2)))
   (my-shell-command
    (concat "kbfs-tracker " (if class "-d " "-c ") "-f "
     (join " "
      (mapcar (lambda (file) (concat dired-directory file)) files2))
     " -x " (shell-quote-argument context2)
     ))
   )
  ;; (see my-shell-command)
  (if no-buffer
   (shell-command-to-string my-shell-command)
   (freekbs2-knowledge-editor context2 buffer my-shell-command))))

(defun kbfs-mode-get-buffername-for-files (context files)
 ""
 (concat "all-asserted-knowledge for files in context: " context ", files: " (join " " files)))

;; (mapcar 'shell-quote-argument (mapcar (lambda (dir) (concat dired-directory (kmax-fix-local-file dir))) (kmax-directory-files-no-hidden "")))

(defun kbfs-mode-open-file ()
 ""
 (interactive)
 (let ((arguments
	(mapcar 'shell-quote-argument
	 (append
	  (list
	   "/var/lib/myfrdcsa/codebases/internal/kbfs/scripts/emacs-run-wrapper"
	   "xdg-open")
	  (kmax-grep-list-regexp
	   (dired-get-marked-files t current-prefix-arg) "^[^\.]")))))
  (shell-command (join " " arguments))))

(defun kbfs-mode-open-file-attempt-1 ()
 ""
 (interactive
  (let ((files (kmax-grep-list-regexp  (dired-get-marked-files t current-prefix-arg) "^[^\.]")))
   (run-in-shell (concat "xdg-open " (join " " (mapcar 'shell-quote-argument (mapcar (lambda (dir) (kmax-fix-local-file (frdcsa-el-concat-dir (list dired-directory dir)))) files))))))))

(defun kbfs-mode-open-file-attempt-2 ()
 ""
 (interactive
  (let ((files (kmax-grep-list-regexp  (dired-get-marked-files t current-prefix-arg) "^[^\.]")))
   (async-shell-command (concat "xdg-open " (join " " files)))
   ;; kmax-execute-in-background
   )))

(defun kbfs-mode-play-file-mplayer ()
 ""
 (interactive
  (let ((files (dired-get-marked-files t current-prefix-arg)))
   ;; (see files)
   (dired-do-shell-command "mplayer" nil files))))

(defun kbfs-mode-execute-clamscan ()
 ""
 (interactive
  (let ((files (dired-get-marked-files t current-prefix-arg)))
   ;; (see files)
   (dired-do-shell-command "clamscan" nil files))))

(defun kbfs-mode-distribute-files ()
 ""
 (interactive
  (let ((files (dired-get-marked-files t current-prefix-arg))
	(target (completing-read "BBDB Mail alias: " (append (bbdb-get-mail-aliases) (kbfs-get-contacts-on-selected-mailinglists))))
	)
   (if (not (= 1 (length files)))
    (message "Please do one file at a time")
    (kbfs-mode-assert-knowledge-about-marked-files
     (freekbs2-print-formula 
      (list "send_to_bbdb_alias" target 'var-_)))))))

(defun kbfs-get-contacts-on-selected-mailinglists ()
 ""
 "Return an alist (alias record-list net-list) elements."
 (let ((aliases (reverse (bbdb-collect-all-aliases)))
       as result)
  (setq as aliases)
  (while as
   (setq result (cons (bbdb-expand-alias (car as) aliases) result))
   (setq as (cdr as)))
  result))

;; (defun kbfs-mode-assert-knowledge-about-marked-files-using-tracker (&optional knowledge files)
;;  (interactive)
;;  "Take the marked files and assert some piece of knowledge about them.
;; KNOWLEDGE is an emacs encoded knowledge, with 'var' for the document. Default is to
;; use freekbs2-stack.
;; FILES is a list of files to assert the knowledge about."
;;  (let*
;;   ((files2 (or files (dired-get-marked-files t current-prefix-arg)))
;;    (knowledge2 (if knowledge
;; 		(freekbs2-print-formula knowledge)
;; 		(if freekbs2-stack
;; 		 (freekbs2-print-formula freekbs2-stack)
;; 		 (read-from-minibuffer "Knowledge: (\"p\" var-_) ")))
;;     ))
;;   (see
;;    (message ;; shell-command-to-string
;;     (concat "tracker-tag -a " 
;;      (shell-quote-argument knowledge2) " " 
;;      (join " "
;;       (mapcar (lambda (file) (shell-quote-argument (concat dired-directory file))) files2))
;; )))))

(defun kbfs-mode-invoke-shell ()
 ""
 (interactive)
 (if (derived-mode-p 'kbfs-mode)
  (run-in-shell (concat "cd " (shell-quote-argument (dired-current-directory))))))

;; (dired-current-directory)

;; (define-key kbfs-mode-map "Ka" 'kbfs-mode-assert-knowledge-about-marked-files)

(defun kbfs-mode-view-assertions-if-any ()
 ""
 (let ((text (kbfs-mode-view-knowledge-about-marked-files-class t) ))
  (if text
   (progn
    (message text)
    (sit-for 3)))))

(defun kbfs-mode-next-line (arg)
 ""
 (interactive "p")
 (dired-next-line arg)
 (kbfs-mode-view-assertions-if-any))

(defun kbfs-mode-previous-line (arg)
 ""
 (interactive "p")
 (dired-previous-line arg)
 (kbfs-mode-view-assertions-if-any))

(defun kbfs-mode-analyze-file ()
 "Analyze the file with additional markup using similar
 techniques to NLU and Sayer/Thinker.  Try to find the most
 salient or important or high entropic observations about a
 file."
 (interactive)
 ;; "/var/lib/myfrdcsa/codebases/internal/kbfs/scripts/kbfs-analyzer"
 ;; (kbfs-mode-analyze ())
 )

(defun kbfs-mode-analyze-marked-files ()
 ""
 (interactive)
 (kbfs-mode-analyze ()))

(defun kbfs-mode-analyze-directory ()
 ""
 (interactive)
 (kbfs-mode-analyze ()))

(defun kbfs-mode-analyze (files-and-directories)
 ""
 ;; retrieve a list of potential knowledge to assert about the files
 ;; and directories

 ;; affordances
 ())

(defun kbfs-mode-assertion-interface ()
 ""
 (interactive)
 
 )

(defun kbfs-mode-reload-kbfs ()
 ""
 (interactive)
 (if (derived-mode-p 'kbfs-mode)
  (let* ((dirname (dired-current-directory)))
   (kill-buffer (current-buffer))
   (dired dirname)
   (kbfs))))

(defvar kbfs-mode-file-data-file
 "/var/lib/myfrdcsa/codebases/internal/kbfs/data/KBFSTrackerFile.dat")
(defvar kbfs-mode-file-class-data-file
 "/var/lib/myfrdcsa/codebases/internal/kbfs/data/KBFSTrackerFileClass.dat")

(defun kbfs-mode-view-tracker-file-data ()
 ""
 (interactive)
 (ffap kbfs-mode-file-data-file))

(defun kbfs-mode-view-tracker-file-class-data ()
 ""
 (interactive)
 (ffap kbfs-mode-file-class-data-file))

(defun kbfs-mode-reset-data-files ()
 ""
 (interactive)
 (freekbs2-clear-context "Org::FRDCSA::KBFS::Tmp")
 (delete-file kbfs-mode-file-data-file)
 (delete-file kbfs-mode-file-class-data-file))

(defun kbfs-mode-system-radar--declare-desire-to-package-file ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((user (kmax-get-user))
	(context "Org::FRDCSA::RADAR")
	(formula (list "desires"
		  user
		  (list "package-file" user 'var-_)
		  )))
  (kbfs-mode-assert-knowledge-about-marked-files-class formula)))

(defun kbfs-mode-system-radar--declare-file-related-to-system ()
 ""
 (interactive)
 ;; assert into a knowledge base somewhere that the current user has
 ;; an academic interest in this topic

 (let* ((user (kmax-get-user))
	(context "Org::FRDCSA::RADAR")
	(formula (list "desires"
		  user
		  (list "package-file" user 'var-_)
		  )))
  (kbfs-mode-assert-knowledge-about-marked-files-class formula)))

(if nil
 (save-excursion
  (ffap "/var/lib/myfrdcsa/codebases/internal/freekbs2/scripts/morbini-phd-thesis.pdf")
  (let ((formula (list "p" 'var-_)))
   (kbfs-mode-assert-knowledge-about-marked-files formula nil t (list (buffer-file-name)))))
 )

(defun kbfs-mode-sort-file-to-directory (topic dir)
 ""
 (let ((chosen-dir (if (string= topic "diversion")
		    "/home/andrewdo/Media/projects/diversion/"
		    (if (string= topic "pictures")
		     "/home/andrewdo/Media/projects/diversion/pictures/"
		     (if (string= topic "classify")
		      "/var/lib/myfrdcsa/codebases/internal/classify/data/"))))
       (file-name (kbfs-mode-get-filename)))
  (if (kmax-mode-is-derived-from 'kbfs-image-mode)
   (image-next-file))
  (shell-command-to-string
   (concat "mv -n " (shell-quote-argument (file-chase-links file-name))
    " " (shell-quote-argument (concat chosen-dir dir))))
  (if (kmax-mode-is-derived-from 'kbfs-mode)
   (revert-buffer))))

(defun kbfs-mode-sort-file-to-irish-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "irish"))

(defun kbfs-mode-sort-file-to-beauty-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "beauty"))

(defun kbfs-mode-sort-file-to-etourism-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "diversion" "etourism"))

(defun kbfs-mode-sort-file-to-fantasy-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "fantasy"))

(defun kbfs-mode-sort-file-to-fun-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "fun"))

(defun kbfs-mode-sort-file-to-games-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "games"))

(defun kbfs-mode-sort-file-to-meredith-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "meredith"))

(defun kbfs-mode-sort-file-to-sci-fi-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "sci-fi"))

(defun kbfs-mode-sort-file-to-treasure-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "treasure"))


(defun kbfs-mode-sort-file-to-ai-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "ai"))

(defun kbfs-mode-sort-file-to-animal-rights-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "animal-rights"))

(defun kbfs-mode-sort-file-to-art-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "art"))

(defun kbfs-mode-sort-file-to-backgrounds-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "backgrounds"))

(defun kbfs-mode-sort-file-to-culture-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "culture"))

(defun kbfs-mode-sort-file-to-dating-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "dating"))

(defun kbfs-mode-sort-file-to-humor-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "humor"))

(defun kbfs-mode-sort-file-to-irish-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "irish"))

(defun kbfs-mode-sort-file-to-lan-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "lan"))

(defun kbfs-mode-sort-file-to-miltech-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "miltech"))

(defun kbfs-mode-sort-file-to-incoming ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "incoming"))

(defun kbfs-mode-sort-file-to-misc-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "misc"))

(defun kbfs-mode-sort-file-to-nature-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "nature"))

(defun kbfs-mode-sort-file-to-palestine-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "palestine"))

(defun kbfs-mode-sort-file-to-pagan-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "pagan"))

(defun kbfs-mode-sort-file-to-politics-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "politics"))

(defun kbfs-mode-sort-file-to-security-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "security"))

(defun kbfs-mode-sort-file-to-self-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "self"))

(defun kbfs-mode-sort-file-to-tech-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "tech"))

(defun kbfs-mode-sort-file-to-tomes-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "tomes"))

(defun kbfs-mode-sort-file-to-sophistication-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "pictures" "sophistication"))

(defun kbfs-mode-sort-file-to-classify-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "classify" "outbound/systems/node"))

(defun kbfs-mode-sort-file-to-tree-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "classify" "outbound/systems/node/Tree"))

(defun kbfs-mode-sort-file-to-to-game-directory ()
 ""
 (interactive)
 (kbfs-mode-sort-file-to-directory "classify" "outbound/systems/game"))

(defun kbfs-mode-sort-add-new-directory ()
 ""
 (interactive)
 (kbfs-not-yet-implemented)
 (setq kbfs-mode-sort-add-new-directory-list
  (list "pictures/infrastructure")))

(defun kbfs-mode-sort-list-directories ()
 ""
 (interactive)
 (kbfs-not-yet-implemented))

(defun kbfs-mode-open-incoming-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "incoming"))

(defun kbfs-mode-open-irish-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "irish"))

(defun kbfs-mode-open-beauty-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "beauty"))

(defun kbfs-mode-open-etourism-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "diversion" "etourism"))

(defun kbfs-mode-open-fantasy-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "fantasy"))

(defun kbfs-mode-open-fun-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "fun"))

(defun kbfs-mode-open-games-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "games"))

(defun kbfs-mode-open-meredith-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "meredith"))

(defun kbfs-mode-open-sci-fi-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "sci-fi"))

(defun kbfs-mode-open-treasure-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "treasure"))


(defun kbfs-mode-open-ai-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "ai"))

(defun kbfs-mode-open-animal-rights-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "animal-rights"))

(defun kbfs-mode-open-art-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "art"))

(defun kbfs-mode-open-backgrounds-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "backgrounds"))

(defun kbfs-mode-open-culture-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "culture"))

(defun kbfs-mode-open-dating-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "dating"))

(defun kbfs-mode-open-humor-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "humor"))

(defun kbfs-mode-open-irish-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "irish"))

(defun kbfs-mode-open-lan-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "lan"))

(defun kbfs-mode-open-miltech-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "miltech"))

(defun kbfs-mode-open-misc-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "misc"))

(defun kbfs-mode-open-nature-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "nature"))

(defun kbfs-mode-open-palestine-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "palestine"))

(defun kbfs-mode-open-pagan-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "pagan"))

(defun kbfs-mode-open-politics-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "politics"))

(defun kbfs-mode-open-security-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "security"))

(defun kbfs-mode-open-self-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "self"))

(defun kbfs-mode-open-tech-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "tech"))

(defun kbfs-mode-open-tomes-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "tomes"))

(defun kbfs-mode-open-sophistication-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "pictures" "sophistication"))

(defun kbfs-mode-open-classify-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "classify" "outbound/systems/node"))

(defun kbfs-mode-open-tree-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "classify" "outbound/systems/node/Tree"))

(defun kbfs-mode-open-to-game-directory ()
 ""
 (interactive)
 (kbfs-mode-open-directory "classify" "outbound/systems/game"))

(defun kbfs-mode-open-directory (topic dir)
 ""
 (let ((chosen-dir
	(if (string= topic "diversion")
	 "/home/andrewdo/Media/projects/diversion/"
	 (if (string= topic "pictures")
	  "/home/andrewdo/Media/projects/diversion/pictures/"
	  (if (string= topic "classify")
	   "/var/lib/myfrdcsa/codebases/internal/classify/data/")))))
  (dired (concat chosen-dir dir))))

(defun kbfs-mode-get-filename-old (&optional arg)
 ""
 (interactive "P")
 (or (dired-get-subdir)
  (mapconcat (function identity)
   (if arg
    (cond ((zerop (prefix-numeric-value arg))
	   (dired-get-marked-files))
     ((consp arg)
      (dired-get-marked-files t))
     (t
      (dired-get-marked-files
       'no-dir (prefix-numeric-value arg))))
    (dired-get-marked-files 'no-dir))
   " ")))

(defun kbfs-mode-get-filename (&optional arg)
 ""
 (interactive "P")
 (cond
  ((kmax-mode-is-derived-from 'kbfs-mode)
   (or
    (dired-get-subdir)
    (mapconcat (function identity)
     (if arg
      (cond ((zerop (prefix-numeric-value arg))
	     (dired-get-marked-files))
       ((consp arg)
	(dired-get-marked-files t))
       (t
	(dired-get-marked-files
       'no-dir (prefix-numeric-value arg))))
    (dired-get-marked-files 'no-dir))
     " ")))
  ((kmax-mode-is-derived-from 'kbfs-image-mode)
   buffer-file-name)))

(defun kbfs-mode-search-for-next-image-file ()
 ""
 (interactive)
 (re-search-forward "\\.\\(jpg\\|jpeg\\|png\\|pnm\\|gif\\|JPG\\|JPEG\\|PNG\\|PNM\\|GIF\\)$"))



(defun kbfs-mode-copy-full-filename-as-kill ()
 ""
 (interactive)
 (kill-new (message (file-chase-links (dired-get-filename))))) 

(define-key kbfs-mode-map "K1" 'kbfs-mode-play-file-mplayer-1)

(defun kbfs-mode-play-file-mplayer-1 (&optional files-arg)
 ""
 (interactive)
 (let ((files (or files-arg
	       (dired-get-marked-files t current-prefix-arg))))
  (shell-command
   (concat "/var/lib/myfrdcsa/codebases/minor/media-library/scripts/m1 "
    (shell-quote-argument (car files))))))

(define-key kbfs-mode-map "K2" 'kbfs-mode-play-file-mplayer-2)

(defun kbfs-mode-play-file-mplayer-2 (&optional files-arg)
 ""
 (interactive)
 (let ((files (or files-arg
	       (dired-get-marked-files t current-prefix-arg))))
  (shell-command
   (concat "/var/lib/myfrdcsa/codebases/minor/media-library/scripts/m2 "
    (shell-quote-argument (car files))))))

;; (defun image-mode--images-in-directory (file)
;;   (let* ((dir (file-name-directory buffer-file-name))
;; 	 (files (directory-files dir nil
;; 				 (image-file-name-regexp) t)))
;;     ;; Add the current file to the list of images if necessary, in
;;     ;; case it does not match `image-file-name-regexp'.
;;     (unless (member file files)
;;       (push file files))
;;    (sort files ;;'string-lessp)))
;;     (lambda (a b) (zerop (random 2))))))
    

;; ;; C-u M-! ls -l | sort -R RET and then M-x dired-virtual RET in the result

;; ;; (defun kbfs-view-randomized-list-of-files ()
;; ;;  ""
;; ;;  (interactive)
;; ;;  (kmax-check-mode 'kbfs-mode)
;; ;;  ;; from: https://lists.gnu.org/archive/html/help-gnu-emacs/2009-01/msg00437.html
;; ;;  (dired (cons (generate-new-buffer-name "My Dired")
;; ;; 	 (nreverse (mapcar (lambda (file)
;; ;; 			    (if (file-name-absolute-p file)
;; ;; 			     (expand-file-name file)
;; ;; 			     file))
;; ;; 		    (see (sort (directory-files dired-directory)
;; ;; 			  (lambda (a b) (zerop (random 2))))))))))

(defun kbfs-clean-emacs-backups (&optional arg)
 (interactive "P")
 (kmax-clean-emacs-backups arg)
 (revert-buffer))

(defvar kbfs-default-context "Org::FRDCSA::KBFS")

(defun kbfs-request-new-category-for-type (type category-name &optional context)
 "Declare the image that is being visited in the current buffer is a meme"
 (interactive)
 (let* ((user (kmax-get-user))
	(context (or context kbfs-default-context))
	(category-name category-name)
	(formula (list "desires" user
		  (list "newCategoryFn" type category-name))))
  (message (concat "Asserted " (prin1-to-string formula) " to " context))
  (freekbs2-assert-formula formula context)))

(defun kbfs-convert-cycl-list-to-list (results)
 (mapcar
  #'cadar
  (freekbs2-get-cycl-from-details results)))

(defun kbfs-list-all-categories-for-type (type &optional context)
 (kbfs-convert-cycl-list-to-list
  (freekbs2-query
   (list "desires" (kmax-get-user) (list "newCategoryFn" type 'var-category))
   (or context kbfs-default-context))))

(defun kbfs-create-new-category ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

(define-key kbfs-mode-map "Km" 'kbfs-mode-killall-mplayer)
(defun kbfs-mode-killall-mplayer ()
 ""
 (interactive)
 (shell-command "killall -9 mplayer"))

(defun kbfs-mode-set-image-as-background ()
 ""
 (interactive)
 (let* ((files (dired-get-marked-files t current-prefix-arg))
	(file (file-chase-links (frdcsa-el-concat-dir (list (dired-current-directory) (car files))))))
  (manager-approve-commands
   (list
    (concat
     "gsettings set org.gnome.desktop.background picture-uri "
     (shell-quote-argument (concat "file://" file)))
    "gsettings set org.gnome.desktop.background picture-options centered"
    (concat "cp -ar --backup=numbered "
     (shell-quote-argument file)
     " "
     (shell-quote-argument "/home/andrewdo/Media/backgrounds")))
   "Set this to desktop?" 'parallel nil)))

(defun kbfs-do-rename ()
 (interactive "P")
 ;; see dired-do-rename
 (kmax-not-yet-implemented)
 ;; (dired-get-marked-files nil arg)
 )

(defun kbfs-search-dired ()
 ""
 (interactive)
 (progn
  (dired-mark-files-regexp (read-from-minibuffer "Regexp?: "))
  (dired-toggle-marks)
  (dired-do-kill-lines)))

(defun kbfs-interactively-walk-slash-traverse-dired-recursively-next ()
 ""
 (interactive)
 ;; have a mode for DFS and BFS, etc, other search techinques as well
 (let ((short-filename (dired-get-filename t t)))
  (if (> (length short-filename) 0)
   (if (file-directory-p (expand-file-name short-filename))
    (dired-find-file)
    (dired-next-line 1))
   (progn
    (kmax-kill-buffer-no-ask (current-buffer))
    (dired-next-line 1)))))

(defun kbfs-interactively-walk-slash-traverse-dired-recursively-previous ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

;; (defun kbfs-interactively-walk-slash-traverse-dired-recursively-previous ()
;;  ""
;;  (interactive)
;;  ;; have a mode for DFS and BFS, etc, other search techinques as well
;;  (let ((short-filename (dired-get-filename t t))
;;        (previous-short-filename
;; 	(save-excursion
;; 	 (dired-previous-line 1)
;; 	 (dired-get-filename t t))))
;;   (message previous-short-filename)
;;   (if (> (length short-filename) 0)
;;    (if (or (file-directory-p (expand-file-name short-filename)) (string= short-filename ".."))
;;     (dired-find-file)
;;     (dired-previous-line 1))
;;    (progn
;;     (kmax-kill-buffer-no-ask (current-buffer))
;;     (dired-previous-line 1)))))

(setq kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file nil)

(defun kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open (&optional other-window)
 ""
 (interactive)
 ;; have a mode for DFS and BFS, etc, other search techinques as well
 (let ((short-filename (dired-get-filename t t)))
  (if (> (length short-filename) 0)
   (if (file-directory-p (expand-file-name short-filename))
    (if (not (string= (dired-get-filename t t) kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file))
     (progn
      (setq kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file (dired-get-filename t t))
      (kbfs-ffap (dired-get-filename t t) other-window))
     (dired-find-file))
    (if (not (string= (dired-get-filename t t) kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file))
     (progn
      (setq kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file (dired-get-filename t t))
      (kbfs-ffap (dired-get-filename t t) other-window))
     (dired-next-line 1)))
  (progn
   (kmax-kill-buffer-no-ask (current-buffer))
   (progn
    (message "ho")
    (dired-next-line 1)
    ;; (kbfs-traverse-minor-mode)
    )))))

(defun kbfs-ffap (&optional file-arg other-window)
 ""
 (interactive)
 (let*
  ((file (or file-arg (dired-get-filename t t))))
  (if (kmax-mode-is-derived-from 'dired-mode)
   (if other-window
    (progn
     (ffap file)
     (switch-to-buffer nil)
     (delete-other-windows)
     (split-window-right)
     (other-window 1)
     (switch-to-buffer nil)
     (other-window 1))
    (ffap file)))))

(defun kbfs-interactively-walk-slash-traverse-dired-recursively-previous-and-open ()
 ""
 (interactive)
 (kmax-not-yet-implemented))

;; (defun kbfs-interactively-walk-slash-traverse-dired-recursively-previous-and-open ()
;;  ""
;;  (interactive)
;;  ;; have a mode for DFS and BFS, etc, other search techinques as well
;;  (let ((short-filename (dired-get-filename t t)))
;;   (if (> (length short-filename) 0)
;;    (if (file-directory-p (expand-file-name short-filename))
;;     (if (not (string= (dired-get-filename t t) kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file))
;;      (progn
;;       (setq kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file (dired-get-filename t t))
;;       (ffap (dired-get-filename t t)))
;;      (dired-find-file))
;;     (if (not (string= (dired-get-filename t t) kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file))
;;      (progn
;;       (setq kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open-last-seen-file (dired-get-filename t t))
;;       (ffap (dired-get-filename t t)))
;;      (dired-next-line 1)))
;;   (progn
;;    (kmax-kill-buffer-no-ask (current-buffer))
;;    (progn
;;     (message "ho")
;;     (dired-next-line 1))))))


(defun kbfs-move-file-to-codebase-incoming (&optional source)
 "Move the file to a codebases incoming directory"
 (interactive)
 ;; if in dired mode grab the item under point
 ;; otherwise thing at point
 (kbfs-move-file-to-codebase-special-dir nil "data/.incoming"))

(defun kbfs-move-file-to-codebase-incoming-dired ()
 "Move the file to a codebases incoming directory and revert buffer in dired mode"
 (interactive)
 (kbfs-move-file-to-codebase-incoming (dired-get-filename))
 (revert-buffer))

;; (load-library "dired")
;; (define-key dired-mode-map "r"
;;  'radar-move-file-to-codebase-incoming-dired)

(defun kbfs-move-file-to-codebase-documentation (&optional source)
 "Move the file to a codebases documentation directory"
 (interactive)
 (radar-move-file-to-codebase-special-dir source "doc"))

(defun kbfs-move-file-to-codebase-special-dir (&optional source-arg special-dir-arg)
 "Move the file to a codebases documentation directory"
 (interactive)
 ;; eventually, apply machine learning to determine appropriate locations
 (let*
  ((dir (radar-select-directory))
   (source (if source-arg
	    source-arg
	    (dired-get-filename t t)))
   (special-dir
    (or special-dir-arg
     (completing-read "Special Directory Name?: " (list "doc" "systems" "projects" "data" "data-git"))))
   (dest (concat dir "/" special-dir "/"))
   (command (concat "mv " (shell-quote-argument source) " " (shell-quote-argument dest))))
  (see command 0.1)
  (kmax-mkdir-p dest)
  (shell-command-to-string command)
  ;; record this into the event system for classification, or into learner for classification
  (if uea-connected
   (freekbs2-assert (list "moved-to-codebase-documentation" source dest) freekbs2-context))
  ;; (revert-buffer)
  ))

(defun kbfs-sort-categorize-files ()
 ""
 (interactive)
 (kbfs-interactively-walk-slash-traverse-dired-recursively-next-and-open t)
 (kbfs-move-file-to-codebase-special-dir)
 (other-window 1)
 (kmax-kill-buffer-no-ask (current-buffer))
 (other-window 1)
 (revert-buffer)
 (recenter-top-bottom)
 ;; (kbfs-sort-categorize-files)
 )

(add-to-list 'load-path "/var/lib/myfrdcsa/codebases/internal/kbfs/frdcsa/emacs")

;; (dired-get-filename t t)
;; (expand-file-name NAME &optional DEFAULT-DIRECTORY)

;; (setq dired-dwim-target t)

;; (see /var/lib/myfrdcsa/codebases/internal/kbfs/frdcsa/emacs/kbfs-image-mode.el)

(require 'kbfs-sort-mode)
(require 'kbfs-image-mode)

(provide 'kbfs)

