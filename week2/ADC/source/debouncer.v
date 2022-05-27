module debouncer (
	input 		noisy,
	input 		clk,
	output reg 	debounced
);

	reg [7:0] shiftreg;      //shift register used to wait for stable input
	
	always @ (posedge clk) 
	begin
		shiftreg[7:0] <= {shiftreg[6:0],noisy}; //shift in the current sampled value of the noisy input
		if (shiftreg[7:0] == 8'b00000000) 
		  begin
			debounced <= 1'b1; //if all 0s, then button is being pressed
		  end 
		else if (shiftreg[7:0] == 8'b11111111) 
		  begin
			debounced <= 1'b0; //if all 1s, then button is not being pressed
		  end 
		else 
		  begin
			debounced <= debounced;
		  end
	end

endmodule
