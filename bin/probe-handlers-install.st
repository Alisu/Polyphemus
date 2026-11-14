"Counts, for every `on: Error do:` in Polyphemus code outside its tests, which errors reach it (#118).
 Context>>handleSignal: keeps its own body under another name, whatever this Pharo's is."
| compiling |
(Context includesSelector: #polyOriginalHandleSignal:) ifFalse: [
	Smalltalk at: #PolyProbeSeen put: Bag new.
	Smalltalk at: #PolyProbeHomes put: IdentityDictionary new.
	Smalltalk at: #PolyProbeBusy put: false.
	compiling := [
		Context compile: 'polyNote: anException
	| home label where key |
	(Smalltalk at: #PolyProbeBusy) ifTrue: [ ^ self ].
	Smalltalk at: #PolyProbeBusy put: true.
	[ [ home := self sender compiledCode method.
	label := (Smalltalk at: #PolyProbeHomes) at: home ifAbsentPut: [
		[ | p | p := home package name.
		((p beginsWith: ''Polyphemus'') and: [ (p includesSubstring: ''Tests'') not ])
			ifTrue: [ home methodClass name , ''>>'' , home selector ]
			ifFalse: [ #no ] ] on: Error do: [ :e | #no ] ].
	label == #no ifFalse: [
		where := [ | m | m := anException signalerContext compiledCode method. m methodClass name , ''>>'' , m selector ] on: Error do: [ :e | ''?'' ].
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
