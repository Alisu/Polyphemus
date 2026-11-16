tests
testADefectReadingAnObjectIsNotAnAddressWithNoObjectOrAnObjectWithoutNames

	"#118: a bug of our own reifying what is at an address made inspect say no object is there;
	one reading its class left its slots unnamed."

	| server object inspecting |
	server := PolyphemusMCPServer new.
	object := self process.
	inspecting := [ :aMemory |
		server inspect: (Dictionary new
				 at: 'handle' put: (server
						  open: (PolyphemusMCPReading new setKind: 'image' path: 'nowhere' reified: aMemory)
						  as: 'image');
				 at: 'address' put: object address;
				 yourself) ].
	self
		should: [ inspecting value: (self defective: self memory in: #reifyOop:) ]
		raise: ZeroDivide
		description: 'a defect reifying it'.
	#( #isReadable #oopClass ) do: [ :each |
		self
			should: [
				inspecting value: ((DefectiveReadDouble of: self memory)
						 when: #reifyOop:
						 answer: [ self defective: object in: each ]) ]
			raise: ZeroDivide
			description: 'a defect in ' , each ]
