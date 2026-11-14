building
buildDamagedCopyFrom: aCleanImage to: aTarget

	"Built under a name of its own and renamed onto aTarget, so a class reading or building it at
	the same time finds it whole and damaged."

	| clean building |
	clean := DamagedCandleImage readingOf: aCleanImage.
	building := aTarget parent / ('.' , aTarget basename , '.' , UUID new asString , '.building').
	DamagedCandleImage
		copyOf: aCleanImage
		damagedBy: (self damagesIn: clean)
		readAs: clean
		to: building.
	LibC runCommand: 'mv -f ' , building fullName , ' ' , aTarget fullName.
	^ aTarget
