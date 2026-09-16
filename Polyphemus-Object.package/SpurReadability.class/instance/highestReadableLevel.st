accessing
highestReadableLevel

	^ self levels detect: [ :level | (self canRead: level) not ] ifFound: [ :failed |
		  | index |
		  index := self levels indexOf: failed.
		  index = 1
			  ifTrue: [ nil ]
			  ifFalse: [ self levels at: index - 1 ] ] ifNone: [ self levels last ]
