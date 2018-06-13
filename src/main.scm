(use extras)
(require-extension srfi-37)
(import rpn-parse rpn-doc rpn-colour)

(define *verbose* (make-parameter #f))

(define (rpn:version #!optional args) ; ignore arguments
  (print   (tint "rpnscm v0.15" 'cyan 'bold))
  (print   (tint "Copyright (C) 2018 Erkin Batu Altunbaş" 'cyan))
  (newline)
  (print* "Each file of this project's source code is subject ")
  (print  "to the terms of the Mozilla Public Licence v2.0")
  (print* "If a copy of the MPL was not distributed with this file, ")
  (print  "you can obtain one at https://mozilla.org/MPL/2.0/")
  (exit))

(define (rpn:usage #!optional opt name arg loads)
  (cond
   ((string? name)
    (unless (string=? name "help")
      (newline)
      (print
       (tint "Unrecognised long option: " 'purple)
       (tint "--" 'yellow)
       (tint name 'yellow))
      (newline)))
   ((char? name)
    (unless (or (char=? name #\h) (char=? name #\?))
      (newline)
      (print
       (tint "Unrecognised short option: " 'purple)
       (tint "-" 'yellow)
       (tint name 'yellow))
      (newline))))
  (display (tint "Usage: " 'green))
  (print (car (argv)) " -e " (tint "\"EXPRESSION\"" 'yellow))
  (display "       ")
  (print (car (argv)) " -f " (tint "\"FILE\"" 'yellow))
  (for-each print rpn:help-messages)
  (exit))

(define rpn:opts
  (list
   (option '(#\h #\? "help") #f #f
           rpn:usage)
   (option '(#\V "version") #f #f
           rpn:version)
   (option '(#\v "verbose") #f #f
           (lambda _
             (*verbose* #t)))
   (option '(#\o "operators") #f #f
           rpn:operator-usage)
   (option '(#\e "eval" "evaluate") #t #f
           (lambda (op name arg loads)
             (rpn:calculate arg (*verbose*))))
   (option '(#\i "interactive" "repl") #f #f
           (lambda _
             (rpn:repl (*verbose*))))
   (option '(#\f "file") #t #f
           (lambda (opt name arg loads)
             (rpn:calculate
              (with-input-from-file arg read-string)
              (*verbose*))))))

(if (null? (command-line-arguments))
    (rpn:usage)
    (args-fold (command-line-arguments) rpn:opts rpn:usage #f #f))
