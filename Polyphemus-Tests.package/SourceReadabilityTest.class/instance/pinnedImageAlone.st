helpers
pinnedImageAlone

	"The pinned image, linked into a directory of its own: whatever else is there is what
	the test put there."

	| link |
	link := directory / 'alone.image'.
	LibC system: 'ln -s ' , PharoImageAccessor pathToPharo10 asFileReference fullName , ' '
		, link fullName.
	^ link
