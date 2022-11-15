;$00 to $20 are reserved for kernal

r0 = $02
r0l = r0
r0h = r0l + 1

r1 = r0 +2
r1l = r1
r1h = r1l + 1

r2 = r1 +2
r2l = r2
r2h = r2l + 1

r3 = r2 +2
r3l = r3
r3h = r3l + 1

r4 = r3 +2
r4l = r4
r4h = r4l + 1

r5 = r4 +2
r5l = r5
r5h = r5l + 1

r6 = r5 +2
r6l = r6
r6h = r6l + 1

r7 = r6 +2
r7l = r7
r7h = r7l + 1

r8 = r7 + 2
r8l = r8
r8h = r8l + 1

r9 = r8 +2
r9l = r9
r9h = r9l + 1

r10 = r9 +2
r10l = r10
r10h = r10l + 1

r11 = r10 +2
r11l = r11
r11h = r11l + 1

r12 = r11 +2
r12l = r12
r12h = r12l + 1

r13 = r12 +2
r13l = r13
r13h = r13l + 1

r14 = r14l = r13 +2
r14l = r14
r14h = r14l + 1

r15 = r15l = r14 +2
r15l = r15
r15h = r15l + 1


;====================== Kernal API ============================
;----Channel I/O:
SETMSG 						= $FF90	;set verbosity
READST 						= $FFB7	;return status byte
SETLFS 						= $FFBA	;set LA, FA and SA
SETNAM 						= $FFBD	;set filename
OPEN						= $FFC0	;open a channel
CLOSE 						= $FFC3	;close a channel
CHKIN 						= $FFC6 ;set channel for character input
CHKOUT 						= $FFC9 ;set channel for character output
CLRCHN 						= $FFCC ;restore character I/O to screen/keyboard
BASIN 						= $FFCF ;get character
BSOUT 						= $FFD2 ;write character
LOAD 						= $FFD5 ;load a file into memory
SAVE 						= $FFD8 ;save a file from memory
CLALL 						= $FFE7 ;close all channels

;----Commodore Peripheral Bus:
TALK						= $FFB4 ;send TALK command
LISTEN						= $FFB1 ;send LISTEN command
UNLSN						= $FFAE ;send UNLISTEN command
UNTLK						= $FFAB ;send UNTALK command
CIOUT						= $FFA8 ;send byte to peripheral bus
ACPTR						= $FFA5 ;read byte from peripheral bus
SETTMO						= $FFA2 ;set timeout - Not Working!
TKSA						= $FF96 ;send TALK secondary address
SECOND						= $FF93 ;send LISTEN secondary address
;X16:
MACPTR						= FF44	;read multiple bytes from peripheral bus

;---- Memeory
MEMBOT						= $FF9C ;read/write address of start of usable RAM
MEMTOP						= $FF99	;read/write address of end of usable RAM
;X16:
memory_fill					= $FEE4	;fill memory region with a byte value
memory_copy					= $FEE7	;copy memory region
memory_crc					= $FEEA	;calculate CRC16 of memory region
memory_decompress			= $FEED	;decompress LZSA2 block
fetch						= $FF74 ;read a byte from any RAM or ROM bank
stash						= $FF77 ;write a byte to any RAM bank

;---- Time
RDTIM						= $FFDE ;read system clock
SETTIM						= $FFDB ;write system clock
UDTIM						= $FFEA ;advance clock
;X16:
clock_set_date_time			= $FF4D ;set date and time
clock_get_date_time			= $FF50 ;get date and time

;---- Other
STOP						= $FFE1 ;test for STOP key
GETIN						= $FFE4 ;get character from keyboard
SCREEN						= $FFED ;get the screen resolution
PLOT						= $FFF0 ;read/write cursor position
IOBASE						= $FFF3 ;return start of I/O area - useless!

;---- Keyboard
;X16:
kbdbuf_peek					= $FEBD ;get first char in keyboard queue and queue length
kbdbuf_get_modifiers		= $FEC0 ;get currently pressed modifiers
kbdbuf_put					= $FEC3 ;append a char to the keyboard queue $FED2: keymap - set or get the current keyboard layout

;---- Mouse
;X16
mouse_config				= $FF68 ;configure mouse pointer
mouse_scan					= $FF71 ;query mouse
mouse_get					= $FF6B ;get state of mouse

;---- Joystick
;X16
joystick_scan				= $FF53 ;query joysticks
joystick_get				= $FF56 ;get state of one joystick

;---- I2C
;X16
i2c_read_byte				= $FEC6 ;read a byte from an I2C device
i2c_write_byte				= $FEC9 ;write a byte to an I2C device

;---- C128:
CLOSE_ALL 					= $FF4A	;close all files on a device
LKUPLA						= $FF59 ;search tables for given LA
LKUPSA						= $FF5C ;search tables for given SA
PFKEY						= $FF65 ;program a function key [not yet implemented]
PRIMM						= $FF7D ;print string following the caller’s code

;---- Sprites
;X16
sprite_set_image			= $FEF0 ;set the image of a sprite
sprite_set_position			= $FEF3 ;set the position of a sprite

;---- Framebuffer
;X16
FB_init 					= $FEF6 ;enable graphics mode
FB_get_info 				= $FEF9 ;get screen size and color depth
FB_set_palette 				= $FEFC ;set (parts of) the palette
FB_cursor_position 			= $FEFF ;position the direct-access cursor
FB_cursor_next_line 		= $FF02 ;move direct-access cursor to next line
FB_get_pixel 				= $FF05 ;read one pixel, update cursor
FB_get_pixels 				= $FF08 ;copy pixels into RAM, update cursor
FB_set_pixel  				= $FF0B ;set one pixel, update cursor
FB_set_pixels 				= $FF0E ;copy pixels from RAM, update cursor
FB_set_8_pixels 			= $FF11 ;set 8 pixels from bit mask (transparent), update cursor
FB_set_8_pixels_opaque		= $FF14 ;set 8 pixels from bit mask (opaque), update cursor
FB_fill_pixels 				= $FF17 ;fill pixels with constant color, update cursor
FB_filter_pixels 			= $FF1A ;apply transform to pixels, update cursor
FB_move_pixels 				= $FF1D ;copy horizontally consecutive pixels to a different position

;---- Graphics
;X16
GRAPH_init					= $FF20 ;initialize graphics
GRAPH_clear					= $FF23 ;clear screen
GRAPH_set_window			= $FF26 ;set clipping region
GRAPH_set_colors			= $FF29 ;set stroke, fill and background colors
GRAPH_draw_line				= $FF2C ;draw a line
GRAPH_draw_rect				= $FF2F ;draw a rectangle (optionally filled)
GRAPH_move_rect				= $FF32 ;move pixels
GRAPH_draw_oval				= $FF35 ;draw an oval or circle
GRAPH_draw_image			= $FF38 ;draw a rectangular image
GRAPH_set_font				= $FF3B ;set the current font
GRAPH_get_char_size			= $FF3E ;get size and baseline of a character
GRAPH_put_char				= $FF41 ;print a character

;---- Conslole
;X16
console_init				= $FEDB ;initialize console mode
console_put_char			= $FEDE ;print character to console
console_put_image			= $FED8 ;draw image as if it was a character
console_get_char			= $FEE1 ;get character from console
console_set_paging_message	= $FED5 ;set paging message or disable paging