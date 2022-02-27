CC = gcc

# remove the -g flag when building for release!
CFLAGS = -fPIC -lpigpio -g

OUTPUT = -o build/librfid.so
DEBUG_OUTPUT = -o build/librfiddebug.so
DEBUG_OUTPUT_PROGRAM = -o build/debug_program

.PHONY: all dummy cli clean

all: 
	@ $(CC) src/pn532.c src/pn532_rpi.c src/rfid_reader.c $(OUTPUT) $(CFLAGS) -I./src/ -shared 

dummy:
	@ $(CC) debug/debug.c $(DEBUG_OUTPUT) -I./src/ -shared 

cli: all
	@ $(CC) debug/debug_program.c $(DEBUG_OUTPUT_PROGRAM) -I./src -L./build -lrfid $(CFLAGS)
	$(info Please run `export LD_LIBRARY_PATH=$$(pwd)/build`)
	$(info Then you can execute the debug program with `build/./debug_program`.)
	$(info Please do this (both commands) as root otherwise you can't access the RFID Reader or the LD_LIBRARY_PATH isn't correctly exported)

clean:
	rm -f build/*