refusals
refusals

	"What a held image is not asked to do, by key: the name docs/limitations.md gives it, and what the
	user is told. One place, kept in step with that page by NotOnAReadingTest (#118)."

	^ Dictionary new
		  at: #breakOnStack put: 'Break on stack'
			  -> 'Breakpoints in a method read from another image are not supported yet: to stop it at a method, use runUntil:';
		  at: #frameVariable put: 'changing a frame''s variable'
			  -> 'Changing a variable of a frame read from another image is not supported yet';
		  at: #restart put: 'Restart' -> 'Restart is not supported on a held image yet';
		  at: #returnValue put: 'Return entered value' -> 'Return entered value is not supported on a held image yet';
		  at: #peel put: 'Peel to first like this' -> 'Peel to first like this is not supported on a held image yet';
		  yourself
