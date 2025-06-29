:- dynamic(beer/2).
:- dynamic(brewery/2).
:- dynamic(style/2).

use_module(library(csv)).

% -------------------- CSV -------------------- %
:-

    % working_directory(_CWD, 'C:\Users\anton\OneDrive\Desktop\ICon2024-Papeo\ICon2024-Papeo\Prolog'),
    
    % inizializzazione fatti
    retractall(beer(X, Y)),
    retractall(style(X, Y)),
    retractall(beerstyle(X,Y)),
    retractall(abv(X,Y)),
    retractall(mouthfeel(A,B,C,D)),
    retractall(taste(A,B,C,D,E)),
    retractall(flavour(A,B,C,D,E)),
    retractall(review(X,Y)),
    retractall(dist_flavour(X,Y)),
    retractall(dist_mouthfeel(X,Y)),
    retractall(dist_taste(X,Y)),

    % importazione fatti
    csv_read_file('csv/beer_name.csv', Beer, [functor(beer), separator(0';)]),
    maplist(assert, Beer),
    csv_read_file('csv/style_id.csv', Style, [functor(style), separator(0';)]),
    maplist(assert, Style),
    csv_read_file('csv/beer_style.csv', BeerStyle, [functor(beerstyle), separator(0';)]),
    maplist(assert, BeerStyle),
    csv_read_file('csv/beer_abv.csv', Abv, [functor(abv), separator(0';)]),
    maplist(assert, Abv),
    csv_read_file('csv/style_mouthfeel.csv', MF, [functor(mouthfeel), separator(0';)]),
    maplist(assert, MF),
    csv_read_file('csv/style_taste.csv', Taste, [functor(taste), separator(0';)]),
    maplist(assert, Taste),
    csv_read_file('csv/style_flavour.csv', Flavour, [functor(flavour), separator(0';)]),
    maplist(assert, Flavour),
    csv_read_file('csv/beer_review.csv', Review, [functor(review), separator(0';)]),
    maplist(assert, Review),
    csv_read_file('csv/style_desc.csv', Desc, [functor(desc), separator(0';)]),
    maplist(assert, Desc).

% -------------------- FATTI -------------------- %
% beer(Beer_id, Beer_name).
% style(Style_id, Style_name).
% beerstyle(Beer_id, Style_id).
% abv(Beer_id, Abv_value).

% mouthfeel(Style_id, Astringency_value, Body_value, Alcohol_value).
% taste(Style_id, Sweet_value, Bitter_value, Sour_value, Salty_value).
% flavour(Style_id, Fruits_value, Hoppy_value, Malty_value, Spices_value).

% -------------------- REGOLE -------------------- %

% Regole basate su fatti relativi alle birre
what_beer_id(Beer_name) :-
    beer(Beer_id, Beer_name),

    write(Beer_id).

what_beer_name(Beer_id) :-
    beer(Beer_id, Beer_name),

    write(Beer_name).

what_beer_abv(Beer_name) :-
    beer(A, Beer_name),
    abv(A, Abv_value),

    write(Abv_value).

what_beer_style(Beer_name) :-
    beer(A, Beer_name),
    beerstyle(A, Style_name),

    write(Style_name).

what_beer_review(Beer_name) :-
    beer(A, Beer_name),
    review(A, Review_value),

    write(Review_value).


what_beer_mouthfeel(Beer_name) :-
    beer(A, Beer_name),
    beerstyle(A, Style_name),
    style(B, Style_name),

    mouthfeel(B, Astringency_value, Body_value, Alcohol_value),

    write(Astringency_value), nl,
    write(Body_value), nl,
    write(Alcohol_value).

what_beer_taste(Beer_name) :-
    beer(A, Beer_name),
    beerstyle(A, Style_name),
    style(B, Style_name),

    taste(B, Bitter_value, Sweet_value, Sour_value, Salty_value),

    write(Bitter_value), nl,
    write(Sweet_value), nl,
    write(Sour_value), nl,
    write(Salty_value).

what_beer_flavour(Beer_name) :-
    beer(A, Beer_name),
    beerstyle(A,Style_name),
    style(B, Style_name),

    flavour(B, Fruits_value, Hoppy_value, Spices_value, Malty_value),

    write(Fruits_value), nl,
    write(Hoppy_value), nl,
    write(Spices_value), nl,
    write(Malty_value).

% Regole basate su fatti relativi agli stili
what_style_id(Style_name) :-
    style(Style_id, Style_name),

    write(Style_id).

what_style_name(Style_id) :-
    style(Style_id, Style_name),

    write(Style_name).

what_style_mouthfeel(Style_name) :-
    style(A, Style_name),

    mouthfeel(A, Astringency_value, Body_value, Alcohol_value),

    write(Astringency_value), nl,
    write(Body_value), nl,
    write(Alcohol_value).

what_style_taste(Style_name) :-
    style(A, Style_name),

    taste(A, Bitter_value, Sweet_value, Sour_value, Salty_value),

    write(Bitter_value), nl,
    write(Sweet_value), nl,
    write(Sour_value), nl,
    write(Salty_value).

what_style_flavour(Style_name) :-
    style(A, Style_name),

    flavour(A, Fruits_value, Hoppy_value, Spices_value, Malty_value),

    write(Fruits_value), nl,
    write(Hoppy_value), nl,
    write(Spices_value), nl,
    write(Malty_value).

% -------------------- APPRENDIMENTO -------------------- %
% L'utente fornisce in input i suoi "gusti"
% e il sistema gli consiglia lo stile di birra
% che pi  si avvicina ad essi

% Apprendimento logico
% Viene chiesto all'utente di inserire 3 attributi:
% 1. astringent/body/alcohol
% 2. bitter/sweet/sour/salty
% 3. fruits/hoppy/malty/spices
% Viene data come risposta lo stile che corrisponde agli attributi

find_desc_style(Mouthfeel, Taste, Flavour) :-

    desc(_A, Mouthfeel, Taste, Flavour).

% "Naive" KNN (K = 3, manuale)
% Calcolo la distanza euclidea tra due valori della stessa valutazione
% lo ripeto per tutte le valutazioni e per tutti gli stili presenti nella KB
% memorizzando tutti i valori in una lista.
% Cerco il valore minore della lista, risalgo alla sua posizione e stampo il risultato
% Alternativa: memorizzo codice stile e valore minore

% 1. Prende in input TUTTE le valutazioni
% 2. Prende un fatto dalla KB e ne prende le valutazioni
% 3. Calcola la distanza euclidea tra le due valutazioni
% 4. Memorizza Style_id e distanza euclidea in data
dist_style_mouthfeel(Astringency_input, Body_input, Alcohol_input) :-

    retractall(dist_mouthfeel(_X,_Y)),

    mouthfeel(A, Astringency_value, Body_value, Alcohol_value),

    S is sqrt((Astringency_input-Astringency_value)^2
    +(Body_input-Body_value)^2+(Alcohol_input-Alcohol_value)^2),

    assert(dist_mouthfeel(A, S)).

dist_style_taste(Bitter_input, Sweet_input, Sour_input, Salty_input) :-

    retractall(dist_taste(_X,_Y)),

    taste(A, Bitter_value, Sweet_value, Sour_value, Salty_value),

    S is sqrt((Bitter_input-Bitter_value)^2+(Sweet_input-Sweet_value)^2
    +(Sour_input-Sour_value)^2+(Salty_input-Salty_value)^2),

    assert(dist_taste(A, S)).

dist_style_flavour(Fruity_input, Hoppy_input, Spices_input, Malty_input) :-

    retractall(dist_flavour(_X,_Y)),

    flavour(A, Fruity_value, Hoppy_value, Spices_value, Malty_value),

    S is sqrt((Fruity_input-Fruity_value)^2+(Hoppy_input-Hoppy_value)^2
    +(Spices_input-Spices_value)^2+(Malty_input-Malty_value)^2),

    assert(dist_flavour(A, S)).

% Naive Bayes con smoothing di Laplace
% calcolo la probabilità a priori dello stile
count_style(Name, Count) :-
    findall(Name, desc(Name, _, _, _), L),
    length(L, Count).

prob_style(Name, Prob) :-
    count_style(Name, N),
    count_style(_, T),
    C is T+0.2,
    Prob is (N+0.1)/C.

% calcolo la probabilità condizionata della prima feature
count_mouthfeel(Mouthfeel, Name, Count) :-
    findall(Mouthfeel, desc(Name, Mouthfeel, _, _), L),
    length(L, Count).

prob_mouthfeel(Mouthfeel, Name, Prob) :-
    count_mouthfeel(Mouthfeel, Name, N),
    count_style(Name, T),
    C is T+0.3,
    Prob is (N+0.1)/C.

% calcolo la probabilità condizionata della seconda feature
count_taste(Taste, Name, Count) :-
    findall(Taste, desc(Name, _, Taste, _), L),
    length(L, Count).

prob_taste(Taste, Name, Prob) :-
    count_taste(Taste, Name, N),
    count_style(Name, T),
    C is T+0.3,
    Prob is (N+0.1)/C.

% calcolo la probabilità condizionata della terza feature
count_flavour(Flavour, Name, Count) :-
    findall(Flavour, desc(Name, _, _, Flavour), L),
    length(L, Count).

prob_flavour(Flavour, Name, Prob) :-
    count_flavour(Flavour, Name, N),
    count_style(Name, T),
    C is T+0.3,
    Prob is (N+0.1)/C.

% calcolo della formula Naive Bayes
predict(Name, Mouthfeel, Taste, Flavour, Prob) :-
    prob_style(Name, P1),
    prob_mouthfeel(Mouthfeel, Name, P2),
    prob_taste(Taste, Name, P3),
    prob_flavour(Flavour, Name, P4),
    Prob is P1*P2*P3*P4,

    assert(bayes(Name,Prob)).