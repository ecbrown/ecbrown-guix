;;; Copyright © 2021 Eric Brown <ecbrown@ericcbrown.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (adol-c)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (colpack))

(define-public adol-c
   (package
     (name "adol-c")
     (version "2.7.2")
     (source (origin
               (method url-fetch)
               (uri (string-append
                     "https://www.coin-or.org/download/source/ADOL-C/ADOL-C-"
                     version".tgz"))
               (sha256
                (base32
                 "1hw2ayv91rk8s24dnx70i70vg66rwnvyb8pa7pmv4i6wkzirhawh"))))
     (build-system gnu-build-system)
     (arguments
      `(#:configure-flags `("--enable-sparse")))
     (native-inputs
      `(("gfortran" ,gfortran)))
     (inputs
      `(("colpack" ,colpack)
        ("lapack" ,openblas)))
     (home-page "https://www.coin-or.org")
     (synopsis "Automatic Differentiation of Algorithms")
     (description
      "The ADOLC system automatically calculates exact derivatives of a C/C++
 function.  It uses C++ overloading to record arithmetic operations, which it
 plays back later in various ways to calculate the requested values.")
     (license license:epl1.0)))
