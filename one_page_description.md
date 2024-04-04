# EDR Tester

## Concept

EDR Tester is used to test an Endpoint Detection and Response (EDR) agent.
An EDR agent listens for activity in an environment.

This EDR Tester generates activity by being called with the appropriate command line arguments.
Each time the EDR Tester is called, it will perform one activity and log it.
One can then check the log file of the EDR Tester and the corresponding EDR agent's logs, and see whether that activity was picked up by the EDR agent.

## Usage

To start off, execute `./edr_tester --help`.
If this doesn't work, then use `ruby ./bin/edr_tester.rb --help` instead.

This will print a usage statement with all the possible commands supported by `edr_tester`.
There is also a provided README.md.

Run `edr_tester` with the required command line parameters to perform an action.
The program will perform a single action per invocation.
Results will be logged to `edr_tester.log` in JSON.

## Platforms

This program has been tested on Mac.
I am about to test it on Windows.
It has not been tested on Linux.
