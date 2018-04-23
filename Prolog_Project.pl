%   KNOWLEDGE BASE 
team(realmadrid, madrid).
team(juventus, torino).
team(galatasaray, istanbul).
team(kobenhavn, copenhagen).
team(manutd, manchester).
team(realsociedad, sansebastian).
team(shaktard, donetsk).
team(bleverkusen, bleverkusen).
team(omarseille, marseille).
team(arsenal, london).
team(fcnapoli, napoli).
team(bdortmund, dortmund).

match(1, galatasaray, 1, realmadrid, 6).
match(1, kobenhavn, 1, juventus, 1).
match(1, manutd, 4, bleverkusen, 2).
match(1, realsociedad, 0, shaktard, 2).
match(1, omarseille, 1, arsenal, 2).
match(1, fcnapoli, 2, bdortmund, 1).

match(2, juventus, 2, galatasaray, 2).
match(2, realmadrid, 4, kobenhavn, 0).
match(2, shaktard, 2, manutd, 3).
match(2, bleverkusen, 1, realsociedad, 1).
match(2, bdortmund, 3, omarseille, 0).
match(2, arsenal, 2, fcnapoli, 0).

match(3, galatasaray, 3, kobenhavn, 1).
match(3, realmadrid, 2, juventus, 1).
match(3, manutd, 1, realsociedad, 0).
match(3, bleverkusen, 4, shaktard, 0).
match(3, omarseille, 1, fcnapoli, 2).
match(3, arsenal, 1, bdortmund, 2).

match(4, kobenhavn, 1, galatasaray, 0).
match(4, juventus, 2, realmadrid, 2).
match(4, bleverkusen, 0, manutd, 5).
match(4, shaktard, 4, realsociedad, 0).
match(4, fcnapoli, 4, omarseille, 2).
match(4, bdortmund, 0, arsenal, 1).

match(5, realmadrid, 4, galatasaray, 1).
match(5, juventus, 3, kobenhavn, 1).
match(5, realsociedad, 0, manutd, 0).
match(5, shaktard, 0, bleverkusen, 0).
match(5, bdortmund, 3, fcnapoli, 1).
match(5, arsenal, 2, omarseille, 0).

match(6, galatasaray, 1, juventus, 0).
match(6, kobenhavn, 0, realmadrid, 2).
match(6, manutd, 1, shaktard, 0).
match(6, realsociedad, 2, bleverkusen, 0).
match(6, omarseille, 1, bdortmund, 2).
match(6, fcnapoli, 2, arsenal, 0).

list_length([], 0 ).                                                            % This  section find the length of list.
list_length([_|X] , L ) :- list_length(X,N) , L is N+1 .

sum_list([], 0).                                                                % This  section find the sum of elements of the list.
sum_list([H|T], Sum) :-
   sum_list(T, Rest),
   Sum is H + Rest.

pair_sort(L,Sorted):-                                                           % This  section sort pairs
        sort(1,@>=, L, Sorted).

take(N, _, Xs) :- N =< 0, N =:= 0, Xs = [].                                     % This  section take the first N element of a list.
take(_, [], []).
take(N, [X|Xs], [X|Ys]) :- M is N-1, take(M, Xs, Ys).

allTeams(List,Number) :-                                                         % This  section write teams as list and lenght of the list.
    findall(X, team(X, _), UnsortedList),
    permutation(UnsortedList,List),
    list_length(List,Number).


wins(T,W,L,N) :-                                                                 % This  section write wins in the week which you enter.
    findall(X,(match(W,T,Y,X,Z),Y>Z),L1),
    findall(X,(match(W,X,Y,T,Z),Y<Z),L2),
    append(L1,L2,L),
    list_length(L,N).
    
losses(T,W,L,N) :-                                                               % This  section write losses in the week which you enter.% This  section
    findall(X,(match(W,T,Y,X,Z),Y<Z),L1),
    findall(X,(match(W,X,Y,T,Z),Y>Z),L2),
    append(L1,L2,L),
    list_length(L,N).

draws(T,W,L,N) :-                                                                % This  section write draws in the week which you enter.
    findall(X,(match(W,T,Y,X,Z),Y=Z),L),
    list_length(L,N).

scored(T,W,S) :-                                                                 % This  section write score of a team if you enter a team and a week.
        findall(X,(match(V,T,X,_,_),V=<W),L1),
        findall(X,(match(V,_,_,T,X),V=<W),L2),
        append(L1,L2,L),
        sum_list(L,S).
    

conceded(T,W,C)  :-                                                              % This  section write concede of a team if you enter a team and a week.
        findall(X,(match(V,T,_,_,X),V=<W),L1),
        findall(X,(match(V,_,X,T,_),V=<W),L2),
        append(L1,L2,L),
        sum_list(L,C).


average(T,W,A) :-                                                                % This  section write average (score - concede) of a team if you enter a team and a week.
        findall(X,(match(V,T,X,_,_),V=<W),L1),
        findall(X,(match(V,_,_,T,X),V=<W),L2),
        append(L1,L2,L),
        sum_list(L,S),

        findall(X,(match(V,T,_,_,X),V=<W),L3),
        findall(X,(match(V,_,X,T,_),V=<W),L4),
        append(L3,L4,L5),
        sum_list(L5,C),

        A is S - C.

order(L,W) :-                                                                % This  section write teams sorted acording to their average as a list.
        findall(X,(match(W,L,Y,_,Z),average(L,W,X)),L1),                     
        findall(X,(match(W,_,Y,L,Z),average(L,W,X)),L2),
        append(L1,L2,L3),
        findall(T,match(W,T,X,_,_),L4),
        findall(T,match(W,_,_,T,X),L5),
        append(L4,L5,L6),
        pairs_keys_values(P, L3, L6),                                        %I used it to keep two list as pairs in one list.
        pair_sort(P,SortedP),                                                %sorting pairs.
        msort(L3,L3sort),                                                    %sorting average list.
        reverse(L3sort,L7),
        pairs_keys_values(SortedP,L7, L).

topThree(L,W) :-                                                              % This  section write first three teams sorted acording to their average as a list.
        findall(X,(match(W,L,Y,_,Z),average(L,W,X)),L1),
        findall(X,(match(W,_,Y,L,Z),average(L,W,X)),L2),
        append(L1,L2,L3),
        findall(T,match(W,T,X,_,_),L4),
        findall(T,match(W,_,_,T,X),L5),
        append(L4,L5,L6),
        pairs_keys_values(P, L3, L6),
        pair_sort(P,SortedP),
        msort(L3,L3sort),
        reverse(L3sort,L7),
        pairs_keys_values(SortedP,L7, L8),                                     %until this line this part the same as order section.
        take(3,L8,L).                                                          %I take the most three successfull teams.




        