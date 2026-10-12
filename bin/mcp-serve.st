"Serve MCP on standard input and output (bin/polyphemus-mcp.sh). Standard output is kept for the
protocol: traces, VMMaker's included (Spur Image Format detected), go to standard error."
| protocol |
protocol := ZnCharacterWriteStream on: Stdio stdout encoding: 'utf8'.
NonInteractiveTranscript stderr install.
[ PolyphemusMCPServer new
	serveFrom: (ZnCharacterReadStream on: Stdio stdin encoding: 'utf8')
	to: protocol ]
	on: Error
	do: [ :e | Stdio stderr nextPutAll: 'polyphemus-mcp: ' , e class name , ' ' , e messageText asString; lf; flush ].
Smalltalk exitSuccess
