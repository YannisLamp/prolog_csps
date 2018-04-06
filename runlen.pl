/*
                                Question 1
                                                                        */

decoder([], Curr_L, Curr_L).

decoder([(_, 0) | T], Curr_L, L) :-
    decoder(T, Curr_L, L).

decoder([(Obj, Times) | T], Curr_L, L) :-
    append(Curr_L, [Obj], New_L),
    New_Times is Times - 1,
    decoder([(Obj, New_Times) | T], New_L, L).

decoder([Obj | T], Curr_L, L) :-
    append(Curr_L, [Obj], New_L),
    decoder(T, New_L, L).

decode_rl(Input, L) :-
    decoder(Input, [], L).

enc_cons(Obj, [Obj | T], Times, Rem_L, Result) :-
    New_Times is Times + 1,
    enc_cons(Obj, T, New_Times, Rem_L, Result).

enc_cons(Obj, [Other | T], 0, [Other | T], Obj).

enc_cons(Obj, [Other | T], Times, [Other | T], (Obj, New_Times)) :-
    New_Times is Times + 1.

enc_cons(Obj, [], 0, [], Obj).

enc_cons(Obj, [], Times, [], (Obj, New_Times)) :-
    New_Times is Times + 1.

encoder([], Curr_L, Curr_L).

encoder([Obj | T], Curr_L, L) :-
    enc_cons(Obj, T, 0, Rem_L, Result),
    append(Curr_L, [Result], New_L),
    encoder(Rem_L, New_L, L).

encode_rl(Input, L) :-
    encoder(Input, [], L).
