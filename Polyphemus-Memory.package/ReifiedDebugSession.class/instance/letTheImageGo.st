accessing
letTheImageGo

	"Release the held image, once. Answers whether there was anything to release."

	| held |
	held := release.
	release := nil.
	held ifNil: [ ^ false ].
	held value.
	^ true
