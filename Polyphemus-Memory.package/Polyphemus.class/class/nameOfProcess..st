tools
nameOfProcess: aProcess

	"A reified process's name, or nil: its name instance variable, found by name, as its slot
	moved between Pharo versions."

	^ [
	  | index value |
	  index := aProcess oopClass instanceVariableNames indexOf: 'name'.
	  index = 0
		  ifTrue: [ nil ]
		  ifFalse: [
			  value := aProcess reifiedSlotAt: index.
			  (value isKindOf: OOPString)
				  ifTrue: [ value asString ]
				  ifFalse: [ nil ] ] ]
		  on: Error
		  do: [ :e | nil ]
