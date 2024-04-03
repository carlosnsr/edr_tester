# EDR Tester

## Concept

EDR Tester is used to test an Endpoint Detection and Response (EDR) agent.  An ADL agent listens for activity in an environment.

This EDR Tester generates activity by being called with the appropriate command line arguments.  One can then check the log file of the EDR Tester and see whether that activity was picked up by the EDR

## TODO

- [x] bin/shell script
- [x] handle command line arguments
- [ ] run on windows/linux (developed on mac)
- [ ] start a process
    - [x] cmd line params: exec file w/optional args for exec file
    - [ ] run a process
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
