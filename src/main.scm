(use extras)
(require-extension srfi-37)
(import rpn-parse rpn-doc rpn-colour)

(define *verbose* (make-parameter #f))

(define (rpn:version #!optional arg) ; ignore arguments
  (print   (tint "rpnscm v0.15" 'cyan 'bold))
  (print   (tint "Copyright (C) 2018 Erkin Batu Altunbaş" 'cyan))
  (newline)
  (print* "Each file of this project's source code is subject ")
  (print  "to the terms of the Mozilla Public Licence v2.0")
  (print* "If a copy of the MPL was not distributed with this file, ")
  (print  "you can obtain one at https://mozilla.org/MPL/2.0/")
  (exit))

(define (rpn:usage #!optional arg)
  (unless (null? arg)
    (print (tint "Unrecognised option: " 'purple)
           (tint "-" 'yellow)
           (tint (car (option-names arg)) 'yellow))
    (newline))
  (display (tint "Usage: " 'green))
  (print (car (argv)) " -e " (tint "\"EXPRESSION\"" 'yellow))
  (display "       ")
  (print (car (argv)) " -f " (tint "\"FILE\"" 'yellow))
  (for-each print rpn:help-messages)
  (exit))

(define rpn:opts
  (list
   (option '(#\h "help") #f #f
           rpn:usage)
   (option '(#\V "version") #f #f
           rpn:version)
   (option '(#\v "verbose") #f #f
           (lambda ()
             (*verbose* #t)))
   (option '(#\o "operators") #f #f
           rpn:operator-usage)
   (option '(#\e "eval" "evaluate") #t #f
           (lambda (exp)
             (rpn:calculate exp (*verbose*))))
   (option '(#\i "interactive" "repl") #f #f
           (lambda ()
             (rpn:repl (*verbose*))))
   (option '(#\f "file") #t #f
           (lambda (file)
             (rpn:calculate
              (with-input-from-file file read-string)
              (*verbose*))))))

(args-fold (command-line-arguments) rpn:opts rpn:usage #f #f)
