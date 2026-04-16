# 📂 Relatório de Contexto Técnico: umaMusicaPorDiaProject (Bento)

## 1. Visão Geral do Projeto
O **umaMusicaPorDiaProject** (codinome interno: **Bento**) é um aplicativo iOS nativo desenvolvido em **SwiftUI**. O propósito central do app é oferecer uma experiência diária de descoberta e criatividade, onde o usuário recebe uma "Palavra do Dia" através de uma mecânica de "Gacha" (máquina de sorteio) e a utiliza como inspiração para criar colagens visuais integradas a elementos musicais.

---

## 2. Stack Tecnológica
*   **Linguagem & Interface:** Swift 6.0+ com SwiftUI.
*   **Arquitetura:** MVVM (Model-View-ViewModel) com separação clara de responsabilidades.
*   **Backend & Banco de Dados:** Supabase (PostgreSQL, Auth e Storage).
*   **Monetização:** RevenueCat (Gestão de assinaturas e Paywalls).
*   **Integrações de API:**
    *   **iTunes API:** Para busca e metadados de músicas.
    *   **YouTube API:** Para busca de vídeos relacionados.
*   **Persistência de Dados:** Integração nativa com Supabase para salvar colagens e progresso do usuário.
*   **Extensões:** WidgetKit (Widget para tela de início exibindo a música/palavra do dia).

---

## 3. Arquitetura do Sistema

### 📂 Estrutura de Pastas
*   `/App`: Ponto de entrada e configuração global do ciclo de vida.
*   `/Models`: Entidades de dados (Codable/Identifiable).
*   `/ViewModels`: Lógica de negócio, estados de UI e chamadas a serviços.
*   `/Views`:
    *   `/Screens`: Telas principais (Home, CollageCreator, Auth, Onboarding).
    *   `/Components`: UI modular (Canvas, Layers, NeonStickers, Sheets).
*   `/Services`: Camada de rede e abstração de APIs externas (Supabase, Music, YouTube).
*   `/Utils`: Helpers de imagem (Compressor/Processor), extensões de cor (Hex) e configurações de cliente.

---

## 4. Modelos de Dados Principais

### `Collage`
Representa a criação final do usuário.
- `userId`: Referência ao usuário no Supabase.
- `wordId`: A palavra que inspirou a colagem.
- `imageUrl`: Link para a imagem renderizada no Storage.
- `assetsJson`: Array de `CollageAsset` (posições, escalas e tipos de elementos no canvas).

### `DailyWord`
- `word`: A palavra sorteada.
- `meaning`: Significado ou contexto.
- `date`: Data de expiração/ativação.

### `CollageAsset`
- Define elementos individuais na colagem: Imagens (Pinterest), Stickers, Textos ou Músicas.
- Armazena metadados de transformação (Offset, Scale, Rotation).

---

## 5. Fluxos de Negócio e Serviços

### 🔄 Fluxo Principal do Usuário
1.  **Home (Gacha):** O usuário gira uma alavanca virtual (`TimeMachineConsole`) para sortear a palavra do dia via `WordService`.
2.  **Criação:** A palavra leva ao `CollageCreatorView`, onde o usuário monta um "Bento" visual.
3.  **Refinamento:** Escolha de backgrounds, stickers e refinamento de cores.
4.  **Exportação:** Renderização da colagem e salvamento no perfil.

### 🛠️ Serviços de Backend
*   **SupabaseService:** Gerencia a conexão persistente e autenticação.
*   **CollageService:** CRUD de colagens e upload de assets.
*   **SubscriptionManager:** Singleton que monitora o status Pro via RevenueCat para liberar funcionalidades premium.
*   **APIServices (Music/YouTube):** Realiza o fetch dinâmico de conteúdo baseado na palavra sorteada.

---

## 6. Padrões de UI e Design (Liquid Glass & Modern Swift)
O projeto utiliza uma estética vibrante com gradientes complexos e elementos de UI personalizados:
*   **Cores:** Uso extensivo de Hex codes para fidelidade ao design do Figma (ex: `#81E862` verde, `#6759F1` roxo).
*   **Componentes Customizados:**
    *   `AppButton` e `AppTextField`: Padronização de interação.
    *   `NeonSticker`: Efeitos visuais de brilho em stickers.
    *   `CollageCanvasView`: Um canvas interativo com suporte a gestos e camadas.

---

## 7. Detalhes de Implementação Críticos
*   **Gestão de Estado:** Uso de `@State`, `@Binding` e `@Environment` para propagação de dados entre Views e ViewModels.
*   **Segurança:** As chaves de API e URLs do Supabase são gerenciadas via `SupabaseConfig`.
*   **Performance:** Uso de `ImageCompressor` para otimizar uploads e `ImageProcessor` para filtros e máscaras nas colagens.

---
*Relatório gerado em 16 de Abril de 2026 para fins de documentação e transferência de contexto.*
