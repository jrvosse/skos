:- module(skos_util, [
	      skos_notation_ish/2,
	      skos_all_labels/2,
	      skos_related_concepts/2
	  ]).

:- use_module(library('semweb/rdf_db')).
:- use_module(library('semweb/rdf_label')).

%%	notation_ish(Concept, NotationIsh) is det.
%
%	Unify NotationIsh with a label extend by (notation).
%	For notation, use the skos:notation or dc/dcterms:identifier
skos_notation_ish(Concept, NotationIsh) :-
	rdf_display_label(Concept, Label),
	(   (rdf(Concept, skos:notation, N)
	    ;	rdf_has(Concept, skos:notation, N)
	    ;	rdf_has(Concept, dc:identifier, N)
	    )
	->  literal_text(N, LT),
	    format(atom(NotationIsh), '~w (~w)', [Label, LT])
	;   NotationIsh = Label
	).


%%	skos_all_labels(URI, Labels) is det.
%
%	Find all labels using rdf_label/2.
%	Note that rdf_label itself is skos hooked...
skos_all_labels(R,Labels) :-
	findall(AltLabel, (rdf_label(R,Lit),
			   literal_text(Lit, AltLabel)
			  ),
		Labels0),
	sort(Labels0,Labels).


%%	skos_related_concepts(?Resource, ?Concepts) is det.
%
%	Related Concepts are linked by skos:related to Resource.

skos_related_concepts(S, Rs) :-
	findall(R, skos_related(S, R), Rs0),
	sort(Rs0, Rs).

skos_related(R1, R2) :-
	rdf_has(R1, skos:related, R2).
skos_related(R2, R1) :-
	rdf_has(R2, skos:related, R1).