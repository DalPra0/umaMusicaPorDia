-- BANCO DE DADOS DE NOSTALGIA DEFINITIVO (730+ DIAS) --
-- Versão Corrigida (Sem Duplicatas) --

-- 1. Estrutura
CREATE TABLE IF NOT EXISTS public.word_pool (
  id SERIAL PRIMARY KEY,
  word TEXT NOT NULL UNIQUE,
  category TEXT
);

-- Limpa para garantir um fresh start
TRUNCATE public.word_pool;

-- 2. INSERÇÃO MASSIVA (Lote 1: Tech & Internet)
INSERT INTO public.word_pool (word, category) VALUES 
('Motorola V3 Pink', 'tech'), ('Nokia 3310 Tijolão', 'tech'), ('Sony Ericsson Walkman', 'tech'), ('iPod Nano', 'tech'),
('iPod Shuffle', 'tech'), ('Discman que pula', 'tech'), ('Walkman de fita', 'tech'), ('MP3 Player de 128MB', 'tech'),
('Pendrive de 256MB', 'tech'), ('Câmera Cyber-shot', 'tech'), ('Câmera de Pilha', 'tech'), ('Webcam com microfone', 'tech'),
('Mouse de Bolinha', 'tech'), ('Monitor de Tubo', 'tech'), ('CPU Branca Amarelada', 'tech'), ('Disquete de 1.44MB', 'tech'),
('CD-R de 700MB', 'tech'), ('DVD-RW', 'tech'), ('MiniDisc', 'tech'), ('Zip Drive', 'tech'),
('Palm Pilot', 'tech'), ('Calculadora HP', 'tech'), ('GameBoy Color', 'tech'), ('GameBoy Advance SP', 'tech'),
('Nintendo DS', 'tech'), ('PlayStation 2 Slim', 'tech'), ('Controle de PS2 com fio', 'tech'), ('Memory Card de 8MB', 'tech'),
('Xbox Original', 'tech'), ('GameCube Roxo', 'tech'), ('Tamagotchi Gen 1', 'tech'), ('Brick Game 9999 in 1', 'tech'),
('Rádio de pilha', 'tech'), ('Telefone sem fio', 'tech'), ('Pager / Bip', 'tech'), ('Fax', 'tech'),
('Modem 56kbps', 'tech'), ('Filtro de linha antigo', 'tech'), ('Estabilizador de PC', 'tech'), ('Caixa de som branca', 'tech'),
('Fone de espuma laranja', 'tech'), ('Microfone de pedestal', 'tech'), ('Teclado mecânico barulhento', 'tech'), ('Mousepad de pano', 'tech'),
('MSN Messenger', 'web'), ('Janela de Chamar Atenção', 'web'), ('Subnick do MSN', 'web'), ('Winks do MSN', 'web'),
('Status: Ocupado', 'web'), ('Status: Invisível', 'web'), ('Emoticons de Pixel', 'web'), ('Buzz do MSN', 'web'),
('Orkut', 'web'), ('Sorte do Dia do Orkut', 'web'), ('Depoimento no Topo', 'web'), ('Scrapbook', 'web'),
('Comunidade do Orkut', 'web'), ('BuddyPoke', 'web'), ('Colheita Feliz', 'web'), ('Cafe Mania', 'web'),
('Fotolog', 'web'), ('Flogão', 'web'), ('MySpace', 'web'), ('ICQ', 'web'),
('mIRC', 'web'), ('Bate-papo UOL', 'web'), ('Humortadela', 'web'), ('Charges.com.br', 'web'),
('Limewire', 'web'), ('Kazaa', 'web'), ('Ares Galaxy', 'web'), ('Napster', 'web'),
('Winamp', 'web'), ('Skins do Winamp', 'web'), ('Nero Burning ROM', 'web'), ('Windows Movie Maker', 'web'),
('Google de 2004', 'web'), ('Yahoo Respostas', 'web'), ('Wikipedia da escola', 'web'), ('Cadê?', 'web'),
('Altavista', 'web'), ('StumbleUpon', 'web'), ('Habbo Hotel', 'web'), ('Club Penguin', 'web'),
('Neopets', 'web'), ('Miniclip', 'web'), ('Jogos de Meninas', 'web'), ('O Jogo do Labirinto', 'web'),
('Flash Games', 'web'), ('Newgrounds', 'web'), ('DeviantArt antigo', 'web'), ('Blogger', 'web'),
('Internet Discada', 'web'), ('Barulho do Modem', 'web'), ('Placa de Captura', 'web'), ('Lan House', 'web'),
('Corrente de E-mail', 'web'), ('Vírus do cavalo de troia', 'web'), ('Wallpaper de Paisagem', 'web'), ('Gif de Construção', 'web'),
('AOL', 'web'), ('Globo.com antigo', 'web'), ('Fórum de RPG', 'web'), ('Download de 99%', 'web')
ON CONFLICT (word) DO NOTHING;

-- (Lote 2: Moda, Y2K & Estética)
INSERT INTO public.word_pool (word, category) VALUES 
('Gloss Labial que gruda', 'fashion'), ('Butterfly Clips', 'fashion'), ('Presilha de Tic-Tac', 'fashion'), ('Tiara de dente', 'fashion'),
('Calça de Cintura Baixa', 'fashion'), ('Tênis de Rodinha', 'fashion'), ('All Star Cano Alto', 'fashion'), ('Nike Shox de 4 molas', 'fashion'),
('Mizuno Wave', 'fashion'), ('Adidas Superstar', 'fashion'), ('Reebok EasyTone', 'fashion'), ('Sandália da Sandy', 'fashion'),
('Melissinha de Aranha', 'fashion'), ('Pulseira de Bate-Enrola', 'fashion'), ('Pulseira do Equilíbrio', 'fashion'), ('Pulseira de Silicone', 'fashion'),
('Colar de Miçanga', 'fashion'), ('Gargantilha Choker', 'fashion'), ('Anel de Humor', 'fashion'), ('Piercing no Umbigo', 'fashion'),
('Boné da Von Dutch', 'fashion'), ('Boné de Redinha', 'fashion'), ('Cinto de Tachinhas', 'fashion'), ('Cinto de Corrente', 'fashion'),
('Bandana no pescoço', 'fashion'), ('Bandana no cabelo', 'fashion'), ('Munhequeira de Rock', 'fashion'), ('Meia 7/8 listrada', 'fashion'),
('Saia de Prega', 'fashion'), ('Moletom da Gap', 'fashion'), ('Jaqueta de Tactel', 'fashion'), ('Calça Cargo Baggy', 'fashion'),
('Calça de Moletom escrita na bunda', 'fashion'), ('Camiseta de Personagem', 'fashion'), ('Blusa de Gola Alta', 'fashion'), ('Colete Jeans', 'fashion'),
('Legging Colorida', 'fashion'), ('Tutu de Tule', 'fashion'), ('Luzes no Cabelo', 'fashion'), ('Franja Emo', 'fashion'),
('Cabelo Repicado', 'fashion'), ('Gel com Glitter', 'fashion'), ('Maquiagem Neon', 'fashion'), ('Sombra Azul', 'fashion'),
('Rímel Colorido', 'fashion'), ('Esmalte Craquelado', 'fashion'), ('Adesivo de Estrela', 'fashion'), ('Holográfico', 'fashion'),
('Prateado Metalizado', 'aesthetic'), ('Transparência', 'aesthetic'), ('Frutiger Aero', 'aesthetic'), ('Vaporwave Root', 'aesthetic'),
('Estética Emo', 'aesthetic'), ('Scene Queen', 'aesthetic'), ('Skater Boy', 'aesthetic'), ('Indie Sleaze', 'aesthetic'),
('Cyber Y2K', 'aesthetic'), ('McBling', 'aesthetic'), ('Cores Pastel', 'aesthetic'), ('Glitter Corporal', 'fashion'),
('Mochila da Kipling', 'fashion'), ('Mochila de Rodinha', 'fashion'), ('Fichário da Capricho', 'fashion'), ('Estojo de 100 Pens', 'fashion'),
('Bad Boy', 'fashion'), ('Fubu', 'fashion'), ('Ecko Unltd', 'fashion'), ('Oakley Juliet', 'fashion'),
('Relógio Baby-G', 'fashion'), ('Relógio de Calculadora', 'fashion'), ('Pulseira Livestrong', 'fashion'), ('Chaveiro de Pelúcia', 'fashion')
ON CONFLICT (word) DO NOTHING;

-- (Lote 3: TV, Música & Pop Culture)
INSERT INTO public.word_pool (word, category) VALUES 
('Disk MTV', 'tv'), ('Rockgol', 'tv'), ('Beija Sapo', 'tv'), ('Pânico na TV', 'tv'),
('Hermes e Renato', 'tv'), ('Casseta & Planeta', 'tv'), ('A Turma do Didi', 'tv'), ('Zorra Total antigo', 'tv'),
('TV Globinho', 'tv'), ('Bom Dia & Cia', 'tv'), ('Band Kids', 'tv'), ('Sábado Animado', 'tv'),
('Dragon Ball Z', 'tv'), ('Pokémon na TV', 'tv'), ('Digimon', 'tv'), ('Yu-Gi-Oh!', 'tv'),
('Cavaleiros do Zodíaco', 'tv'), ('Sailor Moon', 'tv'), ('Power Rangers', 'tv'), ('Teletubbies', 'tv'),
('Sítio do Pica-Pau Amarelo', 'tv'), ('Castelo Rá-Tim-Bum', 'tv'), ('Ilha Rá-Tim-Bum', 'tv'), ('Vila Sésamo', 'tv'),
('Disney Channel', 'tv'), ('Nickelodeon', 'tv'), ('Cartoon Network antigo', 'tv'), ('Jetix', 'tv'),
('High School Musical', 'tv'), ('Hannah Montana', 'tv'), ('Lizzie McGuire', 'tv'), ('That''s So Raven', 'tv'),
('Drake & Josh', 'tv'), ('Zoey 101', 'tv'), ('iCarly', 'tv'), ('Victorious', 'tv'),
('Rebelde RBD', 'tv'), ('Floribella', 'tv'), ('Chiquititas', 'tv'), ('Malhação do Cabeção', 'tv'),
('Sandy & Junior', 'tv'), ('Xuxa no Mundo da Imaginação', 'tv'), ('Eliana e os Dedinhos', 'tv'), ('Gugu - Banheira', 'tv'),
('Faustão - Sushi Erótico', 'tv'), ('Ratinho antigo', 'tv'), ('João Kléber - Teste de Fidelidade', 'tv'), ('Leão Lobo', 'tv'),
('Britney Spears - Toxic', 'pop'), ('Avril Lavigne - Sk8er Boi', 'pop'), ('Linkin Park - Hybrid Theory', 'pop'), ('Evanescence - Bring Me To Life', 'pop'),
('Green Day - American Idiot', 'pop'), ('My Chemical Romance', 'pop'), ('Panic! At The Disco', 'pop'), ('Tokio Hotel', 'pop'),
('NX Zero', 'pop'), ('Fresno', 'pop'), ('Pitty', 'pop'), ('Charlie Brown Jr', 'pop'),
('CPM 22', 'pop'), ('Detonautas', 'pop'), ('Kelly Key - Baba Baby', 'pop'), ('Rouge - Ragatanga', 'pop'),
('Bro''z - Sim Sim Sim', 'pop'), ('Felipe Dylon - Musa do Verão', 'pop'), ('Luka - Tô Nem Aí', 'pop'), ('Perlla', 'pop'),
('Black Eyed Peas', 'pop'), ('Beyoncé - Crazy in Love', 'pop'), ('Lady Gaga - Just Dance', 'pop'), ('Rihanna - Umbrella', 'pop'),
('Katy Perry - I Kissed a Girl', 'pop'), ('Shakira - Hips Don''t Lie', 'pop'), ('Eminem', 'pop'), ('50 Cent', 'pop'),
('Akon', 'pop'), ('Sean Paul', 'pop'), ('Daddy Yankee - Gasolina', 'pop'), ('Las Ketchup', 'pop'),
('The Sims 2', 'games'), ('GTA San Andreas', 'games'), ('GTA Vice City', 'games'), ('Counter-Strike 1.6', 'games'),
('Guitar Hero 3', 'games'), ('Need for Speed Underground 2', 'games'), ('Tony Hawk''s Pro Skater', 'games'), ('Winning Eleven', 'games'),
('Tibia', 'games'), ('Ragnarok Online', 'games'), ('Mu Online', 'games'), ('Grand Chase', 'games'),
('Gunbound', 'games'), ('Priston Tale', 'games'), ('PangYa', 'games'), ('MapleStory', 'games'),
('Habbo Moedas', 'games'), ('Lan House no Sábado', 'games'), ('Corujão de CS', 'games'), ('X1 no Tibia', 'games')
ON CONFLICT (word) DO NOTHING;

-- (Lote 4: Comida, Escola & Vibes)
INSERT INTO public.word_pool (word, category) VALUES 
('Bubbaloo de Uva', 'food'), ('Dadinho', 'food'), ('Chocolate Surpresa', 'food'), ('Push Pop', 'food'),
('Trakinas de Morango', 'food'), ('Guaraná Caçulinha', 'food'), ('Toddynho', 'food'), ('Salgadinho de 1 Real', 'food'),
('Fofura de Queijo', 'food'), ('Pipoca de Canhão', 'food'), ('Suco em Pó Tang', 'food'), ('Giro de Frutas', 'food'),
('Geladinho / Chup-chup', 'food'), ('Pirulito que explode', 'food'), ('Bala de Iogurte', 'food'), ('Chiclete da Turma da Mônica', 'food'),
('Kinder Ovo de 2 Reais', 'food'), ('Mocinha', 'food'), ('Danoninho', 'food'), ('Chamyto', 'food'),
('Yakult', 'food'), ('Biscoito Passatempo antigo', 'food'), ('Bolinho Ana Maria', 'food'), ('Piraquê de Goiabada', 'food'),
('Suco Kapo', 'food'), ('Tang de Uva', 'food'), ('Kiwi fatiado', 'food'), ('Maçã do amor', 'food'),
('Caneta de 10 Cores', 'school'), ('Agenda da Tilibra', 'school'), ('Borracha que apaga caneta', 'school'), ('Lapiseira 0.7', 'school'),
('Corretivo em Fita', 'school'), ('Régua de 30cm', 'school'), ('Mapa Mundi', 'school'), ('Trabalho feito à mão', 'school'),
('Caderno de Caligrafia', 'school'), ('Cartolina no Domingo', 'school'), ('Folha de Almaço', 'school'), ('Dicionário Aurélio', 'school'),
('Enciclopédia Barsa', 'school'), ('Lancheira de Metal', 'school'), ('Cantina da escola', 'school'), ('Recreio', 'school'),
('Educação Física', 'school'), ('Queimada no pátio', 'school'), ('Amarelinha', 'school'), ('Pula Corda', 'school'),
('Esconde-esconde', 'school'), ('Beyblade de Metal', 'toys'), ('Tazo do Yu-Gi-Oh', 'toys'), ('Cartas de Pokémon', 'toys'),
('Polly Pocket', 'toys'), ('Max Steel', 'toys'), ('Barbie Escola de Princesas', 'toys'), ('Lego Star Wars', 'toys'),
('Geloucos da Coca-Cola', 'toys'), ('Mini Craques', 'toys'), ('Ioiô da Coca-Cola', 'toys'), ('Pega-Vareta', 'toys'),
('Cara a Cara', 'toys'), ('Banco Imobiliário', 'toys'), ('Jogo da Vida', 'toys'), ('Operação', 'toys'),
('Nostalgia', 'vibe'), ('Saudade', 'vibe'), ('Inocência', 'vibe'), ('Primeiro Crush', 'vibe'),
('Férias na Praia', 'vibe'), ('Domingo de Manhã', 'vibe'), ('Cheiro de Livro Novo', 'vibe'), ('Chuva na Janela', 'vibe'),
('Acampar na Sala', 'vibe'), ('Pijamada', 'vibe'), ('Melhor Amigo de Infância', 'vibe'), ('Alugar Fita na Locadora', 'vibe'),
('Ir na Lan House', 'vibe'), ('Sábado no Shopping', 'vibe'), ('Aniversário no Buffet', 'vibe'), ('Criança Raiz', 'vibe'),
('Noites em Claro jogando', 'vibe'), ('Esperar a música na rádio', 'vibe'), ('Gravar a TV com o Celular', 'vibe'), ('Vintage', 'vibe'),
('Y2K Aesthetics', 'vibe'), ('Efeito Estufa', 'vibe'), ('Virada do Milênio', 'vibe'), ('Futuro do Passado', 'vibe')
ON CONFLICT (word) DO NOTHING;

-- (Lote 5: Miscelânea & Cultura Pop Extra)
INSERT INTO public.word_pool (word, category) VALUES 
('Msn Plus!', 'web'), ('Subnick com letras gregas', 'web'), ('Nick com xX_ _Xx', 'web'), ('Foto de perfil de anime', 'web'),
('Wallpaper do Linkin Park', 'web'), ('Ícone do Internet Explorer', 'web'), ('Barra de ferramentas do Yahoo', 'web'), ('Bate-papo do Terra', 'web'),
('Comunidade: Eu odeio acordar cedo', 'web'), ('Comunidade: Tocava a campainha e corria', 'web'), ('Scrap de "Bom dia grupo"', 'web'), ('Gif de Ursinho', 'web'),
('Montagem no Paint', 'web'), ('Capa de CD feita no Word', 'web'), ('Impressora que engasga', 'web'), ('Scanner barulhento', 'web'),
('Discagem do IG', 'web'), ('iBest', 'web'), ('Click25', 'web'), ('Torta na Cara', 'tv'),
('Passa ou Repassa', 'tv'), ('Show do Milhão', 'tv'), ('Casa dos Artistas', 'tv'), ('Big Brother 1', 'tv'),
('No Limite', 'tv'), ('Linha Direta', 'tv'), ('A Diarista', 'tv'), ('Os Normais', 'tv'),
('Grande Família antiga', 'tv'), ('Sítio do Pica Pau 2001', 'tv'), ('Xuxa Só Para Baixinhos', 'tv'), ('Eliana na Record', 'tv'),
('Disney Cruj', 'tv'), ('Art Attack', 'tv'), ('Mister Maker', 'tv'), ('Bananas de Pijamas', 'tv'),
('Ursinhos Carinhosos', 'tv'), ('Cavalo de Fogo', 'tv'), ('He-Man antigo', 'tv'), ('She-Ra antiga', 'tv'),
('Thundercats', 'tv'), ('Tartarugas Ninja', 'tv'), ('Power Rangers Força do Tempo', 'tv'), ('Digimon Tamers', 'tv'),
('Medabots', 'tv'), ('BeyBlade V-Force', 'tv'), ('Zoids', 'tv'), ('Bakugan', 'tv'),
('Naruto no SBT', 'tv'), ('One Piece na 4Kids', 'tv'), ('Bleach no Animax', 'tv'), ('Death Note pirateado', 'tv'),
('Avril Lavigne - Complicated', 'music'), ('Britney Spears - Everytime', 'music'), ('Christina Aguilera - Beautiful', 'music'), ('Pink - Get the Party Started', 'music'),
('Destiny''s Child', 'music'), ('Spice Girls - Goodbye', 'music'), ('Backstreet Boys', 'music'), ('N''Sync', 'music'),
('Simple Plan', 'music'), ('Good Charlotte', 'music'), ('Sum 41', 'music'), ('Blink-182', 'music'),
('The Offspring', 'music'), ('System of a Down', 'music'), ('Slipknot antigo', 'music'), ('Korn', 'music'),
('Limp Bizkit', 'music'), ('Papa Roach', 'music'), ('Audioslave', 'music'), ('Foo Fighters - Best of You', 'music'),
('Coldplay - Yellow', 'music'), ('The Killers - Mr. Brightside', 'music'), ('Franz Ferdinand', 'music'), ('Arctic Monkeys antigo', 'music'),
('Amy Winehouse', 'music'), ('Duffy', 'music'), ('Adele - Chasing Pavements', 'music'), ('Bruno Mars antigo', 'music'),
('Justin Bieber - One Time', 'music'), ('Miley Cyrus - 7 Things', 'music'), ('Demi Lovato - Camp Rock', 'music'), ('Selena Gomez - Wizards', 'music'),
('Jonas Brothers', 'music'), ('One Direction início', 'music'), ('Taylor Swift Country', 'music'), ('Paramore - Misery Business', 'music'),
('Hayley Williams de cabelo laranja', 'pop'), ('Emocore de franja', 'pop'), ('Cinto de Pirâmide', 'pop'), ('Tênis Mad Rats', 'pop'),
('Mochila de Skatista', 'pop'), ('Shapes de Skate', 'pop'), ('Fingerboard / Tech Deck', 'pop'), ('Patinete de alumínio', 'pop'),
('Patins In-line', 'pop'), ('Bicicleta Caloi Cross', 'pop'), ('Bicicleta com cestinha', 'pop'), ('Garrafa térmica de escola', 'school'),
('Lanche de bisnaguinha', 'school'), ('Suco de caixinha morno', 'school'), ('Bolacha recheada quadrada', 'school'), ('Salgadinho de bacon', 'school'),
('Chocolate Tortuguita', 'food'), ('Bala de Goma de ursinho', 'food'), ('Pirulito de coração', 'food'), ('Bala 7 Belo', 'food'),
('Chiclete Hubba Bubba', 'food'), ('Bala Mentos antiga', 'food'), ('Drops Kids', 'food'), ('Chocolate Lollo', 'food'),
('Barra de Chocolate de 200g', 'food'), ('Ovo de Páscoa com brinde', 'food'), ('Panetone de chocolate', 'food'), ('Sorvete de Napolitano', 'food'),
('Copo de Requeijão de vidro', 'food'), ('Fanta Morango', 'food'), ('Pepsi Twist', 'food'), ('Coca-Cola Light', 'food'),
('Sprite de garrafa verde', 'food'), ('Suco de uva de garrafa', 'food'), ('Água com gás de limão', 'food'), ('H2OH!', 'food'),
('Red Bull no início', 'food'), ('Monster Energy antigo', 'food'), ('Café solúvel', 'food'), ('Leite Ninho em pó', 'food'),
('Nescau vs Toddynho', 'food'), ('Farofinha de Kibe', 'food'), ('Coxinha de Catupiry', 'food'), ('Pão de Queijo de padaria', 'food'),
('Bolo de Aniversário de Glacê', 'food'), ('Docinhos de festa: Beijinho', 'food'), ('Brigadeiro com granulado', 'food'), ('Cajuzinho', 'food'),
('Olho de Sogra', 'food'), ('Bala de coco de festa', 'food'), ('Papel de bala colorido', 'food'), ('Lembrancinha de aniversário', 'food'),
('Chapéu de cone de festa', 'food'), ('Língua de sogra', 'food'), ('Estalinho de salão', 'food'), ('Biribinha', 'food'),
('Festa Americana', 'food'), ('Baile de Debutante', 'food'), ('Formatura da 4ª série', 'food'), ('Viagem de formatura', 'food'),
('Porto Seguro', 'vibe'), ('Disney com a família', 'vibe'), ('Beto Carrero', 'vibe'), ('Hopi Hari', 'vibe'),
('Playcenter', 'vibe'), ('Wet''n Wild', 'vibe'), ('Parque da Mônica', 'vibe'), ('Sesc no Verão', 'vibe'),
('Clube com piscina', 'vibe'), ('Churrasco de Domingo', 'vibe'), ('Futebol na rua', 'vibe'), ('Golzinho de chinelo', 'vibe'),
('Taco', 'vibe'), ('Pipa', 'vibe'), ('Pião de madeira', 'vibe'), ('Mola Maluca', 'vibe'),
('Slime antigo (Geleca)', 'vibe'), ('Areia movediça', 'vibe'), ('Experiência de feira de ciências', 'vibe'), ('Vulcão de bicarbonato', 'vibe'),
('Maquete de isopor', 'vibe'), ('Trabalho em grupo na casa do amigo', 'vibe'), ('Pedir pra ir ao banheiro', 'vibe'), ('Assinar o gesso do amigo', 'vibe'),
('Bate-mão de escola', 'vibe'), ('Guerra de borracha', 'vibe'), ('Avião de papel', 'vibe'), ('Bilhetinho na aula', 'vibe'),
('Caderno de Perguntas', 'vibe'), ('Teste da Capricho', 'vibe'), ('Horóscopo do dia', 'vibe'), ('Amizade Colorida', 'vibe'),
('Ficar no portão', 'vibe'), ('Telefone fixo com fio longo', 'vibe'), ('Passar trote', 'vibe'), ('Identificador de chamadas', 'vibe'),
('Lista Telefônica Páginas Amarelas', 'vibe'), ('Orelhão de cartão', 'vibe'), ('Cartão Telefônico colecionável', 'vibe'), ('Ficha de fliperama', 'vibe'),
('Pac-Man', 'vibe'), ('Space Invaders', 'vibe'), ('Street Fighter 2', 'vibe'), ('Mortal Kombat antigo', 'vibe'),
('Sonic the Hedgehog', 'vibe'), ('Super Mario World', 'vibe'), ('Donkey Kong Country', 'vibe'), ('Zelda Ocarina of Time', 'vibe'),
('GoldenEye 007', 'vibe'), ('Resident Evil 4', 'vibe'), ('Silent Hill 2', 'vibe'), ('Tomb Raider antiga', 'vibe'),
('Lara Croft de polígono', 'vibe'), ('Crash Bandicoot', 'vibe'), ('Spyro the Dragon', 'vibe'), ('Pacote de expansão de RAM', 'vibe'),
('Vibration Pack', 'vibe'), ('Tapete de Dança', 'vibe'), ('Volante de corrida', 'vibe'), ('Joystick de avião', 'vibe'),
('Lan Party', 'vibe'), ('Quake 3', 'vibe'), ('Unreal Tournament', 'vibe'), ('Half-Life', 'vibe'),
('Portal', 'vibe'), ('Team Fortress 2', 'vibe'), ('Left 4 Dead', 'vibe'), ('BioShock', 'vibe'),
('Mass Effect', 'vibe'), ('Fallout 3', 'vibe'), ('Skyrim', 'vibe'), ('Minecraft Alpha', 'vibe'),
('Roblox antigo', 'vibe'), ('Second Life', 'vibe'), ('Imvu', 'vibe'), ('The Movies (jogo)', 'vibe'),
('RollerCoaster Tycoon', 'vibe'), ('Zoo Tycoon', 'vibe'), ('SimCity 4', 'vibe'), ('Age of Empires 2', 'vibe'),
('StarCraft', 'vibe'), ('Warcraft 3', 'vibe'), ('DotA original', 'vibe'), ('LoL temporada 1', 'vibe'),
('Youtuber raiz', 'vibe'), ('Felipe Neto óculos colorido', 'vibe'), ('PC Siqueira antigo', 'vibe'), ('Cauê Moura início', 'vibe'),
('Mystery Guitar Man', 'vibe'), ('FreddieW', 'vibe'), ('Smosh', 'vibe'), ('NigaHiga', 'vibe'),
('PewDiePie Amnesia', 'vibe'), ('Charlie Bit My Finger', 'vibe'), ('Chocolate Rain', 'vibe'), ('Evolution of Dance', 'vibe'),
('Nyan Cat', 'vibe'), ('Keyboard Cat', 'vibe'), ('Rickroll', 'vibe'), ('Shoop da Whoop', 'vibe'),
('Trollface', 'vibe'), ('Forever Alone', 'vibe'), ('Rage Comics', 'vibe'), ('Me Gusta', 'vibe'),
('Challenge Accepted', 'vibe'), ('Fuck Yeah', 'vibe'), ('Okay Guy', 'vibe'), ('Derp e Derpina', 'vibe'),
('Le Wild', 'vibe'), ('Epic Fail', 'vibe'), ('Ownado', 'vibe'), ('Noob', 'vibe'),
('L33t Speak', 'vibe'), ('OMG', 'vibe'), ('LOL', 'vibe'), ('ROFL', 'vibe'),
('BRB', 'vibe'), ('AFK', 'vibe'), ('Gê-Gê (Good Game)', 'vibe'), ('Pode Crê', 'vibe'),
('Demorô', 'vibe'), ('É nóis', 'vibe'), ('Tá ligado?', 'vibe'), ('Qualé a boa?', 'vibe'),
('Vibe Positiva', 'vibe'), ('Paz e Amor', 'vibe'), ('Mundo Mix', 'vibe'), ('Rave de 2008', 'vibe'),
('E-music', 'vibe'), ('Psytrance', 'vibe'), ('Minimal', 'vibe'), ('Dubstep antigo', 'vibe'),
('Skrillex de cabelo raspado', 'vibe'), ('David Guetta no topo', 'vibe'), ('Tiësto', 'vibe'), ('Armin van Buuren', 'vibe'),
('Daft Punk Alive 2007', 'vibe'), ('Gorillaz - Feel Good Inc', 'vibe'), ('Gnarls Barkley - Crazy', 'vibe'), ('Amy Winehouse - Rehab', 'music'),
('Duffy - Mercy', 'music'), ('Adele - Rolling in the Deep', 'music'), ('Bruno Mars - Just the Way You Are', 'music'), ('Katy Perry - Firework', 'music'),
('Lady Gaga - Bad Romance', 'music'), ('Beyoncé - Halo', 'music'), ('Rihanna - Diamonds', 'music'), ('Taylor Swift - Love Story', 'music'),
('Justin Bieber - Baby', 'music'), ('Miley Cyrus - Party in the USA', 'music'), ('Demi Lovato - La La Land', 'music'), ('Selena Gomez - Naturally', 'music'),
('One Direction - What Makes You Beautiful', 'music'), ('The Wanted - Glad You Came', 'music'), ('Big Time Rush', 'music'), ('Camp Rock 2', 'music'),
('HSM 3: Senior Year', 'music'), ('Glee início', 'music'), ('Pitch Perfect', 'music'), ('Whiplash', 'music'),
('Avatar de James Cameron', 'tv'), ('Inception', 'tv'), ('The Dark Knight', 'tv'), ('Iron Man 1', 'tv'),
('Transformers antigo', 'tv'), ('Piratas do Caribe', 'tv'), ('Senhor dos Anéis', 'tv'), ('Crônicas de Nárnia', 'tv'),
('Crepúsculo - Team Edward', 'tv'), ('Crepúsculo - Team Jacob', 'tv'), ('Jogos Vorazes', 'tv'), ('Divergente', 'tv'),
('Maze Runner', 'tv'), ('Percy Jackson filme', 'tv'), ('A Culpa é das Estrelas', 'tv'), ('Cidades de Papel', 'tv'),
('John Green era', 'vibe'), ('Tumblr Aesthetics', 'vibe'), ('Soft Grunge', 'vibe'), ('Pale Aesthetics', 'vibe'),
('Hipster era', 'vibe'), ('Óculos Wayfarer colorido', 'vibe'), ('Bigode no dedo', 'vibe'), ('Keep Calm and Carry On', 'vibe'),
('Floral Dark', 'vibe'), ('Galáxia Print', 'vibe'), ('Lita Boots', 'vibe'), ('Disco Pants', 'vibe'),
('American Apparel era', 'vibe'), ('Urban Outfitters era', 'vibe'), ('Polaroid fugitiva', 'vibe'), ('Instax', 'vibe'),
('Lomografia', 'vibe'), ('Fisheye Lens', 'vibe'), ('Bokeh effect', 'vibe'), ('Vsco Cam antigo', 'vibe'),
('Instagram com filtro Sepia', 'vibe'), ('Snapchat do fantasminha', 'vibe'), ('Vine (6 segundos)', 'vibe'), ('Dubsmash', 'vibe'),
('Musical.ly início', 'vibe'), ('TikTok início', 'vibe'), ('Fidget Spinner', 'vibe'), ('Hoverboard', 'vibe'),
('Selfie Stick (Pau de Selfie)', 'vibe'), ('Power Bank barulhento', 'vibe'), ('Fone Bluetooth que brilha', 'vibe'), ('Kindle 1ª geração', 'vibe'),
('iPad 1', 'vibe'), ('iPhone 3GS', 'vibe'), ('Galaxy S2', 'vibe'), ('Nexus 4', 'vibe'),
('Flappy Bird', 'vibe'), ('Candy Crush', 'vibe'), ('Angry Birds', 'vibe'), ('Fruit Ninja', 'vibe'),
('Temple Run', 'vibe'), ('Pou', 'vibe'), ('Talking Tom', 'vibe'), ('Jetpack Joyride', 'vibe'),
('Subway Surfers', 'vibe'), ('Clash of Clans', 'vibe'), ('Clash Royale', 'vibe'), ('Pokemon GO lançamento', 'vibe'),
('2048 (jogo)', 'vibe'), ('Draw Something', 'vibe'), ('SongPop', 'vibe'), ('Trivia Crack', 'vibe'),
('Vine - 9 + 10 = 21', 'vibe'), ('Vine - What are those?!', 'vibe'), ('Vine - Look at all those chickens', 'vibe'), ('Nostalgia de 2010', 'vibe'),
('Nostalgia de 2012', 'vibe'), ('Fim do Mundo 2012', 'vibe'), ('Harlem Shake', 'vibe'), ('Gangnam Style', 'vibe'),
('Ice Bucket Challenge', 'vibe'), ('Planking', 'vibe'), ('Mannequin Challenge', 'vibe'), ('Dab dance', 'vibe'),
('Fio-terra (brincadeira)', 'vibe'), ('Paulada', 'vibe'), ('Tapa na nuca', 'vibe'), ('Pedala Robinho', 'vibe'),
('Zinedine Zidane', 'vibe'), ('Ronaldinho Gaúcho bruxo', 'vibe'), ('Ronaldo Fenômeno', 'vibe'), ('Kaká no Milan', 'vibe'),
('Neymar no Santos', 'vibe'), ('Neymar de moicano', 'vibe'), ('Ganso no Santos', 'vibe'), ('Libertadores do Corinthians', 'vibe'),
('Copa de 2010 vuvuzela', 'vibe'), ('Copa de 2014 7x1', 'vibe'), ('Jabulani', 'vibe'), ('Waka Waka', 'vibe'),
('Shakira - La La La', 'vibe'), ('Pitbull - We Are One', 'vibe'), ('Fuleco', 'vibe'), ('Brasil de 2002', 'vibe'),
('Penta Campeão', 'vibe'), ('Senna eterno', 'vibe'), ('Guga no Tênis', 'vibe'), ('Daiane dos Santos', 'vibe'),
('Diego Hypolito', 'vibe'), ('Jade Barbosa', 'vibe'), ('Rebeca Andrade início', 'vibe'), ('Olimpíadas de 2016', 'vibe'),
('Rio de Janeiro era', 'vibe'), ('Copa das Confederações', 'vibe'), ('Vem pra rua 2013', 'vibe'), ('Manifestação', 'vibe'),
('Política no Facebook', 'vibe'), ('Treta de comentários', 'vibe'), ('Meme do "É verdade esse bilete"', 'vibe'), ('Meme do "Inês Brasil"', 'vibe'),
('Gretchen a rainha dos memes', 'vibe'), ('Tulla Luana', 'vibe'), ('Nicole Bahls memes', 'vibe'), ('Narcisa Tamborindeguy', 'vibe'),
('Ai que loucura!', 'vibe'), ('Ai que badalo!', 'vibe'), ('Mulheres Ricas', 'vibe'), ('Val Marchiori', 'vibe'),
('Hellooo!', 'vibe'), ('Meme do "Senhora? Senhora?"', 'vibe'), ('Meme do "Já acabou, Jéssica?"', 'vibe'), ('Meme do "E morreu"', 'vibe'),
('Meme do "Pai de Família"', 'vibe'), ('Meme do "Jailson Mendes"', 'vibe'), ('Delícia cara!', 'vibe'), ('Meme do "Irra!"', 'vibe'),
('Meme do "Ó o gás!"', 'vibe'), ('Meme do "Caneta Azul"', 'vibe'), ('Meme do "Bora Bill"', 'vibe'), ('Nostalgia Pura', 'vibe')
ON CONFLICT (word) DO NOTHING;

-- 3. Função de Sorteio Justo (Garante 2 anos sem repetir)
CREATE OR REPLACE FUNCTION public.generate_daily_word()
RETURNS void AS $$
DECLARE
  random_word text;
BEGIN
  -- 1. Tenta pegar uma palavra que NUNCA foi usada na tabela daily_words
  SELECT word INTO random_word 
  FROM public.word_pool 
  WHERE word NOT IN (SELECT word FROM public.daily_words)
  ORDER BY random() 
  LIMIT 1;

  -- 2. Se acabar o pool, ele reseta pegando qualquer uma
  IF random_word IS NULL THEN
    SELECT word INTO random_word FROM public.word_pool ORDER BY random() LIMIT 1;
  END IF;
  
  -- 3. Insere na tabela de consumo
  INSERT INTO public.daily_words (word, created_at)
  VALUES (random_word, current_date)
  ON CONFLICT (created_at) DO UPDATE 
  SET word = EXCLUDED.word;
END;
$$ LANGUAGE plpgsql;

-- 4. Rodar primeira vez
SELECT public.generate_daily_word();
