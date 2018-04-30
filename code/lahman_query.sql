USE lahman2016;

CREATE TEMPORARY TABLE IF NOT EXISTS playerdata
SELECT playerID, yearID, teamID, lgID, H, (H - 2B - 3B - HR) as 1B, 2B, 3B, HR, BB, HBP, SB, CS, AB, AVG(OBP) as OBP, AVG(SLG) as SLG
FROM batting
GROUP BY CONCAT(playerID, yearID);

CREATE TEMPORARY TABLE IF NOT EXISTS playerdata2
SELECT playerID, yearID, teamID, lgID, H, 1B, 2B, 3B, HR, BB, HBP, SB, CS, AB, OBP, SLG,
((1B + 2 * 2B + 3 * 3B + 4 * HR + SB - CS) / (AB - 1B - 2B - 3B - HR + CS)) as BAPA, 
(0.46 * 1B + 0.80 * 2B + 1.02 * 3B + 1.40 * HR + 0.33 * (BB + HBP) + 0.30 * SB - 0.60 * CS - 0.25 * (AB - H)) as LWTS
FROM playerdata;

SELECT m.nameFirst, m.nameLast, p.playerID, p.yearID, p.teamID, p.lgID, p.H, p.1B, p.2B, p.3B, p.HR, p.BB, p.HBP, p.SB, p.CS, p.AB, (p.H / p.AB) as BA, p.OBP, p.SLG, p.BAPA, p.LWTS
FROM playerdata2 p
LEFT JOIN master m ON m.playerID = p.playerID;