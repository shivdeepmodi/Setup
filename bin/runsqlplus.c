#include<stdio.h>
#include <string.h>

int main(int argc,char* argv[]) 
{ 
    int counter; 
    char program1[100];
    char program1val[100];
 
    char userpass[100];
    char as1[100];
    char sysdba1[100];

    char mycommand[100] = "sqlplus ";
    //printf("Program Name Is: %s",argv[0]); 
    if(argc==1) 
        printf("\nNo Extra Command Line Argument Passed Other Than Program Name\n"); 
    if(argc>=2) 
    { 
        printf("Number Of Arguments Passed: %d\n",argc); 
        printf("----Following Are The Command Line Arguments Passed----\n"); 
        for(counter=0;counter<argc;counter++) 
            printf("argv[%d]: %s\n",counter,argv[counter]); 
    } 

   strcat(mycommand, argv[1]);
   strcat(mycommand, " ");
   strcat(mycommand, argv[2]);
   strcat(mycommand, " ");
   strcat(mycommand, argv[3]);

   printf("Command is %s:\n",mycommand);
   system(mycommand);  

   return 0; 
} 
