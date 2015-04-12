(defun open-org-dir ()
  "Opens the org dir"
  (interactive)
  (find-file "~/Dropbox/org/")
  )
(defun gtd-inbox ()
  "Open the gtd inbox"
  (interactive)
  (find-file "~/Dropbox/org/inbox.org")
  )
(defun gtd-inbox-txt ()
  "Open the gtd inbox"
  (interactive)
  (find-file "~/Dropbox/org/inbox.org.txt")
  )
(defun gtd ()
  "Open GTD directory"
  (interactive)
  (find-file "~/Dropbox/org/gtd/main.org")
)
(defun journal ()
    "Open Journal"
    (interactive)
    (find-file "~/Dropbox/org/journal.org")
)
(defun notes ()
    "Switch to my work dir."
    (interactive)
    (find-file "~/Dropbox/org/notes/")
)
(defun edit-personal-keybindings ()
  "Edit personal keybindings"
  (interactive)
  (find-file "~/.emacs.d/private/personal/keybindings.el")
)
(defun edit-personal-funcs ()
  "Edit personal functions"
  (interactive)
  (find-file "~/.emacs.d/private/personal/funcs.el")
)
(defun groceries ()
  "Edit grocery list"
  (interactive)
  (find-file "~/Dropbox/org/groceries.org")
  )

(defun my-org-archive-done-tasks ()
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file)
  )



(setq org-capture-templates
      '(("i" "Inbox" entry (file "~/Dropbox/org/inbox.org")
         "** TODO %?\n %i\n %a")
        ("t" "Todo" entry (file+headline "~/Dropbox/org/gtd/private.org" "Tasks")
         "* TODO %?\n %i\n %a")
        ("g" "Groceries" entry (file+headline "~/Dropbox/org/groceries.org" "INBOX")
         "* %?\n %i\n %a")
        ("j" "Journal Entry" entry (file+datetree "~/Dropbox/org/journal.org")
         "* %?\nEntered on %U\n %i\n %a")
       )
   )


