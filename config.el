;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 16 :weight 'medium))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one-light)
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defun my/babashka-nrepl ()
  "Start a Babashka nREPL server and connect to it with Cider."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (make-process
     :name "babashka"
     :buffer nil
     :command '("bb" "--nrepl-server" "1667")
     :sentinel (lambda (process event)
             (message "Process %s finished with event: %s" process event)))
    (sleep-for 2)
    (cider-connect-clj '(:host "localhost" :port 1667))))

(map! :map clojure-mode-map
      "C-c j" #'my/babashka-nrepl)

(map! "<f3>" #'treemacs)

;; A configuração de inicialização está correta
(setq org-startup-indented t)
(setq org-startup-folded 'content)

;; O 'save-place' já é ativado pelo Doom, mas esta linha 
;; garante que ele ignore arquivos temporários ou sem leitura
(setq save-place-forget-unreadable-files t)

;; O hook para persistir a visibilidade do Org
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'kill-buffer-hook #'org-save-outline-visibility nil t)))

;; Maximiza a janela ao iniciar
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Configuração do gptel
(setq auth-sources '("~/.authinfo"))
(setq
 gptel-model 'gemini-3.5-flash
; gptel-backend (gptel-make-gemini "Gemini"
;                 :key nil
;                 :stream t))
 gptel-backend
 (gptel-make-gemini "Gemini"
   :key (lambda ()
          (let ((creds (car (auth-source-search :host "generativelanguage.googleapis.com" :user "apikey"))))
            (funcall (plist-get creds :secret))))))

(map! :leader
      :desc "gptel"
      "o g" #'gptel)

(defun custom-banner ()
  (let* ((banner
          '(
            ""
            ""
            "                                 M A Y B E   K I N D N E S S   I S   T H E   R E A L   P U N K   R O C K"
            ""
            ""))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert line "\n"))
     'face 'doom-dashboard-banner)))

(setq! +dashboard-functions
       '(custom-banner
         +dashboard-widget-shortmenu
         +dashboard-widget-footer
         +dashboard-widget-loaded))

;; Pra garantir o which-key-mode ligado
(which-key-mode 1)

