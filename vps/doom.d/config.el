;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Dmitry Laptov"
      user-mail-address "dmitry.laptov@serokell.io")

(setq doom-theme 'doom-one)

(setq display-line-numbers-type 'relative)

(global-subword-mode)

(map! :leader :desc "Treemacs select window" "0" #'treemacs-select-window)

(map! :map eshell-mode-map :i "C-n" #'eshell-next-matching-input-from-input :n "C-n" #'eshell-next-matching-input-from-input)

(map! :map eshell-mode-map :i "C-p" #'eshell-previous-matching-input-from-input :n "C-p" #'eshell-previous-matching-input-from-input)

(map! :leader :desc "Turn off ex highlighting" "sc" #'evil-ex-nohighlight)

(add-hook! (c-mode)
 (setq c-basic-offset 4)
 (indent-tabs-mode)
 (setq c-tab-always-indent t)
 (define-key c-mode-base-map (kbd "<tab>") (lambda () (interactive) (insert-char ?\t))))
