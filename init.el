;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-visual-line-mode t)
 '(package-selected-packages
   (quote
    (exec-path-from-shell urscript-mode ibuffer-sidebar all-the-icons-dired dired-sidebar ag projectile xkcd which-key use-package doom-modeline highlight-symbol beacon doom-themes centaur-tabs highlight-indent-guides magit py-autopep8 flycheck elpy ein))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      package-selected-packages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

;; TODO: ag requires to install ag first:
;; https://github.com/ggreer/the_silver_searcher#installation

(setq inhibit-startup-message t) ;; hide the startup message
(global-linum-mode t) ;; enable line numbers globally

;; enable ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(tool-bar-mode -1) ;; disable tool-bar
(menu-bar-mode -1) ;; disable menu-bar
(toggle-scroll-bar -1) ;; disable scroll bars
(windmove-default-keybindings) ;; enable windmove
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)

(exec-path-from-shell-initialize)

(if (equal window-system 'ns)
        (set-face-font 'default "Hack-12") ;; Setting font for macos
    (set-face-font 'default "Hack-9")) ;; Setting font for other
(setq-default indent-tabs-mode nil) ;; use spaces

(beacon-mode 1) ;; enable beacon-mode (cursor highlighting)
(auto-complete-mode 1) ;; enable auto-completion
(which-key-mode 1)

;; Keep searched strings highlighted
(setq lazy-highlight-cleanup nil)
(setq lazy-highlight-max-at-a-time nil)
(setq lazy-highlight-initial-delay 0)


 ;; Configure Indent guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character) ;; sets vertical lines for indents


(require 'use-package)
;; Centaur TABS config
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))
(setq centaur-tabs-set-modified-marker t)
(setq centaur-tabs-style "chamfer")
(setq centaur-tabs-set-bar 'left)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-gray-out-icons 'buffer)

;; Doome Themes config
(require 'doom-themes)
;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-snazzy t)
;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(doom-themes-treemacs-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;; Hightlight symbol config (show corresponding brackets)
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

;; Enable Powerline "Doom modeline"
(require 'doom-modeline)
(doom-modeline-mode 1)
;; Install necessary fonts for this:
;; TODO:  M-X, all-the-icons-install-fonts

;; project manager 'projectile' config
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; (setq projectile-indexing-method 'native)

;; Add dired sidebar
(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  ;; (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;; Add sidebar buffer
(use-package ibuffer-sidebar
  :load-path "~/.emacs.d/fork/ibuffer-sidebar"
  :ensure nil
  :commands (ibuffer-sidebar-toggle-sidebar)
  :config)
  ;; (setq ibuffer-sidebar-use-custom-font t)
  ;; (setq ibuffer-sidebar-face `(:family "Helvetica" :height 140)))

;; Toggle sidebar and ibuffer-sidebar
(defun +sidebar-toggle ()
  "Toggle both `dired-sidebar' and `ibuffer-sidebar'."
  (interactive)
  (dired-sidebar-toggle-sidebar)
  (ibuffer-sidebar-toggle-sidebar))

(global-set-key (kbd "C-x C-n") '+sidebar-toggle)
