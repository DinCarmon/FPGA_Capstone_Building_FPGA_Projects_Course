/*****************************************************************************
* PWM generating module, uses duty cycle value from duty_cycle module
******************************************************************************/
module pwm_gen (
	input    	clk, 
	input [2:0]	duty_cycle, 
	output reg	pwm
);

reg [2:0]	count;

initial 
begin
	count=3'b000;
	pwm=1'b0;
end

always @(posedge clk)
begin
	count = count + 1'b1;
	if (count < duty_cycle) 
		begin 
			pwm = 1'b1;
		end
	else if (count >= duty_cycle)
		begin
			pwm = 1'b0;
		end
end

endmodule
