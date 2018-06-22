(module rpn-colour (tint)
  (import chicken scheme)
  (use (only data-structures ->string))

  (define ansi-colours
    '((black   . "0")
      (red     . "1")
      (green   . "2")
      (yellow  . "3")
      (blue    . "4")
      (purple  . "5")
      (cyan    . "6")
      (white   . "7")
      (default . "9")))

  (define ansi-styles
    '((regular    .  "0")
      (bold       .  "1")
      (faint      .  "2")
      (italic     .  "3")
      (underlined .  "4")
      ;; the rest is useless
      (blink      .  "5")
      (flash      .  "6")
      (swap       .  "7")
      (crossed    .  "9")
      ;; the rest is dead
      (fraktur    . "20")
      (framed     . "50")
      (circled    . "52")
      (overlined  . "53")))
  
  (define (tint string fg #!key (bg 'default) (style 'regular))
    (string-append
     "\033["
     (cdr (assoc style ansi-styles))
     ";3" (cdr (assoc fg ansi-colours))
     ";4" (cdr (assoc bg ansi-colours))
     "m"  (->string string)
     "\033[0m")))
