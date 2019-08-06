;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(dracula-theme
    magit))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'dracula t) ;; load dracula theme
(global-linum-mode t) ;; enable line numbers globally

;; enable ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(tool-bar-mode -1) ;; disable tool-bar

(windmove-default-keybindings) ;; enable windmove
(set-face-attribute 'default nil :height 90) ;; Setting font size

(setq-default indent-tabs-mode nil) ;; use spaces

(global-visual-line-mode t) ;; use visual line mode
;; init.el ends here;; init.el --- Emacs configuration
