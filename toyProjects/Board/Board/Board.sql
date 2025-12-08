-- 게시판 
create sequence seq_board;
 
create table tbl_board (
  bno number(10,0),
  title varchar2(200) not null,
  content varchar2(2000) not null,
  writer varchar2(50) not null,
  regdate date default sysdate, 
  updatedate date default sysdate
);
 
alter table tbl_board add constraint pk_board 
primary key (bno);

-- 댓글
create table tbl_reply (
  rno number(10,0), 
  bno number(10,0) not null,
  reply varchar2(1000) not null,
  replyer varchar2(50) not null, 
  replyDate date default sysdate, 
  updateDate date default sysdate
);
 
create sequence seq_reply;
 
alter table tbl_reply add constraint pk_reply primary key (rno);
 
alter table tbl_reply  add constraint fk_reply_board  
foreign key (bno)  references  tbl_board (bno); 

-- 복합인덱스(composite index)
drop index idx_reply;
create index idx_reply on tbl_reply(bno desc,rno asc);


select rno,bno,reply,replyer,replydate,updatedate
from (
    select  /*+INDEX(tbl_reply idx_reply) */ 
            rownum rn,rno, bno, reply, replyer,replydate,updatedate
    from tbl_reply
    where bno=324
    and rno >0
    and rownum <= 1 * 10			
)
where rn > (1-1) * 10;

-- Connecting tbl_reply with tbl_board
alter table tbl_board add(replycnt number default 0);

-- updating to latest amt of replies
update tbl_board 
    set replycnt = 
        (select count(rno) 
        from tbl_reply 
        where 
        tbl_reply.bno = tbl_board.bno);

select * from tbl_board order by bno desc;
    
    
-- Create table for attachment
create table tbl_attach(
    uuid varchar2(100) not null,
    uploadPath varchar2(200) not null,
    fileName varchar2(100) not null,
    fileType char(1) default 'I',
    bno number(10,0)
);
-- Updating the PK & FK
alter table tbl_attach add constraint pk_attach primary key (uuid);
alter table tbl_attach add constraints fk_board_attach foreign key (bno) references tbl_board(bno);


-- This query generates INSERT statements as text for every row in tbl_board

SELECT 'INSERT INTO tbl_board (bno, title, content, writer, regdate, updatedate, replycnt) VALUES ('
       || bno || ', ''' -- front quotation around title
       || title || ''', '''  -- front quotation in front of content
       || content || ''', ''' -- front quotation in front of writer
       || writer || ''', ''' -- front quotation in front of regdate
       || regdate || ''', ''' -- front quotation in front of updatedate
       || updatedate || ''', ' -- replyCnt is number so no need for ''
       || replycnt || ');'
FROM tbl_board;


-------------------------------------------------------------------------------
-- For first attempt
-------------------------------------------------------------------------------
-- USER table
create table users(
      username varchar2(50) not null primary key,
      password varchar2(50) not null,
      enabled char(1) default '1');
-- USER 권한 table
 create table authorities (
      username varchar2(50) not null,
      authority varchar2(50) not null,
      constraint fk_authorities_users foreign key(username) references users(username));
-- Index for 
create unique index ix_auth_username on authorities (username,authority);

-- User Table Insertion
insert into users (username, password) values ('user00','pw00');
insert into users (username, password) values ('member00','pw00');
insert into users (username, password) values ('admin00','pw00');
-- Authority Table Insertion
insert into authorities (username, authority) values ('user00','ROLE_USER');
insert into authorities (username, authority) values ('member00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_ADMIN');
commit;

select * from users;
select * from authorities order by authority;


-------------------------------------------------------------------------------
-- REAL DATA
-------------------------------------------------------------------------------
-- tbl_member for REAL data
create table tbl_member(
      userid varchar2(50) not null primary key,
      userpw varchar2(100) not null,
      username varchar2(100) not null,
      regdate date default sysdate, 
      updatedate date default sysdate,
      enabled char(1) default '1');
-- tbl_member_auth for REAL data
create table tbl_member_auth (
     userid varchar2(50) not null,
     auth varchar2(50) not null,
     constraint fk_member_auth foreign key(userid) references tbl_member(userid)
);

select * from tbl_member;
select * from tbl_member_auth;

--------------------------------------------------------------------------------
-- Persistent Login
--------------------------------------------------------------------------------
create table persistent_logins(
    username varchar2(64) not null,
    series varchar2(64) primary key,
    token varchar2(64) not null,
    last_used timestamp not null
);

select * from persistent_logins;