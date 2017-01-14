#lang racket/base
(require racket/tcp)
(provide serve-request)

(define (serve-request listener)
  (define-values (in out) (tcp-accept listener))
  (write "sortega" out)
  (flush-output out)
  (tcp-close listener))
