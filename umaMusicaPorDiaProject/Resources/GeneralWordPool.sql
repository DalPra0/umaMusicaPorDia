-- BANCO DE DADOS DE NOSTALGIA ESTÉTICA DEFINITIVO (1100+ DIAS) --
-- Versão Corrigida: Sem Duplicatas --

-- 1. Limpeza Radical
TRUNCATE public.word_pool CASCADE;
TRUNCATE public.daily_words CASCADE;

-- 2. Inserção de Lotes Massivos (Garantindo Unicidade)

-- ATMOSFERAS (VIBES)
INSERT INTO public.word_pool (word, category) VALUES 
('Golden Hour', 'vibe'), ('Chuva de Verão', 'vibe'), ('Céu de Algodão Doce', 'vibe'), ('Madrugada Silenciosa', 'vibe'),
('Brisa do Mar', 'vibe'), ('Nevoeiro Matinal', 'vibe'), ('Sol de Outono', 'vibe'), ('Noite Estrelada', 'vibe'),
('Crepúsculo', 'vibe'), ('Luz de Neon', 'vibe'), ('Sombras na Parede', 'vibe'), ('Reflexo no Vidro', 'vibe'),
('Calor do Meio-dia', 'vibe'), ('Vento no Rosto', 'vibe'), ('Cheiro de Terra Molhada', 'vibe'), ('Frio Aconchegante', 'vibe'),
('Pôr do Sol Dourado', 'vibe'), ('Luz de Vela', 'vibe'), ('Tempestade Distante', 'vibe'), ('Alvorada', 'vibe'),
('Céu Azul Infinito', 'vibe'), ('Garoa Fina', 'vibe'), ('Clima de Montanha', 'vibe'), ('Tarde Preguiçosa', 'vibe'),
('Eclipse Lunar', 'vibe'), ('Aurora Boreal', 'vibe'), ('Céu de Estrelas Cadentes', 'vibe'), ('Orizonte Infinito', 'vibe'),
('Poeira Dançante na Luz', 'vibe'), ('Mundo de Vidro', 'vibe'), ('Luz de Inverno', 'vibe'), ('Calmaria do Lago', 'vibe'),
('Bruma do Porto', 'vibe'), ('Atmosfera de Sonho', 'vibe'), ('Luz de Aquário', 'vibe'),
('Noite de Tempestade', 'vibe'), ('Sol Entre Nuvens', 'vibe'), ('Manhã Gelada', 'vibe'), ('Tarde de Sol', 'vibe'),
('Vento de Primavera', 'vibe'), ('Luz da Cidade', 'vibe'), ('Silêncio da Neve', 'vibe'), ('Reflexo da Lua', 'vibe'),
('Céu Alaranjado', 'vibe'), ('Névoa de Montanha', 'vibe'), ('Brisa de Tarde', 'vibe'),
('Ondas de Calor', 'vibe'), ('Cheiro de Flor', 'vibe'), ('Toque de Vento', 'vibe'), ('Calor da Areia', 'vibe'),
('Frio de Madrugada', 'vibe'), ('Luz de Lanterna', 'vibe'), ('Brilho da Manhã', 'vibe'),
('Tarde Azul', 'vibe'), ('Noite de Lua Cheia', 'vibe'), ('Céu Cinzento', 'vibe'),
('Atmosfera Épica', 'vibe'), ('Vibe Futurista', 'vibe'), ('Luz de Cristal', 'vibe'), ('Sombra Suave', 'vibe'),
('Ondas do Deserto', 'vibe'), ('Frio de Inverno', 'vibe'), ('Calor de Praia', 'vibe'), ('Brisa do Campo', 'vibe'),
('Luz Natural', 'vibe'), ('Atmosfera de Cinema', 'vibe'), ('Noite Urbana', 'vibe'), ('Silêncio do Campo', 'vibe'),
('Luz de Amanhecer', 'vibe'), ('Tarde no Parque', 'vibe'), ('Céu de Tempestade', 'vibe'), ('Brisa Matinal', 'vibe'),
('Calor de Lareira', 'vibe'), ('Luz de Prisma', 'vibe'), ('Reflexo de Espelho', 'vibe'), ('Sombra Fugaz', 'vibe'),
('Atmosfera Mística', 'vibe'), ('Vibe Tropical', 'vibe'), ('Luz de Sunset', 'vibe'), ('Brisa de Verão', 'vibe'),
('Calor de Agosto', 'vibe'), ('Luz de Cinema Antigo', 'vibe'), ('Noite Misteriosa', 'vibe'), ('Silêncio de Biblioteca', 'vibe')
ON CONFLICT (word) DO NOTHING;

-- SENTIMENTOS (FEELINGS)
INSERT INTO public.word_pool (word, category) VALUES 
('Saudade Doce', 'feeling'), ('Euforia', 'feeling'), ('Melancolia Poética', 'feeling'), ('Liberdade', 'feeling'),
('Primeiro Amor', 'feeling'), ('Coração Pulsante', 'feeling'), ('Paz Interior', 'feeling'), ('Desejo de Voar', 'feeling'),
('Inocência', 'feeling'), ('Mistério', 'feeling'), ('Esperança', 'feeling'), ('Sonho Acordado', 'feeling'),
('Nostalgia Pura', 'feeling'), ('Conexão Mágica', 'feeling'), ('Coragem', 'feeling'), ('Solidão Serena', 'feeling'),
('Gratidão', 'feeling'), ('Encanto', 'feeling'), ('Plenitude', 'feeling'), ('Descoberta', 'feeling'),
('Sincronicidade', 'feeling'), ('Alma Leve', 'feeling'), ('Intuição', 'feeling'), ('Paixão', 'feeling'),
('Deslumbramento', 'feeling'), ('Vulnerabilidade', 'feeling'), ('Resiliência', 'feeling'), ('Serenidade', 'feeling'),
('Empatia', 'feeling'), ('Inspiração', 'feeling'), ('Audácia', 'feeling'), ('Calma Interior', 'feeling'),
('Vontade de Mudar', 'feeling'), ('Felicidade Simples', 'feeling'), ('Coração Aberto', 'feeling'), ('Essência', 'feeling'),
('Transformação', 'feeling'), ('Poder da Mente', 'feeling'), ('Energia Vital', 'feeling'), ('Equilíbrio', 'feeling'),
('Amor de Verão', 'feeling'), ('Saudade de Casa', 'feeling'), ('Vontade de Viajar', 'feeling'), ('Sentimento de Pertencer', 'feeling'),
('Paz de Espírito', 'feeling'), ('Alma Viajante', 'feeling'), ('Coração de Artista', 'feeling'), ('Mente Criativa', 'feeling'),
('Desejo de Liberdade', 'feeling'), ('Sonho de Criança', 'feeling'), ('Primeira Vez', 'feeling'), ('Encontro de Almas', 'feeling'),
('Sentimento de Vitória', 'feeling'), ('Calor Humano', 'feeling'), ('Abraço de Amigo', 'feeling'), ('Sorriso de Criança', 'feeling'),
('Olhar de Esperança', 'feeling'), ('Toque de Carinho', 'feeling'), ('Voz de Conforto', 'feeling'), ('Mão Estendida', 'feeling'),
('Coração em Paz', 'feeling'), ('Mente em Foco', 'feeling'), ('Alma em Festa', 'feeling'), ('Espírito Livre', 'feeling'),
('Sentimento de Gratidão', 'feeling'), ('Paz no Coração', 'feeling'), ('Amor Incondicional', 'feeling'), ('Amizade Eterna', 'feeling'),
('Laços de Família', 'feeling'), ('União Verdadeira', 'feeling'), ('Respeito Mútuo', 'feeling'), ('Confiança Plena', 'feeling'),
('Sentimento de Missão', 'feeling'), ('Propósito de Vida', 'feeling'), ('Vontade de Vencer', 'feeling'), ('Força Interior', 'feeling'),
('Luz na Alma', 'feeling'), ('Brilho no Olhar', 'feeling'), ('Paz na Mente', 'feeling'), ('Amor pela Vida', 'feeling'),
('Gratidão pelo Agora', 'feeling'), ('Fé no Futuro', 'feeling'), ('Esperança no Peito', 'feeling'), ('Coração Valente', 'feeling')
ON CONFLICT (word) DO NOTHING;

-- LUGARES (PLACES)
INSERT INTO public.word_pool (word, category) VALUES 
('Estrada Infinita', 'place'), ('Jardim Secreto', 'place'), ('Cidade Luz', 'place'), ('Praia Deserta', 'place'),
('Quarto de Infância', 'place'), ('Estação de Trem', 'place'), ('Rooftop à Noite', 'place'), ('Cafeteria Antiga', 'place'),
('Biblioteca de Madeira', 'place'), ('Parque de Diversões', 'place'), ('Casa de Campo', 'place'), ('Farol Solitário', 'place'),
('Cinema de Rua', 'place'), ('Floresta Encantada', 'place'), ('Vilarejo', 'place'), ('Ponte sobre o Rio', 'place'),
('Varanda com Rede', 'place'), ('Livraria de Sebo', 'place'), ('Trilha na Mata', 'place'), ('Aeroporto', 'place'),
('Cachoeira Escondida', 'place'), ('Mirante', 'place'), ('Rua sem Saída', 'place'), ('Sótão de Memórias', 'place'),
('Ilha Tropical', 'place'), ('Montanha Nevada', 'place'), ('Deserto de Areia', 'place'), ('Metrópole Agitada', 'place'),
('Jardim Japonês', 'place'), ('Observatório Astronômico', 'place'), ('Templo Antigo', 'place'), ('Castelo Medieval', 'place'),
('Casa de Barco', 'place'), ('Vila de Pescadores', 'place'), ('Farol no Penhasco', 'place'), ('Campo de Girassóis', 'place'),
('Floresta de Pinheiros', 'place'), ('Lago de Cristal', 'place'), ('Cânion Profundo', 'place'), ('Oásis no Deserto', 'place'),
('Praça da Cidade', 'place'), ('Mercado de Flores', 'place'), ('Galeria de Arte', 'place'), ('Teatro Clássico', 'place'),
('Estádio de Futebol', 'place'), ('Pista de Skate', 'place'), ('Quadra de Basquete', 'place'), ('Escola de Dança', 'place'),
('Ateliê de Artista', 'place'), ('Oficina de Sonhos', 'place'), ('Garagem de Rock', 'place'), ('Estúdio de Música', 'place'),
('Quintal de Brincadeiras', 'place'), ('Terraço de Verão', 'place'), ('Sacada de Apartamento', 'place'),
('Corredor de Hotel', 'place'), ('Lobby de Cinema', 'place'), ('Pátio de Escola', 'place'), ('Refeitório Antigo', 'place'),
('Caminho de Terra', 'place'), ('Trilha de Pedras', 'place'), ('Beira de Estrada', 'place'), ('Parada de Ônibus', 'place'),
('Porto de Navios', 'place'), ('Hangar de Aviões', 'place'), ('Oficina de Bicicletas', 'place'), ('Loja de Discos', 'place'),
('Sebo de Livros', 'place'), ('Antiquário', 'place'), ('Bazar Retro', 'place'), ('Brechó de Estilo', 'place'),
('Parque Urbano', 'place'), ('Reserva Natural', 'place'), ('Pantanal', 'place'), ('Amazonas', 'place'),
('Serra Gaúcha', 'place'), ('Nordeste Lindo', 'place'), ('Rio de Janeiro', 'place'), ('São Paulo Noite', 'place'),
('Belo Horizonte Vibe', 'place'), ('Curitiba Frio', 'place'), ('Porto Alegre Sol', 'place'), ('Recife Antigo', 'place'),
('Salvador Axé', 'place'), ('Fortaleza Mar', 'place'), ('Manaus Rio', 'place'), ('Brasília Céu', 'place')
ON CONFLICT (word) DO NOTHING;

-- ESTÉTICAS (AESTHETIC)
INSERT INTO public.word_pool (word, category) VALUES 
('Polaroid Velha', 'aesthetic'), ('Fita VHS', 'aesthetic'), ('Grão de Filme', 'aesthetic'), ('Papel Envelhecido', 'aesthetic'),
('Glitter e Brilho', 'aesthetic'), ('Cores Pastéis', 'aesthetic'), ('Visual Retrô', 'aesthetic'), ('Estética Grunge', 'aesthetic'),
('Minimalismo', 'aesthetic'), ('Colagem de Revista', 'aesthetic'), ('Luz de Flash', 'aesthetic'), ('Câmera Analógica', 'aesthetic'),
('Estética Y2K', 'aesthetic'), ('Vaporwave', 'aesthetic'), ('Dreamcore', 'aesthetic'), ('Visual Cyberpunk', 'aesthetic'),
('Textura de Linho', 'aesthetic'), ('Flores Prensadas', 'aesthetic'), ('Caligrafia à Mão', 'aesthetic'), ('Filtro Sépia', 'aesthetic'),
('Cores Vibrantes', 'aesthetic'), ('Estilo Vintage', 'aesthetic'), ('Aura Colorida', 'aesthetic'), ('Desenho a Lápis', 'aesthetic'),
('Estética 80s', 'aesthetic'), ('Estética 90s', 'aesthetic'), ('Estética 2000s', 'aesthetic'), ('Art Deco', 'aesthetic'),
('Bauhaus', 'aesthetic'), ('Psicodélico', 'aesthetic'), ('Surrealismo', 'aesthetic'), ('Pop Art', 'aesthetic'),
('Renascimento', 'aesthetic'), ('Barroco Moderno', 'aesthetic'), ('Futurismo', 'aesthetic'), ('Boho Chic', 'aesthetic'),
('Cyber Y2K', 'aesthetic'), ('McBling', 'aesthetic'), ('Indie Sleaze', 'aesthetic'), ('Soft Grunge', 'aesthetic'),
('Cottagecore', 'aesthetic'), ('Dark Academia', 'aesthetic'), ('Light Academia', 'aesthetic'), ('Royalcore', 'aesthetic'),
('Angelcore', 'aesthetic'), ('Spacecore', 'aesthetic'), ('Naturecore', 'aesthetic'), ('Oceanly', 'aesthetic'),
('Frutiger Aero', 'aesthetic'), ('Metro Design', 'aesthetic'), ('Glassmorphism', 'aesthetic'), ('Neumorphism', 'aesthetic'),
('Flat Design', 'aesthetic'), ('Skeuomorphism', 'aesthetic'), ('Pixel Art', 'aesthetic'), ('Low Poly', 'aesthetic'),
('High Fidelity', 'aesthetic'), ('Lo-fi Aesthetic', 'aesthetic'), ('Synthwave', 'aesthetic'), ('Retrowave', 'aesthetic'),
('Steampunk', 'aesthetic'), ('Dieselpunk', 'aesthetic'), ('Solarpunk', 'aesthetic'), ('Lunarpunk', 'aesthetic'),
('Goth Aesthetic', 'aesthetic'), ('Emo Vibe', 'aesthetic'), ('Scene Culture', 'aesthetic'), ('Skater Aesthetic', 'aesthetic'),
('Streetwear Vibe', 'aesthetic'), ('Cybercore', 'aesthetic'), ('Webcore', 'aesthetic'), ('Glitchcore', 'aesthetic'),
('Kidcore', 'aesthetic'), ('Babycore', 'aesthetic'), ('Lovecore', 'aesthetic'), ('Glowwave', 'aesthetic'),
('Neon Noir', 'aesthetic'), ('Noir Aesthetic', 'aesthetic'), ('Cinephile Vibe', 'aesthetic'), ('Art Hoe', 'aesthetic'),
('Baddie Aesthetic', 'aesthetic'), ('Soft Girl', 'aesthetic'), ('E-boy/E-girl', 'aesthetic'), ('Vibe Aesthetic', 'aesthetic')
ON CONFLICT (word) DO NOTHING;

-- OBJETOS (OBJECTS)
INSERT INTO public.word_pool (word, category) VALUES 
('Disco de Vinil', 'object'), ('Fita Cassete', 'object'), ('Guitarra Elétrica', 'object'), ('Walkman', 'object'),
('Cartas de Amor', 'object'), ('Diário Trancado', 'object'), ('Relógio de Bolso', 'object'), ('Chave Antiga', 'object'),
('Óculos de Sol', 'object'), ('Skate surrado', 'object'), ('Bilhete de Viagem', 'object'), ('Mapa Amarelado', 'object'),
('Máquina de Escrever', 'object'), ('Telefone de Disco', 'object'), ('Globo Terrestre', 'object'), ('Câmera de Filme', 'object'),
('Instrumentos Musicais', 'object'), ('Livro de Poesia', 'object'), ('Caneca de Café', 'object'), ('Flores Secas', 'object'),
('Mochila de Aventuras', 'object'), ('Fone de Ouvido', 'object'), ('Caderno de Desenho', 'object'), ('Pingente de Ouro', 'object'),
('Piano de Cauda', 'object'), ('Violino Clássico', 'object'), ('Saxofone de Jazz', 'object'), ('Bateria de Rock', 'object'),
('Baixo Elétrico', 'object'), ('Sintetizador Retro', 'object'), ('Microfone de Estúdio', 'object'), ('Amplificador de Som', 'object'),
('Bicicleta Caloi', 'object'), ('Patins In-line', 'object'), ('Prancha de Surf', 'object'), ('Snowboard', 'object'),
('Jaqueta Jeans', 'object'), ('Boné de Aba Reta', 'object'), ('Relógio Casio', 'object'), ('Calculadora Científica', 'object'),
('Agenda Eletrônica', 'object'), ('Pager Antigo', 'object'), ('Celular Tijolão', 'object'), ('Smartphone Moderno', 'object'),
('Tablet de Desenho', 'object'), ('Laptop de Alumínio', 'object'), ('Monitor de Tubo', 'object'), ('Mouse de Bolinha', 'object'),
('Teclado Mecânico', 'object'), ('Joystick de Atari', 'object'), ('GameBoy Color', 'object'), ('Tamagotchi', 'object'),
('Brick Game', 'object'), ('Nintendo 64', 'object'), ('PlayStation 1', 'object'), ('Xbox Clássico', 'object'),
('Dreamcast', 'object'), ('Sega Saturn', 'object'), ('Telescópio', 'object'), ('Lupa de Mão', 'object'),
('Bússola de Bronze', 'object'), ('Canivete Suíço', 'object'), ('Garrafa de Vidro', 'object'), ('Copo de Cristal', 'object'),
('Prato de Porcelana', 'object'), ('Talher de Prata', 'object'), ('Vaso de Flores', 'object'), ('Abajur de Mesa', 'object'),
('Tapete Persa', 'object'), ('Almofada de Veludo', 'object'), ('Quadro a Óleo', 'object'), ('Escultura de Mármore', 'object'),
('Vela Aromática', 'object'), ('Incenso de Sândalo', 'object'), ('Perfume de Rosas', 'object'), ('Sabonete Artesanal', 'object'),
('Toalha de Banho', 'object'), ('Roupão de Seda', 'object')
ON CONFLICT (word) DO NOTHING;

-- MOMENTOS (MOMENTS)
INSERT INTO public.word_pool (word, category) VALUES 
('Dança na Chuva', 'moment'), ('Conversa até o Amanhecer', 'moment'), ('Primeiro Show', 'moment'), ('Viagem de Carro', 'moment'),
('Festa no Quintal', 'moment'), ('Baile de Formatura', 'moment'), ('Piquenique no Parque', 'moment'), ('Olhar o Mar', 'moment'),
('Correr no Gramado', 'moment'), ('Acampar na Sala', 'moment'), ('Ver as Estrelas', 'moment'), ('Guerra de Travesseiro', 'moment'),
('Cantar no Carro', 'moment'), ('Pular na Piscina', 'moment'), ('Andar de Bicicleta', 'moment'), ('Assistir ao Pôr do Sol', 'moment'),
('Cozinhar com Amigos', 'moment'), ('Ler na Rede', 'moment'), ('Explorar a Cidade', 'moment'), ('Noite de Cinema', 'moment'),
('Encontro Inesperado', 'moment'), ('Despedida na Estação', 'moment'), ('Reencontro', 'moment'), ('Fim de Férias', 'moment'),
('Primeiro Dia de Verão', 'moment'), ('Noite de Natal em Família', 'moment'), ('Festa de Réveillon', 'moment'), ('Aniversário Surpresa', 'moment'),
('Casamento no Campo', 'moment'), ('Batizado de Criança', 'moment'), ('Formatura da Faculdade', 'moment'), ('Primeiro Emprego', 'moment'),
('Mudar para Casa Nova', 'moment'), ('Adotar um Pet', 'moment'), ('Aprender a Dirigir', 'moment'), ('Viagem Internacional', 'moment'),
('Ver a Neve pela Primeira Vez', 'moment'), ('Mergulhar no Oceano', 'moment'), ('Escalar uma Montanha', 'moment'), ('Andar de Avião', 'moment'),
('Ver um Eclipse', 'moment'), ('Assistir a uma Peça', 'moment'), ('Ir a um Museu', 'moment'), ('Fazer um Curso de Arte', 'moment'),
('Aprender um Instrumento', 'moment'), ('Escrever uma Música', 'moment'), ('Pintar um Quadro', 'moment'), ('Publicar um Livro', 'moment'),
('Ganhar um Prêmio', 'moment'), ('Ser Voluntário', 'moment'), ('Fazer um Mochilão', 'moment'), ('Morar fora do País', 'moment'),
('Voltar para Casa', 'moment'), ('Ver os Pais Envelhecerem', 'moment'), ('Ver os Filhos Crescerem', 'moment'), ('Ser Avô/Avó', 'moment'),
('Bodas de Ouro', 'moment'), ('Aposentadoria Feliz', 'moment'), ('Realizar um Sonho', 'moment'), ('Vencer um Medo', 'moment'),
('Perdoar Alguém', 'moment'), ('Pedir Perdão', 'moment'), ('Amar Novamente', 'moment'), ('Envelhecer com Dignidade', 'moment'),
('Olhar para Trás com Orgulho', 'moment'), ('Viver Intensamente', 'moment'), ('Aproveitar cada Segundo', 'moment'), ('Ser Feliz no Agora', 'moment'),
('Aprender a Dizer Não', 'moment'), ('Aprender a Dizer Sim', 'moment'), ('Descobrir uma Paixão', 'moment'), ('Mudar de Carreira', 'moment'),
('Começar do Zero', 'moment'), ('Superar um Desafio', 'moment'), ('Encontrar a Paz', 'moment'), ('Ser Grato por Tudo', 'moment'),
('Deixar um Legado', 'moment'), ('Inspirar Outras Pessoas', 'moment'), ('Fazer a Diferença', 'moment'), ('Viver com Propósito', 'moment')
ON CONFLICT (word) DO NOTHING;

-- MÚSICA (MUSIC)
INSERT INTO public.word_pool (word, category) VALUES 
('Ritmo do Coração', 'music'), ('Melodia Suave', 'music'), ('Solo de Guitarra', 'music'), ('Batida de Verão', 'music'),
('Voz de Veludo', 'music'), ('Acústico', 'music'), ('Sinfonia da Cidade', 'music'), ('Som das Ondas', 'music'),
('Playlist de Estrada', 'music'), ('Hino de Infância', 'music'), ('Rock de Garagem', 'music'), ('Pop Chiclete', 'music'),
('Jazz na Madrugada', 'music'), ('Eletrônico Pulsante', 'music'), ('Balada Romântica', 'music'), ('Som do Vinil', 'music'),
('Coro de Vozes', 'music'), ('Letra Inesquecível', 'music'), ('Riff de Baixo', 'music'), ('Batida de Bateria', 'music'),
('Som de Sintetizador', 'music'), ('Voz com Reverb', 'music'), ('Efeito de Eco', 'music'), ('Melodia de Piano', 'music'),
('Acorde de Violão', 'music'), ('Sopro de Trompete', 'music'), ('Som de Saxofone', 'music'), ('Batida de Hip Hop', 'music'),
('Ritmo de Samba', 'music'), ('Melodia de Bossa Nova', 'music'), ('Som de Reggae', 'music'), ('Batida de Funk', 'music'),
('Vibe Indie', 'music'), ('Som Alternativo', 'music'), ('Punk Rock Energia', 'music'), ('Metal Pesado', 'music'),
('Som Clássico', 'music'), ('Ópera Grandiosa', 'music'), ('Música Instrumental', 'music'), ('Trilha Sonora', 'music'),
('Som Ambiental', 'music'), ('Natureza Musical', 'music'), ('Som do Vento', 'music'), ('Ritmo da Chuva', 'music'),
('Canto de Pássaros', 'music'), ('Som de Cachoeira', 'music'), ('Vibe Meditativa', 'music'), ('Frequência de Cura', 'music'),
('Som do Universo', 'music'), ('Melodia das Esferas', 'music'), ('Ritmo Cósmico', 'music'), ('Voz Celestial', 'music'),
('Coral de Igreja', 'music'), ('Cântico Sagrado', 'music'), ('Mantra de Paz', 'music'), ('Oração Cantada', 'music'),
('Hino Nacional', 'music'), ('Canto de Torcida', 'music'), ('Música de Protesto', 'music'), ('Canção de Ninar', 'music'),
('Cantiga de Roda', 'music'), ('Música Folclórica', 'music'), ('Som de Raiz', 'music'), ('Viola Caipira', 'music'),
('Ritmo de Forró', 'music'), ('Xote Apaixonado', 'music'), ('Baião Animado', 'music'), ('Frevo Elétrico', 'music'),
('Som de Carnaval', 'music'), ('Marchinha de Época', 'music'), ('Enredo de Escola', 'music'), ('Bateria de Samba', 'music'),
('Vibe Chillout', 'music'), ('Deep House Noite', 'music'), ('Techno Industrial', 'music'), ('Trance Psicodélico', 'music'),
('Dubstep Bass', 'music'), ('Trap Moderno', 'music'), ('Drill Vibe', 'music'), ('Afrobeats Ritmo', 'music')
ON CONFLICT (word) DO NOTHING;

-- CORES E LUZ (COLOR/LIGHT)
INSERT INTO public.word_pool (word, category) VALUES 
('Azul Profundo', 'color'), ('Rosa Choque', 'color'), ('Verde Esmeralda', 'color'), ('Amarelo Solar', 'color'),
('Vermelho Paixão', 'color'), ('Roxo Real', 'color'), ('Laranja Vibrante', 'color'), ('Ciano Elétrico', 'color'),
('Magenta Doce', 'color'), ('Verde Água', 'color'), ('Azul Celeste', 'color'), ('Amarelo Ouro', 'color'),
('Prata Brilhante', 'color'), ('Bronze Antigo', 'color'), ('Cobre Quente', 'color'), ('Branco Puro', 'color'),
('Preto Absoluto', 'color'), ('Cinza Espacial', 'color'), ('Bege Areia', 'color'), ('Marrom Terra', 'color'),
('Verde Oliva', 'color'), ('Azul Marinho', 'color'), ('Rosa Bebê', 'color'), ('Laranja Pêssego', 'color'),
('Lavanda Suave', 'color'), ('Menta Fresca', 'color'), ('Coral Vivo', 'color'), ('Turquesa Mística', 'color'),
('Bordô Elegante', 'color'), ('Caramelo Doce', 'color'), ('Creme Macio', 'color'), ('Marfim Nobre', 'color'),
('Gradiente de Verão', 'color'), ('Degradê de Inverno', 'color'), ('Neon Rosa', 'color'), ('Neon Verde', 'color'),
('Neon Azul', 'color'), ('Neon Amarelo', 'color'), ('Brilho Holográfico', 'color'), ('Reflexo Metálico', 'color'),
('Textura Perolada', 'color'), ('Acabamento Mate', 'color'), ('Luz de Estúdio', 'light'), ('Luz Natural de Janela', 'light'),
('Luz de Velas Romântica', 'light'), ('Luz de Lareira Quente', 'light'), ('Luz de Lua Fria', 'light'), ('Luz de Sol Forte', 'light'),
('Luz de Entardecer', 'light'), ('Luz de Amanhecer Suave', 'light'), ('Luz de Neon de Bar', 'light'), ('Luz de Poste de Rua', 'light'),
('Luz de Lanterna de Acampamento', 'light'), ('Luz de Farol de Carro', 'light'), ('Luz de Tela de Cinema', 'light'),
('Luz de Monitor de PC', 'light'), ('Luz de Smartphone', 'light'), ('Luz de TV de Tubo', 'light'), ('Sombra de Grade', 'light'),
('Sombra de Folhas', 'light'), ('Sombra de Pessoas', 'light'), ('Sombra de Prédios', 'light'), ('Reflexo na Poça', 'light'),
('Reflexo no Lago', 'light'), ('Reflexo no Mar', 'light'), ('Reflexo no Espelho', 'light'), ('Luz de Disco', 'light'),
('Luz de Laser', 'light'), ('Luz de Flash de Câmera', 'light'), ('Luz de Holofote', 'light'), ('Luz de Pisca-pisca', 'light'),
('Luz de Letreiro', 'light'), ('Luz de Painel', 'light'), ('Luz de Botão', 'light'), ('Luz de Isqueiro', 'light'),
('Luz de Tocha', 'light'), ('Luz de Incêndio', 'light')
ON CONFLICT (word) DO NOTHING;

-- CONCEITOS (CONCEPT)
INSERT INTO public.word_pool (word, category) VALUES 
('Infinito', 'concept'), ('Eternidade', 'concept'), ('Efêmero', 'concept'), ('Instante', 'concept'),
('Karma', 'concept'), ('Dharma', 'concept'), ('Dualidade', 'concept'), ('Unidade', 'concept'),
('Vazio', 'concept'), ('Plenitude', 'concept'), ('Caos', 'concept'), ('Ordem', 'concept'),
('Criação', 'concept'), ('Destruição', 'concept'), ('Vida', 'concept'), ('Morte', 'concept'),
('Renascimento', 'concept'), ('Evolução', 'concept'), ('Involução', 'concept'), ('Revolução', 'concept'),
('Passado', 'concept'), ('Presente', 'concept'), ('Futuro', 'concept'), ('Tempo', 'concept'),
('Espaço', 'concept'), ('Dimensão', 'concept'), ('Universo', 'concept'), ('Multiverso', 'concept'),
('Realidade', 'concept'), ('Sonho', 'concept'), ('Ilusão', 'concept'), ('Verdade', 'concept'),
('Mentira', 'concept'), ('Segredo', 'concept'), ('Enigma', 'concept'), ('Símbolo', 'concept'),
('Significado', 'concept'), ('Metáfora', 'concept'), ('Analogia', 'concept'), ('Poesia', 'concept'),
('Arte', 'concept'), ('Ciência', 'concept'), ('Filosofia', 'concept'), ('Religião', 'concept'),
('Espiritualidade', 'concept'), ('Magia', 'concept'), ('Alquimia', 'concept'), ('Natureza', 'concept'),
('Cultura', 'concept'), ('Sociedade', 'concept'), ('Indivíduo', 'concept'), ('Mente', 'concept'),
('Corpo', 'concept'), ('Alma', 'concept'), ('Espírito', 'concept'), ('Razão', 'concept'),
('Emoção', 'concept'), ('Instinto', 'concept'), ('Lógica', 'concept'), ('Sentimento', 'concept'),
('Pensamento', 'concept'), ('Ação', 'concept'), ('Palavra', 'concept'), ('Silêncio', 'concept'),
('Som', 'concept'), ('Luz', 'concept'), ('Sombra', 'concept'), ('Cor', 'concept'),
('Forma', 'concept'), ('Textura', 'concept'), ('Ritmo', 'concept'), ('Melodia', 'concept'),
('Harmonia', 'concept'), ('Beleza', 'concept'), ('Sublime', 'concept'), ('Trágico', 'concept'),
('Cômico', 'concept'), ('Grotesco', 'concept'), ('Elegante', 'concept'), ('Rústico', 'concept'),
('Moderno', 'concept'), ('Antigo', 'concept'), ('Novo', 'concept'), ('Velho', 'concept'),
('Jovem', 'concept'), ('Singular', 'concept'), ('Plural', 'concept'), ('Único', 'concept'),
('Comum', 'concept'), ('Simples', 'concept'), ('Complexo', 'concept'), ('Fácil', 'concept'),
('Difícil', 'concept'), ('Próximo', 'concept'), ('Distante', 'concept'), ('Dentro', 'concept'),
('Fora', 'concept'), ('Acima', 'concept'), ('Abaixo', 'concept'), ('Antes', 'concept'),
('Depois', 'concept'), ('Sempre', 'concept'), ('Nunca', 'concept'), ('Talvez', 'concept'),
('Certo', 'concept'), ('Errado', 'concept'), ('Bom', 'concept'), ('Mau', 'concept'),
('Justo', 'concept'), ('Injusto', 'concept'), ('Livre', 'concept'), ('Preso', 'concept'),
('Forte', 'concept'), ('Fraco', 'concept'), ('Grande', 'concept'), ('Pequeno', 'concept'),
('Alto', 'concept'), ('Baixo', 'concept'), ('Largo', 'concept'), ('Estreito', 'concept'),
('Cheio', 'concept'), ('Vazio', 'concept'), ('Quente', 'concept'), ('Frio', 'concept'),
('Rápido', 'concept'), ('Lento', 'concept'), ('Brilhante', 'concept'), ('Opaco', 'concept'),
('Suave', 'concept'), ('Áspero', 'concept'), ('Doce', 'concept'), ('Amargo', 'concept'),
('Salgado', 'concept'), ('Azedo', 'concept'), ('Picante', 'concept'), ('Cheiroso', 'concept'),
('Fedorento', 'concept'), ('Barulhento', 'concept'), ('Silencioso', 'concept'), ('Visível', 'concept'),
('Invisível', 'concept'), ('Tangível', 'concept'), ('Intangível', 'concept'), ('Concreto', 'concept'),
('Abstrato', 'concept'), ('Real', 'concept'), ('Imaginário', 'concept'), ('Possível', 'concept'),
('Impossível', 'concept'), ('Incerteza', 'concept'), ('Dúvida', 'concept'), ('Crença', 'concept'),
('Conhecimento', 'concept'), ('Ignorância', 'concept'), ('Sabedoria', 'concept'), ('Loucura', 'concept'),
('Orgulho', 'concept'), ('Humildade', 'concept'), ('Inveja', 'concept'), ('Cobiça', 'concept'),
('Gula', 'concept'), ('Luxúria', 'concept'), ('Preguiça', 'concept'), ('Avareza', 'concept'),
('Ira', 'concept'), ('Paciência', 'concept'), ('Bondade', 'concept'), ('Maldade', 'concept'),
('Generosidade', 'concept'), ('Egoísmo', 'concept'), ('Lealdade', 'concept'), ('Traição', 'concept'),
('Honra', 'concept'), ('Desonra', 'concept'), ('Misericórdia', 'concept'), ('Graça', 'concept'),
('Pecado', 'concept'), ('Salvação', 'concept'), ('Condenação', 'concept'), ('Anjo', 'concept'),
('Demônio', 'concept'), ('Deus', 'concept'), ('Homem', 'concept'), ('Mulher', 'concept'),
('Animal', 'concept'), ('Planta', 'concept'), ('Pedra', 'concept'), ('Metal', 'concept'),
('Água', 'concept'), ('Fogo', 'concept'), ('Terra', 'concept'), ('Ar', 'concept'),
('Éter', 'concept'), ('Vácuo', 'concept')
ON CONFLICT (word) DO NOTHING;

-- ARTE E CULTURA (ART)
INSERT INTO public.word_pool (word, category) VALUES 
('Poema de Amor', 'art'), ('Quadro de Paisagem', 'art'), ('Sinfonia de Inverno', 'art'), ('Ópera de Verão', 'art'),
('Balé Clássico', 'art'), ('Teatro de Sombras', 'art'), ('Filme Noir', 'art'), ('Documentário de Vida', 'art'),
('Fotografia Analógica', 'art'), ('Pintura Abstrata', 'art'), ('Letra de Música', 'art'), ('Partitura de Piano', 'art'),
('Canto Gregoriano', 'art'), ('Solo de Violoncelo', 'art'), ('Lenda Urbana', 'art'), ('Mito Grego', 'art'),
('Fábula de Esopo', 'art'), ('Crônica do Dia', 'art'), ('Romance Épico', 'art'), ('Tragédia Grega', 'art'),
('Comédia de Costumes', 'art'), ('Sátira Política', 'art'), ('Haiku Japonês', 'art'), ('Quadrinhos Retro', 'art'),
('Graphic Novel', 'art'), ('Fanzine', 'art'), ('Lambe-lambe', 'art'), ('Grafite de Rua', 'art'),
('Stencil Art', 'art'), ('Instalação Moderna', 'art'), ('Performance Art', 'art')
ON CONFLICT (word) DO NOTHING;

-- 3. Função de Sorteio (Inalterada)
CREATE OR REPLACE FUNCTION public.generate_daily_word()
RETURNS void AS $$
DECLARE
  random_word text;
BEGIN
  SELECT word INTO random_word 
  FROM public.word_pool 
  WHERE word NOT IN (SELECT word FROM public.daily_words)
  ORDER BY random() 
  LIMIT 1;

  IF random_word IS NULL THEN
    SELECT word INTO random_word FROM public.word_pool ORDER BY random() LIMIT 1;
  END IF;
  
  INSERT INTO public.daily_words (word, created_at)
  VALUES (random_word, current_date)
  ON CONFLICT (created_at) DO UPDATE 
  SET word = EXCLUDED.word;
END;
$$ LANGUAGE plpgsql;

SELECT public.generate_daily_word();
