accessing
allOopSlotNames

	"The names of its instances' slots, those its superclasses declare first."

	| names |
	names := OrderedCollection new.
	self oopSuperclasses reverseDo: [ :each | names addAll: each oopSlotNames ].
	names addAll: self oopSlotNames.
	^ names
