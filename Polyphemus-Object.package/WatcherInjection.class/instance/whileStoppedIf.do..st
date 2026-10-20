injecting
whileStoppedIf: aCondition do: aBlock

	"Stopped, through a reader of its own (a reader keeps what it read): aBlock's value, in an array,
	if aCondition holds and what writing needs reads whole; else nil. Let go before any error (#96)."

	| held fresh answer |
	held := reader.
	fresh := reader class on: reader pid.
	fresh stop.
	answer := [
	          | dumped readability |
	          (aCondition value: fresh) ifTrue: [
		          dumped := SpurDumpedMemory on: fresh.
		          readability := dumped raw readability.
		          ((readability canRead: #classes) and: [ readability canRead: #specialObjects ]) ifTrue: [
			          reader := fresh.
			          { (aBlock value: dumped) } ] ] ] valueThenLetGo: [
		          reader := held.
		          fresh resume.
		          fresh close ].
	answer ifNil: [ (Delay forMilliseconds: 50) wait ].
	^ answer
