;;; GNU Guix --- Functional package management for GNU
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

(define-module (critic2)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)  
  #:use-module (gnu packages bash)
  #:use-module (gnu packages check)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages slang)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages base)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (libcint)
  #:use-module (libxc))

(define-public critic2
  (package
    (name "critic2")
    (version "1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
         (url "https://github.com/aoterodelaroza/critic2")
	 (commit (string-append version "dev"))
	 (recursive? #t)))
       (file-name (git-file-name name (string-append version "dev")))
       (sha256
        (base32         
	 "0bjmv9gbgsj8q6g99v28g17nq31m8pdp5kqfxg95zbrd376j03h7"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           (substitute* "tools/version.sh"
	     (("#! /bin/sh")
	      ""))))))
    (build-system cmake-build-system)
    (inputs
     `(("bash" ,bash)
       ("git" ,git)
       ("gnuplot" ,gnuplot)
       ("nss-certs" ,nss-certs)       
       ("libcint" ,libcint)
       ("libxc" ,libxc)
       ("numdiff" ,numdiff)
       ("openblas" ,openblas)
       ("ncurses" ,ncurses)
       ("readline" ,readline)
       ("slang" ,slang)
       ("qhull" ,qhull)))
    (native-inputs
     `(("automake" ,automake)
       ("autoconf" ,autoconf)
       ("gcc-toolchain" ,gcc-toolchain)
       ("gfortran-toolchain" ,gfortran-toolchain)
       ("libtool" ,libtool)
       ("pkg-config" ,pkg-config)))
    (arguments
     `(#:tests? #f
       #:parallel-build? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'autotools
           (lambda _
	     (setenv "FFLAGS" "-ffree-line-length-512 -O2 -g -fPIC")
	     (setenv "FCFLAGS" "-ffree-line-length-512 -O2 -g -fPIC")
	     (invoke "aclocal")
	     (invoke "automake" "--add-missing")
	     (invoke "autoconf"))))
       #:configure-flags (list "-DENABLE_GUI=0"
			       "-DENABLE_BUILD_STATIC=0")))
    (home-page "https://aoterodelaroza.github.io/critic2")
    (synopsis "Framework for the Quantum Theory of Atoms in Molecules (QTAIM)" )
    (description "Critic2 is a program for the analysis of quantum
mechanical calculation results in molecules and periodic solids.")
    (license license:gpl3+)))
