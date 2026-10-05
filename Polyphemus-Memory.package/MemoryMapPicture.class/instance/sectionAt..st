mapping
sectionAt: aPoint

	"The index of the section whose map holds that point, or nil."

	^ (1 to: sections size)
		  detect: [ :each | ((self originOf: each) extent: (self geometryOf: each) width @ (self geometryOf: each) height) containsPoint: aPoint ]
		  ifNone: [ nil ]
