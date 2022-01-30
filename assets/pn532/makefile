CC = gcc

# remove the -g flag when building for release!
CFLAGS = -lpigpio -g

OUTPUT = -o build/librfid.so
DEBUG_OUTPUT = -o build/librfiddebug.so
DEBUG_OUTPUT_PROGRAM = -o build/debug_program

.PHONY: all dummy cli clean

all: 
	@ $(CC) src/pn532.c src/pn532_rpi.c src/rfid_reader.c $(OUTPUT) $(CFLAGS) -I./src/ -shared 

dummy:
	@ $(CC) debug/debug.c $(DEBUG_OUTPUT) $(CFLAGS) -I./src/ -shared 

cli: all
	@ $(CC) debug/debug_program.c $(DEBUG_OUTPUT_PROGRAM) -I./src -L./build -lrfid $(CFLAGS)
	@ export LD_LIBRARY_PATH=$(pwd)/build
	$(info You can now execute the debug program with `build/./debug_program`.)
	$(info Please do this as root otherwise `LD_LIBRARY_PATH` will be empty.)

clean:
	rm -f build/*