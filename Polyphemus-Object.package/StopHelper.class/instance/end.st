stopping
end

	"Let it go, told with a signal: a child of ours may keep the pipe open (macOS). Answers whether
	the stop lasted until now: not ended at its bound, or never held."

	| lasted |
	pipe ifNil: [ ^ false ].
	self helperPid ifNotNil: [ :helper | LibC system: 'kill -TERM ' , helper printString ].
	LibC pipeClose: pipe.
	pipe := nil.
	lasted := self said = 'resumed'.
	state ensureDelete.
	^ lasted
