# Instalando o pacote 'basedosdados', que permite acessar dados públicos do BigQuery
install.packages("basedosdados")
# Carregando o pacote 'basedosdados' na sessão do R
library(basedosdados)

# Definindo o ID de faturamento do seu projeto no Google Cloud
# Este ID é necessário para realizar consultas no BigQuery e associar possíveis custos ao seu projeto.
basedosdados::set_billing_id("ideb-437412")  # O projeto criado no Google Cloud com o ID 'ideb-437412'

# Definindo uma consulta SQL que busca dados do IDEB para municípios no Rio Grande do Norte (RN)
query <- "
SELECT
    dados.ano as ano,  # Selecionando o ano dos dados
    dados.sigla_uf AS sigla_uf,  # Sigla da unidade federativa (estado)
    diretorio_sigla_uf.nome AS sigla_uf_nome,  # Nome do estado
    dados.id_municipio AS id_municipio,  # Código do município
    diretorio_id_municipio.nome AS id_municipio_nome,  # Nome do município
    dados.rede as rede,  # Rede de ensino (ex: estadual, municipal)
    dados.ensino as ensino,  # Tipo de ensino (ex: fundamental, médio)
    dados.anos_escolares as anos_escolares,  # Anos escolares em questão
    dados.taxa_aprovacao as taxa_aprovacao,  # Taxa de aprovação no ensino
    dados.indicador_rendimento as indicador_rendimento,  # Indicador de rendimento escolar
    dados.ideb as ideb  # Índice de Desenvolvimento da Educação Básica (IDEB)
FROM `basedosdados.br_inep_ideb.municipio` AS dados  # Selecionando os dados do IDEB por município
LEFT JOIN (SELECT DISTINCT sigla, nome FROM `basedosdados.br_bd_diretorios_brasil.uf`) AS diretorio_sigla_uf
    ON dados.sigla_uf = diretorio_sigla_uf.sigla  # Unindo com os nomes dos estados
LEFT JOIN (SELECT DISTINCT id_municipio, nome FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
    ON dados.id_municipio = diretorio_id_municipio.id_municipio  # Unindo com os nomes dos municípios
WHERE dados.sigla_uf = 'RN'  # Filtrando para mostrar apenas os dados do estado do Rio Grande do Norte (RN)
"

# Executando a consulta SQL para obter os dados filtrados
# O resultado será armazenado no dataframe 'data'
data <- basedosdados::read_sql(query, billing_project_id = "ideb-437412")

