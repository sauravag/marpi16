// We'll use SoftwareSerial to communicate with the XBee:
#include <SoftwareSerial.h>
// XBee's DOUT (TX) is connected to pin 2 (Arduino's Software RX)
// XBee's DIN (RX) is connected to pin 3 (Arduino's Software TX)
SoftwareSerial XBee(2, 3); // RX, TX

long previousMillis = 0;   // will store last time heartbeat was sent
 
// the follow variables is a long because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long interval = 1000; 

void setup()
{
  // Set up both ports at 9600 baud. This value is most important
  // for the XBee. Make sure the baud rate matches the config
  // setting of your XBee.
  XBee.begin(57600);
  Serial.begin(9600);
}

String compose_message(int robotNumber, int jobNumber, int jobStatus, char health, int batteryLife, float z, float theta){

  
  //convert varibles to string
  String string_robotNumber = String(robotNumber);
  String string_jobNumber = String(jobNumber);
  String string_jobStatus = String(jobStatus);
  String string_health = String(health);
  String string_batteryLife = String(batteryLife);
  String string_z = String(z);
  String string_theta = String(theta);
  String string_message;
  string_message = String("MI16-")+robotNumber + String("-") + jobNumber + String("-") + jobStatus + String("-") + health + String("-") + batteryLife + String("-") + z + String("-") 
                  + theta + String("-EM16") + String("\n"); //final heartbeat message 

  return string_message; 

}

void loop(){
  //set values
  int robotNumber = 4;
  int jobNumber = 8;
  int jobStatus = 70;
  char health = 'C';
  int batteryLife = 80;
  float z = 34.0;
  float theta = 35.4;
  String k;
  
  k = compose_message(robotNumber, jobNumber, jobStatus, health, batteryLife, z, theta); 

// check to see if it's time to send heartbeat; that is, if the 
  // difference between the current time and last time you sent heartbeat 
  // is bigger than the interval at which you want
  unsigned long currentMillis = millis();
 
  if(currentMillis - previousMillis > interval) {
    // save the last time you blinked the LED 
    previousMillis = currentMillis;   
  XBee.print(k);
  }
  
  if (XBee.available())
  { // If data comes in from XBee, send it out to serial monitor
    Serial.write(XBee.read());
  }

  
}

