building the memory
takeNewSpaceFromTheDumpIn: aMemory

	"Eden and the survivors where the dumped VM had them, filled as far as it had filled them
	(#8, #68); left empty when the dump does not say, rather than invented."

	| variables scavenger |
	raw liveYoungRanges ifNil: [ ^ self ].
	variables := raw vmVariables.
	scavenger := aMemory scavenger.
	{ 'eden' -> variables edenBounds.
	  'pastSpace' -> (variables boundsOf: 'pastSpace').
	  'futureSpace' -> (variables boundsOf: 'futureSpace') } do: [ :each |
		(scavenger perform: each key asSymbol) start: each value key; limit: each value value ].
	scavenger instVarNamed: #futureSurvivorStart put: (variables boundsOf: 'futureSpace') key.
	"No setters for these (setWhatVMMakerHasNoSetterFor:freeLists:)."
	aMemory
		instVarNamed: #freeStart put: (variables at: 'freeStart');
		instVarNamed: #pastSpaceStart put: (variables at: 'pastSpaceStart');
		instVarNamed: #scavengeThreshold put: (variables at: 'scavengeThreshold')
