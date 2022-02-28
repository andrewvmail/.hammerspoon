hs.grid.ui.textSize = 50
hs.grid.setGrid('10x5')
hs.grid.setMargins('0x0')
hs.grid.HINTS = 
{ 
	{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, 
	{ "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" }, 
	{ "A", "S", "D", "F", "G", "H", "J", "K", "L", ";" }, 
	{ "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/" } 
}
hs.hotkey.bind({'cmd'}, 'h', hs.grid.show)