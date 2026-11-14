instance creation
within: aByteCount of: aFramePointer

	"Of a page no record was found for: its frames lie no further than that from its newest."

	^ self new setLimit: aFramePointer + aByteCount baseIsKnown: false
