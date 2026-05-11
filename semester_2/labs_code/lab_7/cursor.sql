begin;
call cinema.movies_pagination('c'::refcursor);
fetch 5 from c;
fetch 3 from c;
commit;