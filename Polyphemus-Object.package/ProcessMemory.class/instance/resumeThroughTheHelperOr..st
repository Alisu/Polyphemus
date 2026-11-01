holding it still
resumeThroughTheHelperOr: aBlock

	"Let it go, noting whether the stop lasted until now: one ended at its bound was read running."

	| helper |
	stopHelper ifNil: [
		aBlock value.
		^ stopLasted := true ].
	helper := stopHelper.
	stopHelper := nil.
	stopLasted := helper end
