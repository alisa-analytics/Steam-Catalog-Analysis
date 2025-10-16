SELECT price_overview FROM games;

CREATE TABLE games_cleaning 
LIKE games;

INSERT games_cleaning 
SELECT * FROM games;

ALTER TABLE games_cleaning  
RENAME COLUMN price_overview TO price;

ALTER TABLE games_cleaning ADD COLUMN currency TEXT;
UPDATE games_cleaning SET currency = price;
ALTER TABLE games_cleaning MODIFY COLUMN currency TEXT AFTER price;

SELECT count(*) FROM games_cleaning;

SELECT * FROM games_cleaning;

UPDATE games_cleaning
SET price = REPLACE(
           REGEXP_REPLACE(
               JSON_UNQUOTE(
                   JSON_EXTRACT(
                       REPLACE(price, ';', ','), 
                       '$.final_formatted'
                   )
               ), 
               '[^0-9,.]', 
               ''
           ), 
           ',', 
           '.'
       );
       
UPDATE games_cleaning
SET currency = JSON_UNQUOTE(JSON_EXTRACT(
               REPLACE(currency, ';', ','), '$.currency'
           ));

UPDATE games_cleaning  
SET price = COALESCE(price, 0);

SELECT price FROM games_cleaning
WHERE price = 0;

SELECT REGEXP_REPLACE(
           REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                   REPLACE(languages, '&amp;', '&'), 
                   '&amp;lt;', '<'), 
                   '&amp;gt;', '>'), 
                   '&lt;', '<'), 
                   '&gt;', '>'), 
                   '<strong>*</strong>', ''), 
                   '<strong></strong>', ''), 
                   '[b]*[/b]', ''), 
               '<strong>\\*</strong>', ''
           ),
           '<br.*', ''
       ) AS cleaned_text
FROM games_cleaning;

UPDATE games_cleaning
SET languages = REGEXP_REPLACE(
           REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                   REPLACE(languages, '&amp;', '&'), 
                   '&amp;lt;', '<'), 
                   '&amp;gt;', '>'), 
                   '&lt;', '<'), 
                   '&gt;', '>'), 
                   '<strong>*</strong>', ''), 
                   '<strong></strong>', ''), 
                   '[b]*[/b]', ''), 
               '<strong>\\*</strong>', ''
           ),
           '<br.*', ''
       );

SELECT * FROM games_cleaning
WHERE release_date IS NULL;

ALTER TABLE games_cleaning
MODIFY COLUMN price FLOAT;

SELECT * FROM games_cleaning
LIMIT 1 OFFSET 1017;

SHOW COLUMNS FROM games_cleaning LIKE 'price';

SELECT * FROM games_cleaning WHERE price REGEXP '\\.(?![0-9])';

SELECT REGEXP_REPLACE(price, '\\.(?![0-9])', '') AS cleaned_text
FROM games_cleaning;

UPDATE games_cleaning
SET price = REGEXP_REPLACE(price, '\\.(?![0-9])', '');

SELECT * FROM games_cleaning WHERE price REGEXP '(^|[^0-9])\\.';

SELECT REGEXP_REPLACE(price, '(^|[^0-9])\\.', '') AS cleaned_text
FROM games_cleaning
WHERE currency = 'PEN';

UPDATE games_cleaning
SET price = REGEXP_REPLACE(price, '(^|[^0-9])\\.', '');

SELECT * FROM games_cleaning WHERE price REGEXP '\\..*\\.';

SELECT REGEXP_REPLACE(price, '^(.*?)\\.', '\\1', 1) AS cleaned_text
FROM games_cleaning
WHERE price REGEXP '\\..*\\.';

UPDATE games_cleaning
SET price = REGEXP_REPLACE(price, '^(.*?)\\.', '\\1', 1)
WHERE price REGEXP '\\..*\\.';

UPDATE games_cleaning
SET price = REGEXP_REPLACE(price, '[^0-9.]', '');

SELECT *
FROM games_cleaning
WHERE (price IS NULL OR price = '') AND is_free = 1;

UPDATE games_cleaning
SET price = 0
WHERE (price IS NULL OR price = '') AND is_free = 1;

ALTER TABLE games_cleaning  
MODIFY COLUMN price FLOAT;

SELECT * FROM reviews;
SELECT * FROM games_cleaning;

#The Boxleiter method allows us to estimate a game’s number of owners on Steam based on how many reviews it has. Source: https://greyaliengames.com/blog/how-to-estimate-how-many-sales-a-steam-game-has-made/

SELECT ROUND(r.total * 35 * g.price * 0.3) AS estimated_revenue
FROM games_cleaning g
JOIN reviews r ON g.app_id = r.app_id;

ALTER TABLE games_cleaning ADD COLUMN estimated_revenue FLOAT;

ALTER TABLE reviews 
DROP COLUMN metacritic_score, 
DROP COLUMN reviews,
DROP COLUMN recommendations,
DROP COLUMN steamspy_user_score,
DROP COLUMN steamspy_score_rank,
DROP COLUMN steamspy_positive,
DROP COLUMN steamspy_negative;

EXPLAIN UPDATE games_cleaning g
JOIN reviews r ON g.app_id = r.app_id
SET g.estimated_revenue = ROUND(r.total * 35 * g.price * 0.3);

ALTER TABLE games_cleaning ADD UNIQUE INDEX idx_app_id (app_id);
ALTER TABLE reviews ADD UNIQUE INDEX idx_app_id (app_id);
ALTER TABLE categories ADD INDEX idx_app_id (app_id);
ALTER TABLE genres ADD INDEX idx_app_id (app_id);
ALTER TABLE tags ADD INDEX idx_app_id (app_id);


UPDATE games_cleaning g
JOIN reviews r ON g.app_id = r.app_id
SET g.estimated_revenue = ROUND(r.total * 35 * g.price * 0.3);

SELECT 
    COUNT(*) AS total_rows, 
    COUNT(DISTINCT app_id) AS unique_app_ids
FROM games_cleaning;

SELECT COUNT(*) AS total_rows
FROM games_cleaning
WHERE is_free = 1;

SELECT currency, COUNT(app_id) AS app_count
FROM games_cleaning
GROUP BY currency
ORDER BY app_count DESC;

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.9,
    price = price * 0.9
WHERE currency = 'USD';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 1.2,
    price = price * 1.2
WHERE currency = 'GBP';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.01,
    price = price * 0.01
WHERE currency = 'RUB';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.65,
    price = price * 0.65
WHERE currency = 'CAD';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.26,
    price = price * 0.26
WHERE currency = 'ILS';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.16,
    price = price * 0.16
WHERE currency = 'BRL';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.23,
    price = price * 0.23
WHERE currency = 'AED';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.56,
    price = price * 0.56
WHERE currency = 'AUD';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.12,
    price = price * 0.12
WHERE currency = 'CNY';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.0002,
    price = price * 0.0002
WHERE currency = 'COP';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.11,
    price = price * 0.11
WHERE currency = 'HKD';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.00005,
    price = price * 0.00005
WHERE currency = 'IDR';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.0096,
    price = price * 0.0096
WHERE currency = 'INR';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.0058,
    price = price * 0.0058
WHERE currency = 'JPY';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.00061,
    price = price * 0.00061
WHERE currency = 'KRW';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 2.79,
    price = price * 2.79
WHERE currency = 'KWD';
--
UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.0016,
    price = price * 0.0016
WHERE currency = 'KZT';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.20,
    price = price * 0.20
WHERE currency = 'MYR';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.085,
    price = price * 0.085
WHERE currency = 'NOK';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.49,
    price = price * 0.49
WHERE currency = 'NZD';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.24,
    price = price * 0.24
WHERE currency = 'PEN';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.015,
    price = price * 0.015
WHERE currency = 'PHP';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.028,
    price = price * 0.028
WHERE currency = 'TWD';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.021,
    price = price * 0.021
WHERE currency = 'UAH';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.000032,
    price = price * 0.000032
WHERE currency = 'VND';

-- the price didn't converted right due to the currency format
UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 1000,
    price = price * 1000
WHERE app_id = 1942280;

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.23,
    price = price * 0.23
WHERE currency = 'PLN';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.23,
    price = price * 0.23
WHERE currency = 'SAR';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.66,
    price = price * 0.66
WHERE currency = 'SGD';

UPDATE games_cleaning
SET estimated_revenue = estimated_revenue * 0.026,
    price = price * 0.026
WHERE currency = 'THB';


UPDATE games_cleaning
SET currency = 'EUR'
WHERE currency = 'USD' or currency = 'GBP' or currency = 'RUB' or currency = 'CAD' or currency = 'ILS' or currency = 'BRL' or currency = 'MXN' or currency = 'AED' or currency = 'AUD' or currency = 'CNY' or currency = 'COP' or currency = 'HKD' or currency = 'IDR' or currency = 'INR' or currency = 'JPY' or currency = 'KRW' or currency = 'KWD' or currency = 'KZT';

UPDATE games_cleaning
SET currency = 'EUR'
WHERE currency = 'MYR' or currency = 'NOK' or currency = 'NZD' or currency = 'PEN' or currency = 'PHP' or currency = 'TWD' or currency = 'UAH' or currency = 'VND' or currency = 'THB' or currency = 'SGD' or currency = 'SAR' or currency = 'PLN';

SELECT * 
FROM games_cleaning 
WHERE currency IS NULL 
  AND is_free = 0; 
  AND price != 0;
  
SELECT * FROM categories
WHERE category REGEXP '[^a-zA-Z0-9_\\-/–()& \xA0]';

SELECT * FROM genres
WHERE genre REGEXP '[^a-zA-Z0-9_\\-/–()& \xA0]';

SELECT COUNT(*) AS total_rows
FROM categories
WHERE category REGEXP '[^a-zA-Z0-9_\\-/–()& \xA0]';

SELECT COUNT(*) AS total_rows
FROM genres
WHERE genre REGEXP '[^a-zA-Z0-9_\\-/–()& \xA0]';

DELETE FROM categories
WHERE category REGEXP '[^a-zA-Z0-9_\\-/–()& \xA0]';

DELETE FROM genres
WHERE genre REGEXP '[^a-zA-Z0-9_\\-/–()& \xA0]';

SELECT * 
FROM games
WHERE price_overview LIKE '%VND%';

SELECT * 
FROM games_cleaning
WHERE app_id = 1942280;

SELECT DISTINCT category
FROM categories
ORDER BY category;

#Translate all categories to English

-- 🎯 Achievements
UPDATE categories SET category = 'Steam Achievements' WHERE category IN (
  'Achievement di Steam','Achievementy','Conquistas Steam','Logros de Steam','Proezas do Steam',
  'Steam Achievements','Steam-Errungenschaften','Steam-prestasjoner','Steam-prestaties',
  'Steam-saavutukset','Steam-ruilkaarten','Steam-Errungenschaften'
);

-- 🎯 Trading Cards
UPDATE categories SET category = 'Steam Trading Cards' WHERE category IN (
  'Carte collezionabili di Steam','Cromos de Steam','Karty kolekcjonerskie Steam',
  'Steam Trading Cards','Steam-byttekort','Steam-ruilkaarten','Steam-Sammelkarten','Tarjetas de Steam'
);

-- 🎯 Leaderboards
UPDATE categories SET category = 'Steam Leaderboards' WHERE category IN (
  'Classements Steam','Classifiche di Steam','Marcadores de Steam','Steam Leaderboards','Steam-Bestenlisten'
);

-- 🎯 Family Sharing
UPDATE categories SET category = 'Family Sharing' WHERE category IN (
  'Condivisione familiare','Familiedeling','Familienbibliothek','Gezinsbibliotheek',
  'Partage familial','Partilha de Biblioteca','Perhejako','Family Sharing'
);

-- 🎯 Cloud
UPDATE categories SET category = 'Steam Cloud' WHERE category IN (
  'Nuvem Steam','Steam Cloud'
);

-- 🎯 Workshop
UPDATE categories SET category = 'Steam Workshop' WHERE category IN (
  'Warsztat Steam','Workshop Steam','Steam Workshop'
);

-- 🎯 Multiplayer
UPDATE categories SET category = 'Multiplayer' WHERE category IN (
  'Mehrspieler','Moninpeli','Multi-player','Multigiocatore','Multijogador',
  'Multijoueur','Multijugador','Wieloosobowa','Multiplayer'
);

-- 🎯 Cross-Platform Multiplayer
UPDATE categories SET category = 'Cross-Platform Multiplayer' WHERE category IN (
  'Multijoueur multiplateforme','Multijugador multiplataforma','Wieloplatformowa wieloosobowa',
  'Cross-Platform Multiplayer'
);

-- 🎯 MMO
UPDATE categories SET category = 'MMO' WHERE category IN ('MMO');

-- 🎯 Single-player
UPDATE categories SET category = 'Single-player' WHERE category IN (
  'Einzelspieler','Enkeltspiller','Giocatore singolo','Jednoosobowa','Solo',
  'Um jogador','Un jugador','Yksinpeli','Single-player','Singleplayer'
);

-- 🎯 Co-op
UPDATE categories SET category = 'Co-op' WHERE category IN (
  'Co-op','Cooperativo','Cooperativos','Koop','Kooperacja','Koop-Spiele mit geteiltem Bildschirm',
  'Multijoueur coopératif','Partita cooperativa online','LAN Co-op','LAN – co-op','Online Co-op',
  'Online-Koop','Sieciowa kooperacja','Partage coopératif'
);

-- 🎯 Split/Shared Screen
UPDATE categories SET category = 'Shared/Split Screen' WHERE category IN (
  'Cooperativos en pantalla dividida/compartida','Geteilter Bildschirm','Pantalla dividida/compartida',
  'Pantalla partida/compartida','Shared/Split Screen','Shared/Split Screen Co-op','Shared/Split Screen PvP'
);

-- 🎯 PvP
UPDATE categories SET category = 'PvP' WHERE category IN (
  'JcJ','JcJ a pantalla (com)partida','JcJ en ligne','JcJ en pantalla dividida/compartida',
  'LAN PvP','Online PvP','Online-PvP','PvP','PvP online','Verkko-PvP'
);

-- 🎯 Remote Play
UPDATE categories SET category = 'Remote Play' WHERE category IN (
  'Remote Play auf Smartphones','Remote Play auf Tablets','Remote Play na tablecie',
  'Remote Play na telefonie','Remote Play na telewizorze','Remote Play na TV',
  'Remote Play no celular','Remote Play no tablet','Remote Play on Phone','Remote Play on Tablet',
  'Remote Play on TV','Remote Play op tablets','Remote Play op telefoons','Remote Play op televisies',
  'Remote Play para tabletas','Remote Play para TV','Remote Play sul tablet','Remote Play sul telefono',
  'Remote Play sulla TV','Remote Play sur tablette','Remote Play tabletilla','Remote Play Together'
);

-- 🎯 Controller Support
UPDATE categories SET category = 'Full Controller Support' WHERE category IN (
  'Full controller support','Volledige controllerondersteuning','Supporto completo per i controller'
);
UPDATE categories SET category = 'Partial Controller Support' WHERE category IN (
  'Partial Controller Support','Gedeeltelijke controllerondersteuning','Supporto parziale per i controller'
);
UPDATE categories SET category = 'Tracked Controller Support' WHERE category IN (
  'Supporto per i controller tracciati','Tracked Controller Support'
);

-- 🎯 VR
UPDATE categories SET category = 'VR Supported' WHERE category IN (
  'Compatibile con VR','Compatibilidad con RV','Compatible con RV','VR Supported'
);
UPDATE categories SET category = 'VR Only' WHERE category IN ('VR Only');
UPDATE categories SET category = 'VR Support' WHERE category IN ('VR Support');
UPDATE categories SET category = 'SteamVR Collectibles' WHERE category IN ('SteamVR Collectibles');

-- 🎯 Mods
UPDATE categories SET category = 'Mods' WHERE category IN (
  'Mods','Mods (require HL2)'
);

-- 🎯 Demos
UPDATE categories SET category = 'Game demo' WHERE category IN (
  'Game demo','Spieldemo'
);

-- 🎯 Statistics
UPDATE categories SET category = 'Stats' WHERE category IN (
  'Statistik','Stats','Statystyki'
);

-- 🎯 Timeline / Turn notifications
UPDATE categories SET category = 'Steam Timeline' WHERE category IN ('Steam Timeline');
UPDATE categories SET category = 'Steam Turn Notifications' WHERE category IN ('Steam Turn Notifications');

-- 🎯 Anti-Cheat
UPDATE categories SET category = 'Valve Anti-Cheat enabled' WHERE category IN (
  'Valve Anti-Cheat enabled','Valve Anti-Cheat integriert'
);

-- 🎯 HDR
UPDATE categories SET category = 'HDR available' WHERE category IN (
  'HDR available','HDR disponibili','HDR disponible'
);

-- 🎯 Captions / Commentary
UPDATE categories SET category = 'Captions available' WHERE category IN ('Captions available','Tekstitys');
UPDATE categories SET category = 'Commentary available' WHERE category IN (
  'Comentario disponible','Commentary available'
);

-- 🎯 Level Editor / SDK
UPDATE categories SET category = 'Includes level editor' WHERE category IN (
  'Includes level editor','Indeholder baneeditor'
);
UPDATE categories SET category = 'Includes Source SDK' WHERE category IN ('Includes Source SDK');

-- 🎯 In-App Purchases
UPDATE categories SET category = 'In-App Purchases' WHERE category IN (
  'Achats en jeu','Compras em aplicativo','Zakupy w aplikacji','In-App Purchases'
);

UPDATE categories 
SET category = 'Massively Multiplayer' 
WHERE category = 'Multijugador masivo';

SELECT DISTINCT genre
FROM genres
ORDER BY genre;

#Translate genres

-- 🎯 Action
UPDATE genres SET genre = 'Action' WHERE genre IN (
  'Actie','Action','Akcja','Azione'
);

-- 🎯 Adventure
UPDATE genres SET genre = 'Adventure' WHERE genre IN (
  'Abenteuer','Adventure','Aventura','Aventure','Avontuur','Avventura','Eventyr','Seikkailu'
);

-- 🎯 RPG
UPDATE genres SET genre = 'RPG' WHERE genre IN (
  'GDR','Rol','Rollenspiel','Roolipelit','RPG'
);

-- 🎯 Strategy
UPDATE genres SET genre = 'Strategy' WHERE genre IN (
  'Estrategia','Strategi','Strategia','Strategie','Strategy'
);

-- 🎯 Simulation
UPDATE genres SET genre = 'Simulation' WHERE genre IN (
  'Simulaatio','Simuladores','Simulatie','Simulation','Simulationen','Simulering'
);

-- 🎯 Racing
UPDATE genres SET genre = 'Racing' WHERE genre IN (
  'Carreras','Course automobile','Race','Racing'
);

-- 🎯 Sports
UPDATE genres SET genre = 'Sports' WHERE genre IN (
  'Deportes','Sport','Sports'
);

-- 🎯 Casual
UPDATE genres SET genre = 'Casual' WHERE genre IN (
  'Casual','Gelegenheitsspiele','Occasionnel','Passatempo'
);

-- 🎯 Indie
UPDATE genres SET genre = 'Indie' WHERE genre IN ('Indie');

-- 🎯 Early Access
UPDATE genres SET genre = 'Early Access' WHERE genre IN (
  'Acceso anticipado','Early Access'
);

-- 🎯 Free to Play
UPDATE genres SET genre = 'Free-to-play' WHERE genre IN (
  'Free To Play','Free-to-play','Kostenlos spielbar'
);

-- 🎯 Massively Multiplayer
UPDATE genres SET genre = 'Massively Multiplayer' WHERE genre IN (
  'Massively Multiplayer','Massivement multijoueur','MMO','Multijugador masivo'
);

-- 🎯 Sexual Content
UPDATE genres SET genre = 'Sexual Content' WHERE genre IN ('Sexual Content','Nudity');

-- 🎯 Violent
UPDATE genres SET genre = 'Violent' WHERE genre IN ('Violent','Gore');

-- 🎯 Education
UPDATE genres SET genre = 'Education' WHERE genre IN ('Education','Software Training','Tutorial');

-- 🎯 Utilities
UPDATE genres SET genre = 'Utilities' WHERE genre IN ('Utilidades','Utilities');

-- 🎯 Design & Illustration
UPDATE genres SET genre = 'Design & Illustration' WHERE genre IN ('Design & Illustration');

-- 🎯 Animation & Modeling
UPDATE genres SET genre = 'Animation & Modeling' WHERE genre IN ('Animation & Modeling');

-- 🎯 Audio Production
UPDATE genres SET genre = 'Audio Production' WHERE genre IN ('Audio Production');

-- 🎯 Photo Editing
UPDATE genres SET genre = 'Photo Editing' WHERE genre IN ('Photo Editing');

-- 🎯 Video Production
UPDATE genres SET genre = 'Video Production' WHERE genre IN ('Video Production');

-- 🎯 Web Publishing
UPDATE genres SET genre = 'Web Publishing' WHERE genre IN ('Web Publishing');

-- 🎯 Game Development
UPDATE genres SET genre = 'Game Development' WHERE genre IN ('Game Development');

-- 🎯 Episodic
UPDATE genres SET genre = 'Episodic' WHERE genre IN ('Episodic');

-- 🎯 Accounting (VR genre)
UPDATE genres SET genre = 'Accounting' WHERE genre IN ('Accounting');

-- 🎯 Strategy (already handled, but keep duplicates safe)
UPDATE genres SET genre = 'Strategy' WHERE genre IN ('Strategie');

SELECT DISTINCT tag
FROM tags
ORDER BY tag;
