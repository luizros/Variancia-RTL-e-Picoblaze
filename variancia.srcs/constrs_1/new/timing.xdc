create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

create_clock -period 10.000 -name virtual_clock

set_output_delay -clock virtual_clock -2.0 [get_ports led[*]]
set_output_delay -clock virtual_clock -2.0 [get_ports ready]