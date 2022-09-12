CREATE TABLE messages (
   id SERIAL NOT NULL PRIMARY KEY,
   parentid int REFERENCES messages,
   threadid int NOT NULL,
   _from text NOT NULL,
   _to text NOT NULL,
   cc text NOT NULL,
   subject text NOT NULL,
   date timestamptz NOT NULL,
   loaddate timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
   has_attachment boolean NOT NULL,
   hiddenstatus int NULL,
   messageid text NOT NULL,
   bodytxt text NOT NULL,
   rawtxt bytea NOT NULL
);
CREATE INDEX idx_messages_threadid ON messages(threadid);
CREATE UNIQUE INDEX idx_messages_msgid ON messages(messageid);
CREATE INDEX idx_messages_date ON messages(date);
CREATE INDEX idx_messages_parentid ON messages(parentid);

CREATE TABLE message_hide_reasons (
   message int NOT NULL PRIMARY KEY REFERENCES messages,
   dt timestamptz,
   reason text,
   by text
);

CREATE SEQUENCE threadid_seq;

CREATE TABLE unresolved_messages(
   message int NOT NULL REFERENCES messages,
   priority int NOT NULL,
   msgid text NOT NULL,
   CONSTRAINT unresolved_messages_pkey PRIMARY KEY (message, priority)
);

CREATE UNIQUE INDEX idx_unresolved_msgid_message ON unresolved_messages(msgid, message);

CREATE TABLE listgroups(
   groupid int NOT NULL PRIMARY KEY,
   groupname text NOT NULL UNIQUE,
   sortkey int NOT NULL
);

CREATE TABLE lists(
   listid int NOT NULL PRIMARY KEY,
   listname text NOT NULL UNIQUE,
   shortdesc text NOT NULL,
   description text NOT NULL,
   active boolean NOT NULL,
   subscriber_access boolean NOT NULL,
   groupid int NOT NULL REFERENCES listgroups(groupid)
);

CREATE TABLE list_months(
   listid int NOT NULL REFERENCES lists(listid),
   year int NOT NULL,
   month int NOT NULL,
   CONSTRAINT list_months_pk PRIMARY KEY (listid, year, month)
);

CREATE TABLE list_threads(
   threadid int NOT NULL, /* comes from threadid_seq */
   listid int NOT NULL REFERENCES lists(listid),
   CONSTRAINT pg_list_threads PRIMARY KEY (threadid, listid)
);
CREATE INDEX list_threads_listid_idx ON list_threads(listid);

CREATE TABLE attachments(
   id serial not null primary key,
   message int not null references messages(id),
   filename text not null,
   contenttype text not null,
   attachment bytea not null
);
CREATE INDEX idx_attachments_msg ON attachments(message);

CREATE TABLE loaderrors(
   id SERIAL NOT NULL PRIMARY KEY,
   listid int NOT NULL,
   dat timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
   msgid text NOT NULL,
   srctype text NOT NULL,
   src text NOT NULL,
   err text NOT NULL
);
