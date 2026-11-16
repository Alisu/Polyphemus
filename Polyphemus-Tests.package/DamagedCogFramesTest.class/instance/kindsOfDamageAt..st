running
kindsOfDamageAt: aFramePointer

	"What a word of a stack page can hold after damage, each named. A low address is not among
	them: measured, every question answers to it as to the address of nothing."

	| raw |
	raw := memory vmLayout raw.
	^ {
		  ('a tagged word' -> 16r29).
		  ('the address of nothing' -> 16rFFE9797400).
		  ('an object of another kind' -> process address).
		  ('the middle of an object' -> (process address + 8)).
		  ('zero' -> 0).
		  ('the frame''s own address' -> aFramePointer).
		  ('an address below the frame' -> (aFramePointer - 64)).
		  ('an address in the code zone' -> (raw codeZone == false ifTrue: [ 16r2000 ] ifFalse: [ raw codeZone key + 64 ])).
		  ('a word with its top bit set' -> 16rFFFFFFFFFFFFFFF9) }
