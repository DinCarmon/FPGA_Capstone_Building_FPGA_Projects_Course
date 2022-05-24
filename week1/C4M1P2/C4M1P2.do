onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE10_LITE_Golden_Top/u1/SW
add wave -noupdate /DE10_LITE_Golden_Top/u1/HEX0
add wave -noupdate /DE10_LITE_Golden_Top/u1/HEX1
add wave -noupdate /DE10_LITE_Golden_Top/u1/V
add wave -noupdate /DE10_LITE_Golden_Top/u1/A
add wave -noupdate /DE10_LITE_Golden_Top/u1/D0
add wave -noupdate /DE10_LITE_Golden_Top/u1/z
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 287
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {822 ns}
