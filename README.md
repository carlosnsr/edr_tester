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

## TODO

- [x] bin/shell script
- [x] handle command line arguments
- [ ] run on windows/linux (developed and runs on mac)
- [ ] start a process
    - [x] cmd line params: exec file w/optional args for exec file
    - [ ] path exists?
    - [x] run a process
        - [ ] non-blocking
        - [ ] time out if process runs too long
    - [ ] log it
    - [ ] update readme
- [ ] create a file
    - [ ] cmd line params: file path, file type
    - [ ] [QUESTION] what types? bin, text, what?
    - [ ] create file at location
    - [ ] path exists?
    - [ ] populate with random/preset stuff
    - [ ] log it
    - [ ] update readme
- [ ] modify a file
    - [ ] cmd line params: file path, file type
    - [ ] find file at location
    - [ ] exists?
    - [ ] bin? add some crap to the end
    - [ ] text? add some crap to the end
    - [ ] log it
    - [ ] update readme
- [ ] delete a file
    - [ ] cmd line params: file path
    - [ ] find file at location
    - [ ] exists?
    - [ ] delete it
    - [ ] success?
    - [ ] log it
    - [ ] update readme
- [ ] network connection and transmit
    - [ ] cmd line params: url, maybe data
    - [ ] connects?
    - [ ] response?
    - [ ] log it
    - [ ] update readme
