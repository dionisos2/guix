(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
						 ((guix licenses) #:prefix license:)
						 (guix build-system python)
						 (gnu packages python)
						 (gnu packages python-build)
						 (gnu packages python-crypto)
						 (gnu packages python-xyz)
						 (guix build-system pyproject)
						 (gnu packages libffi)
						 (gnu packages glib)
						 (gnu packages check)
						 )

(package
 (name "my-qtile")
 (version "0.25.0")
 (source
  (origin
   (method url-fetch)
   (uri (pypi-uri "qtile" version))
   (sha256
    (base32 "04gwcgip7469zq0vivrq2ppw25f3v99kymhhlr1740z7l37q0yyc"))))
 (build-system pyproject-build-system)
 (propagated-inputs (list python-cairocffi python-cffi python-xcffib))
 (native-inputs (list python-dbus-next python-libcst python-pygobject
                      python-pytest))
 (home-page "https://qtile.org/")
 (synopsis "A pure-Python tiling window manager.")
 (description "This package provides a pure-Python tiling window manager.")
 (license license:expat))

