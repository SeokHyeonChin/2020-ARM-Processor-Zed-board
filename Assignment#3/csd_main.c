int csd_main()
{
	unsigned int* sw_data_addr = (unsigned int*)0x41210000;
	int sw_data = *sw_data_addr;

	if(sw_data>=128)		//if SW7 is on
		return 0x00FFFFFF;	//makes roughly 100ms loop
	else if(sw_data>=64)	//if SW6 is on
		return 0x03FFFFFF;	//makes roughly 200ms loop
	else if(sw_data>=32)	//if SW5 is on
		return 0x06FFFFFF;	//makes roughly 300ms loop
	else if(sw_data>=16)	//if SW4 is on
		return 0x09FFFFFF;	//makes roughly 400ms loop
	else if(sw_data>=8)		//if SW3 is on
		return 0x0CFFFFFF;	//makes roughly 500ms loop
	else if(sw_data>=4)		//if SW2 is on
		return 0x0FFFFFFF;	//makes roughly 600ms loop
	else if(sw_data>=2)		//if SW1 is on
		return 0x12FFFFFF;	//makes roughly 700ms loop
	else if(sw_data==1)		//if SW0 is on
		return 0x15FFFFFF;	//makes roughly 800ms loop

	return 0x1BFFFFFF;		//makes roughly 1s loop if all switches are off
}
