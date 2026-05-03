#define PIN_LED    27
#define PIN_BUTTON 26
bool ledState = false; // variavel para blinkar

void setup() {
  // initialize digital pin PIN_LED as an output.
  pinMode(PIN_LED, OUTPUT);
  pinMode(PIN_BUTTON, INPUT);
}

// the loop function runs over and over again forever
void loop() {
  // CONJUNTO para atuar como debounce
  if (digitalRead(PIN_BUTTON) == HIGH) { // se foi pressionado
    delay(20); /// delay para evitar trepidação da entrada
    if (digitalRead(PIN_BUTTON) == HIGH) { // se foi pressionado
      reverseGPIO(PIN_LED); // apenas blinka a saída => pode ser otimizado
    }
    while (digitalRead(PIN_BUTTON) == HIGH); // Enquanto tiver pressionado não faz nada
  }
}

void reverseGPIO(int pin) { // variavel para blinkar
  ledState = !ledState;
  digitalWrite(pin, ledState);
}
//**********************************************************************
