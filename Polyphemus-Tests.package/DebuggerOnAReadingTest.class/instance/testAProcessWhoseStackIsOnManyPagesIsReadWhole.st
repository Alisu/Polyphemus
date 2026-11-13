tests
testAProcessWhoseStackIsOnManyPagesIsReadWhole

	"#183: a stack that outgrew its page goes on below a context married to the page before's head
	frame; the walk stopped there, the newest page and one context shown. Every page is read."

	| pid reading deep activations browser |
	pid := self launchTargetDefining: 'Deep' thenRunning: 'cls compile: ''down: n
	n = 0 ifTrue: [ Semaphore new wait ].
	^ (self down: n - 1) + 1''.
[ cls new down: 300 ] forkAt: Processor userSchedulingPriority + 1 named: ''deep''.
'.
	[
	reading := Polyphemus readProcess: pid.
	deep := Polyphemus processNamed: 'deep' in: reading.
	activations := reading activationsOfProcess: deep.
	self assert: (activations count: [ :each | each selector = #down: ]) equals: 301.
	"The process browser shows that stack too, not its contexts alone."
	browser := SnapshotProcessBrowser on: reading.
	browser selectProcess: deep.
	self assert: (browser instVarNamed: #frameList) items size equals: activations size.
	self assert: ((browser labelForProcess: deep) includesSubstring: '(' , activations size printString , ' frames)') ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]