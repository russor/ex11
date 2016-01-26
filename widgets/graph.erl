-module(graph).
-author(skvamme).
-export([make/5,init/5,loop/4]).
-define (WT,800).
-define (HT,480).
-include("ex11_lib.hrl").
-import(ex11_lib, [xColor/2,xCreateSimpleWindow/10,xClearArea/2,mkArc/6,eFillPoly/5,ePolyFillArc/3,eMapWindow/1,xDo/2,xFlush/1,xCreateGC/2,
    ePolyLine/4,mkPoint/2,xClearArea/2]).


make(Parent,Display,PWin,X,Y) -> 
    spawn_link(?MODULE,init,[Parent,Display,PWin,X,Y]).


init(Parent,Display,PWin,X,Y) ->
    Pid = self(),
    Win = xCreateSimpleWindow(Display,PWin,X,Y,?WT,?HT,0,?XC_cross,xColor(Display,?black),
        ?EVENT_BUTTON_PRESS bor ?EVENT_BUTTON_RELEASE bor ?EVENT_STRUCTURE_NOTIFY), 
    xDo(Display, eMapWindow(Win)),
    xFlush(Display),        
    Pen0 = xCreateGC(Display, [{function,copy},{line_width,10},{foreground, xColor(Display, 16#FF0000)}]),  
    xFlush(Display),
    Y1 = sevensegsmall:make(Pid,Display,Win,0,431), % Place the sevensegments
    Y11 = sevensegsmall:make(Pid,Display,Win,40,431),
    Y2 = sevensegsmall:make(Pid,Display,Win,0,371),
    Y22 = sevensegsmall:make(Pid,Display,Win,40,371),
    Y3 = sevensegsmall:make(Pid,Display,Win,0,311),
    Y33 = sevensegsmall:make(Pid,Display,Win,40,311),
    Y4 = sevensegsmall:make(Pid,Display,Win,0,251),
    Y44 = sevensegsmall:make(Pid,Display,Win,40,251),
    Y5 = sevensegsmall:make(Pid,Display,Win,0,191),
    Y55 = sevensegsmall:make(Pid,Display,Win,40,191),
    Y6 = sevensegsmall:make(Pid,Display,Win,0,131),
    Y66 = sevensegsmall:make(Pid,Display,Win,40,131),
    Y7 = sevensegsmall:make(Pid,Display,Win,0,71),
    Y77 = sevensegsmall:make(Pid,Display,Win,40,71),
    Y1 ! Y11 ! Y2 ! Y22 ! Y3 ! Y33 ! Y4 ! Y44 ! Y5 ! Y55 ! Y6 ! Y66 ! Y7 ! Y77 ! {new,8,false},
    draw_static(Display,Win,Pen0),
    loop(Parent,Display,Win,Pen0).

loop(Parent,Display,Win,Pen0) ->
    receive
    	{clear} -> xClearArea(Display,Win),
    		xFlush(Display),
    		?MODULE:loop(Parent,Display,Win,Pen0);
 		{'EXIT', _Pid, _Why} -> true;
		Any -> io:format("~p got unknown msg: ~p~n",[?MODULE, Any]),
            ?MODULE:loop(Parent,Display,Win,Pen0)
	end.

%% Processing ascii file: "graph.dxf"
%% Title: "graph.dxf"
draw_static(Display,Win,Pen0) ->
xDo(Display,eFillPoly(Win, Pen0, convex, origin, [mkPoint(104,11),mkPoint(104,448),mkPoint(84,468),mkPoint(84,11)])),
xDo(Display,eFillPoly(Win, Pen0, convex, origin, [mkPoint(104,448),mkPoint(789,448),mkPoint(789,468),mkPoint(84,468)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(80,401),mkPoint(120,401)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(80,341),mkPoint(120,341)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(80,281),mkPoint(120,281)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(80,221),mkPoint(120,221)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(80,161),mkPoint(120,161)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(80,101),mkPoint(120,101)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(80,41),mkPoint(120,41)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(0,431),mkPoint(789,431)])).
%% END
