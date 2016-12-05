// We'll use SoftwareSerial to communicate with the XBee:
#include <SoftwareSerial.h>
#include <StringTokenizer.h>
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
  XBee.begin(9600);
  Serial.begin(9600);
}

void decompose_message(String const string_message, int &robotNumber, int &jobNumber, int &jobStatus, char &health, int &batteryLife, float &z, float &theta) {
    // the values are seperated by "-", so I can use that tokenizer library
    // I know this from Rebecca's code
    StringTokenizer tokens(string_message, "-"); // this is from a library i downloaded
                                                 // first argument is the string, the next is the delimeter
    String header = String(tokens.nextToken()); // Next token is pretty self explnatory
    
    String rn = String(tokens.nextToken());
    robotNumber = rn.toInt();
    
    String jn = String(tokens.nextToken());
    jobNumber = jn.toInt();
    
    String js = String(tokens.nextToken());
    jobStatus = js.toInt();
    
    String h = String(tokens.nextToken());
    h.toCharArray(health, 2);
    
    String bl = String(tokens.nextToken());
    batteryLife = bl.toInt();
    
    String distance = String(tokens.nextToken());
    z = distance.toFloat();
    
    String t = String(tokens.nextToken());
    theta = t.toFloat();
    
    String footer = String(tokens.nextToken());
     
  }


bool isDataFromFailureConnection(String const receipt_Message, String const string_message)
{

  StringTokenizer tokens(receipt_Message, "-");
  String header = String(tokens.nextToken());
  String receiptRobotNumber = String(tokens.nextToken());
  
  int receiptRN = receiptRobotNumber.toInt();
  int robotRN = get_robotNumber(string_message);

  if (receiptRN == robotRN) {
    return 1;
  } else {
    return 0;
  }
  
}

//  // 1. decompose the message
//  decompose_message = decompose_message(String const string_message, int &robotNumber, int &jobNumber, int &jobStatus, char &health, int &batteryLife, float &z, float &theta)
//  // 2. Check robot number in decomposed message, 
//  
//  // 3. if it corresponds to failure then return True (yes data is
//  // coming from failure), otherwise return False (0).
//
//  // when the master gets a message, it sends a receipt message. then, if the robot number is 3, then the message is rejected. then, robot 3 will relay the message


String receiptMessage(int robotNumber){

  String string_rn = String(robotNumber);
  String receipt_Message = String("RC-") + string_rn + String("-EM");

  return receipt_Message;
  
}

int get_robotNumber(String const string_message){

  int robotNumber;
  int jobNumber;
  int jobStatus;
  char health;
  int batteryLife;
  float z;
  float theta;
  decompose_message(string_message, robotNumber, jobNumber, jobStatus, health, batteryLife, z, theta);

  return robotNumber;
  

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
  
 // k = compose_message(robotNumber, jobNumber, jobStatus, health, batteryLife, z, theta); 

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
  { 
    if (
      
    }

    else 
    // If data comes in from XBee, send it out to serial monitor
    Serial.write(XBee.read());
  }

  
}

