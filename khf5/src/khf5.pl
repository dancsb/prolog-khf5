% :- type parcMutató ==    int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák ==           list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->    n                 % észak 
%                        ; e                 % kelet 
%                        ; s                 % dél   
%                        ; w.                % nyugat
% :- type iránylista ==    list(irany).      % egy adott fához rendelt sátor
                                             % lehetséges irányait megadó lista
% :- type iránylisták ==   list(iránylista). % az összes fa iránylistája

% :- pred iranylistak(parcMutató::in         % NM
%                     fák::in,               % Fs
%                     iránylisták::out)      % ILs
                                             
% :- pred sator_szukites(fák::in,            % Fs
%                        int::in,            % I
%                        iránylisták::in,    % ILs0
%                        iránylisták::out)   % ILs
:- use_module(library(lists)). % SICStus lists library betöltése

% Sátor meghatározása fa és irány alapján
get_tent(Fx-Fy, e, Tx-Ty) :- Fy1 is Fy + 1, Tx-Ty = Fx - Fy1. % Kelet
get_tent(Fx-Fy, n, Tx-Ty) :- Fx1 is Fx - 1, Tx-Ty = Fx1 - Fy. % Észak
get_tent(Fx-Fy, s, Tx-Ty) :- Fx1 is Fx + 1, Tx-Ty = Fx1 - Fy. % Dél
get_tent(Fx-Fy, w, Tx-Ty) :- Fy1 is Fy - 1, Tx-Ty = Fx - Fy1. % Nyugat

% Egy adott fa iránylistájának meghatározása. Egy adott irány akkor megfelelő, ha az általa mutatott sátor nem lóg le a pályáról, és nem létezik olyan fa.
get_directions(N-M, Fs, Fx-Fy, Dir) :-
    (get_tent(Fx-Fy, e, Txe-Tye), Tye =< M, nonmember(Txe-Tye, Fs) -> EDir = [e]; EDir = []), % Kelet
    (get_tent(Fx-Fy, n, Txn-Tyn), Txn >= 1, nonmember(Txn-Tyn, Fs) -> append(EDir, [n], NDir); NDir = EDir), % Észak
    (get_tent(Fx-Fy, s, Txs-Tys), Txs =< N, nonmember(Txs-Tys, Fs) -> append(NDir, [s], SDir); SDir = NDir), % Dél
    (get_tent(Fx-Fy, w, Txw-Tyw), Tyw >= 1, nonmember(Txw-Tyw, Fs) -> append(SDir, [w], WDir); WDir = SDir), % Nyugat
    Dir = WDir.

% Elfogytak a fák
iranylistak_core(_, _, [], []).

% Iránylisták meghatározása rekurzívan a fák alapján
iranylistak_core(N-M, Fs, [F | RestFs], [Dir | RestILs]) :-
    get_directions(N-M, Fs, F, Dir),
    iranylistak_core(N-M, Fs, RestFs, RestILs).

iranylistak(N-M, Fs, ILs) :-
    iranylistak_core(N-M, Fs, Fs, Dir), % Iránylisták generálása
    (nonmember([], Dir) -> ILs = Dir; ILs = []), % Üres iránylisták ellenőrzése
    !. % cut

% Adott fa meglévő iránylistájának újrartékelése, szűkítése. Egy adott irány akkor maradhat, ha eddig is volt, és az általa mutatott sátor X ésvagy Y koordinátájának a deltája nagyobb mint 1 az I-edik fa sátorához képest.
reevaluate_directions(Fx-Fy, Ix-Iy, PrevDir, Dir) :-
    (member(e, PrevDir), get_tent(Fx-Fy, e, Txe-Tye), Dxe is Ix - Txe, Dye is Iy - Tye, (abs(Dxe) > 1; abs(Dye) > 1) -> EDir = [e]; EDir = []), % Kelet
    (member(n, PrevDir), get_tent(Fx-Fy, n, Txn-Tyn), Dxn is Ix - Txn, Dyn is Iy - Tyn, (abs(Dxn) > 1; abs(Dyn) > 1) -> append(EDir, [n], NDir); NDir = EDir), % Észak
    (member(s, PrevDir), get_tent(Fx-Fy, s, Txs-Tys), Dxs is Ix - Txs, Dys is Iy - Tys, (abs(Dxs) > 1; abs(Dys) > 1) -> append(NDir, [s], SDir); SDir = NDir), % Dél
    (member(w, PrevDir), get_tent(Fx-Fy, w, Txw-Tyw), Dxw is Ix - Txw, Dyw is Iy - Tyw, (abs(Dxw) > 1; abs(Dyw) > 1) -> append(SDir, [w], WDir); WDir = SDir), % Nyugat
    Dir = WDir.

% Elfogytak az iránylisták
sator_szukites_core([], _, _, [], []).

% Iránylisták szűkítése rekurzívan
sator_szukites_core([F | RestFs], If, Ixy, [Dir | RestILs0], [NewDir | RestILs]) :-
    (If \= F -> reevaluate_directions(F, Ixy, Dir, NewDir); NewDir = Dir), % Szűkítés futtatása, kivéve, ha az I-edik fánál járunk
    sator_szukites_core(RestFs, If, Ixy, RestILs0, RestILs).

sator_szukites(Fs, I, ILs0, ILs) :-
    nth1(I, Fs, If), % I-edik fa meghatározása
    nth1(I, ILs0, Id), % I-edik fa iránylistájának meghatározása
    proper_length(Id, 1), % Ellenőrzése, hogy tényleg csak 1 irányt tartalmaz-e
    [IdH | _] = Id, % I-edik fa sátorának irányának meghatározása
    get_tent(If, IdH, Ixy), % I-edik fa sátorának meghatározása
    sator_szukites_core(Fs, If, Ixy, ILs0, Dir), % Szűkített iránylisták generálása
    (nonmember([], Dir) -> ILs = Dir; ILs = []), % Üres iránylisták ellenőrzése
    !. % cut