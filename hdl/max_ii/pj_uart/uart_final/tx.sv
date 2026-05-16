module tx (
    input logic clk, // clk do dispositivo
    input logic rst, // reset do circuito
    input logic en_tx, // transmissao habilitada
    input logic baud_rate, // baud_date da transmissão

    input logic [7:0] data_in, // entrada dos dados a serem transmitidos

    output logic data_out, // saida dos dados transmitidos interface rs232
    output logic done_tx // concluiu transmissao
);


// 1. definir fios
//Variabels used for state machine...
parameter  IDLE = 1'b0, SEND = 1'b1; 	//We haev 2 states for the State Machine state 0 and 1 (READ adn IDLE)
reg [1:0] estado, proximo;			//Create some registers for the states
reg  read_enable = 1'b0;		//Variable that will enable or NOT the data in read


reg  start_bit = 1'b1;			//Variable used to notify when the start bit was detected (first falling edge of RX)
reg  RxDone = 1'b0;			//Variable used to notify when the data read process is done

reg [4:0]Bit = 5'b00000;		//Variable used for the bit by bit read loop (in this case 8 bits so 8 loops)
reg [3:0] counter = 4'b0000;		//Counter variable used to count the tick pulses up to 16
reg [7:0] Read_data= 8'b00000000;	//Register where we store the Rx input bits before assigning it to the RxData output
reg [7:0] RxData;			//We register the output as well so we store the value

reg [7:0] data_in; // registrado para dados
reg [1:0] State, proximo; // registrado para a FSM
reg [12:0] contador_baud; // registrador para contar o baud_rate (mc)
reg bit_paridade; // bit de paridade // acho que um fio da conta, mas por questão de raciocinio deixa como reg
reg [3:0] controle_bit // até 16 bits, usado para controlar qual é o bit de data que está sendo enviado no momento pelo wire

// 2. Definindo a FSM - cada bloco possui uma FSM própria, logo aqui é a FSM TX
always @ (posedge clk or negedge rst)			//Boa prática considera o reset
    begin
        if (!rst)	
            estado <= IDLE;				// Se botão de reset ativo, vai para idle
        else 		
            estado <= SEND;				// Senão, vai para o próximo estado
    end

// 3. garantir condições de sincroniza

// 4. se tudo ok, data_in encaminha os bits para data_out + bit_paridade
/* interface rs232 para transmissão de dados em linha em um único fio*/
always@ (posedge clk or negedge rst) begin
    if (! rst) // se clicou no reset volta para idle o fio fica em 1
        data_out <= 1'b1;
    else if(estado)begin
        if(bit_flag) begin
            case(bit_cnt)
                4'd0:data_out <= 1'b0; // indica que se vai iniciar a transmissão com a queda
                4'd1:data_out <= r_data[0];
                4'd2:data_out <= r_data[1];
                4'd3:data_out <= r_data[2];
                4'd4:data_out <= r_data[3];
                4'd5:data_out <= r_data[4];
                4'd6:data_out <= r_data[5];
                4'd7:data_out <= r_data[6];
                4'd8:data_out <= r_data[7];
                4'd9:data_out <= bit_paridade;
                4'd10:data_out <= 1'b1;
                default:data_out <= 1'b1; // em idle o fio fica transmitindo em 1
            endcase
        end
    end
 else
    data_out <= 1'b1;
end

// BIT PARIDADE PAR
// Se a contagem original de bits '1' na mensagem for ímpar, o bit de paridade é definido como 1 para tornar o total par;
// se a contagem original for par (ou nula), o bit de paridade é definido como 0.
// XOR : a saída é 1 se a quantidade for 1 -> O ^ 1 = 1  |  1 ^1 = 0 
// Se encadear operações XOR ele só retorna 1 se a quantidade de bits for impar
// O operador unário ^ realiza o XOR entre todos os bits do vetor
assign bit_paridade = ^data_out;  // XOR de todos os bits = 1 se número ímpar de 1s

endmodule