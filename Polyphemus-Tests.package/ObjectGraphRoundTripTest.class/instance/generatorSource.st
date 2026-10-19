helpers
generatorSource

	"A block from a seed to a graph: integers, characters, strings and wide strings, symbols,
	8, 16 and 32-bit arrays, nil, true, false, arrays nesting them, objects met before, arrays
	holding themselves, and arrays too large for a header's slot count (over 254)."

	^ '[ :seed | | state next pool make |
state := seed.
next := [ :n | state := (state * 1103515245 + 12345) \\ 2147483648. state \\ n ].
pool := OrderedCollection new.
make := nil.
make := [ :depth | | kind made |
	kind := depth > 3 ifTrue: [ next value: 6 ] ifFalse: [ next value: 10 ].
	made := kind = 0 ifTrue: [ (next value: 2000000) - 1000000 ] ifFalse: [
	kind = 1 ifTrue: [ Character value: 32 + (next value: 90) ] ifFalse: [
	kind = 2 ifTrue: [ (String new: (next value: 20)) collect: [ :each | Character value: 97 + (next value: 26) ] ] ifFalse: [
	kind = 3 ifTrue: [ (''s'' , (next value: 50) printString) asSymbol ] ifFalse: [
	kind = 4 ifTrue: [ (ByteArray new: (next value: 30)) collect: [ :each | next value: 256 ] ] ifFalse: [
	kind = 5 ifTrue: [ #( nil true false ) at: 1 + (next value: 3) ] ifFalse: [
	kind = 6 ifTrue: [ | array | array := (1 to: (next value: 7)) collect: [ :each | make value: depth + 1 ].
		(array notEmpty and: [ (next value: 5) = 0 ]) ifTrue: [ array at: 1 put: array ].
		array ] ifFalse: [
	kind = 7 ifTrue: [ pool isEmpty ifTrue: [ Array new: 0 ] ifFalse: [ pool at: 1 + (next value: pool size) ] ] ifFalse: [
	kind = 8 ifTrue: [ (1 to: 255 + (next value: 50)) collect: [ :each | next value: 1000 ] ] ifFalse: [
	| sub | sub := next value: 3.
	sub = 0 ifTrue: [ (WordArray new: (next value: 10)) collect: [ :each | next value: 2147483648 ] ] ifFalse: [
	sub = 1 ifTrue: [ (DoubleByteArray new: (next value: 10)) collect: [ :each | next value: 65536 ] ] ifFalse: [
	(WideString new: 1 + (next value: 10)) collect: [ :each | Character value: 256 + (next value: 1000) ] ] ] ] ] ] ] ] ] ] ] ].
	(made isNumber or: [ made isCharacter or: [ made isNil or: [ made == true or: [ made == false ] ] ] ])
		ifFalse: [ pool add: made ].
	made ].
(1 to: 6) collect: [ :each | make value: 0 ] ]'
