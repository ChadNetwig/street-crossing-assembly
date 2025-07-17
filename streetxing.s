/*
Filename	: streetxing.s
Author		: Chad Netwig
Last Updated	: 05-16-2021
Description	: Program uses the wiringPi library to interface with a Raspberry Pi 3B+ that has been
		: wired with 5 LEDs and a button. The traffic signal is represented by one column of
                : 3 LEDs (Red, Yel, Grn) and the walk/don't walk signal is represented by another column
		: of 2 LEDs (Red, Grn).
                :
                : Pressing the button starts the lighting sequence process as follows:
		:
		: 1. Red traffic signal and green walk light up at the same time and remain lit for 6 seconds
		: 2. Yellow traffic signal and green walk signal both flash for QTY_BLINKS times with BLINK ms
		:    delay between the blinks
		: 3. Green traffic signal and red walk light up at the same time and remain lit for 6 seconds
		:    then program ends, returing 0
*/

// assemble: g++ streetxing.s -lwiringPi -g -o streetxing

/* EQUATES SECTION */

.equ INPUT, 0			// gpio mode in
.equ OUTPUT, 1			// gpio mode out

.equ LOW, 0			// current off
.equ HIGH, 1			// current on

.equ LED_TRAF_RED, 1		// Red Traffic Signal LED on wPi 1, BCM 18
.equ LED_TRAF_YEL, 4		// Yellow Traffic Signal LED on wPi 4, BCM 23
.equ LED_TRAF_GRN, 26		// Green Traffic Signal LED on wPi 26, BCM 12

.equ LED_WALK_RED, 0		// Red Walk Signal LED on wPi 0, BCM 17
.equ LED_WALK_GRN, 3		// Green Walk Signal LED on wPi 3, BCM 22

.equ BUTTON, 7			// Breadboard button on wPi 7, BCM 4

.equ DELAY, 2000		// 2000 ms (2 sec) delay

.equ BLINK, 300			// 300 ms delay between blinks
.equ QTY_BLINKS, 14		// quantiy of blinks set to 14 (even number cause leaves LEDs off)



/* CONSTANTS SECTION */

.align 4			// align on 4-byte boundries (32-bit ARM)
.section .rodata
msg_1:		.asciz	"Welcome to Street Crossing!\n\nPress the button on breadboard to begin!\n"
msg_2:		.asciz	"\nStarting sequence...\n\nWalk\n"
msg_3:		.asciz	"\nSequence complete!\n"

msg_hurry:	.asciz	"\nHurry Up\n"
msg_dontwalk:	.asciz	"\nDon't Walk!\n"


/* CODE SECTION */

.align 4
.text
.global main
main:
	push {R4, LR}			// r4 is used for loop counter and pushed onto stack
					// so that it doesn't get corrupted

	bl wiringPiSetup		// calls wiringPi library for wPi pin number scheme

	/* set mode to OUT on the gpio wPi pins for LEDs */
	mov r0, #LED_TRAF_RED		// sets Red Traffic LED to OUT mode
	mov r1, #OUTPUT
	bl pinMode			// calls gpio mode <pin> out

	mov r0, #LED_TRAF_YEL		// sets Yellow Traffic LED to OUT mode
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #LED_TRAF_GRN		// sets Green Traffic LED to OUT mode
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #LED_WALK_RED		// sets Red Walk LED to OUT mode
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #LED_WALK_GRN		// sets Green Walk LED to OUT mode
	mov r1, #OUTPUT
	bl pinMode

	/* set mode to IN on the gpio wPi pin for the button */
	mov r0, #BUTTON			// sets the button circuit to IN mode
	mov r1, #INPUT
	bl pinMode			// calls gpio mode <pin> in

/* display splash */
	ldr r0, =msg_1			// load into r0 the pointer to address of label msg_1
	bl printf			// branch with link to printf function: displays intro message

do_while_no_button:
	mov r0, #BUTTON
	bl digitalRead			// returns 0 if button not pressed (LOW) and 1 (HIGH) if pressed

	cmp r0, #LOW
	beq do_while_no_button		// loop until button pressed (HIGH breaks loop)


/* SEQUENCE 1: Red Traffic, Green Walk on for 6 seconds */

	/* displays start message */
	ldr r0, =msg_2			// load into r0 the pointer to address of label msg_2
	bl printf			// branch with link to printf function: displays start sequence message

	mov r0, #LED_TRAF_RED
	mov r1, #HIGH
	bl digitalWrite			// turn traffic LED red ON

	mov r0, #LED_WALK_GRN
	mov r1, #HIGH
	bl digitalWrite			// turn walk LED green ON

	mov r0, #DELAY			// leave LEDs lit for 2 seconds
	bl delay

	mov r0, #DELAY			// leave LEDs lit for 2 seconds
	bl delay

	mov r0, #DELAY			// leave LEDs lit for 2 seconds
	bl delay

	/* turn the LEDs off after the delays */
	mov r0, #LED_TRAF_RED
	mov r1, #LOW
	bl digitalWrite			// turn traffic LED red OFF

	mov r0, #LED_WALK_GRN
	mov r1, #LOW			// turn walk LED green OFF
	bl digitalWrite


/* SEQUENCE 2: Yellow Traffic, Green Walk blink for #QTY_BLINKS times with #BLINK ms between blinks */

	/* displays "hurry" message when respective lights are blinking */
	ldr r0, =msg_hurry		// load into r0 the pointer to address of label msg_hurry
	bl printf			// branch with link to printf function: displays hurry message

	mov r4, #0			// set counter to 0
do_while_blink:
	mov r0, #LED_TRAF_YEL
	mov r1, #HIGH
	bl digitalWrite			// turn traffic LED yellow ON

	mov r0, #LED_WALK_GRN
	mov r1, #HIGH
	bl digitalWrite			// turn walk LED green ON

	mov r0, #BLINK			// blink delay on state
	bl delay

	mov r0, #LED_TRAF_YEL
	mov r1, #LOW
	bl digitalWrite			// turn traffic LED yellow OFF

	mov r0, #LED_WALK_GRN
	mov r1, #LOW
	bl digitalWrite			// turn walk LED green OFF

	mov r0, #BLINK			// blink delay off state
	bl delay

	add r4, #1			// increment counter by 1,  r4++;
	cmp r4, #QTY_BLINKS		// blinks QTY_BLINKS times, then breaks out to seq 3
	ble do_while_blink


/* SEQUENCE 3: Green Traffic, Red Walk light up for 6 seconds then turn off and program returns 0*/

	/* displays "Don't Walk" message */
	ldr r0, =msg_dontwalk		// load into r0 the pointer to address of label msg_dontwalk
	bl printf			// branch with link to printf function: displays don't walk message

	mov r0, #LED_TRAF_GRN
	mov r1, #HIGH
	bl digitalWrite			// turn traffic LED yellow ON

	mov r0, #LED_WALK_RED
	mov r1, #HIGH
	bl digitalWrite			// turn walk LED red ON

	mov r0, #DELAY			// leave LEDs lit for 2 seconds
	bl delay

	mov r0, #DELAY			// leave LEDs lit for 2 seconds
	bl delay

	mov r0, #DELAY			// leave LEDs lit for 2 seconds
	bl delay

	/* Turns traffic and walk LEDs off */
	mov r0, #LED_TRAF_GRN
	mov r1, #LOW
	bl digitalWrite			// turn traffic LED green OFF

	mov r0, #LED_WALK_RED
	mov r1, #LOW
	bl digitalWrite			// turn walk LED red OFF

	/* displays exit message */
	ldr r0, =msg_3			// load into r0 the pointer to address of label msg_3
	bl printf			// branch with link to printf function: displays exit message

	/* program terminates and returns 0 */
	mov r0, #0			// return 0
	pop {r4, pc}
