#include <interface.h>
#include <warehouseConfig.h>
#include <localControl.h>
#include <json.h>

using namespace nlohmann; 


void executeCommand(string command) {
	if (command == "move_x_left") {
		moveXLeft();
	}if (command == "move_x_right") {
		moveXRight();
	}if (command == "stop_x") {
		stopX();
	}

	if (command == "move_y_in") {
		moveYInside();
	}if (command == "move_y_out") {
		moveYOutside();
	}if (command == "stop_y") {
		stopY();
	}

	if (command == "move_z_up") {
		moveZUp();
	}if (command == "move_z_down") {
		moveZDown();
	}if (command == "stop_z") {
		stopZ();
	}

	if (command == "move_left_in") {
		moveLeftStationInside();
	}if (command == "move_left_out") {
		moveLeftStationOutside();
	}if (command == "stop_left") {
		stopLeftStation();
	}

	if (command == "move_right_in") {
		moveRightStationInside();
	}if (command == "move_right_out") {
		moveRightStationOutside();
	}if (command == "stop_right") {
		stopRightStation();
	}
}

void dispatcherOperation() {
	string result = sendPrologWebRequest((char*)"/rtx_get?query=consume_control_commands", prologServer, prologPort);
	if (result.length() > 0) {
		try {
			auto j = json::parse(result);
			for (auto& obj : j.items()) {
				string cmd = obj.value();
				executeCommand(cmd);
			}
		}

		catch (const std::exception& e) {
			if (e.what()) {/*just to avoid compiler warning*/ }			
		}
	}
}