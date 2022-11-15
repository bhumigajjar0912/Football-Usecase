--STEP 1
--CREATING A WAREHOUSE
create warehouse usecase;

--STEP 3
--CREATING A DATABASE
create database football_data;


--STEP 4
--CREATING A FILE FORMAT
create file format my_csv_format  
type = 'CSV'  
field_delimiter = ','  
skip_header = 1;

--STEP 5
--CREATING A STAGE
CREATE STAGE my_csv_stage
file_format = my_csv_format
  url = 's3://snowflakefootballdata/Football Dataset/'
  CREDENTIALS=(aws_secret_key='Zl8ku1HCuG6xb0tnC9D7RXlYUtIwS//0OWSmImjI' aws_key_id='AKIAYJ2R46DDFFHRKTCG');

--STEP 6
--CREATING THE BASE TABLE ON SNOWFLAKE

--TABLE 1: LEAGUES
create table Leagues
  (leagueID Int primary Key, 
   Name Varchar, 
   UnderstatNotation Varchar);

--TABLE 2: PLAYERS
create table players
(playerID int primary key, 
 Name Varchar(50));

--TABLE 3: TEAMS
CREATE TABLE teams
(teamId int primary key,
 Name Varchar(100));

--TABLE 4: GAMES
create table games
(gameId int primary key, 
leagueId int,
season int,
date timestamp ,
homeTeamID int,
awayTeamID int,
homeGoals int,
awayGoals int,
homeProbability int,
drawProbability int,
awayProbability int,
homeGoalsHalfTime int,
awayGoalsHalfTime int,
foreign key (leagueId) references leagues(leagueId)
);

--TABLE 5: TEAMSTATS
create table teamstats
(
    gameId int,
    teamId int,
    season int,
    date timestamp,
    location varchar(10),
    goals int,
    xGoals int,
    shots int,
    shotsOnTarget int  
);

ALTER TABLE TEAMSTATS
ADD CONSTRAINT PK_Teamstats PRIMARY KEY (gameId,teamId);


--TABLE 6: APPEARANCES
create table appearances (
    gameID int,
    playerId int,
    goals int,
    ownGoals int,
    shots int,
    xGoals int,
    assists int,
    keyPasses int,
    position varchar(50),
    positionOrder int,
    yellowCard int,
    redCard int,
    time int,
    leagueID int
);

ALTER TABLE APPEARANCES
ADD CONSTRAINT PK_Appearances PRIMARY KEY (gameId,PlayerId);


--TABLE 7: SHOTS
create table shots (
    gameId int,
    shooterId int,
    assisterId int,
    minute int,
    situation varchar(50),
    lastAction varchar(50), 
    shotType varchar(50),
    shotResult varchar(50),
    xGoal int
);

ALTER TABLE SHOTS
ADD CONSTRAINT PK_Shots PRIMARY KEY (gameId,shooterId);



--STEP 7
--COPYING THE DATA FROM S3 INTO TARGET TABLE

--copy data (Leagues Table)
copy into leagues
  from @my_csv_stage/leagues1.csv
  on_error = 'skip_file';
  

--copy data (Players)
copy into players
  from @my_csv_stage/players1.csv
  on_error = 'skip_file';
  
  
--copy data (teams)
copy into teams
  from @my_csv_stage/teams1.csv
  on_error = 'skip_file';


--copy data(games)
copy into games
  from @my_csv_stage/games1.csv
  on_error = 'skip_file';


--copy data (teamstats)
copy into teamstats
  from @my_csv_stage/teamstats1.csv
  on_error = 'skip_file';


--copy data (appearnces)
copy into appearances
  from @my_csv_stage/appearances1.csv
  on_error = 'skip_file';
  

--copy data (shots)
copy into shots
  from @my_csv_stage/shots1.csv
  on_error = 'skip_file';
  



