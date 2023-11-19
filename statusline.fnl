;; Always show one statusline per window
(tset vim.o :laststatus 2)

(macro hi [group content]
  (.. "%#MyStatusLine" group "#" content))

(macro style [{: fg : bg : attr}]
  [(.. "ctermfg=" (or fg "NONE"))
   (.. "ctermbg=" (or bg "NONE"))
   (.. "cterm=" (or attr "NONE"))
   (.. "guifg=" (or fg "NONE"))
   (.. "guibg=" (or bg "NONE"))
   (.. "gui=" (or attr "NONE"))])

(macro sl-if [condition if-true if-false]
  "Creates a vimscript ternary in statusline language.
  if-true and if-false will be further expanded in the statusline."
  (.. "%{%" condition "?"
       "'" (macroexpand if-true) "'" ":"
       "'" (macroexpand if-false) "'" "%}"))

(tset vim.o :statusline
      (..
        (sl-if :&modified
               (hi :Modified "%m")        ; [+] when modified
               (hi :Plain "%m"))          ; [-] when read-only
        (hi :Filename "%.50f ")           ; relative file path
        (hi :BufferType "%h%w%q ")        ; flags: help/preview/quickfix
        "%="                              ; move to right side
        (hi :Filetype "%{&filetype}")     ; filetype
        (hi :Plain " - ")
        (hi :LineCol "%l")                ; line
        (hi :Plain ":")
        (hi :LineCol "%02v")              ; column (screen, not byte)
        (hi :Plain  " - ")
        (hi :Percentage "%P")             ; percentage through file of screen
        (hi :Plain " of ")
        (hi :Percentage "%L")             ; lines in file
        ))

(fn set-statusline-colors []
  (let [groups {:StatusLine (style {:fg :DarkMagenta})
                :StatusLineNC (style {:fg :DarkGrey :attr :bold})
                :MyStatusLinePlain (style {:fg :DarkGrey})
                :MyStatusLineFilename (style {:fg :DarkRed})
                :MyStatusLineBufferType (style {:fg :DarkCyan})
                :MyStatusLineFiletype (style {:fg :DarkMagenta :attr :italic})
                :MyStatusLinePercentage (style {:fg :DarkYellow})
                :MyStatusLineLineCol (style {:fg :DarkGreen})
                :MyStatusLineModified (style {:fg :Red})
                }]
    (each [name args (pairs groups)]
      (vim.cmd.highlight name (unpack args)))))

(vim.api.nvim_create_autocmd
  :ColorScheme
  {:group (vim.api.nvim_create_augroup :MyStatuslineColors {})
   :callback set-statusline-colors})
