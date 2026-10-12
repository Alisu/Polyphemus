tests
testItServesOneAnswerPerRequestLine

	"Lines in, lines out: a notification in between is read and left unanswered."

	| in out lines |
	in := ReadStream on: (String lf join: {
				        (STONJSON toString: (self request: 'ping' id: 1 params: Dictionary new)).
				        '{"jsonrpc":"2.0","method":"notifications/initialized"}'.
				        (STONJSON toString: (self request: 'ping' id: 2 params: Dictionary new)) }).
	out := WriteStream on: String new.
	self server serveFrom: in to: out.
	lines := out contents lines.
	self assert: (lines collect: [ :each | (STONJSON fromString: each) at: 'id' ]) asArray equals: #( 1 2 )
