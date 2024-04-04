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

## Next steps

Looking at it now, there are still some things that I would like to do.
Some of these are listed in the To-Do list at the bottom of the README.

There are some refactorings that I would like to do.
Like how better to structure the code in `./lib/parse_options.rb` and `./lib/edr_tester_ops.rb`.
When I started developing, I just dug in with some considerations towards design and error-handling.

Now that a lot of it is done, I would:
- take a look at these files, and see whether moving the code into classes would help with readability and extensibility
- add testing for the various logs that are being generated
    - most likely move the logging into a dedicated object to abstract away the logger's setup, andto clean up the code in `./bin/edr_tester.rb`
- propagate some errors to the logs
- additional error-handling
- resolving the items still undone in the TODO section
