stopping
end

	"Let it go. Answers whether the stop lasted until now: not ended at its bound, or never held."

	| lasted |
	pipe ifNil: [ ^ false ].
	LibC pipeClose: pipe.
	pipe := nil.
	lasted := self said = 'resumed'.
	state ensureDelete.
	^ lasted
