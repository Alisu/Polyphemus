accessing
cacheDirectory

	"The edition's own: another host's key never matches ours, and one would delete the
	other's image (#50)."

	^ PolyphemusEdition current scratch / 'cache' / 'image-from-dump'
