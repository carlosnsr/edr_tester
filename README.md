# EDR Tester

## Concept

EDR Tester is used to test an Endpoint Detection and Response (EDR) agent.  An ADL agent listens for activity in an environment.

This EDR Tester generates activity by being called with the appropriate command line arguments.  One can then check the log file of the EDR Tester and see whether that activity was picked up by the EDR

## Usage

### Executing an executable file

`
edr_tester [--exec | -x] <file path>
edr_tester [--exec | -x] <file path> -- <arguments>
`

- the given executable file will be executed (with the given arguments, if any)
- the output is not captured
- the following details will be logged:
    - timestamp
    - username
    - process name
    - process command line
    - process ID
- if the file does not exist, an error message will be logged instead

### Creating a file

`edr_tester [--create | -c] <file path> [--bin | --text]`

- creates a binary/text file at the given location
- the following details will be logged:
    - timestamp
    - username
    - process name
    - process command line
    - process ID
    - activity descriptor (i.e. 'Create File')
    - file path

## TODO

- [x] bin/shell script
- [x] handle command line arguments
- [ ] run on windows/linux (developed and runs on mac)
- [ ] log entire process command line
- [x] start a process
    - [x] cmd line params: exec file w/optional args for exec file
    - [x] path exists?
    - [ ] is executable?
    - [x] run a process
        - [x] non-blocking
    - [x] log it
    - [ ] test logging
    - [x] update readme
- [x] create a file
    - [x] cmd line params: file path, file type
    - [ ] [QUESTION] what types? bin, text, what?
    - [x] create file at location
        - [x] text file
        - [x] bin file
    - [x] path exists?
    - [x] populate with random/preset stuff
    - [x] log it
    - [ ] [QUESTION] the file-ops logging also requires the process command line, so now I'm thinking that what I logged for the "start a process" step is wrong
    - [ ] test logging
    - [x] update readme
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
    - [x] cmd line params: file path
    - [x] find file at location
    - [ ] exists?
    - [x] delete it
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
