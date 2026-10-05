mapping
addressAt: aPoint

	^ (self sectionAt: aPoint) ifNotNil: [ :index | (self geometryOf: index) addressAt: aPoint - (self originOf: index) ]
