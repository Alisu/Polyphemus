accessing
buildId

	^ buildId ifNil: [
		  self sectionsDo: [ :type :offset :size :link |
			  type = 7 ifTrue: [
				  (ElfNote buildIdIn: (self bytes copyFrom: offset + 1 to: offset + size))
					  ifNotNil: [ :id | ^ buildId := id ] ] ].
		  nil ]
