module rx (
    input logic clk, // entrada do clk
    input logic rst, // entrada do reset
    input logic en_rx, // enable para recebimento
    input logic tick_rate, // tick rate

    input logic data_in, // entrada de dados que vem por um fio

    output logic [7:0] data_out, // saida de dados para um buffer de 1 byte
    output logic done_rx, // saida para indicar que o recebimento foi concluido
    output logic parity_error // bit de paridade de erro
);

// 1. Definindo parâmetros e registradores para FSM
parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
reg [1:0] state, next;                  // dois registradores de dois bits para cada estado: atual e próximo
reg [3:0] bit_count;                    // contador de bits de dados (0-7)
reg [3:0] tick_counter;                 // contador de ticks (para sampling no meio do bit)
reg [7:0] read_data;                    // registro temporário para dados lidos
reg received_parity;                    // bit de paridade recebido
reg done_rx;                            // flag de conclusão


// 2. Sincronização do sinal de entrada (debouncing)
reg rs232_t, rs232_t1, rs232_t2;
always@ (posedge clk or negedge rst) begin
    if (! rst) begin
        rs232_t <= 1'b1;
        rs232_t1 <= 1'b1;
        rs232_t2 <= 1'b1;
    end
    else begin
        rs232_t <= data_in;
        rs232_t1 <= rs232_t;
        rs232_t2 <= rs232_t1;
    end
end

// 3. FSM - Atualização do estado
always @ (posedge clk or negedge rst) begin
    if (!rst)
        state <= IDLE;
    else
        state <= next;
end

// 4. Lógica combinacional - Decisão do próximo estado
always @ (state or rs232_t2 or en_rx or tick_counter) begin
    case(state)
        IDLE:
            if(!rs232_t2 && en_rx)
                next = START;
            else
                next = IDLE;
        START:
            if(tick_counter == 4'b1111)
                next = DATA;
            else
                next = START;
        DATA:
            if(bit_count == 4'b1000 && tick_counter == 4'b1111)
                next = STOP;
            else
                next = DATA;
        STOP:
            if(tick_counter == 4'b1111)
                next = IDLE;
            else
                next = STOP;
        default:
            next = IDLE;
    endcase
end

// 5. Lógica de recepção - Executa a cada tick_rate
always @ (posedge tick_rate) begin
    if (state != IDLE) begin
        tick_counter <= tick_counter + 1;
        
        if (state == START && tick_counter == 4'b1111) begin
            tick_counter <= 4'b0000;
            bit_count <= 4'b0000;
        end
        
        if (state == DATA && tick_counter == 4'b1111) begin
            bit_count <= bit_count + 1;
            tick_counter <= 4'b0000;
        end
        
        if (state == STOP && tick_counter == 4'b0111) begin
            received_parity <= rs232_t2;
        end
        
        if (state == STOP && tick_counter == 4'b1111) begin
            done_rx <= 1'b1;
            tick_counter <= 4'b0000;
        end
    end
    else begin
        tick_counter <= 4'b0000;
        done_rx <= 1'b0;
    end
end

/*data_out*/
always@ (posedge clk or negedge rst) begin
    if (! rst) // se reset ativo então a saída é nível lógico 0
        data_out <= 'd0;
    else if(state == DATA)begin // se disponivel para leitura
        if(tick_counter == 4'b1111) begin 
            case(bit_count) // atribui os bits a data_out
                4'd0: data_out [0] <= rs232_t2;
                4'd1: data_out[1] <= rs232_t2;
                4'd2: data_out[2] <= rs232_t2;
                4'd3: data_out[3] <= rs232_t2;
                4'd4: data_out[4] <= rs232_t2;
                4'd5: data_out[5] <= rs232_t2;
                4'd6: data_out[6] <= rs232_t2;
                4'd7: data_out[7] <= rs232_t2;
                default:data_out <= data_out;
            endcase
            end
        end
    else
        data_out <= data_out;
end

// Sinal do BIT PARIDADE PAR
// Se a contagem original de bits '1' na mensagem for ímpar, o bit de paridade é definido como 1 para tornar o total par;
// se a contagem original for par (ou nula), o bit de paridade é definido como 0.
// XOR : a saída é 1 se a quantidade for 1 -> O ^ 1 = 1  |  1 ^1 = 0 
// Se encadear operações XOR ele só retorna 1 se a quantidade de bits for impar
// O operador unário ^ realiza o XOR entre todos os bits do vetor
assign parity_error = (received_parity != ^data_out[7:0]);  // comparar com os 8 bits recuperados

endmodule