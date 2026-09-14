"Sync the touched classes, drop the moved selector, reset the cached fixtures,
 then run the stack page suite twice: a second run proves the resource rebuilds."
| root syncSide syncClass runSuite |
root := '/home/observant/polyphemus/Polyphemus/'.

syncSide := [ :target :path |
	| dir n |
	dir := path asFileReference.
	n := 0.
	dir exists ifTrue: [
		dir files do: [ :f |
			(f basename endsWith: '.st') ifTrue: [
				[ | lines category source |
				  lines := f contents lines.
				  category := lines first.
				  source := String streamContents: [ :s |
					  lines allButFirst do: [ :l | s nextPutAll: l; cr ] ].
				  target compile: source classified: category.
				  n := n + 1 ]
					on: Error
					do: [ :e | ('COMPILE ERR ', f basename, ' :: ', e messageText asString) traceCr ] ] ] ].
	n ].

syncClass := [ :cls :packagePath |
	| i c |
	i := syncSide value: cls value: root , packagePath , '/instance'.
	c := syncSide value: cls class value: root , packagePath , '/class'.
	(cls name, ': ', i printString, '+', c printString) traceCr ].

AbstractPharoImageResource class instanceVariableNames: 'numberOfSteps'.
(ImageInterpretedSetup includesSelector: #defaultTimeLimit) ifTrue: [ ImageInterpretedSetup removeSelector: #defaultTimeLimit ].
syncClass value: FullyReifiedMemory value: 'Polyphemus-Object.package/FullyReifiedMemory.class'.
syncClass value: AbstractPharoImageResource value: 'Polyphemus-Tests.package/AbstractPharoImageResource.class'.
syncClass value: AbstractInspectorsTest value: 'Polyphemus-Tests.package/AbstractInspectorsTest.class'.
syncClass value: ImageInterpretedSetup value: 'Polyphemus-Tests.package/ImageInterpretedSetup.class'.
syncClass value: StackPageReificationTest value: 'Polyphemus-Tests.package/StackPageReificationTest.class'.

(StackPageReificationTest includesSelector: #testEveryLivePageIsReifiedFromItsHeadFramePointer)
	ifTrue: [ StackPageReificationTest removeSelector: #testEveryLivePageIsReifiedFromItsHeadFramePointer ].
(ImageInterpretedSetup includesSelector: #interpretUntilMethodChangedNumberOfTimes:)
	ifTrue: [ ImageInterpretedSetup removeSelector: #interpretUntilMethodChangedNumberOfTimes:.
		'moved interpretUntilMethodChangedNumberOfTimes: up to AbstractInspectorsTest' traceCr ].

ImageInterpretedSetup withAllSubclasses do: [ :c | c instVarNamed: 'currentImage' put: nil ].

runSuite := [ :label |
	[ | r |
	  r := StackPageReificationTest buildSuite run.
	  ('RES ', label, ' ', r runCount printString, ' run ', r failureCount printString,
		' failures ', r errorCount printString, ' errors') traceCr.
	  r failures do: [ :t | ('  FAIL  ', t selector) traceCr ].
	  r errors   do: [ :t | ('  ERROR ', t selector) traceCr ] ]
	  on: Error do: [ :e | ('RUN ERR ', e class name, ' ', e messageText asString) traceCr ] ].

runSuite value: 'first'.
runSuite value: 'second'.

Smalltalk snapshot: true andQuit: true
