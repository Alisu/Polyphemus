looking
stoppedIf: aCondition do: aBlock

	"Stopped through a reader of its own (a reader keeps what it read): { aBlock's value } if aCondition
	says nothing against it and what writing needs reads whole, else why not, as a string."

	| fresh answer |
	fresh := reader class on: reader pid.
	fresh stopBound: reader stopBound.
	fresh stop ifFalse: [
		fresh close.
		^ 'it would not stop' ].
	answer := [
	          | why dumped readability |
	          why := aCondition value: fresh.
	          why ifNil: [
		          dumped := SpurDumpedMemory on: fresh.
		          readability := dumped raw readability.
		          why := #( #classes #specialObjects )
			                 detect: [ :each | (readability canRead: each) not ]
			                 ifFound: [ :each | each , ': ' , (readability whyNot: each) asString ]
			                 ifNone: [ nil ] ].
	          why ifNil: [ { (aBlock cull: dumped cull: fresh) } ] ifNotNil: [ why ] ] valueThenLetGo: [
		          fresh resume.
		          fresh close ].
	fresh lastStopLasted ifFalse: [ ^ reader ranWhileRead ].
	answer isArray ifFalse: [ (Delay forMilliseconds: 50) wait ].
	^ answer
