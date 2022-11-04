char lcdLine1[16];                       // memory for lcd line 1
char lcdLine2[16];                       // memory for lcd line 2
//
// Display Commands
//
#define	COMMAND		0xFE		// Command Code
#define	CLEARDISP	0x01		// Clear the display
#define	CURSORHOME	0x02		// Send the cursor home
#define	CURSORRIGHT	0x14		// Move the cursor right one position
#define	CURSORLEFT	0x10		// Move cursor left one position
#define	SCROLLRIGHT	0x1C		// Scroll the display right
#define	SCROLLLEFT	0x18		// Scroll the display left
#define	DISPLAYON	0x0C		// Turn the display on
#define DISPLAYOFF	0x08		// Turn the display off
#define	UCURSORON	0x0E		// Turn underline cursor on
#define UCURSOROFF	0x0C		// Turn underline cursor off
#define	BOXCURSORON	0x0D		// Turn box cursor on
#define	BOXCURSOROFF	0x0C		// Turn box cursor off
#define	LINE1		0x80		// Row 1 COl 1 Address
#define	LINE2		0xC0		// Row 2 COl 1 Address
#define	RESET		0x12		// Reset code, send at 9600 baud immediately after POR
//
// Configuration Commands
//
#define	CONFIG		0x7C		// Configuration Code
#define	B2400		0x0B		// Set 2400  baud
#define B4800		0x0C		// Set 4800  baud
#define	B9600		0x0D		// Set 9600  baud
#define B144K		0x0E		// Set 14400 baud
#define	B192K		0x0F		// Set 19200 baud
#define B384K		0x10		// Set 38400 baud
#define SAVESPLASH	0x0A		// Save a new splash message
#define	TOGGLESPLASH	0x09		// Toggle splash screen on and off
#define	BACKLIGHTOFF	0x80		// Turn the backlight off
#define	BACKLIGHTMED	0x8F		// Turn the backlight to 50%
#define BACKLIGHTHIGH	0x9D		// Turn the backlight to 100%
//
// Misc Defines
//
#define	LCDTYPE		0x03		// Type 2 line x 16 characters
#define	LCDDelay	0x10		// General delay timer
#define	LCDDelay2	0x200		// Scroll timer

void setupLCD(){
  Serial1.begin(9600);                   // setup communication with serial LCD and wait 500ms before sending data to it                          // delay recommended time
  Serial1.write(RESET);			 // Restart from unknown condition
  Serial1.write(CONFIG);
  Serial1.write(B384K);
  delay(LCDDelay);
  Serial1.begin(38400);
  delay(LCDDelay);
  LCDClear();	
}

void LCDClear()
{
  Serial1.write(COMMAND);
  Serial1.write(CLEARDISP);		// Clear the display
  delay(LCDDelay);
}

/* clears the serial LCD */
void clearLCD(){
  Serial1.print(F("                "));
  Serial1.print(F("                "));
}

void writeConstantThroughLCD(){
  clearLCD();
  firstLCDLine();
  printVersionf(); 
  secondLCDLine();
  Serial1.print(F(">>constthru mode"));  
}

void writePassThroughLCD(){
  clearLCD();
  firstLCDLine();
  printVersionf(); 
  secondLCDLine();
  Serial1.print(F(">>passthru mode"));
}

void writeZStackLCD(){
  clearLCD();
  firstLCDLine();
  printVersionf();
  secondLCDLine();
  Serial1.print(F(">>zStack ready"));
}

void writePrintingLCD(){
  clearLCD();
  firstLCDLine();
  printVersionf();
  secondLCDLine();
  Serial1.print(F(">>printing data"));
}

void writeTriggerThroughLCD(){
  clearLCD();
  firstLCDLine();
  printVersionf(); 
  secondLCDLine();
  Serial1.print(F(">>TTLtriggerMode"));  
}

void printVersionf(){
  Serial1.print(F("fchang v20150307")); 
}

void firstLCDLine(){
  Serial1.write(254);
  Serial1.write(128);
}

void secondLCDLine(){
  Serial1.write(254);
  Serial1.write(192);  
}

void errorMsg(){
  clearLCD();
  firstLCDLine();
  Serial1.print(F("error in serial")); 
}






