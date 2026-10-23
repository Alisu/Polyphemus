accessing
letTheImageGo

	"Release the held image, once, and forget it with its reading: Pharo's theme may keep the last
	debugger, and its session with it (#110). Answers whether there was anything to release."

	| letGo |
	letGo := release.
	release := nil.
	letGo ifNil: [ ^ false ].
	held := image := nil.
	letGo value.
	^ true
