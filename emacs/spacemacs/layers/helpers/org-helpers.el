;;; summered-emacs.el --- Summered for Emacs.

;; Copyright (C) 2012 Arthur Leonard Andersen

;; Author: Arthur Leonard Andersen <leoc.git@gmail.com>
;; URL: http://github.com/leoc/org-helpers
;; Version: 0.1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;;    org-helpers provide many methods to configure org-mode easily
;;  for the GTD way of organizing tasks.
;;
;;; Installation:
;;
;;    Just put org-helpers.el in a directory that´s in you load-path
;;  and `(require 'org-helpers)` in your `init.el`.
;;
;;     Afterwards you can use the org-helpers functions to configure
;;   your org-mode to your wishes.
;;
;;; Credits
;;
;;    Most code is based on the wonderful article from
;;  norang. (http://doc.norang.ca/org-mode.html)
;;  Many thanks to Bernt Hansen for a well-founded approach!
;;
;;; Code

(defmacro oh/agenda-type (&rest types)
  `(or ,@(mapcar '(lambda (item)
                   (let ((type (symbol-name (if (listp item)
                                                (car (cdr item))
                                              item))))
                     `(,(intern (concat "oh/is-" type "-p")))))
                types)))

(defun* oh/agenda-skip (&rest types
                        &key ((:headline-if headline) nil)
                             ((:headline-if-restricted-and headline-restricted) nil)
                             ((:headline-if-unrestricted-and headline-unrestricted) nil)
                             ((:subtree-if subtree) nil)
                             ((:subtree-if-restricted-and subtree-restricted) nil)
                             ((:subtree-if-unrestricted-and subtree-unrestricted) nil))
  "True when one of the given check functions return true."
  (save-restriction
    (let* ((subtree-values (or types subtree))
           (subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading)
                                              (point-max))))
           (restricted-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((and headline
             (eval (macroexpand `(oh/agenda-type ,@headline))))
        next-headline)
       ((and subtree
             (eval (macroexpand `(oh/agenda-type ,@subtree))))
        subtree-end)
       ((and headline-restricted
             restricted-to-project
             (eval (macroexpand `(oh/agenda-type ,@headline-restricted))))
        next-headline)
       ((and headline-unrestricted
             (not restricted-to-project)
             (eval (macroexpand `(oh/agenda-type ,@headline-unrestricted))))
        next-headline)
       ((and subtree-restricted
             restricted-to-project
             (eval (macroexpand `(oh/agenda-type ,@subtree-restricted))))
        subtree-end)
       ((and subtree-unrestricted
             (not restricted-to-project)
             (eval (macroexpand `(oh/agenda-type ,@subtree-unrestricted))))
        subtree-end)
       (t nil)))))

(defun oh/has-subtask-p ()
  "Returns t for any heading that has subtasks."
  (save-restriction
    (widen)
    (org-back-to-heading t)
    (let ((end (save-excursion (org-end-of-subtree t))))
      (outline-end-of-heading)
      (save-excursion
        (re-search-forward (concat "^\*+ " org-todo-regexp) end t)))))

(defun oh/has-parent-project-p ()
  "Returns t when current heading has a parent project."
  (let ((has-parent nil))
    (while (and (not has-parent) (org-up-heading-safe))
      (when (oh/is-todo-p)
        (setq has-parent t)))
    has-parent))

(defun oh/is-todo-p ()
  "Returns t for any heading that has a todo keyword."
  (member (org-get-todo-state) org-todo-keywords-1))

(defun oh/is-project-p ()
  "Returns t for any heading that is a todo item and that has a subtask."
  (and (oh/is-todo-p)
       (oh/has-subtask-p)))

(defun oh/is-non-project-p ()
  "Returns t for any heading that is not a project.  E.g. that does not
   have a subtask or is not a todo item."
  (not (oh/is-project-p)))

(defun oh/is-stuck-project-p ()
  "Returns t for any heading that is a project but does not have a NEXT
   subtask but has TODO subtasks."
  (save-excursion
    (let ((end (save-excursion (org-end-of-subtree t))))
      (outline-end-of-heading)
      (and (oh/is-project-p)
           (not (save-excursion (re-search-forward "^\\*+ \\(NEXT\\|STARTED\\) " end t)))
           (re-search-forward "^\\*+ TODO " end t)))))

(defun oh/is-non-stuck-project-p ()
  "Returns t for any heading that is a project and has a `NEXT` subtask."
  (save-excursion
    (let ((end (save-excursion (org-end-of-subtree t))))
      (outline-end-of-heading)
      (and (oh/is-project-p)
           (or (save-excursion (re-search-forward "^\\*+ \\(NEXT\\|STARTED\\) " end t))
               (not (re-search-forward "^\\*+ TODO " end t)))))))

(defun oh/is-subproject-p ()
  "Returns t for any heading that is a project and has a parent project."
  (and (oh/is-project-p)
       (oh/has-parent-project-p)))

(defun oh/is-top-project-p ()
  "Returns t when current heading is not a subproject."
  (and (oh/is-project-p)
       (not (oh/has-parent-project-p))))

(defun oh/is-task-p ()
  "Returns t for any heading that is a todo item but does not have a subtask."
  (and (oh/is-todo-p)
       (not (oh/has-subtask-p))))

(defun oh/is-subtask-p ()
  "Returns t for any heading that is a task with a parent project."
  (and (oh/is-task-p)
       (oh/has-parent-project-p)))

(defun oh/is-single-task-p ()
  "Returns t for any heading that is a task without a parent project."
  (and (oh/is-task-p)
       (not (oh/has-parent-project-p))))

(defun oh/is-habit-p ()
  "Returns t for any heading that is a habit."
  (org-is-habit-p))

(defun oh/is-inactive-p ()
  "Returns t for any heading that is of todo state `SOMEDAY`, `HOLD`,
`WAITING`, `DONE` or `CANCELLED`. This also applys to headings that
have parent headings that are of those given todo states."
  (save-excursion
    (let ((is-inactive (member (org-get-todo-state) '("SOMEDAY" "HOLD" "WAITING" "CANCELLED" "DONE"))))
      (while (and (not is-inactive) (org-up-heading-safe))
        (when (member (org-get-todo-state) '("SOMEDAY" "HOLD" "WAITING" "CANCELLED" "DONE"))
          (setq is-inactive t)))
      is-inactive)))

(defun oh/is-inactive-project-p ()
  "Returns t for any heading that is of todo state `SOMEDAY`, `HOLD`,
`WAITING`, `DONE` or `CANCELLED` or if there is no TODO entry.
This also applys to headings that have parent headings that are of those
given todo states."
  (save-excursion
    (let* ((is-inactive (member (org-get-todo-state) '("SOMEDAY" "HOLD" "WAITING" "CANCELLED" "DONE")))
           (end (save-excursion (org-end-of-subtree t)))
           (is-inactive (or is-inactive
                            (save-excursion (not (re-search-forward "^\\*+ \\(TODO\\|NEXT\\) " end t))))))
      (while (and (not is-inactive) (org-up-heading-safe))
        (when (member (org-get-todo-state) '("SOMEDAY" "HOLD" "WAITING" "CANCELLED" "DONE"))
          (setq is-inactive t)))
      is-inactive)))

(defun oh/is-scheduled-p ()
  "Returns t for any scheduled heading."
  (org-back-to-heading t)
  (let ((end (save-excursion (outline-next-heading) (1- (point)))))
    (re-search-forward org-scheduled-time-regexp end t)))

(defun oh/is-deadline-p ()
  "Returns t for any heading with a deadline."
  (org-back-to-heading t)
  (let ((end (save-excursion (outline-next-heading) (1- (point)))))
    (re-search-forward org-deadline-time-regexp end t)))

;;; MOVEMENT HELPERS
;; To move easily between headings.

(defun oh/find-toplevel-project ()
  "Moves the point to the top project of the current headline, if any ..."
  (save-restriction
    (widen)
    (let ((project-point (point)))
      (while (org-up-heading-safe)
        (if (oh/is-todo-p)
            (setq project-point (point))))
      (goto-char project-point)
      project-point)))

(defun oh/show-toplevel-project ()
  "Switches to the toplevel project of a task."
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (org-agenda-switch-to))
  (oh/find-toplevel-project))

;;; AGENDA RESTRICTION
;; To provide easy context switches and better overview.

(defun oh/agenda-set-restriction ()
  "Sets the restriction lock for a subtree."
  (interactive)
  (org-narrow-to-subtree)
  (org-agenda-set-restriction-lock))

(defun oh/agenda-remove-restriction ()
  "Removes the restriction lock for a subtree."
  (interactive)
  (widen)
  (org-agenda-remove-restriction-lock))

(defun oh/agenda-restrict-to-subtree ()
  "Restricts the agenda view to the subtree of the current heading."
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (org-with-point-at (org-get-at-bol 'org-hd-marker)
        (oh/agenda-set-restriction))
    (oh/agenda-set-restriction)))

(defun oh/agenda-restrict-to-project ()
  "Restricts the agenda view to the top level project of the current heading."
  (interactive)
  (widen)
  (save-excursion
    (if (equal major-mode 'org-agenda-mode)
        (org-with-point-at (org-get-at-bol 'org-hd-marker)
          (oh/find-toplevel-project)
          (oh/agenda-set-restriction))
      (progn
        (oh/find-toplevel-project)
        (oh/agenda-set-restriction)))))


(defun oh/agenda-sort (a b)
  "Sorting strategy for agenda items.
Late deadlines first, then scheduled, then non-late deadlines"
  (let (result num-a num-b)
    (cond
     ;; time specific items are already sorted first by org-agenda-sorting-strategy
     ;; non-deadline and non-scheduled items next
     ((oh/agenda-sort-test 'oh/is-not-scheduled-or-deadline a b))
     ;; deadlines for today next
     ((oh/agenda-sort-test 'oh/is-due-deadline a b))
     ;; late deadlines next
     ((oh/agenda-sort-test-num 'oh/is-late-deadline '< a b))
     ;; scheduled items for today next
     ((oh/agenda-sort-test 'oh/is-scheduled-today a b))
     ;; late scheduled items next
     ((oh/agenda-sort-test-num 'oh/is-scheduled-late '> a b))
     ;; pending deadlines last
     ((oh/agenda-sort-test-num 'oh/is-pending-deadline '< a b))
     ;; finally default to unsorted
     (t (setq result nil)))
    result))

(defmacro oh/agenda-sort-test (fn a b)
  "Test for agenda sort"
  `(cond
    ;; if both match leave them unsorted
    ((and (apply ,fn (list ,a))
          (apply ,fn (list ,b)))
     (setq result nil))
    ;; if a matches put a first
    ((apply ,fn (list ,a))
     (setq result -1))
    ;; otherwise if b matches put b first
    ((apply ,fn (list ,b))
     (setq result 1))
    ;; if none match leave them unsorted
    (t nil)))

(defmacro oh/agenda-sort-test-num (fn compfn a b)
  `(cond
    ((apply ,fn (list ,a))
     (setq num-a (string-to-number (match-string 1 ,a)))
     (if (apply ,fn (list ,b))
         (progn
           (setq num-b (string-to-number (match-string 1 ,b)))
           (setq result (if (apply ,compfn (list num-a num-b))
                            -1
                          1)))
       (setq result -1)))
    ((apply ,fn (list ,b))
     (setq result 1))
    (t nil)))

(defun oh/is-not-scheduled-or-deadline (date-str)
  (and (not (oh/is-deadline date-str))
       (not (oh/is-scheduled date-str))))

(defun oh/is-due-deadline (date-str)
  (string-match "Deadline:" date-str))

(defun oh/is-late-deadline (date-str)
  (string-match "In *\\(-.*\\)d\.:" date-str))

(defun oh/is-pending-deadline (date-str)
  (string-match "In \\([^-]*\\)d\.:" date-str))

(defun oh/is-deadline (date-str)
  (or (oh/is-due-deadline date-str)
      (oh/is-late-deadline date-str)
      (oh/is-pending-deadline date-str)))

(defun oh/is-scheduled (date-str)
  (or (oh/is-scheduled-today date-str)
      (oh/is-scheduled-late date-str)))

(defun oh/is-scheduled-today (date-str)
  (string-match "Scheduled:" date-str))

(defun oh/is-scheduled-late (date-str)
  (string-match "Sched\.\\(.*\\)x:" date-str))

;;; MISC HELPERS

(defun oh/summary-todo-checkbox (c-on c-off)
  "Switch entry to DONE when all subentry-checkboxes are done,
to TODO otherwise."
  (outline-previous-visible-heading 1)
  (let (org-log-done org-log-states)
    (org-todo (if (= c-off 0) "DONE" "TODO"))))

(provide 'org-helpers)
