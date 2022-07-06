// file: param.v
`ifndef CPU_PARAM
`define CPU_PARAM
    `define ADD     'b000
    `define SUB     'b001
    `define AND     'b010
    `define OR      'b011
    `define XOR     'b100
    `define SLL     'b101
    `define SRL     'b110
    `define SRA     'b111
    `define SLT     'b1000
    `define SLTU    'b1001

    `define RF_MUX_pc4   'b000
    `define RF_MUX_alu   'b001
    `define RF_MUX_sext  'b002
    `define RF_MUX_dram  'b003
    `define RF_MUX_sext2 'b004
`endif