// We'll use SoftwareSerial to communicate with the XBee:
#include <SoftwareSerial.h>
#include <StringTokenizer.h> // for string tokens
//#include <Xbee.h>

// XBee's DOUT (TX) is connected to pin 2 (Arduino's Software RX)
// XBee's DIN (RX) is connected to pin 3 (Arduino's Software TX)
SoftwareSerial XBee(2, 3); // RX, TX

void setup() {
  // put your setup code here, to run once:
 // Xbee.begin(9600);
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

void loop() {
  // put your main code here, to run repeatedly
  
}



