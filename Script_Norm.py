import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()


try:
    # Conectar ao banco de dados de origem (primeiro)
    conexao_origem = psycopg2.connect(
        dbname=os.getenv('DBNAME_1'),
        user=os.getenv('USER_1'),
        password=os.getenv('PASSWORD_1'),
        host=os.getenv('HOST_1'),
        port=os.getenv('PORT_1')
    )

    # Conectar ao banco de dados de destino (segundo)
    conexao_destino = psycopg2.connect(
        dbname=os.getenv('DBNAME_2'),
        user=os.getenv('USER_2'),
        password=os.getenv('PASSWORD_2'),
        host=os.getenv('HOST_2'),
        port=os.getenv('PORT_2')
    )

    # Criar cursores
    cursor_origem = conexao_origem.cursor()
    cursor_destino = conexao_destino.cursor()

    # Função para transferir dados de uma tabela
    def transferir_dados(tabela_origem, tabela_destino, tipo_categoria, colunas):
        if tipo_categoria:
            query_origem = f"SELECT sId, cNome, bisinactive, '{tipo_categoria}' FROM {tabela_origem} WHERE transaction_made = false;"
            placeholders = ', '.join(['%s'] * (len(colunas)+1))
            query_destino = f"INSERT INTO {tabela_destino} ({', '.join(colunas)}, ctipo) VALUES ({placeholders})"
        else:
            query_origem = f"SELECT {', '.join(colunas)} FROM {tabela_origem} WHERE transaction_made = false;"
        
            placeholders = ', '.join(['%s'] * len(colunas))
            query_destino = f"INSERT INTO {tabela_destino} ({', '.join(colunas)}) VALUES ({placeholders})"
            
        cursor_origem.execute(query_origem)
        dados = cursor_origem.fetchall()
        
        if dados:
            print(f"Inserindo dados de {tabela_origem} em {tabela_destino}:")
            for linha in dados:
                if tipo_categoria == "Curso":
                    cursor_destino.execute(query_destino, (f'CURS_{linha[0]}', linha[1], linha[2], linha[3]))
                elif tipo_categoria == "Produto":
                    cursor_destino.execute(query_destino, (f'PROD_{linha[0]}', linha[1], linha[2], linha[3]))
                else:
                    cursor_destino.execute(query_destino, linha)
                
            cursor_origem.execute(query= f"UPDATE {tabela_origem} SET transaction_made = true WHERE transaction_made = false;")
            conexao_origem.commit()
            conexao_destino.commit()
            print("Dados Inseridos com sucesso!")
            
        else:
            print(f"Não encontramos dados para a tabela {tabela_origem}!")
        

    def transerir_dados_geral():
        # Transferindo dados para Categoria de CategoriaProduto
        transferir_dados(tabela_origem="CategoriaProduto", tabela_destino="categoria", tipo_categoria='Produto', colunas=["cId", "cnome", 'bisinactive'])

        # Transferindo dados para Categoria de CategoriaCurso
        transferir_dados(tabela_origem="CategoriaCurso", tabela_destino="categoria", tipo_categoria="Curso", colunas=["cId", "cnome", 'bisinactive'])
        
        # Transferindo dados para Plano
        transferir_dados(tabela_origem="Plano", tabela_destino="Plano", tipo_categoria=None, colunas=["sId", "cnome", "cdescricao", "fvalor", 'bisinactive'])
        
        #Transferindo dados de curso
        tabela_origem="Curso"
        tabela_destino="Curso"
        colunas=["sid","bstatus", "cdescricao", "cduracao", "ccertificacao", "cnome", "fvalor", "inumeroinscricao", 'bisinactive', "idcategoriacurso"]
        
        query_origem = f"SELECT {', '.join(colunas)} FROM {tabela_origem} WHERE transaction_made = false;"
        cursor_origem.execute(query_origem)
        dados = cursor_origem.fetchall()
            
        placeholders = ', '.join(['%s'] * len(colunas))
        query_destino = f"INSERT INTO {tabela_destino} ({', '.join(colunas[0:9])}, idCategoria) VALUES ({placeholders})"
            
        if dados:
            print(f"Inserindo dados de {tabela_origem} em {tabela_destino}:")
                
            for linha in dados:
                cursor_destino.execute(query_destino, (linha[0], linha[1], linha[2], linha[3], linha[4], linha[5], linha[6], linha[7], linha[8], f'CURS_{linha[9]}'))

            cursor_origem.execute(f"UPDATE {tabela_origem} SET transaction_made = true WHERE transaction_made = false;")
            conexao_origem.commit()
            conexao_destino.commit()
            print("Dados Inseridos com sucesso!")
        else:
            print(f"Não encontramos dados para a tabela {tabela_origem}!")
            
        #Transferindo dados de midia do curso
        tabela_origem="midiaCurso"
        tabela_destino="Curso"
        colunas = ["cUrlFoto", "idCurso"]
        
        query_origem = f"SELECT {', '.join(colunas)} FROM {tabela_origem} WHERE transaction_made = false;"
        cursor_origem.execute(query_origem)
        dados = cursor_origem.fetchall()
        query_destino = f"UPDATE {tabela_destino} SET {colunas[0]} = %s WHERE sid = %s"
        
        if dados:
            print(f"Dados a inserir de {tabela_origem}:\n{dados}")
                
            for linha in dados:
                cursor_destino.execute(query_destino, (linha))

            cursor_origem.execute(f"UPDATE {tabela_origem} SET transaction_made = true WHERE transaction_made = false;")
            conexao_origem.commit()
            conexao_destino.commit()
            print("Dados Inseridos com sucesso!")
        else:
            print(f"Não encontramos dados para a tabela {tabela_origem}!")
        
    def update_data(tabela_origem, tabela_destino, tipo_categoria, colunas):
        # Construindo a query de origem
        query_origem = f"SELECT {', '.join(colunas)} FROM {tabela_origem} WHERE transaction_made = true AND bisupdated = true;"
        
        cursor_origem.execute(query_origem)
        dados = cursor_origem.fetchall()
        
        if dados:
            print(f"Atualizando dados de {tabela_origem} em em {tabela_destino}:\n")
            # Para cada linha de dados encontrada
            for linha in dados:
                # Construindo a query de destino dependendo da existência de 'tipo_categoria'
                if tipo_categoria:
                    colunas.remove('sid')
                    query_destino = f"UPDATE {tabela_destino} SET {', '.join([f'{coluna} = %s' for coluna in colunas])} WHERE cid = %s"
                    cid_valor = f"{tipo_categoria[0:4].upper()}_{linha[0]}"
                    cursor_destino.execute(query_destino, (linha[1], linha[2], cid_valor))
                else:
                    if tabela_destino == "Curso" and tabela_origem == "Curso":
                        colunas.remove("idcategoriacurso")
                        colunas.append("idcategoria")
                        query_destino = f"UPDATE {tabela_destino} SET {', '.join([f'{coluna} = %s' for coluna in colunas])} WHERE sId = %s"
                        cursor_destino.execute(query_destino, (linha[0], linha[1], linha[2], linha[3], linha[4], linha[5], linha[6], linha[7], linha[8], f'CURS_{linha[9]}', linha[0]))
                    elif tabela_destino == "Curso" and tabela_origem == "MidiaCurso":
                        colunas.remove("idCurso")
                        query_destino = f"UPDATE {tabela_destino} SET {', '.join([f'{coluna} = %s' for coluna in colunas])} WHERE sId = %s"
                        cursor_destino.execute(query_destino, (linha[1], linha[0]))
                    else:
                        query_destino = f"UPDATE {tabela_destino} SET {', '.join([f'{coluna} = %s' for coluna in colunas])} WHERE sId = %s"
                        cursor_destino.execute(query_destino, (*linha, linha[0]))
            
            # Atualizando a tabela de origem
            cursor_origem.execute(f"UPDATE {tabela_origem} SET bisupdated = false WHERE bIsupdated = true;")
            conexao_origem.commit()
            conexao_destino.commit()
            print("Dados atualizados com sucesso!")
            
        else:
            print(f"Não encontramos dados para atualizar na tabela {tabela_origem}!")

    # Transferindo dados das tabelas do 1 para o 2
    transerir_dados_geral()
    
    # Atualizando dados para Categoria de CategoriaProduto
    update_data(tabela_origem="CategoriaProduto", tabela_destino="categoria", tipo_categoria='Produto', colunas=["sid", "cnome", 'bisinactive'])

    # Atualizando dados para Categoria de CategoriaCurso
    update_data(tabela_origem="CategoriaCurso", tabela_destino="categoria", tipo_categoria="Curso", colunas=["sid", "cnome", 'bisinactive'])
        
    # Atualizando dados para Plano
    update_data(tabela_origem="Plano", tabela_destino="Plano", tipo_categoria=None, colunas=["sid", "cnome", "cdescricao", "fvalor", 'bisinactive'])
    
    # Atualizando dados para Curso
    update_data(tabela_origem="Curso",
        tabela_destino="Curso",
        tipo_categoria=None,
        colunas=["sid","bstatus", "cdescricao", "cduracao", "ccertificacao", "cnome", "fvalor", "inumeroinscricao", 'bisinactive', "idcategoriacurso"])
    
    # Atualizando dados para Midia curso
    update_data(tabela_origem="MidiaCurso",
        tabela_destino="Curso",
        tipo_categoria=None,
        colunas=["idCurso", "cUrlFoto"])

    # Commitar e fechar conexões
    conexao_destino.commit()
    cursor_origem.close()
    cursor_destino.close()
    conexao_origem.close()
    conexao_destino.close()

except Exception as error:
    cursor_origem.close()
    cursor_destino.close()
    conexao_origem.close()
    conexao_destino.close()
    print(f"Erro recebido: {error}")