reading
packageOfClassOop: aClassOop

	"Pharo 12 and later: through the class's PackageTag to its Package. Pharo 10 and 11: the
	longest package name its category (its last symbol but its name) is or starts with."

	| tag symbols category |
	tag := self slotOf: aClassOop named: 'PackageTag'.
	tag ifNotNil: [
		^ (self slotOf: tag named: 'Package')
			  ifNil: [ '(no package)' ]
			  ifNotNil: [ :package | (self stringsOf: package) ifEmpty: [ '(no package)' ] ifNotEmpty: [ :names | names first ] ] ].
	symbols := self stringsOf: aClassOop.
	symbols size < 2 ifTrue: [ ^ '(no package)' ].
	category := symbols last.
	^ ((self packageNames select: [ :each | category = each or: [ category beginsWith: each , '-' ] ])
		   inject: nil
		   into: [ :longest :each | (longest isNil or: [ each size > longest size ]) ifTrue: [ each ] ifFalse: [ longest ] ])
		  ifNil: [ '(no package)' ]
