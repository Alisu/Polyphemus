tools
nameOfProcess: aProcess

	"Its name instance variable, found by name: its slot moved between Pharo versions."

	^ [
	  | index value |
	  index := aProcess oopClass instanceVariableNames indexOf: 'name'.
	  index = 0
		  ifTrue: [ nil ]
		  ifFalse: [
			  value := aProcess reifiedSlotAt: index.
			  (value respondsTo: #asString) & (value isKindOf: OOPString)
				  ifTrue: [ value asString ]
				  ifFalse: [ nil ] ] ]
		  on: Error
		  do: [ :e | nil ]
