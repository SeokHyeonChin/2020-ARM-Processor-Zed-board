unsigned volatile char * gpio_led = (unsigned char *) 0x41200000;

int csd_main()
{
 int count;
 int LED_no;

 for(LED_no=1; LED_no<=128; LED_no*=2)
 {
	 for (count=0; count < 0x3C0000; count++);	// Makes 1 second time interval
	 *gpio_led = LED_no;						// Turns on LED from LD0 to LD7
 }

 return 0;
}
