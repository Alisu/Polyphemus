writing
restoreNewSpace

	"Where the dumped VM's new space was, and how much of eden it had used (#8). Its
	survivors are where the spaces say, the VM having been between collections."

	| memory variables scavenger future |
	memory := dumped memory.
	variables := dumped raw vmVariables.
	scavenger := memory scavenger.
	#( #eden #pastSpace #futureSpace ) do: [ :name |
		| bounds |
		bounds := variables boundsOf: name.
		(scavenger perform: name) start: bounds key; limit: bounds value ].
	future := variables boundsOf: 'futureSpace'.
	scavenger
		instVarNamed: #futureSurvivorStart put: future key;
		instVarNamed: #previousRememberedSetSize put: 0.
	memory
		instVarNamed: #freeStart put: (variables at: 'freeStart');
		instVarNamed: #pastSpaceStart put: (variables at: 'pastSpaceStart');
		instVarNamed: #scavengeThreshold put: (variables at: 'scavengeThreshold')
