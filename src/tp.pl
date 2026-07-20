% Base de conocimiento
% Punto 1
% Parte a

% habitante(Nombre, Pueblo, AnioNacimiento, Raza).

habitante(denken, auberst, 1290, humano).
habitante(voll, ende, 1200, enano).
habitante(serie, weise, 500, elfo).
habitante(fern, weise, 1370, humano).
habitante(stark, riegel, 1368, humano).
habitante(lawine, auberst, 1372, humano).
habitante(kanne, weise, 1365, humano).
habitante(wirbel, klares, 1350, humano).
habitante(lernen, auberst, 1315, humano).
habitante(frieren, weise, 100, elfo).
habitante(eisen, riegel, 1150, enano).

habitante(humano_default, pueblo, 2000, humano).
habitante(enano_default, pueblo, 2000, enano).
habitante(elfo_default, pueblo, 2000, elfo).

% Parte b

promedio_vida(humano,80).
promedio_vida(enano,350).


% muerte(Persona, Anio) 
muerte(Persona, Anio) :-
    habitante(Persona, _, AnioNacimiento, Raza),
    Raza \= elfo,
    promedio_vida(Raza, Vida),
    Anio > AnioNacimiento + Vida.

% estaViva(Persona, Anio) 
estaViva(Persona, Anio) :-
    habitante(Persona, _, AnioNacimiento, _),
    AnioNacimiento =< Anio,
    not(muerte(Persona, Anio)).

% conocimiento(Persona, Hazaña, Anio, Medio)

% hazaña = hazaña(NombreHazaña, Protagonistas, Lugar)
% medio  = presencio | escucho_cancion | leyo_libro(CantidadPaginas)

% Punto 2
% Parte a

conocimiento(wirbel,
             hazania(rescatar_hermana_de_wirbel, [stark, fern], klares),
             1390, presencio).

conocimiento(frieren,
             hazania(rescatar_hermana_de_wirbel, [stark, fern], klares),
             1390, presencio).

conocimiento(lawine,
             hazania(destruir_demonio_aura, [frieren], weise),
             1393, escucho_cancion).

conocimiento(voll,
             hazania(destruir_demonio_aura, [denken], auberst),
             1400, leyo_libro(50)).

conocimiento(serie,
             hazania(destruir_rey_demonio, [frieren, himmel, heiter, eisen], ende),
             1335, leyo_libro(100)).

conocimiento(kanne,
             hazania(recuperar_gato_perdido, [himmel, frieren], weise),
             1375, presencio).


% recuerda(Persona, NombreHazaña, Anio)

recuerda(Persona, NombreHazania, Anio) :-
    conocimiento(Persona, hazania(NombreHazania, _, _), AnioConocimiento, Medio),
    AnioConocimiento =< Anio,
    estaViva(Persona, Anio),
    dentro_de_duracion(Medio, AnioConocimiento, Anio).

recuerda(Persona, NombreHazania, Anio) :-
    habitante(Persona, Pueblo, _, _),
    conmemorar_hazanias(NombreHazania , estatua(Tipo, _, AnioConstruccion, ListaMantenimiento), Pueblo),
    buen_estado(Tipo, AnioConstruccion, ListaMantenimiento, Anio).

recuerda(Persona, NombreHazania, Anio) :-
    habitante(Persona, Pueblo, _, _),
    conmemorar_hazanias(NombreHazania , dia_festivo(AnioFestival), Pueblo),
    Anio >= AnioFestival.

buen_estado(marmol, AnioConstruccion, _, Anio) :-
    Anio >= AnioConstruccion,
    Anio - AnioConstruccion =< 30.

buen_estado(marmol, _ , ListaMantenimiento, Anio) :-
    member(AnioMantenimiento, ListaMantenimiento),
    Anio >= AnioMantenimiento,
    Anio - AnioMantenimiento =< 30.

buen_estado(bronce, AnioConstruccion, _, Anio) :-
    Anio >= AnioConstruccion,
    Anio - AnioConstruccion =< 15.

buen_estado(bronce, _ , ListaMantenimiento, Anio) :-
    member(AnioMantenimiento, ListaMantenimiento),
    Anio >= AnioMantenimiento,
    Anio - AnioMantenimiento =< 15.


dentro_de_duracion(presencio, _, _).

dentro_de_duracion(escucho_cancion, AnioConocimiento, Anio) :-
    Anio =< AnioConocimiento + 15.

dentro_de_duracion(leyo_libro(Paginas), AnioConocimiento, Anio) :-
    Anio =< AnioConocimiento + Paginas.



% Parte b

% version(NombreHazaña, ProtagonistasOrdenados, Lugar)

version(NombreHazania, ProtagonistasOrdenados, Lugar) :-
    conocimiento(_, hazania(NombreHazania, Protagonistas, Lugar), _, _),
    msort(Protagonistas, ProtagonistasOrdenados).

% corroborada(NombreHazaña)

corroborada(NombreHazania) :-
    version(NombreHazania, ProtagonistasRef, LugarRef),
    forall(version(NombreHazania, Protagonistas, Lugar),
           (Protagonistas == ProtagonistasRef, Lugar == LugarRef)).
           
% Parte c

al_olvido(NombreHazania, Anio) :-
    conocimiento(_, hazania(NombreHazania, _, _), _, _),  % la hazaña existe
    not(recuerda(_, NombreHazania, Anio)).

% Punto 3
% Parte a

hazania(destruir_schlat_el_omnisciente, [heroe_del_sur], ende).

conmemorar_hazanias(destruir_rey_demonio, dia_festivo(1340), weise).

conmemorar_hazanias(destruir_rey_demonio, estatua(bronce, equipo_de_heroes, 1370, [1400, 1450]), auberst).

conmemorar_hazanias(destruir_schlat_el_omnisciente, estatua(marmol, heroe_del_sur, 1340, [1410]), auberst).

:- begin_tests(tpIntegrador, []).

test("Una persona humana esta viva en promedio hasta 80 años despues de su nacimiento"):-
    estaViva(humano_default, 2020),
    not(estaViva(humano_default, 1900)),
    not(estaViva(humano_default, 2100)).

test("Una persona enana esta viva en promedio hasta 350 años despues de su nacimiento"):-
    estaViva(enano_default, 2100),
    not(estaViva(enano_default, 1900)),
    not(estaViva(enano_default, 2400)).

test("Una persona elfo no esta vivo antes de su nacimiento"):- 
    not(estaViva(elfo_default,1900)).
    
test("Si una persona presencia una hazaña la recuerda por el resto de su vida desde ese momento", nondet):-
    recuerda(wirbel, rescatar_hermana_de_wirbel, 1400),
    not(recuerda(wirbel, rescatar_hermana_de_wirbel, 1300)),
    not(recuerda(wirbel, rescatar_hermana_de_wirbel, 1500)).
test("Si una persona escucho una canción sobre esa hazaña la recuerda por 15 años desde ese momento", nondet):-
    recuerda(lawine, destruir_demonio_aura, 1400),
    not(recuerda(lawine, destruir_demonio_aura, 1380)),
    not(recuerda(lawine, destruir_demonio_aura, 1410)).
test("Si una persona leyó un libro sobre una hazaña, la recuerda por tantos años como paginas que tenga el libro", nondet):-
    recuerda(voll, destruir_demonio_aura, 1450),
    not(recuerda(voll, destruir_demonio_aura, 1460)),
    not(recuerda(voll, destruir_demonio_aura, 1300)).
test("Si en el pueblo en el que vive una persona se conmemora una hazaña con un dia festivo la recuerda por el resto de su vida desde ese momento"):-
    recuerda(fern, destruir_rey_demonio, 1400),
    not(recuerda(voll, destruir_rey_demonio, 1400)).

test("Si en el pueblo en el que vive una persona hay una estatua que conmemora una hazaña, la recuerda si sigue estando en buen estado", nondet):-
    recuerda(lawine, destruir_rey_demonio, 1400),
    not(recuerda(lawine, destruir_rey_demonio, 1390)).

test("Una hazaña esta corroborada si solo hay una versión de la misma", nondet):-
    corroborada(rescatar_hermana_de_wirbel).
test("Una hazaña no esta corrobarada si hubo diferentes personas que la llevaron a cabo o diferente lugar en el que ocurrió la hazaña", nondet):-
    not(corroborada(destruir_demonio_aura)).

test("Una hazaña pasa al olvido si ya nadie la recuerda ese año", nondet):-
    al_olvido(destruir_demonio_aura, 2000),
    not(al_olvido(rescatar_hermana_de_wirbel, 1400)).

:- end_tests(tpIntegrador).
