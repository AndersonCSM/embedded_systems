#include <Servo.h>

//**********************************************************************************
/*
 * Filename    : Small Fan
 * Description : Fan clockwise rotation,stop,counterclockwise rotation,stop,cycle.
 * Auther      : http//www.keyestudio.com
*/
#define Motorla    17  // the Motor_IN+ pin of the motor
#define Motorlb     16  // the Motor_IN- pin of the motor

void setup(){
  pinMode(Motorla, OUTPUT);//set Motorla to OUTPUT
  pinMode(Motorlb, OUTPUT);//set Motorlb to OUTPUT
}
void loop(){
//Set to rotate for 5s anticlockwise at 80% speed
  analogWrite(Motorla, 128);  // 204 = 80% de velocidade (255 * 0.8)
  analogWrite(Motorlb, 0);
  delay(5000);
//Set to stop rotating for 2s 
  analogWrite(Motorla, 0);
  analogWrite(Motorlb, 0);
  delay(2000);
//Set to rotate for 5s clockwise at 50% speed
  analogWrite(Motorla, 0);
  analogWrite(Motorlb, 102);  // 128 = 50% de velocidade (255 * 0.5)
  delay(5000);
//Set to stop rotating for 2s 
  analogWrite(Motorla, 0);
  analogWrite(Motorlb, 0);
  delay(2000);
}
//********************************************************************************
