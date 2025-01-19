module main

import os
import math


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
