int time = 0;			// set global variable for time(Second)
int a[5];				// set array variable for return - Each digit of Hour, Minute, Second

int* as7_main()
{
	int hour, min, sec;	// set local variable for Hour, Minute, Second

	time++;				// time(Second) plus 1

	min = time / 60;
	hour = min / 60;	// set value of hour
	min = min % 60;		// set value of min
	sec = time % 60;	// set value of sec


	a[0] = hour / 10;	// set a[0] as 2nd digit of hour
	a[1] = hour % 10;	// set a[1] as 1st digit of hour
	a[2] = min / 10;	// set a[2] as 2nd digit of minute
	a[3] = min % 10;	// set a[3] as 2nd digit of minute
	a[4] = sec / 10;	// set a[4] as 2nd digit of second
	a[5] = sec % 10;	// set a[5] as 2nd digit of second

	return a;			// return the address of array a
}
