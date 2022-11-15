#========================================== variables =========================================
assetsDir       = ./assets/
sourceDir       = ./source/
binDir          = ./bin/
emuDir          = ../x16emu_mac-r41/
emulator		= x16emu
emuFlags		= -keymap de -scale 2 -debug -sdcard $(assetsDir)sdcard.img -run -prg 
assembler		= 64tass
assemblerFlags 	= --m65c02 --case-sensitive -Wno-label-left --output

sourceFiles		= $(sourceDir)main.asm $(sourceDir)misc.asm $(sourceDir)startup.asm $(sourceDir)zeroPage.asm $(sourceDir)stdio.asm $(sourceDir)console.asm $(sourceDir)kernal.asm $(sourceDir)string.asm $(sourceDir)stdlib.asm $(sourceDir)memory.asm $(sourceDir)vera.asm $(sourceDir)input.asm
#
#==============================================================================================


#============================================ make ============================================
.PHONY: all
all: $(binDir)test.bin

$(binDir)test.bin: $(sourceFiles)
	$(assembler) $(assemblerFlags) $(binDir)test.bin $(sourceDir)main.asm 
#==============================================================================================


#=========================================== testing ==========================================
.PHONY: run
run:
	#$(emuDir)$(emulator) $(binDir)dos/main.exe $(EFLAGS)
	$(emuDir)$(emulator) $(emuFlags) $(binDir)test.bin
#==============================================================================================



#============================================ clean ===========================================
.PHONY: clean
clean:
	rm -Rf $(binDir)*.exe
#==============================================================================================



#============================================== git ===========================================
.PHONY: push
push:
	git add *
	git commit -m "commit"
	git push origin main

.PHONY: pull
pull:
	git pull origin main
#==============================================================================================
