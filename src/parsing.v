import prantlf.cargs { parse, Input }

// Declare a structure with all command-line options.
struct Opts {
  output string
  indent int
  pretty bool
}

// Describe usage of the command-line tool.
fn parsero() ! (&Opts, []string) {

usage := 'Converts YAML input to JSON output.

Usage: yaml2json [options] [<yaml-file>]

  <yaml-file>         read the YAML input from a file

Options:
  -o|--output <file>   write the JSON output to a file
  -i|--indent <count>  write the JSON output to a file
  -p|--pretty          print the JSON output with line breaks and indented
  -V|--version         print the version of the executable and exit
  -h|--help            print the usage information and exit

If no input file is specified, it will be read from standard input.

Examples:
  $ yaml2json config.yaml -o config.json -p
  $ cat config.yaml | yaml2json > config.json'


// Parse command-line options and arguments.
opts, args := parse[Opts](usage, Input{ version: '0.0.1' })!
//return opts, args
return opts, args
}
