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

% Parte b

promedio_vida(humano,80).
promedio_vida(enano,350).


muerte(Persona, Anio) :-
    habitante(Persona, _, AnioNacimiento, Raza),
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


conocimiento(Persona, Hazania, AnioConmemoracion, Medio) :-
    habitante(Persona, Pueblo, _, _),
    conmemorar_hazanias(Hazania, AnioConmemoracion, Medio, Pueblo).

% recuerda(Persona, NombreHazaña, Anio)

recuerda(Persona, NombreHazania, Anio) :-
    conocimiento(Persona, hazania(NombreHazania, _, _), AnioConocimiento, Medio),
    AnioConocimiento =< Anio,
    estaViva(Persona, Anio),
    dentro_de_duracion(Medio, AnioConocimiento, Anio).

limite_mantenimiento(marmol, 30).
limite_mantenimiento(bronce, 15).

evento_de_cuidado(AnioConstruccion, _, AnioConstruccion).

evento_de_cuidado(_, ListaMantenimiento, AnioMantenimiento) :-
    member(AnioMantenimiento, ListaMantenimiento).

buen_estado(Tipo, AnioConstruccion, ListaMantenimiento, Anio) :-
    limite_mantenimiento(Tipo, Limite),
    evento_de_cuidado(AnioConstruccion, ListaMantenimiento, AnioEvento),
    Anio >= AnioEvento,
    Anio - AnioEvento =< Limite.

dentro_de_duracion(presencio, _, _).

dentro_de_duracion(escucho_cancion, AnioConocimiento, Anio) :-
    Anio =< AnioConocimiento + 15.

dentro_de_duracion(leyo_libro(Paginas), AnioConocimiento, Anio) :-
    Anio =< AnioConocimiento + Paginas.

dentro_de_duracion(dia_festivo, _, _).

dentro_de_duracion(estatua(Tipo, _, ListaMantenimiento), AnioConstruccion, Anio) :-
    buen_estado(Tipo, AnioConstruccion, ListaMantenimiento, Anio).

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

% hazania(destruir_schlat_el_omnisciente, [heroe_del_sur], ende).

conmemorar_hazanias(hazania(destruir_rey_demonio, [frieren, himmel, heiter, eisen], ende), 1340, dia_festivo, weise).

conmemorar_hazanias(hazania(destruir_rey_demonio, [frieren, himmel, heiter, eisen], ende), 1370, estatua(bronce, equipo_de_heroes, [1400, 1450]), auberst).

conmemorar_hazanias(hazania(destruir_schlat_el_omnisciente, [heroe_del_sur], ende), 1340, estatua(marmol, heroe_del_sur, [1410]), auberst).

% PARTE 2 TP

% Punto 4

esPueblo(Pueblo):-
    habitante(_, Pueblo, _, _).

esHazania(NombreHazania):-
    conocimiento(_, hazania(NombreHazania, _, _), _, _).

puebloRecuerdaHazania(Anio, NombreHazania, Pueblo):-
    habitante(Persona, Pueblo, _, _),
    recuerda(Persona, NombreHazania, Anio).

paginasLeidas(Pueblo, Anio, CantidadPaginas):-
    esPueblo(Pueblo),
    findall(Pagina, (habitante(Persona, Pueblo, _, _), conocimiento(Persona, _, Anio, leyo_libro(Pagina))), PaginasTotales),
    sum_list(PaginasTotales, CantidadPaginas).
    
puebloMasLector(Anio, Pueblo):-
    paginasLeidas(Pueblo, Anio, MayorCantidadPaginas),
    forall(paginasLeidas(_, Anio, OtraCantidadPaginas), MayorCantidadPaginas >= OtraCantidadPaginas).

puebloMusical(Anio, Pueblo):-
    esPueblo(Pueblo),
    findall(NombreHazania, 
            (habitante(Persona, Pueblo, _, _), 
            conocimiento(_, hazania(NombreHazania, _, _), _, escucho_cancion), 
            recuerda(Persona, NombreHazania, Anio)), 
            HazaniasRecordadasPorCancion),    
    findall(NombreHazania, 
            (habitante(Persona, Pueblo, _, _), 
            conocimiento(_, hazania(NombreHazania, _, _), _, Medio), 
            recuerda(Persona, NombreHazania, Anio),
            Medio \= escucho_cancion,
            not(member(NombreHazania, HazaniasRecordadasPorCancion))), 
            HazaniasRecordadasPorOtrosMedios),
    length(HazaniasRecordadasPorCancion, CantidadDeHazaniasRecordadasPorCancion),
    length(HazaniasRecordadasPorOtrosMedios, CantidadDeHazaniasRecordadasPorOtrosMedios),
    CantidadDeHazaniasRecordadasPorCancion > CantidadDeHazaniasRecordadasPorOtrosMedios.

puebloChismoso(Anio, Pueblo):-
    esPueblo(Pueblo),
    forall(puebloRecuerdaHazania(Anio, NombreHazania, Pueblo), not(corroborada(NombreHazania))).
    
hazaniaImportante(Anio, NombreHazania, Pueblo):-
    esPueblo(Pueblo),
    esHazania(NombreHazania),
    forall((habitante(Persona, Pueblo, _, _), estaViva(Persona, Anio)), recuerda(Persona, NombreHazania, Anio)).
   
tiemposSinPrecedentes(Anio, Pueblo):-
    esPueblo(Pueblo),
    forall(hazaniaImportante(Anio, NombreHazania, Pueblo), 
        (habitante(Persona, Pueblo, _, _), recuerda(Persona, NombreHazania, Anio),conocimiento(Persona, hazania(NombreHazania, _, _), _, presencio))).
    
% Punto 5

esHeroe(Heroe):-
    conocimiento(_, hazania(_, Heroes, _), _, _),
    member(Heroe, Heroes).

inspiroAHeroe(Heroe, HeroeInspirador):-
    esHeroe(Heroe),
    conocimiento(Heroe, hazania(_, Heroes, _), _, _),
    member(HeroeInspirador, Heroes),
    Heroe \= HeroeInspirador.

cadenaDeInspiracion(Heroe, Cadena) :-
    cadenaValida(Heroe, [Heroe], Cadena).

cadenaValida(Heroe, HeroesEnLista, [Heroe, HeroeInfluenciado]):-
    inspiroAHeroe(HeroeInfluenciado, Heroe),
    not(member(HeroeInfluenciado, HeroesEnLista)).

cadenaValida(Heroe, HeroesEnLista, [Heroe, HeroeInfluenciado | Resto]) :-
    inspiroAHeroe(HeroeInfluenciado, Heroe),
    not(member(HeroeInfluenciado, HeroesEnLista)),
    append(HeroesEnLista, [HeroeInfluenciado], HeroesEnListaActualizado),
    cadenaValida(HeroeInfluenciado, HeroesEnListaActualizado, [HeroeInfluenciado | Resto]).

% Punto 6

esAntecesorDe(Antecesor, Heroe) :-
    cadenaDeInspiracion(Antecesor, Cadena),
    last(Cadena, Heroe),
    Antecesor \= Heroe.

antecesoresElegidos(Heroe, HeroesEnLista, [Antecesor]) :-
    esAntecesorDe(Antecesor, Heroe),
    not(member(Antecesor, HeroesEnLista)).

antecesoresElegidos(Heroe, HeroesEnLista, [Antecesor | Resto]) :-
    esAntecesorDe(Antecesor, Heroe),
    not(member(Antecesor, HeroesEnLista)),
    antecesoresElegidos(Heroe, [Antecesor | HeroesEnLista], Resto).

dreamTeam(Heroe, Equipo) :-
    antecesoresElegidos(Heroe, [Heroe], Antecesores),
    permutation([Heroe | Antecesores], Equipo).

:- begin_tests(tpIntegrador, []).

test("Una persona humana esta viva en promedio hasta 80 años despues de su nacimiento"):-
    estaViva(kanne, 1370). % Kanne es una humana nacida en el año 1365

test("Una persona humana no esta viva pasados 80 años de su nacimiento"):-
    not(estaViva(kanne, 2000)). 

test("Una persona enana esta viva en promedio hasta 350 años despues de su nacimiento"):-
    estaViva(voll, 1550). % Voll es un enano nacido en el año 1200

test("Una persona enana no esta viva pasados 350 años de su nacimiento"):-
    not(estaViva(voll, 1551)).

test("Una persona elfo no muere por vejez"):- 
    estaViva(serie, 5000). % Serie es una persona elfo nacida en el 500

test("Ninguna persona esta viva antes de su año de nacimiento"):-
    not(estaViva(kanne, 1364)), % Kanne nacio en el 1365
    not(estaViva(voll, 1199)), % Voll nacio en el 1200
    not(estaViva(serie, 499)). % Serie nacio en el 500

test("Si una persona presencia una hazaña la recuerda por el resto de su vida desde ese momento", nondet):-
    recuerda(wirbel, rescatar_hermana_de_wirbel, 1400), % Wirbel presencio en 1390 la hazaña rescatar_hermana_de_wirbel
    not(recuerda(wirbel, rescatar_hermana_de_wirbel, 1500)). % Wirbel es un humano nacido en 1350, ya no estaría vivo pasados 80 años

test("Si una persona escucho una canción sobre esa hazaña la recuerda por 15 años desde ese momento", nondet):-
    recuerda(lawine, destruir_demonio_aura, 1400), % Lawine escucho en 1393 una cancion sobre la hazaña destruir_demonio_aura
    not(recuerda(lawine, destruir_demonio_aura, 1410)). % Lawine no recordaria la hazaña pasados 15 años

test("Si una persona leyó un libro sobre una hazaña, la recuerda por tantos años como paginas que tenga el libro", nondet):-
    recuerda(voll, destruir_demonio_aura, 1450), % Voll leyo en 1400 un libro de 50 paginas sobre la hazaña destruir_demonio_aura
    not(recuerda(voll, destruir_demonio_aura, 1460)). % Voll no recordaria la hazaña pasados 50 años (50 paginas)

test("Ninguna persona recuerda una hazaña antes de conocerla", nondet) :-
    not(recuerda(wirbel, rescatar_hermana_de_wirbel, 1360)), % Wirbel conocio esta hazaña en 1390 
    not(recuerda(lawine, destruir_demonio_aura, 1380)), % Lawine conocio esta hazaña en 1393
    not(recuerda(voll, destruir_demonio_aura, 1300)). % Voll conocio esta hazaña en 1400

test("Ninguna persona recuerda una hazaña antes de su año de nacimiento", nondet):-
    not(recuerda(wirbel, rescatar_hermana_de_wirbel, 1300)), % Wirbel nacio en 1350 
    not(recuerda(lawine, destruir_demonio_aura, 1300)), % Lawine nacio en 1372
    not(recuerda(voll, destruir_demonio_aura, 1100)). % Voll nacio en 1200

test("Ninguna persona recuerda una hazaña si ya falleció", nondet):-
    not(recuerda(wirbel, rescatar_hermana_de_wirbel, 2000)), % Wirbel es un humano nacido en 1350 , ya estaría muerto pasados 80 años
    not(recuerda(lawine, destruir_demonio_aura, 2000)), % Lawine es un humano nacido en 1372, ya estaría muerto pasados 80 años
    not(recuerda(voll, destruir_demonio_aura, 2000)). % Voll es un enano nacido en 1200, ya estaría muerto pasados 350 años

test("Si en el pueblo en el que vive una persona se conmemora una hazaña con un dia festivo la recuerda por el resto de su vida desde ese momento", nondet):-
    recuerda(fern, destruir_rey_demonio, 1400), % Fern vive en Weise, donde hay un dia festivo para la hazaña destruir_rey_demonio desde 1340
    not(recuerda(voll, destruir_rey_demonio, 1400)). % Voll vive en Ende, donde no se conmemora la hazaña destruir_rey_demonio

test("Si en el pueblo en el que vive una persona hay una estatua que conmemora una hazaña, la recuerda si sigue estando en buen estado", nondet):-
    recuerda(lawine, destruir_rey_demonio, 1400), % Lawine vive en Auberst, donde hay una estatua de bronce de destruir_rey_demonio que recibio mantenimiento en 1400 y 1450
    not(recuerda(lawine, destruir_rey_demonio, 1390)). % En 1390 la estatua de bronce de destruir_rey_demonio no se encuentra en buen estado

test("Una persona que ya falleció NO recuerda una hazaña conmemorada en su pueblo", nondet) :-
    not(recuerda(lernen, destruir_rey_demonio, 1410)). % En 1410 la estatua esta en buen estado, pero Lernen ya esta muerto.

test("Una persona NO recuerda una hazaña conmemorada antes de su año de nacimiento", nondet) :-
    not(recuerda(lawine, destruir_schlat_el_omnisciente, 1360)). % En 1360 la estatua estaba en buen estado, pero Lawine no habia nacido.

test("Una hazaña esta corroborada si solo hay una versión de la misma", nondet):-
    corroborada(rescatar_hermana_de_wirbel). % Solo hay una version de la hazaña rescatar_hermana_de_wirbel

test("Una hazaña NO esta corrobarada si hubo diferentes personas que la llevaron a cabo o diferente lugar en el que ocurrió la hazaña", nondet):-
    not(corroborada(destruir_demonio_aura)). % Hay 2 versiones de la hazaña destruir_demonio_aura donde varian quienes y donde se llevo cabo

test("Una hazaña pasa al olvido si ya nadie la recuerda ese año", nondet):-
    al_olvido(destruir_demonio_aura, 2000), % Para el año 2000 quienes tenian conocimiento de la hazaña destruir_demonio_aura (Voll y Lawine) ya no la recordarian
    not(al_olvido(rescatar_hermana_de_wirbel, 1400)). % Para el año 1400 Wirbel y Freiren recordarian la hazaña rescatar_hermana_de_wirbel.

test("Una hazaña es recordada por un pueblo en cierto año si al menos una persona que vive en ese pueblo recuerda esa hazaña en ese año", nondet):-
    puebloRecuerdaHazania(1400, destruir_rey_demonio, weise), % En Weise viven Serie, Fern, Kanne y Frieren, donde se conmemora la hazaña destruir_rey_demonio desde 1340, en 1400 todos recuerdan dicha hazaña
    puebloRecuerdaHazania(1500, destruir_rey_demonio, weise), % Para el año 1500 en Weise, Fern y Kanne ya habrian muerto de vejez, pero Serie y Frieren al ser elfos todavia recordarian dicha hazaña
    puebloRecuerdaHazania(1395, rescatar_hermana_de_wirbel, klares), % En Klares vive Wirbel, quien presencio la hazaña rescaratar_hermana_de_wirbel en 1390 y en 1395 recuerda dicha hazaña
    not(puebloRecuerdaHazania(1395, destruir_rey_demonio, klares)), % En Klares no vive nadie que recuerda la hazaña destruir_rey_demonio, ya que nunca se tuvo conocimiento de dicha hazaña en ese pueblo
    not(puebloRecuerdaHazania(1500, rescatar_hermana_de_wirbel, klares)). % En Klares en el año 1500 Wirbel ya habria muerto, por lo que nadie recordaria la hazaña rescatar_hermana_de_wirbel en el pueblo

test("El total de paginas leidas por un pueblo es la sumatoria de las cantidades leidas por cada habitante", nondet):-
    paginasLeidas(weise, 1335, 100), % En Weise, en 1335, Serie leyo 100 paginas
    paginasLeidas(weise, 1336, 0). % En Weise, en 1336, ningun habitante leyo paginas

test("El pueblo mas lector es aquel que hasta ese año sus habitantes son los que mas leyeron", nondet):-
    puebloMasLector(1400, ende). % En Ende, en 1400, Voll leyo 50 paginas, mientras que en los otros pueblos se leyeron 0 paginas

test("Cuando la mayoria de hazañas recordadas en un pueblo son recordadas mediante canciones entonces es un pueblo musical", nondet):-
    puebloMusical(1395, auberst), % En Auberst, en 1395, solo recuerdan la hazaña destuir_demonio_aura porque Lawine escucho una canción en 1393, las estatuas que conmemoran otras hazañas estan en mal estado
    not(puebloMusical(1410, auberst)), % En Auberst, en 1410, las estatuas estan en buen estado y Lawine ya no recuerda la hazaña destruir_demonio_aura
    not(puebloMusical(1400, weise)). % En Weise no hay hazañas recordadas mediante canciones

test("Un pueblo es chismoso si todas las hazañas que se recuerdan no estan corroboradas", nondet):-
    puebloChismoso(1420, ende), % En Ende, en 1420, solo recuerdan la hazaña destruir_demonio_aura, que no esta corroborada
    not(puebloChismoso(1400, weise)). % En Weise, en 1400, no todas las que se recuerdan no estan corroboradas

test("Si todos los habitantes que viven en un pueblo en cierto año recuerdan una hazaña entonces la misma es importante", nondet):-
    hazaniaImportante(1400, destruir_rey_demonio, weise), % En Weise, en 1400, todos los habitantes recuerdan la hazaña destruir_rey_demonio por el dia festivo
    not(hazaniaImportante(1400, recuperar_gato_perdido, weise)). % En Weise, en 1400, solo kanne recuerda la hazaña recuperar_gato_perdido porque la presencio

test("Un pueblo vive tiempos sin precedentes si todas las hazañas importantes del pueblo fueron presenciadas por alguien", nondet):-
    tiemposSinPrecedentes(1394, klares), % En Klares, en 1394, Wirbel presencio todas las hazañas importantes (rescatar_hermana_de_wirbel)
    not(tiemposSinPrecedentes(1400, weise)). % En weise, en 1400, la hazaña destuir_rey_demonio es importante pero nadie del pueblo la presencio

test("Cualquiera que haya participado en una hazaña conocida es un heroe", nondet):-
    esHeroe(fern), % Fern participo en la hazaña rescatar_hermana_de_wirbel
    not(esHeroe(wirbel)). % Wirbel no participo en ninguna hazaña

test("Un heroe es inspirado por otro heroe si este ultimo participo en las hazañas que el primer heroe conocio", nondet):-
    inspiroAHeroe(fern, frieren), % Fern conoce destruir_rey_demonio donde Frieren participo
    inspiroAHeroe(frieren, fern), % Frieren conoce rescatar_herman_de_wirbel donde Fern participo
    not(inspiroAHeroe(eisen, _)). % Nadie inspiro a Eisen, ya que no ssabemos ninguna hazaña que conozca

test("Una cadena de inspiracion parte de un heroe inicial siguiendo todos los diferentes caminos por los que influencio a otros heroes", nondet):-
    cadenaDeInspiracion(himmel, [himmel, fern, frieren, denken]), % Himmel inspiro a Fern, Fern inspiro a Frieren y Frieren inspiro a Denken
    not(cadenaDeInspiracion(denken, [denken, frieren])), % Denken no inspiro a Frieren
    not(cadenaDeInspiracion(himmel, [himmel, frieren, fern, frieren])). % Si bien Frieren inspiro a Fern y Fern inspiro a Frieren, no se pueden repetir heroes en la cadena

test("Un Dream Team para un heroe es un equipo que incluya al heroe y tambien incluya antecesores", nondet):-
    dreamTeam(fern, [fern, himmel]), % Es un equipo valido ya que Himmel es antecesor de Fern
    dreamTeam(fern, [himmel, fern]), % Es un equipo valido, no importa el orden de los miembros en el equipo
    not(dreamTeam(fern, [fern])), % No es un equipo valido ya que no incluye antecesoress
    not(dreamTeam(fern, [frieren, himmel])). % No es un equipo valido ya que no incluye a Fern

:- end_tests(tpIntegrador).
