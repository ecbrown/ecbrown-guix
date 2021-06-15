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

(define-module (psopt)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system cmake)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages python)
  #:use-module (colpack)
  #:use-module (adol-c))

(define-public psopt
   (package
     (name "psopt")
     (version "5.0.1")
     (source (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/PSOPT/psopt")
                     (commit version)))
               (file-name (git-file-name name version))
               (sha256
                (base32
                 "15bi7s1dnvm0hhzidr5bnz98rhb6yhz9q177s1yd43mqb70waa6h"))))
     (build-system cmake-build-system)
     (arguments
      `(#:tests? #f ; no test suite
        #:configure-flags
        `(,(string-append "-Dadolc_INCLUDE_DIR="
                          (assoc-ref %build-inputs "adol-c") "/include")
          ,(string-append "-Dadolc_LIBRARY="
                          (assoc-ref %build-inputs "adol-c") "/lib"))))
     (native-inputs
      `(("python-2" ,python-2)
        ("pkg-config" ,pkg-config)))
     (inputs
      `(("adol-c" ,adol-c)
        ("colpack" ,colpack)
        ("eigen" ,eigen)
        ("gnuplot" ,gnuplot)
        ("ipopt" ,ipopt)
        ("lapack" ,lapack)))
     (home-page "https://github.com/PSOPT/psopt")
     (synopsis "Optimal Control Software")
     (description
      "PSOPT is an optimal control package written in C++ that uses direct
 collocation methods. These methods solve optimal control problems by
 approximating the time-dependent variables using global or local
 polynomials.")
     (license license:lgpl2.1)))
