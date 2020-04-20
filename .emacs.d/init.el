(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; MELPA-stableを追加
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; Orgを追加
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; 初期化
(package-initialize)

;;load-path追加
(setq load-path (cons "~/.emacs.d/elisp" load-path))

;; ディレクトリをサブディレクトリごとload-pathに追加
;; https://qiita.com/icb54615/items/4c652ad4afccae5fe2ef
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
     (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
         (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
             (normal-top-level-add-subdirs-to-load-path))))))
(add-to-load-path "elisp")

;;ファルパスからファイルを開く
(ffap-bindings)

(set-frame-parameter nil 'unsplittable t)

;;補完
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t) ;; 中間/あいまい一致

;;yes/no -> y/n
(defalias 'yes-or-no-p 'y-or-n-p)

; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; バックアップファイルを作成させない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; タブにスペースを使用する
(setq-default tab-width 8 indent-tabs-mode nil)

;; 改行コードを表示する
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; メニューバーを消す
(menu-bar-mode -1)

;; ツールバーを消す
(tool-bar-mode -1)

;; 列数を表示する
(column-number-mode t)

;; カーソルの点滅をやめる
(blink-cursor-mode 0)

;; 対応する括弧を光らせる
(show-paren-mode 1)

;; ウィンドウ内に収まらないときだけ、カッコ内も光らせる
(setq show-paren-style 'mixed)

;; スクロールは１行ごとに
(setq scroll-conservatively 1)

;;; スクロールを一行ずつにする
(setq scroll-step 1)

;; C-kで行全体を削除する
(setq kill-whole-line t)

;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)

;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)

;;; モードラインに情報を表示
(display-time)
(line-number-mode 1)
(column-number-mode 1)

;;; 現在の関数名をモードラインに表示
(which-function-mode 1)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)

;; elips

;;ポップアップ
;; 選択した領域を使ってインクリメンタル検索を実行
;; http://swiftlife.hatenablog.jp/entry/2016/02/21/144716
  (defadvice isearch-mode (around isearch-mode-default-string
                                  (forward &optional regexp op-fun recursive-edit word-p)
                                  activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))

;; popwin
(require 'popwin)
(popwin-mode 1)

;; gtags
;; (autoload 'gtags-mode "gtags" "" t)
;; (setq gtags-mode-hook
;;     '(lambda ()
;;         (local-set-key "\M-t" 'gtags-find-tag)    ;関数へジャンプ
;;         (local-set-key "\M-r" 'gtags-find-rtag)   ;関数の参照元へジャンプ
;;         (local-set-key "\M-s" 'gtags-find-symbol) ;変数の定義元/参照先へジャンプ
;;         (local-set-key "\C-t" 'gtags-pop-stack)   ;前のバッファに戻る
;;         ))
;; (add-hook 'c-mode-hook 'gtags-mode)
;; (add-hook 'c++-mode-hook 'gtags-mode)

;; package

;;magit
(global-set-key (kbd "C-x C-g") 'magit-status)

;;git-gutter
(global-git-gutter-mode t)

;;undo-tree
(require 'undo-tree)
(global-undo-tree-mode t)

;; カッコ補完
(require 'smartparens-config)
(smartparens-global-mode t)
(show-smartparens-global-mode t)

(autoload 'dockerfile-mode "dockerfile-mode" nil t)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(autoload 'docker-compose-mode "docker-compose-mode" nil t)
(add-to-list 'auto-mode-alist '("docker-compose.yml\\'" . docker-compose-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (markdown-mode sudo-edit docker-compose-mode dockerfile-mode undo-tree smartparens magit git-gutter))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

