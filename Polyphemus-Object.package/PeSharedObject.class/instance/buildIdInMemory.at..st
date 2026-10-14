accessing
buildIdInMemory: aMemory at: aBase

	"The same fields in the header as loaded at aBase: the loader maps the headers' page there."

	^ self buildIdIn: ((aMemory bytesAt: aBase count: 4096) ifNil: [ ^ nil ])
