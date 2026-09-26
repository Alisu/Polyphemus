accessing
scratch

	"Where the edition's tests and fixtures leave files: its own, so two hosts on one box do not
	take each other's (#50)."

	^ (FileLocator temp / 'polyphemus' / self name) ensureCreateDirectory
