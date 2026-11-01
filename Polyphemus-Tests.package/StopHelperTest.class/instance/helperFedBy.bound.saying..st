helpers
helperFedBy: aCommand bound: seconds saying: aName

	"A helper whose observer is a shell that ends when aCommand does."

	LibC system: '(' , aCommand , ') | ' , StopHelper helperFile fullName , ' ' , target printString , ' '
		, seconds printString , ' ' , (directory / aName) fullName , ' > /dev/null 2>&1 &'
