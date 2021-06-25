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

(define-module (python-gau2grid)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages version-control)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26))

(define-public python-gau2grid
  (package
   (name "python-gau2grid")
   (version "2.0.6")
   (source (origin
             (method git-fetch)
g             (uri (git-reference
                   (url "https://github.com/dgasmith/gau2grid")
                   (commit (string-append "v" version))
                   (recursive? #t)))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "0m8r2vplsx4hd7p77gzg8akf1r3z8r2vd2s2kbd891llbhgvhx3q"))))
   (build-system cmake-build-system)
   (propagated-inputs
    `(("python" ,python)
      ("python-wrapper" ,python-wrapper)
      ("python-numpy" ,python-numpy)
      ("python-setuptools" ,python-setuptools)
      ("python-setuptools-scm" ,python-setuptools-scm)))
   (arguments `(#:tests? #f))
   (home-page "https://github.com/dgasmith/gau2grid")
   (synopsis "Fast computation of a gaussian and its derivative on a grid")
   (description "gau2grid is a collocation code for computing
gaussians on a grid. The returned matrix can be in either cartesian or
regular solid harmonics.")
   (license license:bsd-3)))
