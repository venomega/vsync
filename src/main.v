module main

import os
import math
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

fn main(){
	_, args := parsero()!
	if args.len != 2 {
		logerr("you need to specify source and destination args")
	}
	source := args[0]
	mut destination := args[1]
	// logica del destino
	if os.is_dir(destination){
		destination = destination + "/" + os.base(source)
	}
	mut source_fd := os.open(source) or {
		panic("Error opening ${source}")
	}
	println("Source: " + source + "\nDestination: " + destination)
	mut destination_fd := os.open_append(destination) or {
		panic("Can't open file ${destination} for writing")
	}
	//seeking
	aaa := destination_fd.tell() !
	if aaa > 0{
		source_fd.seek(aaa, os.SeekMode.start ) or {
			panic("Can't seek ${source}")
		}
	}
	source_stats := os.stat(source) !

	if source_stats.size < aaa{
		panic("Seems like you are trying to mirror not same source & destination file, if you are sure remove destination first.")
	}

	//writing
	mut total_length := aaa
	mut last := 0
	for {
		lop := source_fd.tell() !
		if last <= lop {
			last = int(lop)
		}else{
			break
		}
		nn := source_stats.size - source_fd.tell() !
		min, _ := math.minmax(nn, 3333)

		buff := source_fd.read_bytes_at(int(min), u64(total_length))
		n := buff.len
		if n > 0{
			destination_fd.write(buff) or {
				panic("Can't write to ${destination}")
			}
			total_length += n
			//source_fd.seek(total_length, os.SeekMode.start) or {
			//	panic("Can't seek source ${source}")
			//}
		}else{
			break
		}
		print("\b\b\b${total_length * 100 / source_stats.size}%")
	}
	println("Exited")
}

fn logerr(s string) {
	println(s)
	exit (1)
}

fn main2() {
}
