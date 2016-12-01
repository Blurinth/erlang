%% @author Quinn
%% @doc @todo Add description to test2.


-module(test2).
-include_lib("eunit/include/eunit.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([sort/1, testlistgen/0, testgen/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

%movest biggest right, reverses list
sortbig(In) ->
	sortbig(In, [], 0).
sortbig([Big, Small | Rest], Out, Swaps) when Big > Small ->
	sortbig([Big | Rest], [Small | Out], Swaps + 1);
sortbig([Small, Big | Rest], Out, Swaps) ->
	sortbig([Big | Rest], [Small | Out], Swaps);
sortbig([Last], Out, Swaps) ->
	sortbig([], [Last | Out], Swaps);
sortbig([], Out, Swaps) ->
	{Out, Swaps}.

%moves smallest right, reverses list
sortsmall(In) ->
	sortsmall(In, [], 0).
sortsmall([Small, Big | Rest], Out, Swaps) when Small < Big ->
	sortsmall([Small | Rest], [Big | Out], Swaps + 1);
sortsmall([Big, Small | Rest], Out, Swaps) ->
	sortsmall([Small | Rest], [Big | Out], Swaps);
sortsmall([Last], Out, Swaps) ->
	sortsmall([], [Last | Out], Swaps);
sortsmall([], Out, Swaps) ->
	{Out, Swaps}.

sort(List) ->
	sort(sortbig(List), 1).
sort({List, Swaps}, 1) when Swaps > 0->
	sort(sortbig(List), 2);
sort({List, Swaps}, 2) when Swaps > 0->
	sort(sortsmall(List), 1);
sort({List, 0}, 2) ->
	sort(sortsmall(List), 1);
sort({List, 0}, 1) ->
	List.

sort_test() ->
	sort_test([[], [1],[2,1],[1,3,2]]).
sort_test([A | Tests]) ->
	Correct = lists:sort(A),
	Correct = sort(A),
	sort_test(Tests);
sort_test([]) ->
	ok.
				
testlistgen() ->
	testlistgen([], 1).
testlistgen(Out, Tests) when Tests =< 20 ->
	testlistgen([testgen(rand:uniform(11)-1) | Out], Tests + 1);
testlistgen(Out, _) ->
	Out.
testgen(Max_size) ->
	testgen([], Max_size - 1, 0).
testgen(Out, Max_size, _) when Max_size == 0 ->
	Out;
testgen(Out, Max_size, Current_size) when Current_size =< Max_size ->
	testgen([rand:uniform(11)-1 | Out], Max_size, Current_size + 1);
testgen(Out, _, _) ->
	Out.






				
				
				