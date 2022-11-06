
(setq user-full-name "Dmitry Laptov"
      user-mail-address "dmitry.laptov@serokell.io")

(setq doom-theme 'doom-one)

(setq display-line-numbers-type 'relative)


(setq company-minimum-prefix-length 4
      company-idle-delay 1.0)

(setq projectile-globally-ignored-directories (list ".direnv" "/home/savely/education/org/.attach/" "^.ccls-cache$" "~/.emacs.d/.local/" "^\\.idea$" "^\\.vscode$" "^\\.ensime_cache$" "^\\.eunit$" "^\\.git$" "^\\.hg$" "^\\.fslckout$" "^_FOSSIL_$" "^\\.bzr$" "^_darcs$" "^\\.pijul$" "^\\.tox$" "^\\.svn$" "^\\.stack-work$" "^\\.ccls-cache$" "^\\.cache$" "^\\.clangd$"))

(global-subword-mode)

(setq auth-sources '("~/.authinfo"))

(add-to-list 'auto-mode-alist '("\\.yuck\\'" . parinfer-rust-mode))

(setq multi-term-program "bash")

(after! lsp-haskell
  (setq lsp-ui-sideline-enable nil
        lsp-ui-peek-enable t
        lsp-haskell-formatting-provider "stylish-haskell"
        lsp-haskell-plugin-import-lens-code-lens-on nil))

(map! :leader :desc "Treemacs select window" "0" #'treemacs-select-window)

(map! :desc "One more evil quit" :map evil-window-map "C-q" #'evil-quit)

(map! :map eshell-mode-map :i "C-n" #'eshell-next-matching-input-from-input :n "C-n" #'eshell-next-matching-input-from-input)

(map! :map eshell-mode-map :i "C-p" #'eshell-previous-matching-input-from-input :n "C-p" #'eshell-previous-matching-input-from-input)

(map! :leader :desc "Turn off ex highlighting" "sc" #'evil-ex-nohighlight)

(add-hook! (c-mode)
  (setq c-basic-offset 4
        c-tab-always-indent t
        c-default-style "bsd")
  (indent-tabs-mode)
 (defun c-indent-command (&optional arg)
   (insert-char ?\t)))

(add-hook! (rust-mode)
 (setq rust-indent-offset 2))
