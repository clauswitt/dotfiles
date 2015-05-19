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
(defun gtd-archive ()
  "Open GTD archive"
  (interactive)
  (find-file "~/Dropbox/org/gtd/main.org_archive")
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
        ("I" "Interuption (internal)" entry (file+headline "~/Dropbox/org/gtd/main.org" "Tasks")
         "** DONE %? :INTERUPTION::INTERNAL:\n %i\n %a" :clock-in t :clock-resume t )
        ("E" "Interuption (external)" entry (file+headline "~/Dropbox/org/gtd/main.org" "Tasks")
         "** DONE %? :INTERUPTION::EXTERNAL:\n %i\n %a" :clock-in t :clock-resume t )
        ("t" "Todo" entry (file+headline "~/Dropbox/org/gtd/main.org" "Tasks")
         "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
        ("g" "Groceries" entry (file+headline "~/Dropbox/org/groceries.org" "INBOX")
         "* TODO %?\n %i\n %a")
        ("j" "Journal Entry" entry (file+datetree "~/Dropbox/org/journal.org")
         "* %?\n%U\n" :clock-in t :clock-resume t)
        ("r" "respond" entry (file+headline "~/Dropbox/org/gtd/main.org" "Tasks")
         "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
        ("n" "note" entry (file "~/Dropbox/org/notes/main.org")
         "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
        ("w" "org-protocol" entry (file+headline "~/Dropbox/org/gtd/main.org" "Tasks")
         "* TODO Review %c\n%U\n" :immediate-finish t)
        ("m" "Meeting" entry (file+headline "~/Dropbox/org/gtd/main.org" "Tasks")
         "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
        ("p" "Phone call" entry (file+headline "~/Dropbox/org/gtd/main.org" "Tasks")
         "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
        ("h" "Habit" entry (file+headline "~/Dropbox/org/gtd/main.org" "Habits")
         "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
        )

      )

