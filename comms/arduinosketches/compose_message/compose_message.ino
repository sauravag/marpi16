// We'll use SoftwareSerial to communicate with the XBee:
#include <SoftwareSerial.h>
// XBee's DOUT (TX) is connected to pin 2 (Arduino's Software RX)
// XBee's DIN (RX) is connected to pin 3 (Arduino's Software TX)
SoftwareSerial XBee(2, 3); // RX, TX

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
  int robotNumber = 2;
  int jobNumber = 6;
  int jobStatus = 50;
  char health = 'A';
  int batteryLife = 60;
  float z = 32.0;
  float theta = 33.4;
  String k;
  
  k = compose_message(robotNumber, jobNumber, jobStatus, health, batteryLife, z, theta); 

  XBee.print(k);
  Serial.print(k);
  delay(1000);
}

