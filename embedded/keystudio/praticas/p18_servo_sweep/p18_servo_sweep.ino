//**********************************************************************
/*
 * Filename    : Servo Sweep
 * Description : Control the servo motor for sweeping
 * Auther      : http//www.keyestudio.com
*/
#include <Servo.h>
#define servoPin 18

Servo myServo;  // create servo object to control a servo
int pos = 0;    // variable to store the servo position
unsigned long sweepCount = 0; // contador de ciclos completos

void setup() {
  Serial.begin(115200);
  delay(1000); // aguarda serial estabilizar
  Serial.println("===== SERVO SWEEP DEBUG =====");
  Serial.print("Pino do servo: ");
  Serial.println(servoPin);

  myServo.attach(servoPin);  // attaches the servo on pin 18 to the servo object

  if (myServo.attached()) {
    Serial.println("[OK] Servo anexado com sucesso.");
  } else {
    Serial.println("[ERRO] Falha ao anexar o servo! Verifique o pino.");
  }

  Serial.println("Iniciando sweep...\n");
}

void loop() {
  sweepCount++;
  Serial.print("--- Ciclo #");
  Serial.print(sweepCount);
  Serial.println(" ---");

  // Sweep 0 -> 180
  Serial.println(">> Movendo 0 -> 180");
  for (pos = 0; pos <= 180; pos += 1) {
    myServo.write(pos);
    if (pos % 30 == 0) { // imprime a cada 30 graus para nao sobrecarregar
      Serial.print("  pos = ");
      Serial.print(pos);
      Serial.print("° | attached = ");
      Serial.println(myServo.attached() ? "sim" : "NAO");
    }
    delay(15);
  }

  // Sweep 180 -> 0
  Serial.println(">> Movendo 180 -> 0");
  for (pos = 180; pos >= 0; pos -= 1) {
    myServo.write(pos);
    if (pos % 30 == 0) {
      Serial.print("  pos = ");
      Serial.print(pos);
      Serial.print("° | attached = ");
      Serial.println(myServo.attached() ? "sim" : "NAO");
    }
    delay(15);
  }

  Serial.println("Ciclo completo.\n");
}
//********************************************************************************
