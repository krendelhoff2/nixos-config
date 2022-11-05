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

(setq c-basic-offset 4
      c-tab-always-indent t
      c-default-style "bsd")

(define-key c-mode-base-map (kbd "<tab>") (lambda () (interactive) (insert-char ?\t)))

(add-hook! (c-mode)
  (indent-tabs-mode))

(add-hook! (rust-mode)
 (setq rust-indent-offset 2))
