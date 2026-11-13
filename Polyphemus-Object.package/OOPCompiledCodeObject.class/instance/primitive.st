accessing
primitive

	"Its primitive's number, 0 for none: VMMaker reads it from the first bytecode, against the
	header as we read it, which follows a jitted method's CogMethod (#184)."

	self isPrimitive ifFalse: [ ^ 0 ].
	^ memory interpreter primitiveIndexOfMethod: address header: (memory methodHeaderOf: address)