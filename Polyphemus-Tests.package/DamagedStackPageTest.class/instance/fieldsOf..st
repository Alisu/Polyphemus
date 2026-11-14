running
fieldsOf: aFramePointer

	"The words of a frame as the simulator lays it out, each named, with its address."

	| word |
	word := reifiedMemory wordSize.
	^ {
		  ('saved frame pointer' -> aFramePointer).
		  ('caller''s saved ip' -> (aFramePointer + word)).
		  ('method' -> (aFramePointer - word)).
		  ('context' -> (aFramePointer - (2 * word))).
		  ('flags' -> (aFramePointer - (3 * word))).
		  ('receiver' -> (aFramePointer - (4 * word))).
		  ('first temporary' -> (aFramePointer - (5 * word))) }
