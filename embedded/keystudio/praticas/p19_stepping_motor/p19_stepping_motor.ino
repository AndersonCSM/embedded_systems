/*
 * =================================================================================
 * Prática 19 - Motor de Passo (Stepper Motor)
 * =================================================================================
 *
 * Descrição:
 *   Controla um motor de passo 28BYJ-48 utilizando o driver ULN2003.
 *   O motor realiza uma volta completa em um sentido, aguarda 1 segundo,
 *   e então realiza uma volta completa no sentido oposto, repetindo continuamente.
 *
 * Hardware:
 *   - Motor de passo 28BYJ-48 (unipolar, 4 fases)
 *   - Módulo driver ULN2003 (amplifica os sinais do microcontrolador)
 *   - Conexões: Pinos 21, 20, 19, 18 do microcontrolador → IN1-IN4 do ULN2003
 *
 * Funcionamento do motor 28BYJ-48:
 *   - Possui uma redução interna de 64:1
 *   - São necessários 32 passos para uma volta interna do motor
 *   - Portanto, 32 × 64 = 2048 passos = 1 volta completa do eixo externo
 *
 * Técnica utilizada: Acionamento por passo completo (full-step)
 *   - Apenas uma bobina é energizada por vez
 *   - Sequência: 0001 → 0010 → 0100 → 1000 (sentido horário)
 *   - Sequência: 1000 → 0100 → 0010 → 0001 (sentido anti-horário)
 *
 * Autor: http://www.keyestudio.com
 * =================================================================================
 */

#include <Stepper.h>

// ---------------------------------------------------------------------------------
// Pinos de saída conectados ao driver ULN2003 (IN1 a IN4)
// Cada pino controla uma das 4 bobinas do motor de passo
// ---------------------------------------------------------------------------------
int outPorts[] = {21, 20, 19, 18};

// =================================================================================
// setup() - Configuração inicial (executada uma vez ao ligar/resetar)
// =================================================================================
void setup() {
  // Configura os 4 pinos como saída digital para enviar sinais ao driver
  for (int i = 0; i < 4; i++) {
    pinMode(outPorts[i], OUTPUT);
  }
}

// =================================================================================
// loop() - Laço principal (executado continuamente)
// =================================================================================
void loop()
{
  // Gira uma volta completa no sentido horário (2048 passos = 32 * 64)
  // O terceiro parâmetro (3 ms) define o intervalo entre passos → velocidade máxima
  moveSteps(true, 32 * 64, 3);
  delay(1000);  // Aguarda 1 segundo

  // Gira uma volta completa no sentido anti-horário
  moveSteps(false, 32 * 64, 3);
  delay(1000);  // Aguarda 1 segundo
}

// =================================================================================
// moveSteps() - Move o motor um número específico de passos
// ---------------------------------------------------------------------------------
// Parâmetros:
//   dir   : sentido de rotação (true = horário, false = anti-horário)
//   steps : quantidade de passos a executar (2048 = volta completa)
//   ms    : intervalo entre passos em milissegundos (3 a 20 ms)
//           → 3 ms  = velocidade máxima (~10 RPM)
//           → 20 ms = velocidade mínima (~1.5 RPM)
// ---------------------------------------------------------------------------------
// Obs: O motor funciona com precisão quando ms está entre 3 e 20.
//      Valores fora dessa faixa são limitados automaticamente por constrain().
// =================================================================================
void moveSteps(bool dir, int steps, byte ms) {
  for (unsigned long i = 0; i < steps; i++) {
    moveOneStep(dir);                   // Executa um único passo
    delay(constrain(ms, 3, 20));        // Limita o delay entre 3 e 20 ms
  }
}

// =================================================================================
// moveOneStep() - Executa exatamente um passo do motor
// ---------------------------------------------------------------------------------
// Parâmetro:
//   dir : sentido de rotação (true = horário, false = anti-horário)
//
// Funcionamento:
//   Usa uma variável estática 'out' para manter o estado atual das bobinas.
//   O valor de 'out' usa os 4 bits menos significativos para representar
//   qual bobina está ativa:
//     0x01 = 0001 (bobina 1)
//     0x02 = 0010 (bobina 2)
//     0x04 = 0100 (bobina 3)
//     0x08 = 1000 (bobina 4)
//
//   A cada chamada, o bit ativo é deslocado para a próxima posição
//   (shift circular), criando o campo magnético rotativo que move o rotor.
// =================================================================================
void moveOneStep(bool dir) {
  // Variável estática: mantém o valor entre chamadas da função
  // Inicializa com 0x01 (primeira bobina ativa)
  static byte out = 0x01;

  // Desloca o bit ativo de acordo com o sentido de rotação
  if (dir) {
    // Sentido horário: shift circular para a esquerda
    // Se não chegou ao bit 4 (0x08), desloca para esquerda; senão, volta ao bit 1
    out != 0x08 ? out = out << 1 : out = 0x01;
  }
  else {
    // Sentido anti-horário: shift circular para a direita
    // Se não chegou ao bit 1 (0x01), desloca para direita; senão, volta ao bit 4
    out != 0x01 ? out = out >> 1 : out = 0x08;
  }

  // Envia o sinal para cada um dos 4 pinos de saída
  // A expressão (out & (0x01 << i)) verifica se o bit i está ativo em 'out'
  // Se estiver ativo → HIGH (bobina energizada), senão → LOW (bobina desligada)
  for (int i = 0; i < 4; i++) {
    digitalWrite(outPorts[i], (out & (0x01 << i)) ? HIGH : LOW);
  }
}

// =================================================================================
// moveAround() - Gira o motor um número inteiro de voltas completas
// ---------------------------------------------------------------------------------
// Parâmetros:
//   dir   : sentido de rotação (true = horário, false = anti-horário)
//   turns : número de voltas completas a executar
//   ms    : intervalo entre passos em milissegundos (3 a 20 ms)
// =================================================================================
void moveAround(bool dir, int turns, byte ms) {
  for (int i = 0; i < turns; i++)
    moveSteps(dir, 32 * 64, ms);  // 2048 passos por volta
}

// =================================================================================
// moveAngle() - Gira o motor por um ângulo específico em graus
// ---------------------------------------------------------------------------------
// Parâmetros:
//   dir   : sentido de rotação (true = horário, false = anti-horário)
//   angle : ângulo desejado em graus (ex: 90, 180, 270...)
//   ms    : intervalo entre passos em milissegundos (3 a 20 ms)
//
// Cálculo: passos = (ângulo × 2048) / 360
//   Exemplo: 90° → (90 × 2048) / 360 = 512 passos
// =================================================================================
void moveAngle(bool dir, int angle, byte ms) {
  moveSteps(dir, (angle * 32 * 64 / 360), ms);
}
