setl comments=:;
setl define=^\\s*(def\\k*
setl formatoptions-=t
setl iskeyword+=+,-,*,/,%,<,=,>,:,$,?,!,@-@,94
setl lisp
setl commentstring=;%s

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

setl comments^=:;;;,:;;,sr:#\|,mb:\|,ex:\|#

let b:undo_ftplugin = "setlocal comments< define< formatoptions< iskeyword< lisp< commentstring<"
