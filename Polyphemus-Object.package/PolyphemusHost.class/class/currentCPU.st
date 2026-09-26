private
currentCPU

	"Named as editions name it: x64 for what Linux calls x86_64, arm64 for aarch64 too."

	| subtype |
	subtype := Smalltalk os subtype asString.
	(#( 'x86_64' 'x64' 'X64' 'AMD64' ) includes: subtype) ifTrue: [ ^ 'x64' ].
	(#( 'arm64' 'aarch64' ) includes: subtype) ifTrue: [ ^ 'arm64' ].
	^ subtype
