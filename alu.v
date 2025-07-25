module alu(
  input  wire [11:0] alu_op,
  input  wire [31:0] alu_src1, //1：操作数1应该是32位而不是31位
  input  wire [31:0] alu_src2, //2：操作数2应该是32位而不是31位
  output wire [31:0] alu_result
);

wire op_add;     //add operation
wire op_sub;     //sub operation
wire op_slt;     //signed compared and set less than
wire op_sltu;    //unsigned compared and set less than
wire op_and;     //bitwise and
wire op_nor;     //bitwise nor
wire op_or;      //bitwise or
wire op_xor;     //bitwise xor
wire op_sll;     //logic left shift
wire op_srl;     //logic right shift
wire op_sra;     //arithmetic right shift
wire op_lui;     //Load Upper Immediate 

// control code decomposition
assign op_add   = alu_op[ 0];
assign op_sub   = alu_op[ 1];
assign op_slt   = alu_op[ 2];
assign op_sltu  = alu_op[ 3];
assign op_and   = alu_op[ 4];
assign op_nor   = alu_op[ 5];
assign op_or    = alu_op[ 6]; 
assign op_xor   = alu_op[ 7];
assign op_sll   = alu_op[ 8];
assign op_srl   = alu_op[ 9];
assign op_sra   = alu_op[10];
assign op_lui   = alu_op[11]; //3：应该用op_lui而不是op_lu12i，加载高位立即数

wire [31:0] add_sub_result;
wire [31:0] slt_result;
wire [31:0] sr_result;
wire [31:0] sltu_result;
wire [31:0] and_result;
wire [31:0] nor_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] lui_result;
wire [31:0] sll_result;
wire [63:0] sr64_result; //4：sr64_result是64位，不是65位
//wire [31:0] srl_result; 
//wire [31:0] sra_result; 

// 32-bit adder
wire [31:0] adder_a;
wire [31:0] adder_b;
wire        adder_cin;
wire [31:0] adder_result;
wire        adder_cout;

assign adder_a   = alu_src1;
assign adder_b   = adder_cin ? ~alu_src2 : alu_src2;  //src1 - src2 rj-rk //5：调换顺序
assign adder_cin = op_sub | op_slt | op_sltu;
assign {adder_cout , adder_result} = adder_a + adder_b + adder_cin; //6：最高位是进位，其余位才是相加结果，而不是所有位都是相加结果

// ADD, SUB result
assign add_sub_result = adder_result;

// SLT result
assign slt_result[31:1] = 31'b0;   //rj < rk 1
assign slt_result[0]    = (alu_src1[31] & ~alu_src2[31])
                        | ((alu_src1[31] ~^ alu_src2[31]) & adder_result[31]); 

// SLTU result
assign sltu_result[31:1] = 31'b0;
assign sltu_result[0]    = ~adder_cout; //7：进位取非

// bitwise operation
assign and_result = alu_src1 & alu_src2; //8：应该改逻辑与为按位与
assign or_result  = alu_src1 | alu_src2; //9：应该改逻辑或为按位或
assign nor_result = ~or_result;
assign xor_result = alu_src1 ^ alu_src2;
assign lui_result = alu_src2;

// SLL result
assign sll_result = alu_src1 << alu_src2[4:0];   //rj << i5 //10：操作数反了，应该对操作数1进行逻辑左移，左移位数由操作数2的低5位决定

// SRL, SRA result
assign sr64_result = {{32{op_sra & alu_src1[31]}}, alu_src1[31:0]} >> alu_src2[4:0]; //rj >> i5 //11：操作数反了，应该对操作数1进行算术右移，右移位数由操作数2的低5位决定；而且符号扩展应该选sra（因为是算术右移）而不是srl

assign sr_result   = sr64_result[31:0]; //12：sr64_result应该取低32位，而不是低31位

// final result mux
assign alu_result = ({32{op_add|op_sub}} & add_sub_result) //13：应该改逻辑或为按位或
                | ({32{op_slt       }} & slt_result) //
                | ({32{op_sltu      }} & sltu_result) //
                | ({32{op_and       }} & and_result) //
                | ({32{op_nor       }} & nor_result) //
                | ({32{op_or        }} & or_result) //
                | ({32{op_xor       }} & xor_result) //
                | ({32{op_lui       }} & lui_result) //
                | ({32{op_sll       }} & sll_result) //
                //| ({32{op_srl       }} & srl_result) //
                //| ({32{op_sra       }} & sra_result)
                | ({32{op_srl|op_sra}} & sr_result);//14：改为sr_result

endmodule
