/*
                            Logic Programming
                                Exercise 3
                                                                        */

							 /* dominos */

dominos([(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),
               (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
                     (2,2),(2,3),(2,4),(2,5),(2,6),
                           (3,3),(3,4),(3,5),(3,6),
                                 (4,4),(4,5),(4,6),
                                       (5,5),(5,6),
                                             (6,6)]).

							 /* frame
The solver works under the assumption that all input frames are rectangles */

frame([[3,1,2,6,6,1,2,2],
       [3,4,1,5,3,0,3,6],
       [5,6,6,1,2,4,5,0],
       [5,6,4,1,3,3,0,0],
       [6,1,0,6,3,2,4,0],
       [4,1,5,2,4,3,5,5],
       [4,1,0,2,4,5,2,0]]).

/*						Frame represetation

To solve the domino puzzle of the given frame, a starting frame represetation is made,
using make_starting_rep. The purpose of this representation is to store the current
state of the domino puzzle, to know where a domino piece was placed, or, rather,
to know whether two numbers are connected. An example of the constructed starting
representation for the above given frame (where no dimonos have been placed yet) is:

[[false, 3, false, 1, false, 2, false, 6, false, 6, false, 1, false, 2, false, 2, false],
 [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
 [false, 3, false, 4, false, 1, false, 5, false, 3, false, 0, false, 3, false, 6, false],
 [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
 [false, 5, false, 6, false, 6, false, 1, false, 2, false, 4, false, 5, false, 0, false],
 [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
 [false, 5, false, 6, false, 4, false, 1, false, 3, false, 3, false, 0, false, 0, false],
 [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
 [false, 6, false, 1, false, 0, false, 6, false, 3, false, 2, false, 4, false, 0, false],
 [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
 [false, 4, false, 1, false, 5, false, 2, false, 4, false, 3, false, 5, false, 5, false],
 [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
 [false, 4, false, 1, false, 0, false, 2, false, 4, false, 5, false, 2, false, 0, false]]

 False means that there is no connection between two numbers vertically, or Horizontally.
 After each row of the frame except the last, a new one is made, in order to store vertical connections
 between two numbers */

/*						place_domino

Place_domino takes a domino piece and places it in the current representation, by finding
a place for it that is not taken by another piece.
Its arguments are: 1. the domino piece, 2. the current frame representation,
3. the previous row (row that stores the connections with the previous domino row),
4. the current row, 5. the next row (row that stores the connections with the next domino row),
6. the next domino row, 7. the row after the next domino row (row that stores
the connections with the domino row after the next domino row),
8. a temporary copy of the traversed current domino row
9. a temporary copy of the traversed row that stores the connection with the next domino row,
10. the traversed represetation (after the current row is examined for matches,
the temporary copies of the traversed current domino and connection rows is added to it),
11. the output represetation */

/* Match found, end recursion and return the new representation */

/* If there is only one row */

/* A - B match*/
place_domino((A, B), [_], [], [false, A, false, B, false | R_T],
		[], [], [], Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, true, B, false | R_T], Domrow),
	append(Curr_rep, [Domrow], Rep).

/* B - A match */
place_domino((A, B), [_], [], [false, B, false, A, false | R_T],
		[], [], [], Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, true, A, false | R_T], Domrow),
	append(Curr_rep, [Domrow], Rep).

/* For the first row */
/* Horizontally */

/* A - B match*/
place_domino((A, B), [_ | Frame_T], [], [false, A, false, B, false | R_T],
		[_, false, _, false | _], _, _, Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, true, B, false | R_T], Domrow),
	append(Curr_rep, [Domrow | Frame_T], Rep).

/* B - A match */
place_domino((A, B), [_ | Frame_T], [], [false, B, false, A, false | R_T],
		[_, false, _, false | _], _, _, Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, true, A, false | R_T], Domrow),
	append(Curr_rep, [Domrow | Frame_T], Rep).

/* Vertically where the next row is the last */

/* A
   | match
   B */
place_domino((A, B), [_, _ | Frame_T], [], [false, A, false | R_T], [false, false | C_T],
		[false, B, false | _], [], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* B
   | match
   A */
place_domino((A, B), [_, _ | Frame_T], [], [false, B, false | R_T], [false, false | C_T],
		[false, A, false | _], [], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* Vertically where the next row is NOT the last */

/* A
   | match
   B */
place_domino((A, B), [_, _ | Frame_T], [], [false, A, false | R_T], [false, false | C_T],
		[false, B, false | _], [_, false | _], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* B
   | match
   A */
place_domino((A, B), [_ , _ | Frame_T], [], [false, B, false | R_T], [false, false | C_T],
		[false, A, false | _], [_, false | _], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* For the last row */
/* Horizontally */

/* A - B match */
place_domino((A, B), [_], [_, false, _, false | _], [false, A, false, B, false | R_T], [],
		[], [], Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, true, B, false | R_T], Domrow),
	append(Curr_rep, [Domrow], Rep).

/* B - A match */
place_domino((A, B), [_], [_, false, _, false | _], [false, B, false, A, false | R_T], [],
		[], [], Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, true, A, false | R_T], Domrow),
	append(Curr_rep, [Domrow], Rep).

/* For the rows in the middle (normally) */
/* Horizontally */

/* A - B match */
place_domino((A, B), [_ | Frame_T], [_, false, _, false | _], [false, A, false, B, false | R_T],
		[_, false, _, false | _], _, _, Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, true, B, false | R_T], Domrow),
	append(Curr_rep, [Domrow | Frame_T], Rep).

/* B - A match */
place_domino((A, B), [_ | Frame_T], [_, false, _, false | _], [false, B, false, A, false | R_T],
		[_, false, _, false | _], _, _, Curr_dom, _, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, true, A, false | R_T], Domrow),
	append(Curr_rep, [Domrow | Frame_T], Rep).

/* Vertically where the next row is the last */

/* A
   | match
   B */
place_domino((A, B), [_, _ | Frame_T], [_, false | _], [false, A, false | R_T], [false, false | C_T],
		[false, B, false | _], [], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* B
   | match
   A */
place_domino((A, B), [_, _ | Frame_T], [_, false | _], [false, B, false | R_T], [false, false | C_T],
		[false, A, false | _], [], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* Vertically where the next row is NOT the last */

/* A
   | match
   B */
place_domino((A, B), [_, _ | Frame_T], [_, false | _], [false, A, false | R_T], [false, false | C_T],
		[false, B, false | _], [_, false | _], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, A, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* B
   | match
   A */
place_domino((A, B), [_, _ | Frame_T], [_, false | _], [false, B, false | R_T], [false, false | C_T],
		[false, A, false | _], [_, false | _], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false, B, false | R_T], Domrow),
	append(Curr_con, [false, true | C_T], Conrow),
	append(Curr_rep, [Domrow, Conrow | Frame_T], Rep).

/* Else if there is no match, continue recursion */

/* If its the last item of the row */

/* If the next row is the last */
place_domino(Dom, [_, Con_R, Next_R], _, [false], [false],
		[false], _, Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false], Domrow),
	append(Curr_con, [false], Conrow),
	append(Curr_rep, [Domrow, Conrow], New_rep),
	place_domino(Dom, [Next_R], Con_R, Next_R, [], [], [], [], [], New_rep, Rep).

/* If there are only 2 rows left */
place_domino(Dom, [_, Con_R, Next_R, Con_R2, Next_R2], _, [false], [false],
		[false], _, Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false], Domrow),
	append(Curr_con, [false], Conrow),
	append(Curr_rep, [Domrow, Conrow], New_rep),
	place_domino(Dom, [Next_R, Con_R2, Next_R2], Con_R, Next_R, Con_R2, Next_R2, [], [], [], New_rep, Rep).

/* If there are at least 3 rows left */
place_domino(Dom, [_, Con_R, Next_R, Con_R2, Next_R2, Con_R3 | Frame_T], _, [false], [false],
		[false], _, Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [false], Domrow),
	append(Curr_con, [false], Conrow),
	append(Curr_rep, [Domrow, Conrow], New_rep),
	place_domino(Dom, [Next_R, Con_R2, Next_R2, Con_R3 | Frame_T], Con_R, Next_R, Con_R2, Next_R2, Con_R3, [], [], New_rep, Rep).

/* If it is not the last item of the row */

/* If there is only one row */
place_domino(Dom, Frame, [], [Item_1, Item_2 | R_T], [], [], [], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [Item_1, Item_2], Domrow),
	place_domino(Dom, Frame, [], R_T, [], [], [], Domrow, Curr_con, Curr_rep, Rep).

/* If its the first row and there are only 2 rows */
place_domino(Dom, Frame, [], [Item_1, Item_2 | R_T], [Con_1, Con_2 | C_T], [_, _ | NR_T], [],
		Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [Item_1, Item_2], Domrow),
	append(Curr_con, [Con_1, Con_2], Conrow),
	place_domino(Dom, Frame, [], R_T, C_T, NR_T, [], Domrow, Conrow, Curr_rep, Rep).

/* If its the first row with multiple rows remaining */
place_domino(Dom, Frame, [], [Item_1, Item_2 | R_T], [Con_1, Con_2 | C_T], [_, _ | NR_T],
		[_, _ | NC_T], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [Item_1, Item_2], Domrow),
	append(Curr_con, [Con_1, Con_2], Conrow),
	place_domino(Dom, Frame, [], R_T, C_T, NR_T, NC_T, Domrow, Conrow, Curr_rep, Rep).

/* If its the last row */
place_domino(Dom, Frame, [_, _ | PrevC_T], [Item_1, Item_2 | R_T], [], [], [],
		Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [Item_1, Item_2], Domrow),
	place_domino(Dom, Frame, PrevC_T, R_T, [], [], [], Domrow, Curr_con, Curr_rep, Rep).

/* Else, for the rows in the middle (normally) */

/* If there is only one row next */
place_domino(Dom, Frame, [_, _ | PrevC_T], [Item_1, Item_2 | R_T], [Con_1, Con_2 | C_T],
		[_, _ | NR_T], [], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [Item_1, Item_2], Domrow),
	append(Curr_con, [Con_1, Con_2], Conrow),
	place_domino(Dom, Frame, PrevC_T, R_T, C_T, NR_T, [], Domrow, Conrow, Curr_rep, Rep).

/* If there are multiple rows next */
place_domino(Dom, Frame, [_, _ | PrevC_T], [Item_1, Item_2 | R_T], [Con_1, Con_2 | C_T],
		[_, _ | NR_T], [_, _ | NC_T], Curr_dom, Curr_con, Curr_rep, Rep) :-
	append(Curr_dom, [Item_1, Item_2], Domrow),
	append(Curr_con, [Con_1, Con_2], Conrow),
	place_domino(Dom, Frame, PrevC_T, R_T, C_T, NR_T, NC_T, Domrow, Conrow, Curr_rep, Rep).


/*						solve_domino

Places all the domino pieces (calls place_domino for each domino piece, ends when all
the pieces are placed in the represetation) */

/* End recursion if there are no pieces left */
solve_domino([], Solution, Solution).

/* If the normal frame is only a single row (represetation is 1 row) */
solve_domino([Dom | Dom_T], [Row], Solution) :-
	place_domino(Dom, [Row], [], Row, [], [], [], [], [], [], New_rep),
	solve_domino(Dom_T, New_rep, Solution).

/* If the frame is 2 rows (represetation is 3 rows) */
solve_domino([Dom | Dom_T], [Row1, Row2, Row3], Solution) :-
	place_domino(Dom, [Row1, Row2, Row3], [], Row1, Row2, Row3, [], [], [], [], New_rep),
	solve_domino(Dom_T, New_rep, Solution).

/* If the frame is more than 2 rows (represetation is 5 rows minimum) */
solve_domino([Dom | Dom_T], [Row1, Row2, Row3, Row4 | Frame_T], Solution) :-
	place_domino(Dom, [Row1, Row2, Row3, Row4 | Frame_T], [], Row1, Row2, Row3, Row4, [], [], [], New_rep),
	solve_domino(Dom_T, New_rep, Solution).


/*						print_solution

Prints the represetation that is the output of solve_domino,
the domino solution of the input frame */

print_connection_row([]).

print_connection_row([true | T]) :-
	write('|'),
	print_connection_row(T).

print_connection_row([false | T]) :-
	write(' '),
	print_connection_row(T).

print_domino_row([]).

print_domino_row([true | T]) :-
	write('-'),
	print_domino_row(T).

print_domino_row([false | T]) :-
	write(' '),
	print_domino_row(T).

print_domino_row([Num | T]) :-
	write(Num),
	print_domino_row(T).

print_solution([Row]) :-
	print_domino_row(Row),
	nl.

print_solution([Dom_row, Con_row | T]) :-
	print_domino_row(Dom_row),
	nl,
	print_connection_row(Con_row),
	nl,
	print_solution(T).

/*						make_starting_rep

Generates the initial domino solution representation
False if there is not a - or a | , true otherwise */

make_empty_row([], Empty_row, Empty_row).

make_empty_row([_ | T], Curr_row, Empty_row) :-
	/* There is a false value next to the last domino number too so...*/
	append(Curr_row, [false, false], New_row),
	make_empty_row(T, New_row, Empty_row).

make_row_rep([], Row_rep, Row_rep).

/* There is a false value next to the last domino number */
make_row_rep([Num | T], Curr_row_rep, Row_rep) :-
	/* Append adds the current number in the given list and a false */
	/* There is a false value next to the last domino number */
	append(Curr_row_rep, [Num, false], New_row_rep),
	make_row_rep(T, New_row_rep, Row_rep).

make_starting_rep([Row], Curr_rep, Rep) :-
	/* There is a false value left of the first number in the row */
	make_row_rep(Row, [false], Row_rep),
	append(Curr_rep, [Row_rep], New_rep),
	append([], New_rep, Rep).

make_starting_rep([Row | T], Curr_rep, Rep) :-
	/* There is a false value left of the first number in the row */
	make_row_rep(Row, [false], Row_rep),
	/* There is a false value left of the first domino number too so...*/
	make_empty_row(Row, [false], Empty_row),
	append(Curr_rep, [Row_rep, Empty_row], New_rep),
	make_starting_rep(T, New_rep, Rep).

/*						put_dominos
If the number of given dominos is more than what is needed for the solution to the
given frame, then false is returned. If the given domino number is less, then
an incomplete solution using these input dominos is returned. */

put_dominos() :-
	dominos(Dominos),
	frame(Frame),
	make_starting_rep(Frame, [], Starting_rep), !,
	/* backtrack at solve_domino */
	solve_domino(Dominos, Starting_rep, Solution),
	print_solution(Solution).
