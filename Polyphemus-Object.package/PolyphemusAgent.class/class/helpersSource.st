source
helpersSource

	"What a held image is asked to do, as blocks in the agent's workspace, called by name with
	literal values (HeldProcess>>call:with:) rather than source pasted together (#118)."

	^ 'self at: #keepStill put: [
	((Processor instVarNamed: #quiescentProcessLists) includes: ((self at: #process) instVarNamed: #myList))
		ifTrue: [ (self at: #process) suspend. self at: #suspended put: true ] ].
self at: #letGo put: [
	(self at: #suspended ifAbsent: [ false ]) ifTrue: [
		self removeKey: #suspended.
		(self at: #process) resume ] ].
self at: #frameBelow put: [ :depth |
	| context |
	context := (self at: #session) interruptedContext.
	depth timesRepeat: [ context := context sender ].
	context ].
self at: #methodNamed put: [ :className :selector |
	| class |
	class := Smalltalk globals at: (className substrings: '' '') first asSymbol.
	(className endsWith: '' class'') ifTrue: [ class := class class ].
	class >> selector ].
self at: #step put: [ :selector :depth |
	(self at: #session) perform: selector with: ((self at: #frameBelow) value: depth).
	(self at: #keepStill) value ].
self at: #restart put: [ :className :selector :depth |
	(self at: #session)
		rewindContextToMethod: ((self at: #methodNamed) value: className value: selector)
		fromContext: ((self at: #frameBelow) value: depth) home.
	(self at: #keepStill) value ].
self at: #saveSource put: [ :className :selector :source :preamble :collect |
	| method |
	method := (self at: #methodNamed) value: className value: selector.
	(method respondsTo: #putSource:withPreamble:)
		ifTrue: [
			method putSource: source withPreamble: [ :stream | stream cr; nextPut: $!; nextPutAll: preamble; cr ] ]
		ifFalse: [
			method
				putSource: source
				withFooter: ''''
				protocol: ([ method protocol name asString ] on: Error do: [ :e | ''polyphemus'' ])
				timestamp: DateAndTime now asString
				priorSourcePointer: 0 ].
	collect ifTrue: [ Smalltalk garbageCollect ] ].
self at: #untrap put: [ :start :method |
	(start method ~~ method and: [ start method selector == method selector ]) ifTrue: [
		| caller |
		caller := start sender.
		[ caller notNil and: [ caller method methodClass == (Smalltalk globals at: #ReflectiveMethod ifAbsent: [ nil ]) ] ]
			whileTrue: [ caller := caller sender ].
		(self at: #session) rewindContextToMethod: method fromContext: start.
		start privSender: caller.
		(self at: #session) updateContextTo: start ] ].
self at: #hold put: [ :hash :method |
	| found start |
	found := Process allInstances select: [ :each | each basicIdentityHash = hash ].
	found size = 1 ifFalse: [ self error: found size printString , '' processes have that hash'' ].
	self at: #process put: found first.
	(self at: #keepStill) value.
	start := found first suspendedContext.
	method ifNotNil: [
		start := (start findContextSuchThat: [ :each |
			          each method selector == method selector and: [ each method methodClass == method methodClass ] ])
			         ifNil: [ start ] ].
	self at: #session put: (DebugSession named: ''Polyphemus'' on: found first startedAt: start).
	method ifNotNil: [ (self at: #untrap) value: start value: method ] ].
nil'
