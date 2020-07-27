int as4_main(int r0)
{
	int input_data = r0;

	if(input_data=='1')		//if input data is 1
		return 0x00FFFFFF;	//makes roughly 100ms loop
	else if(input_data=='2')	//if input data is 2
		return 0x03FFFFFF;	//makes roughly 200ms loop
	else if(input_data=='3')	//if input data is 3
		return 0x06FFFFFF;	//makes roughly 300ms loop
	else if(input_data=='4')	//if input data is 4
		return 0x09FFFFFF;	//makes roughly 400ms loop
	else if(input_data=='5')	//if input data is 5
		return 0x0CFFFFFF;	//makes roughly 500ms loop
	else if(input_data=='6')	//if input data is 6
		return 0x0FFFFFFF;	//makes roughly 600ms loop
	else if(input_data=='7')	//if input data is 7
		return 0x12FFFFFF;	//makes roughly 700ms loop
	else if(input_data=='8')	//if input data is 8
		return 0x1BFFFFFF;	//makes roughly 1s loop
	return 1;		//wrong input
}
