#include <chrono>
#include <warehouseConfig.h>
#include <interface.h>

#include "localControl.h"


char queryString[10000]; // It is not the best way...
unsigned __int64 timeStamp = 0; 


void monitorXAxis() {
	static int previous_x_position = -1, previous_x_moving = -9999;

	int xPosition = getXPosition();
	int xMoving   = getXMoving();
	
	if (xPosition != previous_x_position) {

		if (xPosition >= 1) {
			sprintf(queryString, "/rtx_get?query=assert_state(x_is_at(%d))", xPosition);
		}
		else if (xPosition == -1) {  // when x_axis leaves a position sensor, then the state disapears
			sprintf(queryString, "/rtx_get?query=retract_state(x_is_at(_))"  );
		}
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_x_position = xPosition;
	}

	if (xMoving != previous_x_moving) { // in this case, there is always a state for x_movement {-1, 0, 1}
		sprintf(queryString, "/rtx_get?query=assert_state(x_moving(%d))", xMoving);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_x_moving = xMoving;
	}
}


void monitorYAxis() {
	static int previous_y_position = -1, previous_y_moving = -9999;

	int yPosition = getYPosition();
	int yMoving = getYMoving();

	if (yPosition != previous_y_position) {

		if (yPosition >= 1) {
			sprintf(queryString, "/rtx_get?query=assert_state(y_is_at(%d))", yPosition);
		}
		else if (yPosition == -1) {  // when y_axis leaves a position sensor, then the state disapears
			sprintf(queryString, "/rtx_get?query=retract_state(y_is_at(_))");
		}
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_y_position = yPosition;
	}

	if (yMoving != previous_y_moving) { // in this case, there is always a state for x_movement {-1, 0, 1}
		sprintf(queryString, "/rtx_get?query=assert_state(y_moving(%d))", yMoving);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_y_moving = yMoving;
	}
}


void monitorZAxis() {		// por testar
	static float previous_z_position = -1;
	static int previous_z_moving = -9999;

	float zPosition = getZPosition();
	int zMoving = getZMoving();

	if (zPosition != previous_z_position) {

		if (zPosition >= 1) {
			sprintf(queryString, "/rtx_get?query=assert_state(z_is_at(%f))", zPosition);
		}
		else if (zPosition == -1) {  // when z_axis leaves a position sensor, then the state disapears
			sprintf(queryString, "/rtx_get?query=retract_state(z_is_at(_))");
		}
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_z_position = zPosition;
	}

	if (zMoving != previous_z_moving) { // in this case, there is always a state for z_movement {-1, 0, 1}
		sprintf(queryString, "/rtx_get?query=assert_state(z_moving(%d))", zMoving);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_z_moving = zMoving;
	}
}


void monitorLeftStation() {		//por testar
	static int previous_l_moving = -9999;

	int leftMoving = getLMoving();

	if (leftMoving != previous_l_moving) { // in this case, there is always a state for z_movement {-1, 0, 1}
		sprintf(queryString, "/rtx_get?query=assert_state(left_moving(%d))", leftMoving);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_l_moving = leftMoving;
	}


	static int previous_l_part = -9999;

	int partAtLeftStation = isPartAtLeftStation(); 

	if (partAtLeftStation != previous_l_part) { // in this case, there is always a state for z_movement {-1, 0, 1}
		sprintf(queryString, "/rtx_get?query=assert_state(part_at_left_station(%d))", partAtLeftStation);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_l_part = partAtLeftStation; 
	}

}

void monitorRightStation() {	// por testar
	static int previous_r_moving = -9999;

	int rightMoving = getRMoving();

	if (rightMoving != previous_r_moving) { // in this case, there is always a state for z_movement {-1, 0, 1}
		sprintf(queryString, "/rtx_get?query=assert_state(right_moving(%d))", rightMoving);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_r_moving = rightMoving;
	}

	static int previous_r_part = -9999;

	int partAtRightStation = isPartAtRightStation();

	if (partAtRightStation != previous_r_part) { // in this case, there is always a state for z_movement {-1, 0, 1}
		sprintf(queryString, "/rtx_get?query=assert_state(part_at_left_station(%d))", partAtRightStation);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_r_part = partAtRightStation;
	}
}


void monitorCage() {		// por testar
	static int previous_cage_status = -9999;

	int cageStatus = isCageFull();

	if (cageStatus != previous_cage_status) { 
		sprintf(queryString, "/rtx_get?query=assert_state(cage_status(%d))", cageStatus);
		sendPrologWebRequest((char*)queryString, prologServer, prologPort);
		previous_cage_status = cageStatus;
	}
}

void monitoringOperation() {
	monitorXAxis();
	monitorYAxis();
	monitorZAxis();
	monitorLeftStation();
	monitorRightStation();
	monitorCage();	
}
