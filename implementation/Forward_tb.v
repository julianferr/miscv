`timescale 1 ns / 1 ps

module Forward_tb();

//inputs
reg [2:0] rs1EXtest;
reg [2:0] rs2EXtest;
reg [2:0] rdEXtest;
reg [2:0] rdMEMtest;
reg [2:0] rdWBtest;
reg [2:0] rs1test;
reg [2:0] rs2test;
reg [0:0] clock;

//outputs
wire [1:0] fwd1EXtest;
wire [1:0] fwd2EXtest;
wire [0:0] fwd3EXtest;
wire [0:0] Bfwd1test;
wire [0:0] Bfwd2test;
wire [0:0] fwdMEMtest;


Forward Forward_uut(
	.rs1EX(rs1EXtest),
	.rs2EX(rs2EXtest),
	.rdEX(rdEXtest),
	.rdMEM(rdMEMtest),
	.rdWB(rdWBtest),
	.rs1(rs1test),
	.rs2(rs2test),
	.fwd1EX(fwd1EXtest),
	.fwd2EX(fwd2EXtest),
	.fwd3EX(fwd3EXtest),
	.Bfwd1(Bfwd1test),
	.Bfwd2(Bfwd2test),
	.fwdMEM(fwdMEMtest)
);

//clockwork
parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
    clock = 0;
    forever begin
        #(HALF_PERIOD);
        clock = ~clock;
    end
end

initial begin

//Testing initilization
	$display("Testing inilitilization.");
	
	rs1EXtest = 0;
	rs2EXtest = 0;
	rs1test = 0;
	rs2test = 0;
	rdEXtest = 0;
	rdMEMtest = 0;
	rdWBtest = 0;
	
	#(2*HALF_PERIOD);
	
	repeat (8) begin
		repeat (8) begin
			repeat (8) begin
				repeat (8) begin
					repeat (8) begin
						repeat (8) begin
							repeat (8) begin
								#(2*HALF_PERIOD);
								if (rs1EXtest == rdMEMtest) begin
									if (fwd1EXtest != 0) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								
								if (rs1EXtest == rdWBtest && rs1EXtest != rdMEMtest) begin
									if (fwd1EXtest != 1) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								
								if (rs1EXtest != rdMEMtest && rs1EXtest != rdWBtest) begin
									if (fwd1EXtest != 2) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								
								if (rs2EXtest == rdMEMtest) begin
									if (fwd2EXtest != 0) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								
								if (rs2EXtest == rdWBtest && rs2EXtest != rdMEMtest) begin
									if (fwd2EXtest != 1) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								
								if (rs2EXtest != rdMEMtest && rs2EXtest != rdWBtest) begin
									if (fwd2EXtest != 2) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rdEXtest == rdWBtest) begin
									if (fwd3EXtest != 0) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rdEXtest != rdWBtest) begin
									if (fwd3EXtest != 1) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rdMEMtest == rdWBtest) begin
									if (fwdMEMtest != 0) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rdEXtest != rdWBtest) begin
									if (fwd3EXtest != 1) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rs1test == rdMEMtest) begin
									if (Bfwd1test != 0) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rs1test != rdMEMtest) begin
									if (Bfwd1test != 1) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rs2test == rdMEMtest) begin
									if (Bfwd2test != 0) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
								if (rs2test != rdMEMtest) begin
									if (Bfwd2test != 1) begin
										failures = failures + 1;
										$display("Fail here: rs1: %d, rs2: %d, rd: %d, rdMEM: %d, rdWB: %d, fwd1: %d", rs1EXtest, rs2EXtest, rdEXtest, rdMEMtest, rdWBtest, fwd1EXtest);
									end
								end
							rs1test = rs1test + 1;
							end
							
						rs2test = rs2test + 1;
						end
						
					rs1EXtest = rs1EXtest + 1;
					end
					
				rs2EXtest = rs2EXtest + 1;
				end
				
			rdEXtest = rdEXtest + 1;
			end
			
		rdMEMtest = rdMEMtest + 1;
		end
		
	rdWBtest = rdWBtest + 1;
	end
	
	$display("TESTS COMPLETE. \n Failures = %d", failures);
	$stop;
	end
endmodule
	
	
