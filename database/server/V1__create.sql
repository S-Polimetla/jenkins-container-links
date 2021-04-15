CREATE TABLE project (
	id bigint GENERATED BY DEFAULT AS IDENTITY,
	name TEXT NOT NULL,
	CONSTRAINT pk_project PRIMARY KEY (id),
	CONSTRAINT u_project UNIQUE (name)
);