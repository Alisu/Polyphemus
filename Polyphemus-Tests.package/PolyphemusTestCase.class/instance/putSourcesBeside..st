helpers
putSourcesBeside: anImage

	"An image written from the pinned one looks for its sources next to itself, and says so on
	every start when they are not there (#38)."

	| name pinned |
	name := PharoImageAccessor sourcesNameForPharo: 10.
	pinned := PharoImageAccessor pathToPharo10 asFileReference parent / name.
	(anImage asFileReference parent / name) exists ifFalse: [
		LibC system: 'ln -s ' , pinned resolve fullName , ' ' , (anImage asFileReference parent / name) fullName ]
