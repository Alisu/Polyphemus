naming
eventWaits

	"The calls a VM waits for its events in, idle: pselect6 on VM 9, epoll_wait from VM 10.3."

	^ #( 'pselect6' 'epoll_wait' 'epoll_pwait' 'epoll_pwait2' 'poll' 'ppoll' 'select' )
