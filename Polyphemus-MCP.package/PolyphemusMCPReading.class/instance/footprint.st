reading
footprint

	"What each package of an image file owns, worked out once."

	memory ifNil: [ ^ ToolCallFailed signal: 'packages reads image files; this handle is not one' ].
	^ footprint ifNil: [ footprint := PackageFootprint of: memory ]
