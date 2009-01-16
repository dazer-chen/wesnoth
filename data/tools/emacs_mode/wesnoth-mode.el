;;; wesnoth-mode.el --- A major mode for editing WML.
;; Copyright (C) 2006, 2007, 2008, 2009 Chris Mann

;; This file is part of wesnoth-mode.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
;; MA 02139, USA.

;;; Description:
;; wesnoth-mode is a major mode for Emacs which assists in the editing
;; of Wesnoth Markup Language (WML) files.  Currently, this major-mode
;; features syntax highlighting support, automatic indentation,
;; context-sensitive completion and WML checking.

;;; Commentary:
;; Add the following to your .emacs:
;;   (add-to-list 'load-path "path/to/wesnoth-mode")
;;   (autoload 'wesnoth-mode "wesnoth-mode" "Major mode for editing WML." t)
;; Optionally adding:
;;   (add-to-list 'auto-mode-alist '("\\.cfg\\'" . wesnoth-mode))
;; to automatically load wesnoth-mode for all files ending in '.cfg'.

;;; History:
;; 1.3.4a
;; * #ifdef, #ifndef preprocessor statements now indent their contents relative
;;   to themselves when `wesnoth-indent-preprocessor-bol' is nil.
;; * Fixed a bug which could prevent element completion immediately within a
;;   preprocessor statement.
;; 1.3.4
;; * Fixed some errors produced when wesnoth-mode.el is byte-compiled.
;; * Improve detection and position of inserted closing tags in some
;;   circustances.
;; * Improved context detection for completion in some circumstances.
;; * Read `wesnoth-addition-file' as needed; M-x wesnoth-update no longer
;;   required.
;; * `wesnoth-indent-preprocessor-bol' has been re-introduced to control
;;   whether preprocessor statements are indented to the beginning of the line
;;   or as tags.
;; * Many minor bug fixes.
;; 1.3.3
;; * Improve performance when inserting missing elements.  Support for
;;   searching for missing elements over a region has been removed;
;;   `narrow-to-region' can be used to provide the functionality when
;;   required.
;; * All warnings found when checking WML are now underlined in the buffer.
;; * Next and previous warning can be jumped to using C-c C-f (or C-x `) and
;;   C-c C-b, respectively.
;; * Any macro arguments are now prompted for and inserted when performing
;;   completing, as suggested by fabi.
;; * Improved handling of completion; no longer prompt when no completion
;;   found, as suggested by uzytkownik.
;; * Added indentation for FOREACH, as suggested by fabi.
;; * Several bugs and inconsistencies corrected.
;; 1.3.2
;; * Major performance improvements to indentation and WML checking.
;; * Fixed a bug where nesting could break when inserting multiple elements
;;   near the last element in a buffer.
;; * Fixed a bug where attributes immediately within #ifn?def were always
;;   reported to be illegal.
;; * Fixed a bug where tags immediately within #ifn?def were always legal.
;; * Fixed a bug where when inserting missing tags, scanning would only be
;;   performed up to point.
;; * Fixed a bug when jumping between preprocessor statements.
;; 1.3.1
;; * Completion history available is now specific to wesnoth-mode.
;; * Added binding to explicitly update macro information from the current
;;   buffer (C-c C-u).
;; * Significantly improved performance of completion and WML checking.
;; * Improved performance for inserting missing tags.
;; * Fixed a bug where #ifdef was never matched when checking WML.
;; * Added completion for preprocessor statements.
;; * Improved macro completion and checking.
;; 1.3.0
;; * Added support for Xemacs.
;; * WML checking is now context sensitive; checks attributes and macros.
;; * WML checks are now always performed on the entire buffer, with results
;;   displayed in a temporary buffer.
;; * Context-sensitive completion for attributes and tags.
;; * Completion for built-in and project-specific macros.
;; * Changed the following bindings:
;;   `wesnoth-insert-tag' - C-c e -> C-c t
;;   `wesnoth-jump-to-matching' - C-c m -> C-c o
;;   `wesnoth-check-structure' -> `wesnoth-check-wml' - C-c c
;; * Added the following bindings:
;;   `wesnoth-complete-attribute' - C-c a
;;   `wesnoth-complete-macro' - C-c m
;;   `wesnoth-complete-tag' - C-c t
;; * Removed the following bindings:
;;   `wesnoth-check-tag-names' - C-c n
;; * Removed `wesnoth-check-tag-names'.  Replaced by `wesnoth-check-wml'.
;; * Completion for an incomplete attribute, tag, or macro at point is
;;   attempted via TAB.
;; 1.2.5
;; * Fixed support for GNU Emacs 21.
;; * Added several new tags to `wesnoth-tags-list'.
;; * Added M-TAB binding for `wesnoth-insert-tag'.
;; * `wesnoth-insert-tag' now takes an optional numeric argument indicating
;;   how many blocks to wrap across instead of a region.
;; * Support for `wesnoth-indent-preprocessor-bol' removed.
;; * Fixed a bug in `wesnoth-insert-tag' and `wesnoth-insert-missing-closing'
;;   causing tags not to be inserted in the correct position.
;; * Fixed highlighting of array indexes as tags.
;; 1.2.4
;; * Improved syntax-highlighting for macro calls.
;; * Underscore is now treated as whitespace.
;; * Fixed incorrect indentation when preprocessor preceeded by whitespace.
;; * Point is now placed at the first non-whitespace character of the line,
;;   instead of the last.
;; * Corrected minor indentation bugs.
;; * Indenting across large regions is now much more efficient.
;; * Fix hooks modifying wesnoth-mode-map causing default bindings not being
;;   applied.
;; 1.2.3
;; * Now compatible with GNU Emacs 21.4.
;; * Added support for several new tags.
;; * Added menu entry for wesnoth-mode.
;; * Significant speed increase to indentation.
;; * Indentation can now be customised using `wesnoth-indent-preprocessor-bol'
;;   and `wesnoth-indent-savefile'; support for `wesnoth-indentation-function'
;;   has been removed.
;; * Trailing whitespace is no longer created when creating a second
;;   consecutive newline.
;; * Spurious newlines are no longer created when inserting a tag elements
;;   around a region.
;; 1.2.2
;; * Added functions: `wesnoth-indent', `wesnoth-element-closing',
;;   `wesnoth-element', `wesnoth-element-opening',
;;   `wesnoth-insert-and-indent', `wesnoth-insert-missing-closing'.
;; * Renamed `wesnoth-indent-line-default', `wesnoth-indent-line-savefile' and
;;   `wesnoth-jump-backward', `wesnoth-jump-forward' to
;;   `wesnoth-indent-withtags-inline', `wesnoth-indent-default-inline' and
;;   `wesnoth-backward-tag', `wesnoth-forward-tag', respectively.
;; * Fixed a bug in indentation where content was needed between elements pairs
;;   for indentation to work.
;; * Fixed `wesnoth-newline-and-indent' ignoring the state of
;;   `wesnoth-auto-indent-flag'.
;; * Fixed `{...}' and `#endif' not font-locking correctly.
;; * Added indentation styles: `wesnoth-indent-default',
;;   `wesnoth-indent-withtags' which implement a a similar indentation
;;   style to the existing styles, however all preprocessor statements are
;;   indented to the first column.
;; * Added support for several new tags.
;; * Modified `wesnoth-newline' to behave more consistently.
;; * `wesnoth-jump-to-matching', `wesnoth-forward-tag', `wesnoth-backward-tag'
;;   now leaves point at the beginning (when moving backward) or end (when
;;   moving forward) of the match.
;; * `wesnoth-jump-to-matching' now attempts to find a target if necessary and
;;   will now work on preprocessor statements.  Will now warn if jump
;;   destination may not be correct (due to errors in WML structure).
;; * Indentation style is now determined by `wesnoth-indentation-function'.
;; * `wesnoth-check-structure' can now be applied over an active region and
;;   now checks preprocessor statements for correct nesting.
;; * `wesnoth-newline' and `wesnoth-newline-and-indent' can now be forced to
;;   perform indentation by providing a prefix argument.
;; * Indentation styles now leave point at the first non-whitespace character
;;   of the line.
;; * `wesnoth-check-tag-names' now reports on success.
;; * `wesnoth-insert-tag' is now able to insert tags around a region.
;; * `outline-minor-mode' now works on macro definitions.
;; 1.2.1
;; * Base indent now defaults to 4.
;; * Added support for #ifndef.

;;; Code:
(require 'easymenu)
(require 'wesnoth-update)
(require 'wesnoth-wml-data)

(defconst wesnoth-mode-version "1.3.4a"
  "The current version of `wesnoth-mode'.")

(defgroup wesnoth-mode nil "Wesnoth-mode access"
  :group 'languages
  :prefix "wesnoth-")

(defcustom wesnoth-auto-indent-flag t
  "Non-nil means indent the current line upon creating a newline."
  :type 'boolean
  :group 'wesnoth-mode)

(defcustom wesnoth-indent-preprocessor-bol t
  "Whether to indent Preprocessor statements to the beginning of the line."
  :type 'boolean
  :group 'wesnoth-mode)

(defcustom wesnoth-indent-savefile t
  "Non-nil means to use the current indentation conventions.
If nil, use the old convention for indentation.
The current convention is all attributes are indented a level deeper
than their parent; in the past attributes were indented to the same
level as their parent.")

(defcustom wesnoth-base-indent 4
  "The number of columns to indent WML."
  :type 'integer
  :group 'wesnoth-mode)

(defconst wesnoth-preprocessor-regexp
  "[\t ]*#\\(enddef\\|define \\|e\\(lse\\|nd\\(\\(de\\|i\\)f\\)\\)\\|\\(ifn?\\|un\\)def \\)"
  "Regular expression to match all preprocessor statements.")

(defconst wesnoth-preprocessor-opening-regexp
  "[\t ]*#\\(define \\|else\\|ifdef \\|ifndef \\)"
  "Regular expression to match \"opening\" preprocessor statements.")

(defconst wesnoth-preprocessor-closing-regexp
  "[\t ]*#\\(end\\(\\(de\\|i\\)f\\)\\)"
  "Regular expression to match \"closing\" preprocessor statements.")

(defvar wesnoth-define-blocks '()
  "Cache of all toplevel #define and #enddef pairs.")

(defvar wesnoth-history-list '()
  "History of inserted WML elements.")

(defvar wesnoth-warning-markers '()
  "Markers for warnings in the buffer.")

(defvar wesnoth-mode-hook nil)

(defface wesnoth-warning-face
  '((t (:underline "tomato1")))
  "Face to use for warnings in wesnoth-mode"
  :group 'wesnoth-mode)

(defvar wesnoth-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-M-a") 'wesnoth-backward-element)
    (define-key map (kbd "C-M-e") 'wesnoth-forward-element)
    (define-key map (kbd "C-m") 'wesnoth-newline)
    (define-key map (kbd "C-j") 'wesnoth-newline-and-indent)
    (define-key map (kbd "C-c C-c") 'wesnoth-check-wml)
    (define-key map (kbd "C-c C-a") 'wesnoth-complete-attribute)
    (define-key map (kbd "C-c C-t") 'wesnoth-complete-tag)
    (define-key map (kbd "C-c C-p") 'wesnoth-complete-preprocessor)
    (define-key map (kbd "C-c C-u") 'wesnoth-update-project-information)
    (define-key map (kbd "M-TAB") 'wesnoth-complete-tag)
    (define-key map (kbd "C-c C-m") 'wesnoth-complete-macro)
    (define-key map (kbd "C-c C-o") 'wesnoth-jump-to-matching)
    (define-key map (kbd "C-c C-f") 'wesnoth-forward-warning)
    (define-key map (kbd "C-x `") 'wesnoth-forward-warning)
    (define-key map (kbd "C-c C-b") 'wesnoth-backward-warning)
    (define-key map (kbd "C-c C-/") 'wesnoth-insert-missing-closing)
    (define-key map (kbd "TAB") 'wesnoth-indent-or-complete)
    map)
  "Keymap used in `wesnoth-mode'.")

(easy-menu-define wesnoth-menu wesnoth-mode-map "Menu for wesnoth-mode"
  '("WML"
    ["Check WML" wesnoth-check-wml t]
    ["Indent or Complete" wesnoth-indent-or-complete t]
    ["Indent buffer" (lambda ()
		       (interactive)
		       (wesnoth-indent-region (point-min) (point-max))) t]
    ["Insert Tag" wesnoth-complete-tag t]
    ["Insert Attribute" wesnoth-complete-attribute t]
    ["Insert Macro" wesnoth-complete-macro t]
    ["Insert Preprocessor" wesnoth-complete-preprocessor t]
    ["Insert Missing Tag" wesnoth-insert-missing-closing t]
    ["Jump to Matching" wesnoth-jump-to-matching t]
    ["Update Macros" wesnoth-update-project-information t]))

(defvar wesnoth-syntax-table
  (let ((wesnoth-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?# "<" wesnoth-syntax-table)
    (modify-syntax-entry ?\" "\"" wesnoth-syntax-table)
    (modify-syntax-entry ?= "." wesnoth-syntax-table)
    (modify-syntax-entry ?| "w" wesnoth-syntax-table)
    (modify-syntax-entry ?_ "_" wesnoth-syntax-table)
    (modify-syntax-entry ?- "_" wesnoth-syntax-table)
    (modify-syntax-entry ?. "_" wesnoth-syntax-table)
    (modify-syntax-entry ?\n ">" wesnoth-syntax-table)
    (modify-syntax-entry ?\r ">" wesnoth-syntax-table)
    wesnoth-syntax-table)
  "Syntax table for `wesnoth-mode'.")

;; Prevents automatic syntax-highlighting of elements which might be
;; pre-processor statements.
(defvar wesnoth-syntactic-keywords
  (list
   '("\\([\t ]*\\(#\\(?:define \\|e\\(?:lse\\|nd\\(?:\\(?:de\\|i\\)f\\)\\)\\|\\(?:ifn?\\|un\\)def \\)\\)\\)" 1 "w"))
  "Syntactic keywords for preprocessor statements within `wesnoth-mode'.")

(defvar wesnoth-font-lock-keywords
  (list
   '("#\\(?:define\\|\\(?:ifn?\\|un\\)def\\)" . font-lock-keyword-face)
   '("\\(#e\\(?:lse\\|nd\\(?:\\(?:de\\|i\\)f\\)\\)\\)" .
     font-lock-keyword-face)
   '("\\(#\\(?:define\\|\\(?:ifn?\\|un\\)def\\)\\)[\t ]+\\(\\(\\w\\|_\\)+\\)"
     2 font-lock-function-name-face)
   '("\\({[@~]?\\(\\w\\|\\.\\|/\\|-\\)+}\\)" (1 font-lock-function-name-face))
   '("\\({\\(\\w\\|:\\|_\\)+\\|{[~@]?\\)" (1 font-lock-function-name-face))
   '("}" .  font-lock-function-name-face)
   '("[\t ]*\\(\\[/?[^$]\\(\\w\\|_\\)+\\]\\)" 1 font-lock-type-face)
   '("\\$\\(\\w\\|_\\)+" . font-lock-variable-name-face)
   '("\\(\\(\\w\\|_\\)+\\(\\,[\t ]*\\(\\w\\|_\\)+\\)*\\)="
     1 font-lock-variable-name-face))
  "Syntax highlighting for `wesnoth-mode'.")

(defun wesnoth-element-closing (&optional limited)
  "Return the regexp to match a closing element.
If LIMITED is non-nil, return a regexp which matches only the
#enddef preprocessor."
  (concat "^[\t ]*\\(\\[/\\(\\w\\|_\\)+\\]\\|"
	  (if limited
	      "#enddef"
	    "#end\\(?:def\\|if\\)")
          (if (and (not wesnoth-indent-preprocessor-bol) limited)
              "\\|#endif"
            "")
	  "\\)"))

(defun wesnoth-element-opening (&optional limited)
  "Return the regexp to match a closing element.
If LIMITED is non-nil, return a regexp which matches only the
#define preprocessor."
  (concat "^[\t ]*\\(\\[\\+?\\(\\w\\|_\\)+\\]\\|#define "
	  (if limited
	      "\\|{FOREACH .+}"
	    "\\|#ifn?def ")
          (if (and (not wesnoth-indent-preprocessor-bol) limited)
              "\\|#ifn?def \\|#else"
            "")
	  "\\)"))

(defun wesnoth-element (&optional limited)
  "Return the regexp to match a closing element.
If LIMITED is non-nil, return a regexp which matches only the
#define and #enddef preprocessors."
  (concat "^[\t ]*\\(\\[[+/]?\\(\\w\\|_\\)+\\]?\\|"
	  (if limited
	      "#define \\|#enddef"
	    (substring wesnoth-preprocessor-regexp 5))
          (if (and (not wesnoth-indent-preprocessor-bol) limited)
              "\\|#\\(ifn?def \\|endif\\|else\\)"
            "")
	  "\\)"))

(defun wesnoth-find-next (type)
  "Find the next element of TYPE.
TYPE is a symbol representing an element type, or a list of
element types to find."
  (let ((element (wesnoth-next-element)))
    (while (and element (if (listp type)
			    (not (member (car element) type))
			  (not (eq (car element) type))))
      (setq element (wesnoth-next-element)))
    (when (if (listp type)
	      (member (car element) type)
	    (eq (car element) type))
      element)))

(defun wesnoth-next-element ()
  "Move to the next element in the buffer.
Return non-nil when an element is found.  Otherwise, return nil."
  (interactive)
  (save-match-data
    (and (or (eolp) (looking-at "[}\t ]"))
	 (search-forward-regexp "[^}
\t ]" (point-max) t)
	 (forward-char -1)))
  (let ((details (wesnoth-element-type (point))))
    (save-match-data
      (when (nth 2 details)
	(goto-char (nth 2 details))
	(while (nth 3 (parse-partial-sexp
		       (save-excursion (search-backward-regexp
					(wesnoth-element t) (point-min) t)
				       (point))
		       (point)))
	  (search-forward "\"" (point-max) t))))
    details))

(defun wesnoth-element-type (point)
  "Return details regarding the element at POINT.
A list is returned, the elements of the list represent the
following, respectively: A symbol representing the type of
element; the position of the start of the element and the
position of the end of the element.  POINT must be at the start
of the element."
  (let ((element-matches
	 '(("{\\(.*?[/\]\\)+}" . nil)  ;; pathnames
	   ("{\\(\\w\\|_\\)+" . macro)
	   ("\\[\\+?[^/]+?\\]" . tag-opening)
	   ("\\[/.+?\\]" . tag-closing)
	   ("\\(\\w\\|_\\)+[\t ]*=" . attribute)
	   ("#\\(enddef\\|define \\|e\\(lse\\|nd\\(\\(de\\|i\\)f\\)\\)\\|\\(ifn?\\|un\\)def \\)"
	    . preprocessor)
	   ("#.*$" . comment)
	   ("[^\t ]+") . nil)))
    (catch 'result
      (dolist (pair element-matches)
	(when (looking-at (car pair))
	  (throw 'result (list (cdr pair)
			       (match-beginning 0)
			       (min (save-excursion (forward-line 1) (point))
				    (match-end 0)))))))))

(defun wesnoth-estimate-element-type (point)
  "Return match data for a partial element at POINT."
  (save-excursion
    (goto-char point)
    (let ((element-matches
	   '(("{\\(.*?[/\]\\)+$" . nil)	; pathnames
	     ("{\\(\\w\\|_\\)*$" . macro)
	     ("\\[/\\(\\w\\|_\\)*$" . tag-closing)
	     ("\\[\\+?\\(\\w\\|_\\)*$" . tag-opening)
	     ("^[\t ]*\\(\\w\\|_\\)+$" . attribute)
	     ("[\t ]*#\\(enddef\\|define \\|e\\(lse\\|nd\\(\\(de\\|i\\)f\\)\\)\\|\\(ifn?\\|un\\)def \\)"
	      . nil) ; not a partial match
	     ("[\t ]*#\\w*$" . preprocessor))))
      (catch 'result
	(dolist (pair element-matches)
	  (when (looking-at (car pair))
	    (throw 'result (list (cdr pair)
				 (match-beginning 0)
				 (match-end 0)))))))))

(defun wesnoth-guess-element-type (point)
  "Return details for the the element near POINT.
Locate the start of the element before determining details.
BOUND is the limit to search backwards."
  (let ((details (wesnoth-estimate-element-type point))
	(bound (save-excursion
		 (goto-char point)
		 (beginning-of-line)
		 (point))))
    (while (and (not (car details)) (> point bound))
      (setq point (1- point)
	    details (wesnoth-estimate-element-type point)))
    (and (nth 1 details)
	 (>= (point) (nth 1 details))
	 (nth 2 details)
	 (<= (point) (nth 2 details))
	 details)))


;;; Insertion and completion
(defmacro wesnoth-element-completion (completions prompt partial
						  &optional completep)
  "Process completion of COMPLETIONS, displaying PROMPT.
PARTIAL is the partial string on which to attempt completion.
If COMPLETEP is non-nil, do not prompt if no completion is found."
  `(let* ((element (when ,partial (try-completion ,partial ,completions))))
     (cond ((eq element t)
	    ,partial)
	   ((and completep (null element))
	    nil)
	   ((and element (eq (try-completion element ,completions) t))
	    element)
	   ((> (length (all-completions (or element "") ,completions)) 1)
	    (completing-read ,prompt ,completions
			     nil nil element
			     'wesnoth-history-list))
	   (t
	    element))))

(defun wesnoth-active-parent-tag ()
  "Return the name of the active parent tag.
Finds the relevant parent tag, ignoring any conditional tags."
  (save-excursion
    (let ((parent (wesnoth-parent-tag)))
      (while (and (stringp (car parent))
                  (string-match "else\\|then"
                                (car parent)))
	(goto-char (cdr parent))
	(setq parent (wesnoth-parent-tag))
	(when (string= (car parent) "if")
	  (goto-char (cdr parent))
	  (setq parent (wesnoth-parent-tag))))
      (car parent))))

(defun wesnoth-parent-tag ()
  "Return the name of the parent tag.
If the parent is a preprocessor statement, return non-nil.
If the element does not have a parent, return nil.
Otherwise, return a string containing the name of the parent tag."
  (save-excursion
    (let ((start-point (point))
	  (depth 1))
      (when (save-excursion (> (point) (progn (back-to-indentation)
					      (point))))
	(end-of-line))
      (while (and (> depth 0)
		  (search-backward-regexp (wesnoth-element t)
					  (point-min) t))
	(if (string-match "[\t ]*\\[/" (match-string 0))
	    (setq depth (1+ depth))
	  (setq depth (1- depth))))
      (beginning-of-line)
      (if (> depth 0)
	  (cons nil nil)
	(when (looking-at (wesnoth-element-opening))
	  (let ((parent (match-string-no-properties 1))
		(position (point)))
	    (if (or (string-match wesnoth-preprocessor-opening-regexp parent)
		    ;; Check if we're immediately within a macro
		    (and (goto-char start-point)
			 (search-backward-regexp "[}{]" (point-min) t)
			 (string= (match-string 0) "{")
			 (goto-char start-point)
			 (not (and (search-backward parent (point-min) t)
				   (search-backward-regexp "[}{]" (point-min) t)
				   (string= (match-string 0) "{")))))
		(cons t position)
	      (cons (substring parent 1 (1- (length parent))) position))))))))

(defun wesnoth-partial-macro-p ()
  "Return non-nil if point is in a partial macro."
  (save-excursion
    (let ((opened 0))
      (search-backward-regexp "{" (point-min) t)
      (while (search-forward-regexp "[{}]" (point-max) t)
	(if (string= (match-string 0) "{")
	    (setq opened (1+ opened))
	  (setq opened (1- opened))))
      (> opened 0))))

(defun wesnoth-indent-or-complete (&optional elements)
  "Indent or complete the line at point, depending on context.
ELEMENTS is the number of elements to wrap around if inserting
matching tags."
  (interactive "P")
  (or elements (setq elements 0))
  (let ((details (wesnoth-guess-element-type (point))))
    (cond
     ((eq (car details) 'tag-opening)
      (wesnoth-complete-tag elements t))
     ((and (eq (car details) 'macro)
	   (wesnoth-partial-macro-p))
      (wesnoth-complete-macro t))
     ((eq (car details) 'preprocessor)
      (wesnoth-complete-preprocessor elements t))
     ((eq (car details) 'tag-closing)
      ;; FIXME: Solve incorrect behaviour when partial closing is "[/"
      (insert "a")
      (and (wesnoth-insert-missing-closing t)
	   (delete-region (nth 1 details)
			  (save-excursion (beginning-of-line) (point))))
      (end-of-line)
      (wesnoth-indent))
     ((eq (car details) 'attribute)
      (wesnoth-complete-attribute t))
     (t
      (wesnoth-indent)))))

(defun wesnoth-preprocessor-closed-p (preprocessor)
  "Determine whether PREPROCESSOR has been closed.
PREPROCESSOR is a string matching the preprocessor statement to
be inserted."
  (save-excursion
    (back-to-indentation)
    (wesnoth-jump-to-matching preprocessor)
    (looking-at
     (if (string= preprocessor "#define ")
	 "#enddef"
       "#endif"))))

(defun wesnoth-complete-preprocessor (&optional elements completep)
  "Complete and insert the preprocessor at point.
ELEMENTS is the number of elements to wrap around.
If COMPLETEP is non-nil, attempt to complete preprocessor at point."
  (interactive "P")
  (or elements (setq elements 0))
  (let* ((completions (wesnoth-emacs-completion-formats
		       '("define" "else" "ifdef" "ifndef"
			 "enddef" "endif" "undef")))
	 (partial (when completep
		    (save-excursion
		      (back-to-indentation)
		      (when (looking-at "#\\(\\w*\\)$")
			(match-string-no-properties 1)))))
	 (preprocessor (wesnoth-element-completion
			completions "Preprocessor: " partial completep))
	 (details (wesnoth-guess-element-type (point)))
	 (closedp
	  (save-excursion
	    (when preprocessor
	      (unless (string= "#" (substring preprocessor 0 1))
		(setq preprocessor (concat "#" preprocessor)))
	      (when (string-match "#\\(define\\|ifn?def\\|undef\\)" preprocessor)
		(setq preprocessor (concat preprocessor " ")))
	      (when partial
		(delete-region (nth 1 details) (nth 2 details)))
	      (wesnoth-preprocessor-closed-p preprocessor)))))
    (when preprocessor
      (when partial
	(delete-region
	 (save-excursion
	   (progn (search-backward
		   "#" (save-excursion (back-to-indentation)
				       (point))
		   t)
		  (point)))
	 (point)))
      (if (and (string-match "#\\(define \\|ifn?def\\)" preprocessor)
	       (not closedp))
	  (progn
	    (wesnoth-insert-tag elements preprocessor)
	    (forward-line -1)
	    (end-of-line))
	(wesnoth-insert-element-separately preprocessor)))))

(defun wesnoth-macro-arguments ()
  "Find any current macro arguments."
  (let ((results '())
	(depth (wesnoth-within-define (point))))
    (save-excursion
      (while (> depth 0)
	(save-match-data
	  (search-backward-regexp
	   "[\t ]*#define \\(?:\\w+\\|_\\)*\\(\\([\t ]*\\(\\w\\|_\\)+\\)*\\)"
	   (point-min) t)
	  (when (<= (wesnoth-within-define (point)) depth)
	    (and (> depth 0)
		 (setq results
		       (append (mapcar (lambda (macro)
					 (list macro nil))
				       (split-string
					(match-string-no-properties 1)))
			       results)))
	    (setq depth (1- depth)))))
      results)))

(defun wesnoth-complete-macro (&optional completep)
  "Complete and insert the macro at point.
If COMPLETEP is non-nil, attempt to complete the macro at point."
  (interactive)
  (wesnoth-update-project-information)
  (let* ((macro-information (wesnoth-merge-macro-data
			     wesnoth-macro-data
			     (wesnoth-macro-additions)
			     wesnoth-local-macro-data
			     (wesnoth-macro-arguments)))
	 (completions (wesnoth-emacs-completion-formats
		       (mapcar 'car macro-information)))
	 (details (wesnoth-guess-element-type (point)))
	 (partial (when
		      (save-excursion
			(and completep
			     (eq (car details) 'macro)
			     (goto-char (cadr details))
			     (looking-at "{\\(\\(\\w\\|_\\)*\\)")))
		    (match-string-no-properties 1)))
	 (macro (wesnoth-element-completion completions "Macro: " partial
					    completep))
	 (args (cadr (assoc macro macro-information))))
    (when macro
      (if partial
	  (progn
	    ;; Delete the region corresponding to the current macro.
	    (delete-region (nth 1 details) (nth 2 details))
	    (insert "{" macro (if args " }" "}")))
	(wesnoth-insert-element-separately "{" macro (if args " }" "}")))
      (save-excursion
	(wesnoth-indent))
      (forward-char -1)
      (when args
	(let ((input (read-string (concat (car args) ": "))))
	  (insert input (if (and (cdr args)
				 (not (string= input "")))
			    " " ""))
	  (while (and (setq args (cdr args)) (not (string= input "")))
	    (insert (setq input (read-string (concat (car args) ": ")))
		    (if (and (not (string= input ""))
			     (cdr args))
			" " "")))))
      (when (null args) (forward-char 1)))))

(defun wesnoth-complete-attribute (&optional completep)
  "Insert the attribute at point.
If COMPLETEP is non-nil, attempt to complete the attribute at point."
  (interactive)
  (wesnoth-refresh-wml-data)
  (let* ((details (save-excursion
		    (back-to-indentation)
		    (wesnoth-guess-element-type (point))))
	 (completions (save-excursion (when (nth 1 details)
					(goto-char (nth 1 details)))
				      (wesnoth-build-completion 1)))
	 (partial (when completep
		    (when (save-excursion
			    (back-to-indentation)
			    (looking-at "\\(\\(\\w\\|_\\)+\\)"))
		      (match-string-no-properties 1))))
	 (attribute (wesnoth-element-completion completions "Attribute: "
						partial completep)))
    (when attribute
      (if partial
	  (progn
	    (delete-region (nth 1 details) (nth 2 details))
	    (insert attribute "="))
	(wesnoth-insert-element-separately attribute
					   (if (string-match "=" attribute)
					       ""
					     "=")))
      (save-excursion
	(wesnoth-indent)))))

(defun wesnoth-complete-tag (&optional elements completep)
  "Complete and insert the tag at point.
ELEMENTS is the number of elements to wrap around.
If COMPLETEP is non-nil, attempt to complete tag at point."
  (interactive "P")
  (or elements (setq elements 0))
  (let* ((details (wesnoth-guess-element-type (point)))
	 (completions (save-excursion (and (nth 1 details)
					   (goto-char (nth 1 details)))
				      (wesnoth-build-completion 0)))
	 (partial (save-excursion
		    (when (and completep
			       (eq (car details) 'tag-opening)
			       (goto-char (cadr details))
			       (looking-at "\\[\\(\\(\\w\\|_\\)*\\)[\t ]*$"))
		      (match-string-no-properties 1))))
	 (tag (wesnoth-element-completion completions "Tag: " partial
					  completep))
	 (closedp
	  (save-excursion
	    (wesnoth-jump-to-matching (concat "[" tag "]"))
	    (back-to-indentation)
	    (and (looking-at "\\[/\\(\\(\\w\\|_\\)+\\)")
		 (string= tag (match-string 1))))))
    (if tag
	(progn
	  (if completep
	      (progn
		(delete-region (nth 1 details) (nth 2 details))
		(if closedp
		    (progn
		      (wesnoth-insert-and-indent "[" tag "]")
		      (end-of-line))
		  (wesnoth-insert-tag elements tag)))
	    (wesnoth-insert-tag elements tag)))
      (or completep (wesnoth-insert-tag elements)))))

(defun wesnoth-build-completion (position)
  "Create a new list for tag completion if necessary.
Rebuilding list is required for versions of GNU Emacs earlier
than 22.  POSITION is the argument passed to `nth' for
`wesnoth-tag-data'."
  (interactive "P")
  (let ((parent (wesnoth-active-parent-tag))
	(tag-data (wesnoth-refresh-wml-data)))
    (wesnoth-emacs-completion-formats
     (if (or (stringp parent) (null parent))
	 (nth position (gethash parent wesnoth-tag-hash-table))
       (mapcar 'car tag-data)))))

(defun wesnoth-emacs-completion-formats (candidates)
  "Return the completions in the correct format for `emacs-major-version'.
CANDIDATES is a list of all possible completions."
  (if (> emacs-major-version 21)
      candidates
    (let ((tags '())
	  (iter 0))
      (dolist (tag candidates)
	(setq iter (1+ iter))
	(setq tags (append tags (list (cons tag iter)))))
      tags)))

(defun wesnoth-insert-tag (&optional elements tagname)
  "Insert the specified opening tag and it's matching closing tag.
Both the opening and closing tags will be placed on their own
lines with point positioned between them.  Completion of tags at
the prompt uses `wesnoth-tags-list'.

ELEMENTS is specifies the number of following blocks which the
tag should wrap around.

TAGNAME is the name of the tag to be inserted."
  (interactive "Ps")
  (unless tagname
    (setq tagname (completing-read "Tag: " (wesnoth-build-completion 0)
				   nil nil nil 'wesnoth-history-list)))
  (when (or (not elements)
	    (looking-at (concat "[\t ]*\\(:?\\[/\\|"
				wesnoth-preprocessor-regexp "\\)")))
    (setq elements 0))
  (let ((start (save-excursion (forward-line -1) (point)))
	(end (unless (= elements 0)
	       ;; Work around some strange behaviour when the target is at the
	       ;; end of the buffer.
	       (save-excursion
		 (goto-char (point-max))
		 (beginning-of-line)
		 (unless (looking-at "^[\t ]*$")
		   (end-of-line)
		   (newline)))
	       (wesnoth-nth-pair-position elements))))
    (if (string-match wesnoth-preprocessor-regexp tagname)
	(wesnoth-insert-element-separately tagname)
      (wesnoth-insert-element-separately "[" tagname "]"))
    (save-excursion
      (if end
	  (goto-char (marker-position end))
	(newline (if (string-match wesnoth-preprocessor-regexp tagname) 1 2)))
      (if (string-match wesnoth-preprocessor-opening-regexp tagname)
	  (wesnoth-insert-element-separately
	   (if (string= tagname "#define ")
	       "#enddef"
	     "#endif"))
	(wesnoth-insert-element-separately "[/" tagname "]"))
      (indent-region start (point) nil))
    (unless end
      (forward-line 1)))
  (wesnoth-indent))

(defun wesnoth-insert-element-separately (&rest strings)
  "Concatenate STRINGS and insert them on a line of their own."
  (if (save-excursion (and (> (point) (progn (back-to-indentation) (point)))))
      (if (save-excursion (forward-line 1) (looking-at "^[\t ]*$"))
	  (progn
	    (forward-line 1)
	    (end-of-line))
	(end-of-line)
	(newline))
    (beginning-of-line)
    (if (looking-at "^[\t ]*$")
	(end-of-line)
      (open-line 1)))
  (insert (apply 'concat strings)))

(defun wesnoth-insert-missing-closing (&optional completep)
  "Insert the next expected closing element at point.
If COMPLETEP is non-nil, do not move forward a line when scanning
for the matching tag."
  (interactive)
  (let ((match nil)
	(skip t))
    (save-excursion
      (when (and (null completep)
		 (<= (point) (save-excursion (back-to-indentation) (point))))
	(if (save-excursion (beginning-of-line)
			    (looking-at (wesnoth-element-opening)))
	    (forward-line -1)
	  (when
	      (save-excursion (beginning-of-line)
			      (looking-at (wesnoth-element-closing)))
	    (setq skip nil))))
      (when (wesnoth-search-for-matching-tag
	     'search-backward-regexp (wesnoth-element-opening) 'point-min
	     (and skip (if completep nil 1)))
	(setq match (and (looking-at (wesnoth-element-opening))
			 (match-string-no-properties 1)))))
    (when match
      (if (string= (substring match 0 1) "[")
	  (wesnoth-insert-element-separately
	   "[/" (substring match 1 (1- (length match))) "]")
	(wesnoth-insert-element-separately
	 (cdr (assoc match '(("#define " . "#enddef")
			     ("#ifndef " . "#endif")
			     ("#ifdef " . "#endif")))))))
    (wesnoth-indent)
    (end-of-line)
    match))

(defun wesnoth-insert-and-indent (&rest args)
  "Concatenate and insert the given string(s) before indenting.

ARGS is a list of strings to be inserted."
  (insert (apply 'concat args))
  (wesnoth-indent))

(defun wesnoth-newline (&optional indent)
  "Indent the current line and create a newline.
If `wesnoth-auto-indent-flag' is nil, indentation will not be
performed.  Indentation can be forced by setting INDENT to
non-nil."
  (interactive "P")
  (newline)
  (save-excursion
    (forward-line -1)
    (when (and (or wesnoth-auto-indent-flag indent)
	       (not (looking-at "^[\t ]*$")))
      (wesnoth-indent))))

;;; Movement
(defun wesnoth-navigate-element (repeat search-function bound)
  "Move point to the tag in the given direction REPEAT times.

SEARCH-FUNCTION is the symbol of the function for searching in
the required direction, with BOUND marking the furthest point to
search."
  (or repeat (setq repeat 1))
  (while (> repeat 0)
    (and (eq search-function 'search-forward-regexp) (end-of-line))
    (funcall search-function (wesnoth-element-opening) bound t)
    (back-to-indentation)
    (setq repeat (1- repeat))))

(defun wesnoth-nth-pair-position (count)
  "Return `point' after COUNT number of matching element pairs.
COUNT is a positive number representing the number of balanced
pairs to move across.
`point' is returned as a marker object."
  (save-excursion
    (let ((failed nil))
      (if (> (point) (save-excursion (back-to-indentation) (point)))
	  (end-of-line)
	(beginning-of-line))
      (while (> count 0)
	;; Currently looking-at target tag.  Stop here to avoid
	;; incorrect nesting.
	(unless (wesnoth-search-for-matching-tag
		 'search-forward-regexp (wesnoth-element-closing) 'point-max)
	  (setq count 0)
	  (setq failed t))
	(and (> (setq count (1- count)) 0) (forward-line 1)))
      (if failed
	  (beginning-of-line)
	(end-of-line))
      (point-marker))))

(defun wesnoth-forward-element (repeat)
  "Move point to the end of the next tag.
REPEAT is an optional numeric argument.  If REPEAT is non-nil,
jump forward the specified number of tags."
  (interactive "p")
  (if (< repeat 0)
      (wesnoth-backward-element (abs repeat))
    (wesnoth-navigate-element repeat 'search-forward-regexp (point-max))))

(defun wesnoth-backward-element (repeat)
  "Move point to the beginning of the previous tag.
REPEAT is an optional numeric argument.  If REPEAT is non-nil,
jump backward the specified number of tags."
  (interactive "p")
  (if (< repeat 0)
      (wesnoth-forward-element (abs repeat))
    (wesnoth-navigate-element repeat 'search-backward-regexp (point-min))))

(defun wesnoth-search-for-matching-tag (search-function
                                        search-string bound &optional skip)
  "Search for the matching tag for the current line.
SEARCH-FUNCTION is the name of the function used to perform the search.
SEARCH-STRING is a string representing the matching tag type.
BOUND is the bound to be passed to the search function.
If SKIP is non-nil, skip the first element and continue from there."
  (let ((depth 1))
    (when (and (or (and (numberp skip) (forward-line skip))
                   (funcall search-function (wesnoth-element) (funcall bound) t))
               (or skip (not (string-match search-string (match-string 0)))))
      (while (and (> depth 0)
                  (funcall search-function (wesnoth-element)
                           (funcall bound) t))
        (if (string-match search-string (match-string 0))
            (setq depth (1- depth))
          (setq depth (1+ depth))))
      (= depth 0))))

(defun wesnoth-jump-to-matching (&optional element)
  "Jump point to the matching opening/closing tag.
ELEMENT is an element to find a match for."
  (interactive)
  (beginning-of-line)
  (let ((target nil)
	(first-element nil))
    (save-excursion
      (cond
       ((or (and (stringp element)
		 (string-match (wesnoth-element-opening) element))
	    (looking-at (wesnoth-element-opening)))
	(setq first-element (match-string-no-properties 0 element))
	(when (wesnoth-search-for-matching-tag
	       'search-forward-regexp (wesnoth-element-closing) 'point-max
	       (and (stringp element) 1))
	  (beginning-of-line)
	  (if (and (string-match wesnoth-preprocessor-opening-regexp
				 first-element)
		   (looking-at (wesnoth-element-closing)))
	      (when (string= (match-string-no-properties 0)
			     (cdr (assoc first-element
					 '(("#define " . "#enddef")
					   ("#ifndef " . "#endif")
					   ("#ifdef " . "#endif")))))
		(setq target (point)))
	    (setq target (point)))))
       ((or (and (stringp element)
		 (string-match (wesnoth-element-closing) element))
	    (looking-at (wesnoth-element-closing)))
	(end-of-line)
	(setq first-element (match-string-no-properties 0 element))
	(when (wesnoth-search-for-matching-tag
	       'search-backward-regexp (wesnoth-element-opening)
	       'wesnoth-wml-start-pos (and (stringp element) -1))
	  (if (and (string-match wesnoth-preprocessor-closing-regexp
				 first-element)
		   (looking-at (wesnoth-element-opening)))
	      (progn
		(when (or (and (string= "#enddef" first-element)
			       (string= "#define "
					(match-string-no-properties
					 0)))
			  (and (string= "#endif" first-element)
			       (string-match
				"#ifn?def "
				(match-string-no-properties
				 0))))
		  (setq target (point))))
	    (setq target (point)))))
       (t
	(search-backward-regexp (wesnoth-element-opening) (point-min) t)
	(setq target (point)))))
    (if target
	(progn
	  (goto-char target)
	  (back-to-indentation))
      (when (interactive-p)
	(message "%s" "Tag does not appear to be matched")))))

;;; Indentation
(defun wesnoth-wml-start-pos ()
  "Determine the position of `point' relative to where the actual WML begins.
Return the likely starting position of the WML if it is found.
Otherwise return nil."
  (save-excursion
    (goto-char (point-min))
    (when (search-forward-regexp (wesnoth-element) (point-max) t)
      (beginning-of-line)
      (point))))

(defun wesnoth-first-column-indent-p (point)
  "Return non-nil if the current line should not be indented.

POINT is the position in the buffer to check.
CONTEXT represents the type of element which precedes the current element."
  (or (not (wesnoth-wml-start-pos))
      (<= (point) (wesnoth-wml-start-pos))
      (nth 3 (parse-partial-sexp
	      (save-excursion (search-backward-regexp
			       (wesnoth-element t) (point-min) t)
			      (point))
	      point))
      (and (looking-at wesnoth-preprocessor-regexp)
	   wesnoth-indent-preprocessor-bol)))

(defun wesnoth-indent ()
  "Indent the current line as WML."
  (save-excursion
    (beginning-of-line)
    (let* ((cur-indent 0)
	   (context-data (wesnoth-determine-context (point)))
	   (context (car context-data))
	   (ref-indent (cdr context-data)))
      (unless (wesnoth-first-column-indent-p (point))
	(cond
	 ((eq context 'opening)
          (if (and (looking-at "^[\t ]*#else")
                   (not wesnoth-indent-preprocessor-bol))
              (setq cur-indent ref-indent)
            (if (or (and wesnoth-indent-savefile
                         (or (looking-at "[\t ]*{NEXT ")
                             (and (not (looking-at (wesnoth-element-closing t)))
                                  (not (looking-at "[\t ]*{NEXT ")))))
                    (looking-at (wesnoth-element-opening t))
                    (looking-at "[\t ]*{FOREACH "))
                (setq cur-indent (+ ref-indent wesnoth-base-indent))
              (setq cur-indent ref-indent))))
	 ((eq context 'closing)
          (if (and (looking-at "^[\t ]*#else")
                   (not wesnoth-indent-preprocessor-bol))
              (setq cur-indent (- ref-indent wesnoth-base-indent))
            (if (or (looking-at (concat "^[\t ]*\\(\\[/\\|\\#enddef"
                                        (if (not wesnoth-indent-preprocessor-bol)
                                            "\\|#endif"
                                          "")
                                        "\\)"))
                    (and (not wesnoth-indent-savefile)
                         (not (looking-at (wesnoth-element-opening t)))
                         (not (looking-at "[\t ]*{FOREACH "))))
                (setq cur-indent (- ref-indent wesnoth-base-indent))
              (setq cur-indent ref-indent))))))
      (indent-line-to (max cur-indent 0))))
  (when (> (save-excursion (back-to-indentation) (point))
	   (point))
    (back-to-indentation)))

(defun wesnoth-within-define (position)
  "Determine whether point is currently inside a #define block.
POSITION is the initial cursor position."
  (save-match-data
    (let ((depth 0)
	  (defblocks (or wesnoth-define-blocks
			 (wesnoth-find-macro-definitions))))
      (unless (equal (car defblocks) 'none)
	(dolist (element defblocks)
	  (when (= (cadr (sort (append (mapcar 'marker-position (cadr element))
				       (list position)) '>)) position)
	    (setq depth (max (car element) depth)))))
      depth)))

(defun wesnoth-find-macro-definitions ()
  "Return information regarding positioning of macro definitions."
  (save-excursion
    (goto-char (point-min))
    (let ((depth 0)
	  openings cache)
      (while (search-forward-regexp "#define\\|#enddef" (point-max) t)
	(and (string= (match-string 0) "#define") (beginning-of-line))
	(setq depth
	      (if (string= (match-string 0) "#define")
		  (progn
		    (add-to-list 'openings (point-marker))
		    (1+ depth))
		(if openings
		    (progn
		      (add-to-list 'cache
				   (list depth (list (car openings)
						     (point-marker))))
		      (setq openings (cdr openings))
		      (1- depth))
		  depth)))
	(end-of-line))
      (or cache (list 'none)))))

(defun wesnoth-indent-region (start end)
  "Indent the region from START to END.
Creates and destroys a cache of macro definition details as necessary."
  (interactive "r")
  (unwind-protect
      (save-excursion
	(goto-char end)
	(setq end (point-marker))
	(goto-char start)
	(setq wesnoth-define-blocks (wesnoth-find-macro-definitions))
	(or (bolp) (forward-line 1))
	(while (< (point) end)
	  (if (looking-at "^[\t ]*$")
	      (indent-line-to 0)
	    (funcall indent-line-function))
	  (forward-line 1)))
    (setq wesnoth-define-blocks nil)))

(defun wesnoth-determine-context (position)
  "Determine the type of the last relevant element.
POSITION is the buffer position of the element for which to
determine the context."
  (save-excursion
    (let* ((elements (concat (substring (wesnoth-element t)
					0 (- (length (wesnoth-element t)) 2))
			     "\\|{FOREACH .+}\\|{NEXT .+}\\)"))
	   (match (or
		   (and (search-backward-regexp
			 elements (point-min) t)
			(progn
			  (while (save-match-data
				   (looking-at "^[\t ]*\\[[^/].+\\]\\[/.+\\]"))
			    (search-backward-regexp elements
						    (point-min) t))
			  t)
			(match-string 1))
		   ""))
	   (depth (wesnoth-within-define position)))
      (while (and (wesnoth-wml-start-pos)
		  (> (wesnoth-within-define (point)) depth)
		  (not (= (point) (wesnoth-wml-start-pos))))
	(search-backward-regexp elements
				(wesnoth-wml-start-pos) t)
	(setq match (match-string 1)))
      (when (and (wesnoth-wml-start-pos)
		 (= (point) (wesnoth-wml-start-pos))
		 (= depth 0)
		 (string-match "#define" match))
	;; Found nothing of use; reset match and assume top-level tag.
	(setq match ""))
      (cond
       ((string-match (concat "\\[/\\|#enddef"
                              (if (not wesnoth-indent-preprocessor-bol)
                                  "\\|#endif"
                                ""))
                      match)
	(cons 'closing (current-indentation)))
       ((string-match "{NEXT " match)
	(cons 'closing (if wesnoth-indent-savefile
			   (- (current-indentation) wesnoth-base-indent)
			 (current-indentation))))
       ((string-match (concat "\\[[^/]?\\|#define\\|{FOREACH "
                              (if (not wesnoth-indent-preprocessor-bol)
                                  "\\|#ifn?def \\|#else"
                                "")) match)
	(cons 'opening (current-indentation)))))))

(defun wesnoth-newline-and-indent (&optional indent)
  "Indent both the current line and the newline created.
If `wesnoth-auto-indent-flag' is nil, indentation will not be
performed.

If the optional argument, INDENT is non-nil, force indentation to
be performed."
  (interactive)
  (wesnoth-newline)
  (when (or wesnoth-auto-indent-flag indent)
    (wesnoth-indent)))

;;; WML checks
(defun wesnoth-check-element-type (position)
  "Determine the context of the element.
POSITION is the position of the element in the list."
  (let ((parent (save-match-data (car (wesnoth-parent-tag)))))
    (if (or (stringp parent) (null parent))
	(member (match-string-no-properties 1)
		(nth position (gethash parent wesnoth-tag-hash-table)))
      (member (match-string-no-properties 1)
	      (let ((result '()))
		(mapc
		 '(lambda (x)
		    (let ((value (nth position (cdr x))))
		      (and value (mapc '(lambda (y)
					  (setq result (cons y result)))
				       value))))
		 (or wesnoth-tmp-tag-data (wesnoth-refresh-wml-data)))
		result)))))

;; Provide `line-number-at-pos' implementation (not available in Emacs 21).
(defun wesnoth-line-number-at-pos (&optional pos)
  "Return (narrowed) buffer line number at position POS.
If POS is nil, use current buffer location.
Counting starts at (point-min), so the value refers
to the contents of the accessible portion of the buffer."
  (let ((opoint (or pos (point))) start)
    (save-excursion
      (goto-char (point-min))
      (setq start (point))
      (goto-char opoint)
      (forward-line 0)
      (1+ (count-lines start (point))))))

(defun wesnoth-check-output (buffer format-string &rest args)
  "Output the string as passed to `format'.
BUFFER is the buffer to output the result.
FORMAT-STRING is the string as the first argument of `format'.
ARGS is any additional data required by `format' to handle FORMAT-STRING."
  (save-excursion
    (let ((lnap (wesnoth-line-number-at-pos)))
      (set-buffer buffer)
      (let ((buffer-read-only nil))
	(insert (apply 'format (concat "Line %d: " format-string "\n")
		       lnap args))))))

(defun wesnoth-extract-macro-details (macro-arguments)
  "Return a list of all macros in MACRO-ARGUMENTS."
  (when macro-arguments
    (let ((results '()))
      (dolist (macro (split-string macro-arguments "[{}][\t ]*"))
	(when (string-match "^\\(\\(?:\\w\\|_\\)+\\)"
			    macro)
	  (add-to-list 'results (match-string-no-properties 1 macro))))
      results)))

(defmacro wesnoth-check-process (format-string &rest args)
  "Output to buffer where requested and position overlays as required.
FORMAT-STRING is the string to pass as the first argument to
`format' for the error.  ARGS is a list of arguments required by
FORMAT-STRING."
  `(progn
     (wesnoth-check-output outbuf ,format-string ,@args)
     (wesnoth-place-overlay (match-beginning 0) (match-end 0))))

(defmacro wesnoth-overlay-at-pos-p (position)
  "Return non-nil when there is an overlay at POSITION."
  `(and (overlays-at (goto-char ,position))
	(overlay-get (car (overlays-at (point))) 'wesnoth-error)
	(overlay-start (car (overlays-at (point))))))

(defmacro wesnoth-locate-warning (string start end)
  "Search for STRING and move to the warning in the given direction.
Searching starts from `point' and will wrap from START if no
match was found.  STRING is a form to locate the warning in the
required direction.  START is the start of the region searched.
END is the end of the region searched."
  `(let ((target nil))
     (save-excursion
       (cond
	((setq target (wesnoth-overlay-at-pos-p ,string)))
	((setq target (wesnoth-overlay-at-pos-p ,start)))
	((and (not (= (goto-char ,string) ,end))
	      (setq target (wesnoth-overlay-at-pos-p (point)))))))
     target))

(defun wesnoth-forward-warning ()
  "Move to the next warning."
  (interactive)
  (let ((target
	 (if (fboundp 'next-overlay-change)
  	     (save-excursion
	       (end-of-line)
	       (wesnoth-locate-warning (next-overlay-change (point))
				       (point-min)
				       (point-max)))
	   (wesnoth-target-position '< '>))))
    (if target
	(goto-char target)
      (message "%s" "No warnings found"))))

(defun wesnoth-backward-warning ()
  "Move to the previous warning."
  (interactive)
  (let ((target
	 (if (fboundp 'previous-overlay-change)
	     (save-excursion
	       (beginning-of-line)
	       (wesnoth-locate-warning (1- (previous-overlay-change (point)))
				       (point-max)
				       (point-min)))
	   (wesnoth-target-position '> '< t))))
    (if target
	(goto-char target)
      (message "%s" "No warnings found"))))

(defun wesnoth-target-position (predicate search &optional lastp)
  "Return the target marker position.
PREDICATE is the function to use to sort
`wesnoth-warning-markers'.  SEARCH must be a function which
returns non-nil when the match is correct.  If LASTP is non-nil,
swap the order of the sorted positions when attempting to
fallback."
  (let ((positions (sort (mapcar 'marker-position wesnoth-warning-markers)
			 predicate)))
    (or (catch 'pos
	  (dolist (position positions)
	    (when (funcall search position (point))
	      (throw 'pos position))))
	(car positions))))

(defun wesnoth-place-overlay (start end)
  "Place overlay in the region and apply necessary properties.
START is the start of the region to place the overlay.  END is
the end of the region to place the overlay."
  (if (fboundp 'overlay-put)
      (let ((overlay (make-overlay start end)))
	(overlay-put overlay 'wesnoth-error t)
	(overlay-put overlay 'face 'wesnoth-warning-face))
    (add-to-list 'wesnoth-warning-markers (save-excursion
					    (goto-char start)
					    (point-marker)))))

(defun wesnoth-check-wml ()
  "Perform context-sensitive analysis of WML-code."
  (interactive)
  ;; Temporarily cache all tag-data.
  (setq wesnoth-tmp-tag-data (wesnoth-refresh-wml-data))
  (wesnoth-update-project-information)
  (if (fboundp 'delete-overlay)
      (dolist (overlay (overlays-in (point-min) (point-max)))
	(if (eq 'wesnoth-warning-face (overlay-get overlay 'face))
	    (delete-overlay overlay)))
    (setq wesnoth-warning-markers nil))
  (when (= 0 (hash-table-count wesnoth-tag-hash-table))
    (error "WML data not available; unable to generate report"))
  (setq wesnoth-define-blocks (wesnoth-find-macro-definitions))
  (let ((unmatched '())
	(outbuf (and (interactive-p) (get-buffer-create "*WML*")))
	(last-match-pos 1)
	(details nil)
	(foreach '()))
    (save-excursion
      (set-buffer outbuf)
      (let ((buffer (buffer-name))
	    (buffer-read-only nil))
	(erase-buffer)
	(insert (format "Checking %s...\n" buffer))
	(message (format "Checking %s..." buffer))))
    (save-excursion
      (goto-char (point-min))
      (while (setq details (wesnoth-find-next
			    '(tag-opening tag-closing preprocessor attribute
					  macro)))
	(save-excursion
	  (goto-char (match-beginning 0))
	  (cond ((nth 3 (parse-partial-sexp last-match-pos (point)))
		 nil)
		((eq (car details) 'macro)
		 (dolist (macro (save-match-data
				  (wesnoth-extract-macro-details
				   (match-string-no-properties 0))))
		   (unless (assoc macro
				  (wesnoth-merge-macro-data
				   wesnoth-macro-data
				   (wesnoth-macro-additions)
				   wesnoth-local-macro-data
				   (wesnoth-macro-arguments)))
		     (wesnoth-check-process "Unknown macro: '%s'"
					    macro)))
		 (save-match-data
		   (when
		       (looking-at
			"{\\(FOREACH\\|NEXT\\).*[\t ]+\\(\\(?:\\w\\|_\\)+\\)}")
		     (if (string= (match-string-no-properties 1) "FOREACH")
			 (setq foreach
			       (cons (match-string-no-properties 2) foreach))
		       (if (string= (match-string-no-properties 1) "NEXT")
			   (progn
			     (unless (string= (car foreach)
					      (match-string-no-properties 2))
			       (wesnoth-check-process
				(concat "NEXT does not match corresponding "
					"FOREACH: '%s' found; '%s' expected.")
				(match-string-no-properties 2)
				(car foreach)))
			     (setq foreach (cdr foreach))))))))
		((looking-at "[\t ]*\\[\\+?\\(\\(\\w\\|_\\)+\\)\\]")
		 (unless (wesnoth-check-element-type 0)
		   (wesnoth-check-process
		    "Tag not available in this context: '%s'"
		    (match-string-no-properties 1)))
		 (setq unmatched (cons (match-string-no-properties 1)
				       unmatched)))
		((looking-at
		  (concat "[\t ]*\\(#define\\|#ifdef\\|#ifndef\\|#undef\\)"
			  "\\( \\(\\w\\|_\\)+\\)*"))
		 (unless (match-string-no-properties 2)
		   (wesnoth-check-process
		    (concat "Preprocessor statement has no argument: "
			    (match-string-no-properties 1))))
		 (unless (string= (match-string-no-properties 1) "#undef")
		   (setq unmatched (cons (match-string-no-properties 1)
					 unmatched))))
		((looking-at wesnoth-preprocessor-closing-regexp)
		 (when (and unmatched
			    (not (string-match
				  (cdr (assoc (match-string-no-properties 1)
					      '(("enddef" . "#define")
						("endif" . "#ifn?def"))))
				  (car unmatched))))
		   (wesnoth-check-process
		    "Preprocessor statement does not nest correctly"))
		 (setq unmatched (cdr unmatched)))
		((looking-at "[\t ]*\\(\\(\\w\\|_\\)+\\)=\\(.+\\)?")
		 (unless (wesnoth-check-element-type 1)
		   (wesnoth-check-process
		    "Attribute not available in this context: '%s'"
		    (match-string-no-properties 1)))
		 (unless (match-string 3)
		   (wesnoth-check-process
		    "Attribute has no value")))
		((looking-at "[\t ]*#else")
		 (unless (string-match "ifn?def" (car unmatched))
		   (if (string= (car unmatched) "#define")
		       (wesnoth-check-process "Expecting: '%s'"
					      (car unmatched))
		     (wesnoth-check-process "Expecting: '[/%s]'"
					    (car unmatched)))))
		((looking-at "[\t ]*\\[/\\(\\(\\w\\|_\\)+\\)\\]")
		 (when (and unmatched
			    (not (string= (match-string-no-properties 1)
					  (car unmatched))))
		   (wesnoth-check-process
		    "Expecting '%s'"
		    (or (cdr (assoc (car unmatched)
				    '(("#define" . "#enddef")
				      ("#ifdef" . "#endif")
				      ("#ifndef" . "#endif"))))
			(concat "[/" (car unmatched) "]"))))
		 (setq unmatched (cdr unmatched)
		       last-match-pos (point))))))
      (when foreach
	(dolist (var foreach)
	  (wesnoth-check-process "Unmatched FOREACH: '%s'" var)))
      (when unmatched
	(dolist (element unmatched)
	  (wesnoth-check-process "Unmatched element: '%s'" element))))
    (save-excursion
      (setq wesnoth-define-blocks nil
	    wesnoth-tmp-tag-data nil)
      (set-buffer outbuf)
      (toggle-read-only t)
      (let ((buffer (buffer-name))
	    (buffer-read-only nil))
	(display-buffer outbuf t)
	(let ((warnings (- (wesnoth-line-number-at-pos
			    (save-excursion (goto-char (point-max)))) 2)))
	  (insert (format (concat "\nCheck complete.  %d warning"
				  (if (= warnings 1) "." "s.")) warnings)))
	(message (format "Checking %s...done" buffer))))))


;;; wesnoth-mode
(define-derived-mode wesnoth-mode fundamental-mode "wesnoth-mode"
  "Major mode for editing WML."
  (kill-all-local-variables)
  (use-local-map wesnoth-mode-map)
  (setq major-mode 'wesnoth-mode)
  (setq mode-name "WML")
  (set-syntax-table wesnoth-syntax-table)
  (set (make-local-variable 'outline-regexp) "[\t ]*#define")
  (set (make-local-variable 'comment-start) "#")
  (set (make-local-variable 'indent-line-function) 'wesnoth-indent)
  (set (make-local-variable 'indent-region-function) 'wesnoth-indent-region)
  (set (make-local-variable 'wesnoth-warning-markers) '())
  (set (make-local-variable 'font-lock-defaults)
       '(wesnoth-font-lock-keywords
	 nil t nil nil
	 (font-lock-syntactic-keywords . wesnoth-syntactic-keywords)))
  (setq indent-tabs-mode nil)
  (easy-menu-add wesnoth-menu wesnoth-mode-map)
  (wesnoth-refresh-wml-data)
  (wesnoth-update-project-information)
  (run-hooks 'wesnoth-mode-hook))

(provide 'wesnoth-mode)

;;; wesnoth-mode.el ends here
