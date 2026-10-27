stepping
letGo

	"End the agent: the image goes on, and the held process with it, back in its run queue if the
	hold had taken it out (#103). The agent ends though putting the process back failed."

	| gone |
	[ self call: #letGo with: #(  ) ] ensure: [ gone := channel letGo ].
	gone ifFalse: [ ^ self error: 'the image''s agent never served: the image may still be held' ]
