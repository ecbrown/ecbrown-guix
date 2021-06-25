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

(define-module (libint)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages tex))

(define-public libint
  (package
    (name "libint")
     (version "2.6.0")
     (source (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/evaleev/libint")
                     (commit (string-append "v" version))
                     (recursive? #f)))
               (file-name (git-file-name name version))
               (sha256
                (base32
                 "0pbc2j928jyffhdp4x5bkw68mqmx610qqhnb223vdzr0n2yj5y19"))
	              (modules '((guix build utils)))
		      (snippet
		       '(begin
			  (substitute* "configure.ac"
			    (("/bin/rm")
			     "rm"))
			  (substitute* "src/bin/libint/Makefile"
			    (("/bin/rm")
			     "rm"))
			  (substitute* "tests/eri/Makefile"
			    (("/bin/rm")
			     "rm"))
			  (substitute* "tests/hartree-fock/Makefile"
			    (("/bin/rm")
			     "rm"))
			  (substitute* "tests/unit/Makefile"
			    (("/bin/rm")
			     "rm"))))))
     (build-system gnu-build-system)
     (arguments
      `(#:configure-flags
	`("--enable-unrolling"
	  "--enable-mpfr"
	  "--with-cxxgen-optflags=-O2")))
     (native-inputs
      `(("autoconf" ,autoconf)
	("automake" ,automake)
	("boost" ,boost)
	("doxygen" ,doxygen)
	("latex2html" ,latex2html)
	("perl" ,perl)
	("texlive" ,texlive)))
     (inputs
      `(("gmp" ,gmp)
	("mpfr" ,mpfr)))
     (home-page "http://libint.valeyev.net")
     (synopsis "High-performance library for computing Gaussian
integrals in quantum mechanics")
     (description
      "The LIBINT library contains functions to compute many-body
integrals over Gaussian functions which appear in electronic and
molecular structure theories.")
     (license license:gpl3)))
