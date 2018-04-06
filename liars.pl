/*
                            Logic Programming
                                Exercise 2
                                                                        */

/*                                liars                                 */

/* Find the maximum integer in a list with value lower than that of a given integer */
find_max_under([], Curr_max, _, Curr_max).

find_max_under([Value | T], Curr_max, Ceil, Max) :-
    Value < Ceil,
    Value > Curr_max,
    find_max_under(T, Value, Ceil, Max).

find_max_under([_ | T], Curr_max, Ceil, Max) :-
    find_max_under(T, Curr_max, Ceil, Max).

/* Count how many integers in a list are greater than that of a given integer */
count_greater_than([], Curr_count, _, Curr_count).

count_greater_than([Value | T], Curr_count, Min, Count) :-
    Value > Min,
    New_count is Curr_count + 1,
    count_greater_than(T, New_count, Min, Count).

count_greater_than([_ | T], Curr_count, Min, Count) :-
    count_greater_than(T, Curr_count, Min, Count).

/* Make a list that contains only zeroes (the answer if nobody is a liar)*/
make_truthlist([], Curr_L, Curr_L).

make_truthlist([_ | T], Curr_L, Truth_L) :-
    append(Curr_L, [0], New_L),
    make_truthlist(T, New_L, Truth_L).

/* Make the list that contains the answer to the liars problem */
make_liarlist([], _, Curr_L, Curr_L).

make_liarlist([Person | T], Min, Curr_L, Liar_L) :-
    Person > Min,
    append(Curr_L, [1], New_L),
    make_liarlist(T, Min, New_L, Liar_L).

make_liarlist([_ | T], Min, Curr_L, Liar_L) :-
    append(Curr_L, [0], New_L),
    make_liarlist(T, Min, New_L, Liar_L).

/* Decide whether to stop the algorithm (recirsion) or keep going */

/* The Up_max value is the current lowest value of a liar's statement and the Down_max
   value is the current biggest value of a truth-teller's statement, so if at any
   time, the number of liars is lower than Up_max and and more than or equal to
   Down_max, a correct solution has been found. (Down_max <= Liar_num < Up_max) */

/* In this case it is impossible to determine whether anyone is a liar or not
   so stop the recursion */
rec_decision(_, Up_max, _, Liar_num, []) :-
    Liar_num >= Up_max.

/* In this case a correct solution has been found, so return it (make_liarlist) */
rec_decision(People, _, Down_max, Liar_num, Liars) :-
    Liar_num >= Down_max,
    make_liarlist(People, Down_max, [], Liars).

/* In this case a correct solution has not been found yet, so continue the recursion */
rec_decision(People, _, Down_max, _, Liars) :-
    find_liars(People, Down_max, Liars).


/* Find liars */
find_liars(People, Up_max, Liars) :-
    find_max_under(People, 0, Up_max, Down_max),
    count_greater_than(People, 0, Down_max, Liar_num),
    rec_decision(People, Up_max, Down_max, Liar_num, Liars).


/* Decide whether there are any liars in the group */
liar_decision(People, Liars) :-
    length(People, People_num),
    Starting_max is People_num + 1,
    find_max_under(People, 0, Starting_max, _),
    /* If liars exist in the group, find them */
    find_liars(People, Starting_max, Liars).

/* Else if there are no liars, return the result */
liar_decision(People, Liars) :-
    length(People, People_num),
    Starting_max is People_num + 1,
    find_max_under(People, 0, Starting_max, 0),
    make_truthlist(People, [], Liars).

/* liars */
liars(People, Liars) :-
    liar_decision(People, Liars), !,
    /* If the length of the Liars list is 0, then a correct solution cannot be found */
    length(Liars, Liar_length),
    Liar_length > 0.
