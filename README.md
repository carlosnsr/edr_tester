# EDR Tester

## Concept

EDR Tester is used to test an Endpoint Detection and Response (EDR) agent.
An EDR agent listens for activity in an environment.

This EDR Tester generates activity by being called with the appropriate command line arguments.
Each time the EDR Tester is called, it will perform one activity and log it.
One can then check the log file of the EDR Tester and the corresponding EDR agent's logs, and see whether that activity was picked up by the EDR agent.

## Installation

### Mac

- Requires `ruby 3.2.3`.
- To install, run `bundle install`.
- To execute, run `./edr_tester`.

### Windows

- Requires [ruby 3.2.3](https://rubyinstaller.org/downloads)
- Open "Start Command Prompt with Ruby"
- Clone this repo and `cd` into the directory
- To install, run `bundle install`.
- To execute, run `.\edr_tester.bat`.

## Testing

To run the provided tests, execute `rspec`

## Usage

Use the provided commands to execute one action at a time.
Results will be logged to `edr_tester.log` in JSON.

### Help

`edr_tester --help` provides a usage statement for the activities supported by the program.

### Executing an executable file

```
edr_tester [--exec | -x] [--file, -f] <file path>
edr_tester [--exec | -x] [--file, -f] <file path> -- <arguments>
```

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

`edr_tester [--create | -c] [--file, -f] <file path> [--bin | --text]`

- creates a binary/text file at the given location
- the following details will be logged:
    - timestamp
    - username
    - process name
    - process command line
    - process ID
    - activity descriptor (i.e. 'Create File')
    - file path

### Deleting a file

`edr_tester [--delete | -d] [--file, -f] <file path>`

- deletes the file at the given location
- the following details will be logged:
    - timestamp
    - username
    - process name
    - process command line
    - process ID
    - activity descriptor (i.e. 'Delete File')
    - file path

### Modifying a file

`edr_tester [--modify | -m] [--file, -f] <file path>`

- modify the file at the given location
- detects if the file is binary or text and appends some cruft
- the following details will be logged:
    - timestamp
    - username
    - process name
    - process command line
    - process ID
    - activity descriptor (i.e. 'Delete File')
    - file path

### Transmitting Data

`edr_tester [--transmit | -t] [--dest] <address> [--port] <port> [--data] <data>`

- connects to the given address and port using TCP and transmits data across it
- the following details will be logged:
    - timestamp
    - username
    - process name
    - process command line
    - process ID
    - destination address
    - destination port
    - source address
    - source port
    - amount of data sent
    - protocol

## TODO

- [x] bin/shell script
- [x] handle command line arguments
- [x] run on mac
- [ ] run on windows/linux
- [x] log entire process command line
- [ ] command line parameters
    - [ ] handle multiple operations
    - [ ] handle no operation parameter
- [x] one page description
- [ ] remove todos from README
- [ ] refactor
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
    - [x] cmd line params: file path, file type
    - [x] find file at location
    - [x] exists?
    - [ ] write-able?
    - [x] bin? add some crap to the end
    - [x] text? add some crap to the end
    - [x] log it
    - [ ] test logging
    - [x] update readme
- [x] delete a file
    - [x] cmd line params: file path
    - [x] find file at location
    - [x] exists?
    - [x] delete it
    - [ ] success?
    - [x] log it
    - [ ] test logging
    - [x] update readme
- [x] network connection and transmit
    - [x] cmd line params: dest, port, data
    - [x] connects?
    - [ ] response?
    - [x] log it
    - [ ] test logging
    - [x] update readme
