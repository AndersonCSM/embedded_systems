//**********************************************************************
/* 
 * Projeto: Alarme de Presença com Interrupções
 * Descrição: Sensor PIR detecta movimento e aciona LED + buzzer
 * Hardware: Raspberry Pi Pico RP2040
 * Técnica: Modo HÍBRIDO - Interrupção + Polling manual
 * 
 * IMPORTANTE sobre o sensor PIR HC-SR501:
 * - O sensor tem um DELAY FÍSICO depois de cada detecção
 * - Ele permanece em HIGH por 2-8 segundos (configurável no potenciômetro)
 * - Só pode detectar novamente quando voltar para LOW
 * - Por isso usamos detecção de borda manual + interrupção
 * - Sistema de RETRIGGERING: novas detecções renovam o alarme
 * 
 * Autor: Modificado para uso educacional
*/

// ========== CONFIGURAÇÃO DOS PINOS ==========
#define BUZZER  19    // Pino do buzzer
#define LED     22    // Pino do LED
#define PIR     2     // Pino do sensor PIR (suporta interrupção)

// ========== VARIÁVEIS GLOBAIS ==========
// volatile = pode ser modificada pela interrupção
volatile bool movimentoDetectado = false;
volatile unsigned long ultimaInterrupcao = 0;
volatile int contadorDeteccoes = 0;

unsigned long tempoInicioAlarme = 0;
unsigned long tempoUltimaPiscada = 0;
bool estadoLED = LOW;
bool alarmeAtivo = false;
byte estadoPIR = LOW;
byte estadoPIRAnterior = LOW;

// ========== CONSTANTES DE TEMPO ==========
const int INTERVALO_PISCADA = 100;   // Tempo entre piscadas (ms)
const int DURACAO_ALARME = 2000;     // Quanto tempo o alarme toca (ms)
const int DEBOUNCE = 100;            // Reduzido para capturar mais rápido (ms)
const int INTERVALO_LEITURA = 50;    // Lê sensor a cada 50ms

// ========== FUNÇÃO DE INTERRUPÇÃO ==========
// Esta função é chamada AUTOMATICAMENTE pelo hardware quando o PIR detecta movimento
void interrupcaoMovimento() {
  unsigned long agora = millis();
  
  // Debounce: ignora se a última interrupção foi muito recente
  if (agora - ultimaInterrupcao > DEBOUNCE) {
    movimentoDetectado = true;
    ultimaInterrupcao = agora;
  }
}

// ========== CONFIGURAÇÃO INICIAL ==========
void setup() {
  // Inicia comunicação serial
  Serial.begin(9600);
  
  // Configura pinos
  pinMode(BUZZER, OUTPUT); 
  pinMode(LED, OUTPUT);    
  pinMode(PIR, INPUT);
  
  // Configura interrupção: quando PIR vai de LOW para HIGH (RISING), chama interrupcaoMovimento()
  attachInterrupt(digitalPinToInterrupt(PIR), interrupcaoMovimento, RISING);
  
  Serial.println("==================================");
  Serial.println("Sistema de Alarme Iniciado!");
  Serial.println("Modo HIBRIDO: Interrupcao + Polling");
  Serial.println("PIR HC-SR501 tem delay fisico");
  Serial.println("==================================");
}

// ========== LOOP PRINCIPAL ==========
void loop() {
  unsigned long agora = millis();
  
  // Lê estado do sensor PIR continuamente para debug e detecção de borda
  estadoPIR = digitalRead(PIR);
  
  // Detecta transição LOW -> HIGH manualmente (complementa a interrupção)
  if (estadoPIR == HIGH && estadoPIRAnterior == LOW) {
    unsigned long tempoDesdeUltimaDeteccao = agora - ultimaInterrupcao;
    Serial.print("Transicao detectada! Tempo desde ultima: ");
    Serial.print(tempoDesdeUltimaDeteccao);
    Serial.println("ms");
    
    if (tempoDesdeUltimaDeteccao > DEBOUNCE) {
      movimentoDetectado = true;
      ultimaInterrupcao = agora;
      contadorDeteccoes++;
    }
  }
  
  estadoPIRAnterior = estadoPIR;
  
  // Verifica se movimento foi detectado
  if (movimentoDetectado) {
    movimentoDetectado = false;  // Reseta a flag
    Serial.print(">>> MOVIMENTO #");
    Serial.print(contadorDeteccoes);
    Serial.println(" DETECTADO! <<<");
    
    // RETRIGGERING: Se alarme já está ativo, renova o tempo
    if (alarmeAtivo) {
      Serial.println("ALARME RENOVADO!");
    }
    
    alarmeAtivo = true;
    tempoInicioAlarme = agora;  // Sempre atualiza o tempo
  }
  
  // Gerencia o alarme se estiver ativo
  if (alarmeAtivo) {
    // Verifica se já passou o tempo de duração do alarme
    if (agora - tempoInicioAlarme >= DURACAO_ALARME) {
      alarmeAtivo = false;
      digitalWrite(BUZZER, LOW);
      digitalWrite(LED, LOW);
      Serial.println("Alarme desativado");
      Serial.println("----------------------------------");
    } 
    else {
      // Pisca LED e buzzer
      if (agora - tempoUltimaPiscada >= INTERVALO_PISCADA) {
        tempoUltimaPiscada = agora;
        estadoLED = !estadoLED;  // Inverte estado
        digitalWrite(BUZZER, estadoLED);
        digitalWrite(LED, estadoLED);
      }
    }
  }
  
  // Debug: mostra estado do sensor a cada segundo
  static unsigned long ultimoDebug = 0;
  if (agora - ultimoDebug >= 1000) {
    ultimoDebug = agora;
    Serial.print("PIR: ");
    Serial.print(estadoPIR ? "HIGH" : "LOW");
    Serial.print(" | Alarme: ");
    Serial.println(alarmeAtivo ? "ATIVO" : "inativo");
  }
  
  delay(INTERVALO_LEITURA);  // Pequeno delay para não sobrecarregar
}
//*********************************************************************************
