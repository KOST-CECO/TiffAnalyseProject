# This is the default standard .cshrc provided to csh users.
# They are expected to edit it to meet their own needs.

##### Path is loaded with user's home bin(s) #####

#####  with some additional directories.     #####

#####  Install Golang                        #####
set GOROOT = $HOME/go
set path = ( . $GOROOT/bin $path )
set GOHOME = $HOME/Gowork

##### sets the prompt #####


##### some environment variables #####

set history = 100

##### aliases #####

alias h  history
alias help apropos
alias rm "rm -i"
alias ls 'ls -C --color'
 
##### my additions here down #####
