# EDR Tester

## Concept

EDR Tester is used to test an Endpoint Detection and Response (EDR) agent.  An ADL agent listens for activity in an environment.

This EDR Tester generates activity by being called with the appropriate command line arguments.  One can then check the log file of the EDR Tester and see whether that activity was picked up by the EDR

## Usage

### Executing an execuatable file

`
edr_tester [--exec | -x] <file path>
edr_tester [--exec | -x] <file path> -- <arguments>
`

- the given executable file will be executed (with the given arguments, if any)
- the output is not captured
- the following details will be logged:
    - timestamp of start time
    - username that started the process
    - process name
    - process command line
    - process ID
- if the file does not exist, an error message will be logged instead

## TODO

- [x] bin/shell script
- [x] handle command line arguments
- [ ] run on windows/linux (developed and runs on mac)
- [x] start a process
    - [x] cmd line params: exec file w/optional args for exec file
    - [x] path exists?
    - [x] run a process
        - [x] non-blocking
    - [x] log it
    - [ ] test logging
    - [x] update readme
- [ ] create a file
    - [x] cmd line params: file path, file type
    - [ ] [QUESTION] what types? bin, text, what?
    - [x] create file at location
        - [x] text file
        - [x] bin file
    - [ ] path exists?
    - [x] populate with random/preset stuff
    - [x] log it
    - [ ] [QUESTION] the file-ops logging also requires the process command line, so now I'm thinking that what I logged for the "start a process" step is wrong
    - [ ] test logging
    - [ ] update readme
- [ ] modify a file
    - [ ] cmd line params: file path, file type
    - [ ] find file at location
    - [ ] exists?
    - [ ] bin? add some crap to the end
    - [ ] text? add some crap to the end
    - [ ] log it
    - [ ] test logging
    - [ ] update readme
- [ ] delete a file
    - [ ] cmd line params: file path
    - [ ] find file at location
    - [ ] exists?
    - [ ] delete it
    - [ ] success?
    - [ ] log it
    - [ ] test logging
    - [ ] update readme
- [ ] network connection and transmit
    - [ ] cmd line params: url, maybe data
    - [ ] connects?
    - [ ] response?
    - [ ] log it
    - [ ] test logging
    - [ ] update readme
