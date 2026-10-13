reading
symbols

	"Defined symbols (n_type N_SECT, stabs aside) by name, without the leading underscore."

	symbols ifNotNil: [ ^ symbols ].
	symbols := Dictionary new.
	self commandsIn: self bytes do: [ :type :at |
		type = 16r2 ifTrue: [
			| table count strings |
			table := self unsignedIn: self bytes at: at + 8 size: 4.
			count := self unsignedIn: self bytes at: at + 12 size: 4.
			strings := self unsignedIn: self bytes at: at + 16 size: 4.
			0 to: count - 1 do: [ :i |
				| entry kind |
				entry := table + (i * 16).
				kind := self unsignedIn: self bytes at: entry + 4 size: 1.
				((kind bitAnd: 16rE0) = 0 and: [ (kind bitAnd: 16r0E) = 16r0E ]) ifTrue: [
					| name |
					name := self stringAt: strings + (self unsignedIn: self bytes at: entry size: 4).
					(name beginsWith: '_') ifTrue: [ name := name allButFirst ].
					symbols at: name put: (self unsignedIn: self bytes at: entry + 8 size: 8) ] ] ] ].
	^ symbols
