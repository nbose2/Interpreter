#include<stdio.h>
int main(int argc, char *argv[]){
	int counter = 1;

	int a = atoi(argv[counter]); 
	counter++; 

	int b = atoi(argv[counter]); 
	counter++; 

	int sum = a + b ;

	printf("%d ", sum );

	printf("%d ", sum / 2 );
}
