/////////////////////////////////////////////
//Sketch realizado por Alex TC (TCRobotics)//
//web: http://tcrobotics.blogspot.com      //
//twitter: @TCRobotics                     //
//email: alex.tc.robotics-AT-gmail.com     //
/////////////////////////////////////////////
#include <Wire.h>
#include <LibCompass.h>
#include <Servo.h> 
LibCompass compass = LibCompass(0);

int radiocirculo=30;
int radiolinea= 18;
int centroX= 95;
int centroY= 31;
double seno;
double coseno;
double seno90;
double coseno90;
double seno270;
double coseno270;
double anguloDEG=0;
double anguloRAD=0;

Servo servo; 

void setup() {
  servo.attach(9);
  Serial.begin(115200); //por defecto el LCD trabaja a estos bps
  delay(4000);          //retardo de encendido del LCD
  borrar();             //borramos pantalla
  delay(50);
  
  //escribimos las cosas que no cambian en la pantalla
  coordenadas(0, 62);
  Serial.print("Brujula");
  coordenadas(12, 69);
  Serial.print(",");
  coordenadas(0, 54);
  Serial.print("BricoGeek");
  coordenadas(40, 42);
  Serial.print("o");
  coordenadas(0, 8);
  Serial.print("byTCRobotics");
}

void loop() {  
  //Borramos solo lo que cambia para mejorar el refresco
  linea (centroX,centroY, radiolinea*coseno+centroX, radiolinea*seno+centroY, 0); 
  coordenadas(25*coseno+centroX-2, 25*seno+centroY+3);
  Serial.print(" ");
  coordenadas(25*coseno270+centroX-2, 25*seno270+centroY+3);
  Serial.print(" ");
  coordenadas(-25*coseno+centroX-2, -25*seno+centroY+3);
  Serial.print(" ");
  coordenadas(25*coseno90+centroX-2, 25*seno90+centroY+3);
  Serial.print(" "); 
  coordenadas(26, 38);
  Serial.print("  ");

  //calculamos los angulos antes para optimizar la escritura en pantalla
  anguloDEG = compass.GetHeading();   //conseguimos el dato de orientacion
  anguloRAD = ((anguloDEG)*2*PI)/360; //convertimos a radianes
  coseno=   sin(anguloRAD);
  seno=     cos(anguloRAD);
  coseno90= sin(anguloRAD+PI/2*3);
  seno90=   cos(anguloRAD+PI/2*3);
  coseno270=sin(anguloRAD+PI/2);
  seno270=  cos(anguloRAD+PI/2);
  
  //pintamos el circulo y la linea
  circulo (centroX,centroY, radiocirculo, 1);
  linea (centroX,centroY, radiolinea*coseno+centroX, radiolinea*seno+centroY, 1);
  
  //escribimos las letras de las cuatro direcciones
  coordenadas(25*coseno+centroX-2, 25*seno+centroY+3);
  Serial.print("N");
  coordenadas(25*coseno270+centroX-2, 25*seno270+centroY+3);
  Serial.print("W");
  coordenadas(-25*coseno+centroX-2, -25*seno+centroY+3);
  Serial.print("S");
  coordenadas(25*coseno90+centroX-2, 25*seno90+centroY+3);
  Serial.print("E");
  
  //escribimos por ultimo el dato del angulo
  coordenadas(2, 38);
  Serial.print(anguloDEG);
  
  //servo.write(anguloDEG); 
  delay(500);
}



//////////////////////FUNCIONES LCD SERIAL//////////////////////////////////////////////

void borrar(){
  Serial.print(0x7C,BYTE);
  Serial.print(0x00,BYTE);
 delay(20);
}


//cambia el baudrate. Si no conseguimos comunicarnos con el display
//podemos solucionarlo mandandole cualquier dato a 115200bps durante el arranque,
//mostrara en la pantalla 115200 y se autoajustara a esa velocidad
void cambiar_baudrate(char frec){  //"1" =  4.800bps "2" =  96,00bps
  Serial.print(0x7C,BYTE);         //"3" = 19,200bps "4" =  38,400bps 
  Serial.print(0x07,BYTE);         //"5" = 57,600bps "6" = 115,200bps
  Serial.print(frec,BYTE); 
  delay(20);
}

//coloca el puntero de escritura en la posicion que le indiquemos
void coordenadas(int x, int y){    //x de 0 a 127
  Serial.print(0x7C,BYTE);         //y de 0 a  63
  Serial.print(0x18,BYTE);
  Serial.print(x,BYTE);
  Serial.print(0x7C,BYTE); 
  Serial.print(0x19,BYTE);
  Serial.print(y,BYTE);
  //delay(20);
}

//dibuja o borra una linea
void linea (int desde_x, int desde_y, int hasta_x, int hasta_y, int on_off){ 
  Serial.print(0x7C,BYTE);             
  Serial.print(0x0C,BYTE);               
  Serial.print(desde_x,BYTE);
  Serial.print(desde_y,BYTE);
  Serial.print(hasta_x,BYTE);
  Serial.print(hasta_y,BYTE);  
  Serial.print(on_off,BYTE);
  //delay(20);
}

//dibuja o borra un circulo
void circulo (int x, int y, int radio, int on_off){ 
  Serial.print(0x7C,BYTE);             
  Serial.print(0x03,BYTE);               
  Serial.print(x,BYTE);
  Serial.print(y,BYTE);
  Serial.print(radio,BYTE);  
  Serial.print(on_off,BYTE);
  //delay(20);
}



