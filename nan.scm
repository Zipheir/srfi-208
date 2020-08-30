;;; Copyright (C) 2020 Wolfgang Corcoran-Mathe
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a
;;; copy of this software and associated documentation files (the
;;; "Software"), to deal in the Software without restriction, including
;;; without limitation the rights to use, copy, modify, merge, publish,
;;; distribute, sublicense, and/or sell copies of the Software, and to
;;; permit persons to whom the Software is furnished to do so, subject to
;;; the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included
;;; in all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
;;; OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
;;; CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
;;; TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;;; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(define (%real->bytevector n)
  (let ((bvec (make-bytevector 8)))
    (bytevector-ieee-double-set! bvec 0 n (endianness big))
    bvec))

(define (nan-negative? nan)
  (assume (real? nan))
  (assume (nan? nan))
  (let ((bvec (%real->bytevector nan)))
    (bit-set? 7 (bytevector-u8-ref bvec 0))))

(define (nan-quiet? nan)
  (assume (real? nan))
  (assume (nan? nan))
  (let ((bvec (%real->bytevector nan)))
    (bit-set? 3 (bytevector-u8-ref bvec 1))))

(define (nan-payload nan)
  (assume (real? nan))
  (assume (nan? nan))
  (let ((bvec (%real->bytevector nan)))
    (bytevector-u8-set! bvec 1 (bitwise-and #x7
                                            (bytevector-u8-ref bvec 1)))
    (bytevector-uint-ref bvec 1 (endianness big) 7)))

(define (nan= nan1 nan2)
  (assume (real? nan1))
  (assume (nan? nan1))
  (assume (real? nan2))
  (assume (nan? nan2))
  (bytevector=? (%real->bytevector nan1) (%real->bytevector nan2)))
