;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "PragmataPro Mono Liga" :size 23)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 24)
      doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font" :weight 'bold :size 21)
      doom-big-font (font-spec :family "PragmataPro Mono Liga" :size 37))

(setq dotfiles-dir (substitute-in-file-name "$HOME/.dotfiles/"))

(use-package! org
  :init
  (setq org-directory "~/education/org")
  :custom
  (org-babel-confirm-evaluate nil)
  (org-ellipsis " ")
  (org-hide-emphasis-markers t)
  (org-agenda-files (mapcar (lambda (dir) (expand-file-name dir org-directory)) '("roam/" "roam/daily/")))
  (org-agenda-start-with-log-mode t)
  (org-log-into-drawer t)
  (org-log-done nil)
  (org-log-note-clock-out t)
  (org-babel-load-languages '((emacs-lisp . t) (haskell . t) (python . t) (eshell . t) (lisp . t) (latex . t))))

(use-package! org-tempo
  :config
  (add-to-list 'org-structure-template-alist (cons "sh" "src shell"))
  (add-to-list 'org-structure-template-alist (cons "esh" "src eshell"))
  (add-to-list 'org-structure-template-alist (cons "el" "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist (cons "cl" "src lisp"))
  (add-to-list 'org-structure-template-alist (cons "hs" "src haskell"))
  (add-to-list 'org-structure-template-alist (cons "py" "src python")))

(use-package! org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("w" "wiki" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: wiki\n#+startup: overview\n* REPOS\n* VIDEOS\n* ARTICLES\n* BOOKS\n* OTHER LINKS")
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%I:%M %p>: %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (:map org-mode-map
         ("C-M-i" . completion-at-point))
  :config
  (require 'org-roam-dailies)
  (org-roam-db-autosync-mode))

(use-package! org-wild-notifier
  :hook (org-mode . org-wild-notifier-mode))

(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode))

(use-package! doct
  :commands (doct))

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))

(use-package! pdf-tools
 :custom
 (pdf-view-resize-factor 1.05)
 :hook (pdf-view-mode . pdf-view-midnight-minor-mode))

(defun org-toggl-prettify-heading (heading)
  (require 'subr-x)
  (string-trim (string-remove-prefix "[ ]" (org-link-display-format heading))))

(map! :leader :desc "Open config.org" "oc" (lambda () (interactive) (find-file (expand-file-name "config.org" doom-user-dir))))

(map! :leader :desc "Open home.nix" "oh" (lambda () (interactive) (find-file (expand-file-name "home/home.nix" dotfiles-dir))))

(use-package! hcl-mode)
