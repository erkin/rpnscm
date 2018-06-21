(require-extension (only srfi-37 args-fold option option-processor))
(import rpn-parse rpn-doc rpn-colour)

(define *verbose* (make-parameter #f))

(define (rpn:version #!optional args) ; ignore arguments
  (print   (tint "rpnscm v0.17" 'cyan 'bold))
  (print   (tint "Copyright (C) 2018 Erkin Batu Altunbaş" 'cyan))
  (newline)
  (print* "Each file of this project's source code is subject ")
  (print  "to the terms of the Mozilla Public Licence v2.0")
  (print* "If a copy of the MPL was not distributed with this file, ")
  (print  "you can obtain one at https://mozilla.org/MPL/2.0/")
  (exit))

(define (rpn:usage #!optional opt name arg loads)
  (define unrecognised
    (if opt ; When called without options, the value of opt is #f.
        (if (string? name)
            (if (string=? name "help")
                #f
                'long)
            (if (or (char=? name #\?) (char=? name #\h))
                #f
                'short)) ; We don't actually check for 'short anywhere.
        #f))
  (when unrecognised
    (newline)
    (print
     (tint "Unrecognised " 'purple 'bold)
     (tint (if (eq? unrecognised 'long) "long" "short") 'purple 'bold)
     (tint " option: " 'purple 'bold)
     (tint (if (eq? unrecognised 'long) "--"   "-")     'yellow)
     (tint name 'yellow))
    (newline))

  (print* (tint "Usage: " 'green))
  (print  (car (argv)) " -e " (tint "\"EXPRESSION\"" 'yellow))
  (print* "       ")
  (print  (car (argv)) " -f " (tint "FILE" 'yellow))
  (for-each print rpn:help-messages)
  (exit (if unrecognised 1 0)))

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

(define (main args)
  (if (pair? args)
      (args-fold args rpn:opts rpn:usage cons '()))
  (rpn:usage))

(main (command-line-arguments))
