General Info
--------------

This assignment was done for CSC 360 - Operating Systems at the University of Victoria taught by Dr Jianping Pan in Spring 2018.

The purpose of this assignment is to become familiar with using threads, mutexes, and conditional variables. The POSIX pthread library is used for this.

In this assignment, a control system for an automated railway crossing is constructed. The design can vary. Trains have to be loaded on stations and once loaded,
can cross the railway crossing.

Simulation Rules
----------------

The rules enforced by the automated control system are:

1. Only one train is on the main track at any given time.

2. Only loaded trains can cross the main track.

3. If there are multiple loaded trains, the one with the high priority crosses.

4. If two loaded trains have the same priority, then:
(a) If they are both traveling in the same direction, the train which finished loading first gets the clearance to cross first. 
If they finished loading at the same time, the one appeared first in the input file gets the clearance to cross first.
(b) If they are traveling in opposite directions, pick the train which will travel in the direction 
opposite of which the last train to cross the main track traveled. If no trains have crossed the main track yet, the

5. Eastbound train has the priority

Logic of Code
--------------

1. The files are read one line at a time from the text file.
2. Once each line is read, the values are stored in a struct of train parameters through dynamic memory allocation.
3. The main thread waits for all the threads to finish so that it can start broadcasting to all of them to start loading
4. The logic below is implemented in a while loop in the main function which keeps looping until all trains have crossed
	a) if there are multiple loaded trains, the one with the high priority crosses
	b) if 2 trains have same priority: 1) if they are both traveling in the same direction, the train which finished loading first gets the clearance to cross first. If they finished loading at the same time, the one appeared firstin the input file gets the clearance to cross first. 2) f they are traveling in opposite directions, pick the train which will travel in the direction opposite of which the last train to cross the main track traveled. If no trains have crossed the main track yet, the Eastbound train has the priority.

*Trains which appear first in list with same priority and direction and finished loading at the same time are not coded in because the code isn't completely functional. If the code was working, the logic would be added here, and bubble sort would be used to reaarange the queue(s) before deuqueing and sending back a 'ready to cross' signal.

5. The logic in the main thread is protected by a mutex since trains are dequeued here.
6. Four queues are used to represent each station and priority.
7. The trains are added to a queue once they are done loading. This block of code uses the same mutex as the while loop in the main thread.
8. When a train is first added to the list, this is when we know we can start the dispatcher. A signal is sent to the dispatcher in order to set a 'ready to cross' signal for the train.
9. When the train gets this signal in its train thread (in another mutex), the train is ready to cross, and begins crossing.
10. Once it exits the mutex, another train can enter this mutex.


Sample Input Provided:

e 12 6
E 14 5
w 1 3
E 3 7
e 4 12
W 6 9
w 7 5

Program Output:

00:00:00.1 Train 2 is ready to go West
00:00:00.1 Train 2 is on the main track going West
00:00:00.3 Train 3 is ready to go East
00:00:00.4 Train 4 is ready to go East
00:00:00.4 Train 2 is OFF the main track after going West
00:00:00.4 Train 3 is on the main track going East
00:00:00.6 Train 5 is ready to go West
00:00:00.7 Train 6 is ready to go West
00:00:01.1 Train 3 is OFF the main track after going East
00:00:01.1 Train 5 is on the main track going West
00:00:01.2 Train 0 is ready to go East
00:00:01.4 Train 1 is ready to go East
00:00:02.0 Train 5 is OFF the main track after going West
00:00:02.0 Train 4 is on the main track going East
00:00:03.2 Train 4 is OFF the main track after going East
00:00:03.2 Train 1 is on the main track going East
00:00:03.7 Train 1 is OFF the main track after going East
00:00:03.7 Train 0 is on the main track going East
00:00:04.3 Train 0 is OFF the main track after going East
00:00:04.3 Train 6 is on the main track going West
00:00:04.8 Train 6 is OFF the main track after going West
	
Although the output isn't exactly correct, the timing system seems to be working fine. However, the order of the trains are only usually ~65% accurate. The code also hangs on certain inputs.


Code Structure
---------------

create 4 queues
initialize train struct

train thread{
	mutex1 -> conditional wait (for loading at same time)
 	mutex2 -> after loading, add train to appropriate queue
	mutex3 -> signals the 'dispatcher' while loop in main to find out which train is next to cross
	mutex3 -> if received a signal, exits while waiting loop and crosses train track
} 
main{
	read text file of trains and create the train threads
	broadcast to all trains to start loading at same time
	mutex2 -> while the trains arent all crossed, wait in while loop for signal to dequeue from a queue
}


The code should be run using the makefile. The command used in the terminal is gcc -o mts mts.c -lpthread -std=gnu99
In code also takes exactly 1 input file. To run the code, follow the following steps.

1) Type make in the terminal
2) enter ./mts trains
