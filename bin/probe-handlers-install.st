"Counts, for every `on: Error do:` in Polyphemus code outside its tests, which errors reach it (#118),
 and through which of Polyphemus's own methods, nearest the signal first.
 Context>>handleSignal: keeps its own body under another name, whatever this Pharo's is."
| compiling |
(Context includesSelector: #polyOriginalHandleSignal:) ifFalse: [
	Smalltalk at: #PolyProbeSeen put: Bag new.
	Smalltalk at: #PolyProbeHomes put: IdentityDictionary new.
	Smalltalk at: #PolyProbeBusy put: false.
	compiling := [
		Context compile: 'polyLabelOf: aMethod
	^ (Smalltalk at: #PolyProbeHomes) at: aMethod ifAbsentPut: [
		[ | p | p := aMethod package name.
		((p beginsWith: ''Polyphemus'') and: [ (p includesSubstring: ''Tests'') not ])
			ifTrue: [ aMethod methodClass name , ''>>'' , aMethod selector ]
			ifFalse: [ #no ] ] on: Error do: [ :e | #no ] ]'.
		Context compile: 'polyNote: anException
	| home label where key |
	(Smalltalk at: #PolyProbeBusy) ifTrue: [ ^ self ].
	Smalltalk at: #PolyProbeBusy put: true.
	[ [ home := self sender compiledCode method.
	label := self polyLabelOf: home.
	label == #no ifFalse: [
		where := [ | m near walked |
			m := anException signalerContext compiledCode method.
			near := OrderedCollection new.
			walked := anException signalerContext.
			[ walked notNil and: [ walked ~~ self and: [ near size < 3 ] ] ] whileTrue: [
				| name |
				name := self polyLabelOf: walked compiledCode method.
				(name == #no or: [ near notEmpty and: [ near last = name ] ]) ifFalse: [ near add: name ].
				walked := walked sender ].
			m methodClass name , ''>>'' , m selector
				, (near isEmpty ifTrue: [ '''' ] ifFalse: [ '' via '' , ('' < '' join: near) ]) ] on: Error do: [ :e | ''?'' ].
		key := label , '' | '' , anException class name , '' | ''
			, (anException class == MessageNotUnderstood
				ifTrue: [ ''#'' , anException message selector , '' to '' , anException receiver class name ]
				ifFalse: [ ((anException messageText ifNil: [ ''-'' ]) asString truncateTo: 70) ])
			, '' | '' , where.
		(Smalltalk at: #PolyProbeSeen) add: ((key copyReplaceAll: String cr with: '' '') copyReplaceAll: String lf with: '' '') ] ] on: Error do: [ :e | nil ] ]
		ensure: [ Smalltalk at: #PolyProbeBusy put: false ]'.
		Context compile: 'polyOriginalHandleSignal:' , ((Context >> #handleSignal:) sourceCode allButFirst: 'handleSignal:' size).
		Context compile: 'handleSignal: exception
	(self exceptionClass == Error and: [ Error handles: exception ]) ifTrue: [ self polyNote: exception ].
	^ self polyOriginalHandleSignal: exception' ].
	(Smalltalk globals includesKey: #Author)
		ifTrue: [ (Smalltalk globals at: #Author) useAuthor: 'probe' during: compiling ]
		ifFalse: [ compiling value ] ]
