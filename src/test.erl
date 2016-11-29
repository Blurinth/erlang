%% @author Quinn
%% @doc @todo Add description to test.


-module(test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([getDigitsX/1, getDigits/1, count/1, count/0, reverseList/1, sort1/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

getDigitsX(N) when N > 10 ->
	io:format("~p ~n", [N rem 10]),
	test:getDigitsX(N div 10);
getDigitsX(N) ->
	io:format("~p ~n", [N]).

count(0) -> 
	ok;
count(N) ->
	io:format("~p ~n", [N]),
	count(N-1).
count() -> 
	count(10).

getDigits(N) ->
	getDigits2(N, []);
getDigits(0) ->
	[0].
getDigits2(0, L) ->
	L;
getDigits2(N, L) ->
	getDigits2(N div 10, [N rem 10 | L]).

reverseList(L) ->
	reverseList(L, []).
reverseList([A | B], L2) ->
	reverseList(B, [A | L2]);
reverseList([], L2) ->
	L2.

sort1(L) ->
	sort1(L, []).
sort1([A, B | C], D) when A > B ->
	sort1([A | C], [B | D]);
sort1([A, B | C], D) ->
	sort1([B | C], [A| D]);
sort1([A], B) ->
	sort1([], [A | B]);
sort1([], A) ->
	reverseList(A).

%sort1([A, B], S) ->
%	if
%		A > B -> sort1([], [B, A | S]);
%		true -> sort1([], [A, B | S])
%	end;
%sort1([A], [B | C]) ->
%	if
%		A > B -> sort1([], [B, A | C]);
%		true -> sort1([], [A, B | C])
% 	end;
%sort1([A, B | C], D) ->
%	if
%		A > B -> sort1(C, [B, A | D]);
%		true -> sort1(C, [A, B | D])
%	end;
%sort1([A | B], [C | D]) ->
%	if
%		A > C -> sort1(B, [C, A | D]);
%		true -> sort1(B, [A, C | D])
%	end;
%sort1([], S) ->
%	S.








		  



	
