injecting
whileStoppedIf: aCondition do: aBlock

	"Stopped, through a reader of its own (a reader keeps what it read): aBlock's value in an array if
	aCondition says nothing against it and what writing needs reads whole, else nil (#96)."

	| held fresh answer |
	held := reader.
	fresh := reader class on: reader pid.
	fresh stop.
	answer := [
	          | dumped readability |
	          lastSeen := aCondition value: fresh.
	          lastSeen ifNil: [
		          dumped := SpurDumpedMemory on: fresh.
		          readability := dumped raw readability.
		          lastSeen := #( #classes #specialObjects )
			                      detect: [ :each | (readability canRead: each) not ]
			                      ifFound: [ :each | each , ': ' , (readability whyNot: each) asString ]
			                      ifNone: [ nil ] ].
	          lastSeen
		          ifNil: [
			          reader := fresh.
			          { (aBlock value: dumped) } ]
		          ifNotNil: [ nil ] ] valueThenLetGo: [
		          reader := held.
		          fresh resume.
		          fresh close ].
	answer ifNil: [ (Delay forMilliseconds: 50) wait ].
	^ answer
