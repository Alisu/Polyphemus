running
kindsOfDamageAt: aFramePointer

	"What a word of a stack page can hold after damage, each named."

	^ {
		  ('a tagged word' -> 16r29).
		  ('the address of nothing' -> self nowhere).
		  ('an object of another kind' -> reifiedMemory reifiedActiveProcess address).
		  ('zero' -> 0).
		  ('the frame''s own address' -> aFramePointer).
		  ('an address off the stack pages' -> 16r1000).
		  ('a word with its top bit set' -> 16rFFFFFFFFFFFFFFF9) }
