#include <iostream>
#include <stdio.h>
#include <conio.h>
#include <stdio.h>
#include <windows.h>

#include <interface.h>
#include <localControl.h>

using namespace std;

void initializeHardwarePorts()
{
	// INPUT PORTS
	createDigitalInput(0);
	createDigitalInput(1);
	createDigitalInput(2);
	createDigitalInput(3);
	// OUTPUT PORTS
	createDigitalOutput(4);
	createDigitalOutput(5);

	writeDigitalU8(4, 0);
	writeDigitalU8(5, 0);
}

void setBitValue(uInt8* variable, int n_bit, int new_value_bit)
// given a byte value, set the n bit to value
{
	uInt8  mask_on = (uInt8)(1 << n_bit);
	uInt8  mask_off = ~mask_on;
	if (new_value_bit)  *variable |= mask_on;
	else                *variable &= mask_off;
}

int getBitValue(uInt8 value, uInt8 n_bit)
// given a byte value, returns the value of bit n
{
	return(value & (1 << n_bit));
}

// ------------------------- X AXIS -------------------------

int getXPosition()
{
	int pp[10] = { 0,0,0,0,0,0,0,0,1,1 };
	int bb[10] = { 0,1,2,3,4,5,6,7,0,1 };
	int ports[2];
	ports[0] = readDigitalU8(0);
	ports[1] = readDigitalU8(1);
	for (int i = 0; i < 10; i++) {
		if (!getBitValue(ports[pp[i]], bb[i]))
			return i + 1;
	}
	return(-1);
}

void stopX(){
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 0, 0);
	setBitValue(&p, 1, 0);
	writeDigitalU8(4, p);
}

void moveXLeft(){
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 0, 0);
	setBitValue(&p, 1, 1);
	writeDigitalU8(4, p);
}

void moveXRight(){
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 0, 1);
	writeDigitalU8(4, p);
}

int isMovingRight() {
	uInt8 p4 = readDigitalU8(4);
	if (!getBitValue(p4, 0))
		return 0;
	return 1;
}

int isMovingLeft() {
	uInt8 p4 = readDigitalU8(4);
	if (!getBitValue(p4, 1))
		return 0;
	return 1;
}

int getXMoving() {

	if (isMovingLeft() == 1) {
		return -1;
	}
	else if (isMovingRight() == 1) {
		return 1;
	}
	else if (isMovingLeft() == 0 || isMovingRight() == 0) {
		return 0;
	}

	return -1;
}

// ------------------------- Y AXIS -------------------------

int getYPosition() { 
	int bb[3] = { 2,3,4 };
	int p1 = 1;

	p1 = readDigitalU8(1);
	for (int i = 0; i < 3; i++) {
		if (!getBitValue(p1, bb[i]))
			return i + 1;
	}
	return(-1);

}

void moveYInside() {
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 3, 0);
	setBitValue(&p, 4, 1);
	writeDigitalU8(4, p);
}

void moveYOutside() {
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 3, 1);
	setBitValue(&p, 4, 0);
	writeDigitalU8(4, p);
}

void stopY() {
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 3, 0);
	setBitValue(&p, 4, 0);
	writeDigitalU8(4, p);
}

int isMovingIn() {
	uInt8 p4 = readDigitalU8(4);
	if (!getBitValue(p4, 4))
		return 0;
	return 1;
}

int isMovingOut() {
	uInt8 p4 = readDigitalU8(4);
	if (!getBitValue(p4, 3))
		return 0;
	return 1;
}

int getYMoving() {

	if (isMovingOut() == 1) {
		return -1;
	}
	else if (isMovingIn() == 1) {
		return 1;
	}
	else if (isMovingOut() == 0 || isMovingIn() == 0) {
		return 0;
	}

	return -1;
}

boolean isCageFull() {
	uInt8 p2 = readDigitalU8(2);
	if (!getBitValue(p2, 7))
		return false;
	return true;
}


// ------------------------- Z AXIS -------------------------

float getZPosition()
{
	int pp[10] = { 2,2,2,2,2,2,2,1,1,1 };
	int bb[10] = { 6,5,4,3,2,1,0,7,6,5 };
	int ports[2];
	ports[0] = readDigitalU8(1);
	ports[1] = readDigitalU8(2);
	for (float i = 0.0; i < 10.0; i++) {
		if (!getBitValue(ports[pp[(int) i] - 1], bb[(int) i])) 
			return ((i + 1) / 2 + 0.5f);
	}
	return(-1);
}

void moveZUp() {
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 1);
	setBitValue(&p, 6, 0);
	writeDigitalU8(4, p);
}

void moveZDown() {
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 0);
	setBitValue(&p, 6, 1);
	writeDigitalU8(4, p);
}

void stopZ() {
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 0);
	setBitValue(&p, 6, 0);
	writeDigitalU8(4, p);
}

int isMovingUp() {
	uInt8 p4 = readDigitalU8(4);
	if (!getBitValue(p4, 5))
		return 0;
	return 1;
}

int isMovingDown() {
	uInt8 p4 = readDigitalU8(4);
	if (!getBitValue(p4, 6))
		return 0;
	return 1;
}

int getZMoving() {

	if (isMovingDown() == 1) {
		return -1;
	}
	else if (isMovingUp() == 1) {
		return 1;
	}
	else if (isMovingDown() == 0 || isMovingUp() == 0) {
		return 0;
	}

	return -1;
}


// ----------------------- LEFT STATION ---------------------------

void moveLeftStationInside() {
	uInt8 p4 = readDigitalU8(4);
	uInt8 p5 = readDigitalU8(5);
	setBitValue(&p5, 0, 0);
	setBitValue(&p4, 7, 1);
	writeDigitalU8(4, p4);
	writeDigitalU8(5, p5);
}

void moveLeftStationOutside() {
	uInt8 p4 = readDigitalU8(4);
	uInt8 p5 = readDigitalU8(5);
	setBitValue(&p5, 0, 1);
	setBitValue(&p4, 7, 0);
	writeDigitalU8(4, p4);
	writeDigitalU8(5, p5);
}

void stopLeftStation() {
	uInt8 p4 = readDigitalU8(4);
	uInt8 p5 = readDigitalU8(5);
	setBitValue(&p5, 0, 0);
	setBitValue(&p4, 7, 0);
	writeDigitalU8(4, p4);
	writeDigitalU8(5, p5);
}

int isLMovingIn() {
	uInt8 p4 = readDigitalU8(4);
	if (!getBitValue(p4, 7))
		return 0;
	return 1;
}

int isLMovingOut() {
	uInt8 p5 = readDigitalU8(5);
	if (!getBitValue(p5, 1))
		return 0;
	return 1;
}

int getLMoving() {

	if (isLMovingOut() == 1) {
		return -1;
	}
	else if (isLMovingIn() == 1) {
		return 1;
	}
	else if (isLMovingOut() == 0 || isLMovingIn() == 0) {
		return 0;
	}

	return -1;
}


// ---------------------- RIGHT STATION ---------------------------

void moveRightStationInside() {
	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 1);
	setBitValue(&p, 2, 0);
	writeDigitalU8(5, p);
}

void moveRightStationOutside() {
	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 2, 1);
	writeDigitalU8(5, p);
}

void stopRightStation() {
	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 2, 0);
	writeDigitalU8(5, p);
}

int isRMovingIn() {
	uInt8 p5 = readDigitalU8(5);
	if (!getBitValue(p5, 1))
		return 0;
	return 1;
}

int isRMovingOut() {
	uInt8 p5 = readDigitalU8(5);
	if (!getBitValue(p5, 2))
		return 0;
	return 1;
}

int getRMoving() {

	if (isRMovingOut() == 1) {
		return -1;
	}
	else if (isRMovingIn() == 1) {
		return 1;
	}
	else if (isRMovingOut() == 0 || isRMovingIn() == 0) {
		return 0;
	}

	return -1;
}


void showPortsInformation() {
	for (int portNumber = 0; portNumber < 6; portNumber++) {
		uInt8 portValue = readDigitalU8(portNumber);
		printf("\nport(%d)=%02x --> ", portNumber, portValue);
		for (int bitNumber = 0; bitNumber < 8; bitNumber++) {
			bool bitValue = portValue & (1 << (7 - bitNumber));
			if ((bitNumber % 4) == 0)
				putchar(' ');
			printf("%d", (int)bitValue);
		}
		printf("\n");
	}
}


void executeLocalControl(int keyboard) {


	switch (keyboard) {
	case 'q': moveXRight(); break;
	case 'a': moveXLeft();	break;
	case 'z': stopX();		break;

		
	case 'w': moveYInside(); break;
	case 's': moveYOutside(); break;
	case 'x': stopY(); break;

	case 'e': moveZUp(); break;
	case 'd': moveZDown(); break;
	case 'c': stopZ(); break;

	case 'r': moveLeftStationInside(); break;
	case 'f': moveLeftStationOutside(); break;
	case 'v': stopLeftStation(); break;

	case 't': moveRightStationInside(); break;
	case 'g': moveRightStationOutside(); break;
	case 'b': stopRightStation(); break;

	case 'p': showPortsInformation(); break;


	default: break;
	}
}