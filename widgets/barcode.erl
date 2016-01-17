-module(barcode).
-author(skvamme).
-export([make/5,init/5,loop/4]).
-define (WT,300).
-define (HT,200).
-define (SPACE,2).
-include("ex11_lib.hrl").
-import(ex11_lib, [xDo/2,xPen/3,xClearArea/1,xFlush/1,xColor/2,eFillPoly/5,xCreateSimpleWindow/10,eMapWindow/1,mkPoint/2,xSetScreenSaver/2]).

% 0 narrow black % 1 wide black % 2 narrow white % 3 wide white
make(Parent,Display,PWin,X,Y) -> 
    spawn_link(?MODULE,init,[Parent,Display,PWin,X,Y]).

init(_Parent,Display,PWin,X,Y) ->
   Window = xCreateSimpleWindow(Display,PWin,X,Y,?WT,?HT,0,?XC_cross,xColor(Display,?white),
        ?EVENT_EXPOSURE bor ?EVENT_BUTTON_PRESS bor ?EVENT_BUTTON_RELEASE), 
    xDo(Display, eMapWindow(Window)),
    xFlush(Display),
    Black = xPen(Display,0,?black),
    xFlush(Display),
    self() ! {new,"1234567890"},
	Figures = {[0,2,0,3,1,2,1,2,0],[1,2,0,3,0,2,0,2,1],[0,2,1,3,0,2,0,2,1],[1,2,1,3,0,2,0,2,0],[0,2,0,3,1,2,0,2,1],
		[1,2,0,3,1,2,0,2,0],[0,2,1,3,1,2,0,2,0],[0,2,0,3,0,2,1,2,1],[1,2,0,3,0,2,1,2,0],[0,2,1,3,0,2,1,2,0]},
    loop(Display,Window,Figures,Black).

loop(Display,Window,{Zero,One,Two,Three,Four,Five,Six,Seven,Eight,Nine},Black) ->
    receive
    	{new,Str} -> Codearray = lists:map(fun(Char) -> case Char of
	    		48 -> Zero;
	    		49 -> One;
	    		50 -> Two;
	    		51 -> Three;
	    		52 -> Four;
	    		53 -> Five;
	    		54 -> Six;
	    		55 -> Seven;
	    		56 -> Eight;
	    		57 -> Nine
	    	end end,Str),
    		draw_new(Display,Window,Codearray,Black),
    		?MODULE:loop(Display,Window,{Zero,One,Two,Three,Four,Five,Six,Seven,Eight,Nine},Black);
    	Any -> io:format("~p got unknown msg: ~p~n",[?MODULE, Any]),
			?MODULE:loop(Display,Window,{Zero,One,Two,Three,Four,Five,Six,Seven,Eight,Nine},Black)
	end.

draw_new(Display,Window,Codearray,Black) ->
	xClearArea(Window),
	Codearray1 = [[0,3,0,2,1,2,1,2,0]|lists:reverse(Codearray)],
	Codearray2 = [[0,3,0,2,1,2,1,2,0]|Codearray1],
	d_n(Display,Window,Black,Codearray2,1).

d_n(Display,_,_,[],_) -> xFlush(Display);
d_n(Display,Window,Black,[Head|Tail],X) ->
	X1 = d_n_n(Display,Window,Black,Head,X),
	xFlush(Display),
	d_n(Display,Window,Black,Tail,X1).

d_n_n(_,_,_,[],X) -> X;
d_n_n(Display,Window,Black,[Head|Tail],X) ->
	X1 = case Head of
		0 -> xDo(Display,eFillPoly(Window,Black,convex,origin,[mkPoint(X,0),mkPoint(X + ?SPACE,0),mkPoint(X + ?SPACE,?HT),mkPoint(X,?HT)])), ?SPACE;
		1 -> xDo(Display,eFillPoly(Window,Black,convex,origin,[mkPoint(X,0),mkPoint(X+(3 * ?SPACE),0),mkPoint(X+(3 * ?SPACE),?HT),mkPoint(X,?HT)])), 3 * ?SPACE;
		2 -> ?SPACE;
		3 -> 3 * ?SPACE
	end,
	d_n_n(Display,Window,Black,Tail,X+X1).


