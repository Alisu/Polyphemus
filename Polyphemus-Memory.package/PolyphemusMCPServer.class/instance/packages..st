tools
packages: someArguments

	| image lines |
	image := self imageAt: someArguments.
	lines := (image at: #footprint ifAbsentPut: [ PackageFootprint of: (image at: #memory ifAbsent: [ self error: 'packages reads image files; this handle is a core' ]) ]) lines first: (self top: someArguments).
	^ self
		  text: (self table: lines) , String lf
			  , 'Owned: classes, metaclasses, method dictionaries, methods, blocks and method state; extension methods count for the class''s package; what class variables keep alive is not counted.'
		  structured: (Dictionary new at: 'packages' put: (self rows: lines); yourself)
