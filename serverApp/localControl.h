#include <interface.h>

void setBitValue(uInt8* variable, int n_bit, int new_value_bit);
int getBitValue(uInt8 value, uInt8 n_bit);

// ------------------------- X AXIS -------------------------

int getXPosition();
int getXMoving();

void moveXRight();
void moveXLeft();
void stopX();


// ------------------------- Y AXIS -------------------------

int getYPosition();
int getYMoving();

bool isCageFull();

void moveYInside();
void moveYOutside();
void stopY();


// ------------------------- Z AXIS -------------------------

float getZPosition();
int getZMoving();

void moveZUp();
void moveZDown();
void stopZ();


// ----------------------- LEFT STATION ---------------------------

int getLMoving();

void moveLeftStationInside();
void moveLeftStationOutside();
void stopLeftStation();


// ---------------------- RIGHT STATION ---------------------------

int getRMoving();

void moveRightStationInside();
void moveRightStationOutside();
void stopRightStation();

// ---------------------- RIGHT STATION PARTS ---------------------------
int isPartAtLeftStation();
int isPartAtRightStation();

// ----------------------------------------------------------------

void showPortsInformation();

void executeLocalControl(int keyboard);

