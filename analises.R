library(tidyverse)

# Verificar quais colunas do dataframe possuem NA's e a quantidade de NAs em cada coluna
na_counts <- colSums(is.na(data))
print(na_counts)

# Filtrando os dados a partir de 2007 e organizando por ano
new_data <- data %>%
  filter(ano >= 2007) %>%  
  arrange(ano)             

# Remover os NAs da coluna 'ideb'
new_data <- new_data %>%
  filter(!is.na(ideb))     

# Verificar a quantidade de NAs após a remoção na nova base de dados limpa
na_counts <- colSums(is.na(new_data))
print(na_counts)

# Estatísticas descritivas
stats <- new_data %>%
  summarise(
    mean_ideb = mean(ideb, na.rm = TRUE),        # Média
    median_ideb = median(ideb, na.rm = TRUE),    # Mediana
    sd_ideb = sd(ideb, na.rm = TRUE),             # Desvio padrão
    min_ideb = min(ideb, na.rm = TRUE),           # Mínimo
    max_ideb = max(ideb, na.rm = TRUE),           # Máximo
    n = n(),                                      # Número total de observações
    n_missing = sum(is.na(ideb))                  # Contagem de valores ausentes
  )

# Exibir as estatísticas descritivas
print(stats)

# Estatísticas descritivas por rede de ensino
stats_rede <- new_data %>%
  group_by(rede) %>%  # Agrupar os dados pela coluna 'rede'
  summarise(
    mean_ideb = mean(ideb, na.rm = TRUE),        # Média
    median_ideb = median(ideb, na.rm = TRUE),    # Mediana
    sd_ideb = sd(ideb, na.rm = TRUE),             # Desvio padrão
    min_ideb = min(ideb, na.rm = TRUE),           # Mínimo
    max_ideb = max(ideb, na.rm = TRUE),           # Máximo
    n = n(),                                      # Número total de observações
    n_missing = sum(is.na(ideb))                  # Contagem de valores ausentes
  )

# Exibir as estatísticas descritivas por rede
print(stats_rede)

# Filtrar os dados para incluir apenas Mossoró e a rede municipal
mossoro_data <- new_data %>%
  filter(id_municipio_nome == "Mossoró", rede == "municipal")

# Filtrar os dados para incluir apenas os anos finais
mossoro_anos_finais <- mossoro_data %>%
  filter(anos_escolares == "finais (6-9)")

# Filtrar os dados para incluir apenas os anos iniciais
mossoro_anos_iniciais <- mossoro_data %>%
  filter(anos_escolares == "iniciais (1-5)")

# Gerar gráfico para os anos iniciais
ggplot(mossoro_anos_iniciais, aes(x = ano, y = ideb)) +
  geom_line(size = 1.2, color = "#0072B2") +  # Linha azul mais espessa
  geom_point(size = 3, color = "#0072B2") +  # Pontos laranja mais grandes
  geom_text(aes(label = round(ideb, 2)), 
            vjust = -0.5, 
            color = "black", 
            size = 3.5, 
            fontface = "bold") +  # Rótulos em negrito
  labs(
    title = "IDEB em Mossoró: Anos Iniciais (1-5)",
    x = "Ano",  # Rótulo do eixo X
    y = "IDEB"  # Rótulo do eixo Y
  ) +
  scale_x_continuous(breaks = unique(mossoro_anos_iniciais$ano)) +  # Define todos os anos únicos no eixo X
  theme_classic() +  # Tema minimalista com tamanho de base aumentado
  theme(
    plot.title = element_text(size = 18, face = "bold"),  # Centraliza e aumenta o tamanho do título
    axis.title.x = element_text(size = 14),  # Aumenta o tamanho do rótulo do eixo X
    axis.title.y = element_text(size = 14),  # Aumenta o tamanho do rótulo do eixo Y
    axis.text = element_text(size = 12)  # Aumenta o tamanho do texto dos eixos

  )

# Gerar gráfico para os anos finais
ggplot(mossoro_anos_finais, aes(x = ano, y = ideb)) +
  geom_line(size = 1.2, color = "#0072B2") +  # Linha azul mais espessa
  geom_point(size = 3, color = "#0072B2") +  # Pontos laranja mais grandes
  geom_text(aes(label = round(ideb, 2)), 
            vjust = -0.5, 
            color = "black", 
            size = 3.5, 
            fontface = "bold") +  # Rótulos em negrito
  labs(
    title = "IDEB em Mossoró: Anos Finais (6-9)",
    x = "Ano",  # Rótulo do eixo X
    y = "IDEB"  # Rótulo do eixo Y
  ) +
  scale_x_continuous(breaks = unique(mossoro_anos_finais$ano)) +  # Define todos os anos únicos no eixo X
  theme_classic() +  # Tema minimalista com tamanho de base aumentado
  theme(
    plot.title = element_text(size = 18, face = "bold"),  # Centraliza e aumenta o tamanho do título
    axis.title.x = element_text(size = 14),  # Aumenta o tamanho do rótulo do eixo X
    axis.title.y = element_text(size = 14),  # Aumenta o tamanho do rótulo do eixo Y
    axis.text = element_text(size = 12)  # Aumenta o tamanho do texto dos eixos
    
  )

# Calcular a média do IDEB por municipio
media_ideb_cidade <- new_data %>%
  group_by(id_municipio_nome) %>%  # Agrupar por nome do município
  summarise(mean_ideb = mean(ideb, na.rm = TRUE)) %>%  # Calcular a média do IDEB
  arrange(desc(mean_ideb)) %>%
  slice_head(n = 30)

# Verificar as médias calculadas
print(media_ideb_cidade)

# Criar gráfico de barras para as 30 maiores médias do IDEB por município, destacando Mossoró
ggplot(media_ideb_cidade, aes(x = reorder(id_municipio_nome, mean_ideb), y = mean_ideb)) +
  geom_bar(stat = "identity", aes(fill = ifelse(id_municipio_nome == "Mossoró", "Mossoró", "Outros"))) +  # Definindo cores
  coord_flip() +  # Inverter os eixos para melhor visualização
  labs(
    title = "As 30 maiores médias do IDEB por Município no RN",
    x = "Município",  # Rótulo do eixo X
    y = "Média do IDEB"  # Rótulo do eixo Y
  ) +
  scale_fill_manual(values = c("Mossoró" = "red", "Outros" = "grey")) +  # Cores personalizadas
  theme_classic(base_size = 15) +  # Tema clássico
  theme(
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),  # Centraliza e aumenta o título
    axis.title.x = element_text(size = 14),  # Tamanho do rótulo do eixo X
    axis.title.y = element_text(size = 14),  # Tamanho do rótulo do eixo Y
    axis.text = element_text(size = 12),  # Tamanho do texto dos eixos
    legend.position = "none"  # Remove a legenda
  )
