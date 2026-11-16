running
kindsOfDamageAt: aFramePointer

	"What a word of a stack page can hold after damage, each named. A low address off the pages
	is not among them: measured, every question answers to it as to the address of nothing."

	^ {
		  ('a tagged word' -> 16r29).
		  ('the address of nothing' -> self nowhere).
		  ('an object of another kind' -> reifiedMemory reifiedActiveProcess address).
		  ('zero' -> 0).
		  ('the frame''s own address' -> aFramePointer).
		  ('a word with its top bit set' -> 16rFFFFFFFFFFFFFFF9) }
