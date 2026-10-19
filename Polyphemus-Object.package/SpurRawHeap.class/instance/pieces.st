building the memory
pieces

	"Each stretch of the mapping the memory holds, copied once, touching mappings as one: a gap
	between segments costs nothing. Where the memory stops handing bytes over, a live region
	gone since its map was read (#15), the mapping stops too."

	^ pieces ifNil: [
		  | found |
		  found := OrderedCollection new.
		  self stretchesDo: [ :from :upTo :parts |
			  | buffer end |
			  buffer := ByteArray new: upTo - from.
			  end := from.
			  parts do: [ :each |
				  end = each key ifTrue: [ end := self copyFrom: each key upTo: each value into: buffer at: from ] ].
			  end > from ifTrue: [
				  found add: (ByteArrayAddressSpace
						   on: (end < upTo ifTrue: [ buffer copyFrom: 1 to: end - from ] ifFalse: [ buffer ])
						   at: from) ].
			  end < upTo ifTrue: [
				  mappingLimit := end.
				  ^ pieces := found asArray ] ].
		  pieces := found asArray ]
