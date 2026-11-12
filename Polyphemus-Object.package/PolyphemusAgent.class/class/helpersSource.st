source
helpersSource

	"What a held image is asked to do, as blocks in the agent's workspace, called by name with
	literal values (HeldProcess>>call:with:) (#118). The held process is unregistered once the image
	runs again, not inside the table's lock (#162); Stop leaves the idle process be (#170)."

	^ 'self at: #keepStill put: [
	((Processor instVarNamed: #quiescentProcessLists) includes: ((self at: #process) instVarNamed: #myList))
		ifTrue: [ (self at: #process) suspend. self at: #suspended put: true ] ].
self at: #letGo put: [
	| process |
	process := self at: #process.
	(self at: #suspended ifAbsent: [ false ]) ifTrue: [
		self removeKey: #suspended.
		process resume ].
	[ Smalltalk unregisterExternalObject: process ] forkAt: Processor userBackgroundPriority ].
self at: #stop put: [
	| process |
	process := self at: #process.
	process == (ProcessorScheduler classPool at: #BackgroundProcess)
		ifTrue: [ (self at: #letGo) value ]
		ifFalse: [
			self removeKey: #suspended ifAbsent: [ nil ].
			(self at: #session) terminate.
			[ Smalltalk unregisterExternalObject: process ] forkAt: Processor userBackgroundPriority ] ].
self at: #frameBelow put: [ :depth |
	| context |
	context := (self at: #session) interruptedContext.
	depth timesRepeat: [ context := context sender ].
	context ].
self at: #evaluate put: [ :source :depth |
	| context result printed |
	context := (self at: #frameBelow) value: depth.
	result := Smalltalk compiler receiver: context receiver; context: context; evaluate: source.
	self at: #evaluated put: result.
	printed := [ result printString ] on: Error do: [ :error | ''a '' , result class name , '' that does not print: '' , error messageText asString ].
	String streamContents: [ :stream |
		stream print: result class basicIdentityHash; lf.
		(result isKindOf: SmallInteger) ifTrue: [ stream nextPutAll: ''integer ''; print: result ].
		(result isKindOf: Character) ifTrue: [ stream nextPutAll: ''character ''; print: result asInteger ].
		result isImmediateObject ifFalse: [ stream print: result basicIdentityHash ].
		stream lf; nextPutAll: printed ] ].
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
self at: #compile put: [ :className :selector :source |
	| method protocol |
	method := (self at: #methodNamed) value: className value: selector.
	protocol := [ method protocol isString ifTrue: [ method protocol ] ifFalse: [ method protocol name ] ]
		on: Error do: [ :e | nil ].
	protocol
		ifNil: [ method methodClass compile: source ]
		ifNotNil: [ method methodClass compile: source classified: protocol ] ].
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
	self at: #processSlot put: (Smalltalk registerExternalObject: found first).
	(self at: #keepStill) value.
	start := found first suspendedContext.
	method ifNotNil: [
		start := (start findContextSuchThat: [ :each |
			          each method selector == method selector and: [ each method methodClass == method methodClass ] ])
			         ifNil: [ start ] ].
	self at: #session put: (DebugSession named: ''Polyphemus'' on: found first startedAt: start).
	method ifNotNil: [ (self at: #untrap) value: start value: method ] ].
nil'
