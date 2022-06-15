DELIMITER $  
-- A criação de novos objetos é fundamental para personalizar seu banco de dados de modo que o mesmo passe a, não só armazenar dados, como a realizar ações próprias, necessárias para seus sistemas.
-- Objetos como triigers, stored procedures, views, etc tem como função, realizar este tipo de personalização dentro do seu SGBD.
CREATE FUNCTION validar_CPF(CPF CHAR(11)) RETURNS BOOL DETERMINISTIC
-- O comando RETURN termina incondicionalmente o procedimento e retorna um valor inteiro ao chamador. Pode ser usado para retornar status de sucesso ou falha do procedimento.
-- Bool Este tipo de dado é muito empregado para armazenar valores do tipo sim / não, como por exemplo o status de envio de um produto, disponibilidade de um item e outras informações que sejam representadas por valores binários, ocupando muito pouco espaço de armazenamento no banco de dados.
-- Determinisct As funções determinísticas sempre retornam o mesmo resultado quando são chamadas com o uso de um conjunto específico de valores de entrada e quando recebem o mesmo estado do banco de dados.
BEGIN
    DECLARE SOMA INT;
    DECLARE INDICE INT;
    DECLARE DIGITO_1 INT;
    DECLARE DIGITO_2 INT;
    DECLARE NR_DOCUMENTO_AUX VARCHAR(11);
   
 DECLARE DIGITO_1_CPF CHAR(2);
    DECLARE DIGITO_2_CPF CHAR(2);
    /*
    Remove os CPFs onde todos os números são iguais
    */
    SET NR_DOCUMENTO_AUX = LTRIM(RTRIM(CPF));
    
    -- LTRIM (str): Remove todos os espaços em branco do início da cadeia.
    -- RTRIM (str): Remove todos os espaços em branco do final da cadeia.
    IF (NR_DOCUMENTO_AUX IN ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999', '12345678909')) THEN
      RETURN FALSE;
    END IF;
   /*
   O CPF deve ter 11 caracteres 
   */
    IF (LENGTH(NR_DOCUMENTO_AUX) <> 11) THEN
    
    -- A função LENGTH em SQL é utilizada para obter o comprimento de uma cadeia. Esta função possui nomes diferentes nas diversas bases de dados: MySQL: LENGTH ( ) Oracle: LENGTH ( )
    
        RETURN FALSE;
    ELSE 

   SET DIGITO_1_CPF = SUBSTRING(NR_DOCUMENTO_AUX,LENGTH(NR_DOCUMENTO_AUX)-1,1);
   SET DIGITO_2_CPF = SUBSTRING(NR_DOCUMENTO_AUX,LENGTH(NR_DOCUMENTO_AUX),1);

        SET SOMA = 0;
        SET INDICE = 1;
        WHILE (INDICE <= 9) DO          
            SET Soma = Soma + CAST(SUBSTRING(NR_DOCUMENTO_AUX,INDICE,1) AS UNSIGNED) * (11 - INDICE);             
            SET INDICE = INDICE + 1;      
         END WHILE;      
         SET DIGITO_1 = 11 - (SOMA % 11);      
         IF (DIGITO_1 > 9) THEN
            SET DIGITO_1 = 0;
         END IF;
        
        SET SOMA = 0;
        SET INDICE = 1;
        WHILE (INDICE <= 10) DO
             SET Soma = Soma + CAST(SUBSTRING(NR_DOCUMENTO_AUX,INDICE,1) AS UNSIGNED) * (12 - INDICE);           
             
             -- Retorna o subconjunto de uma string com base na posição inicial especificada da string. Se a entrada for uma cadeia de caracteres, a posição inicial e o número de caracteres extraídos são baseados nos caracteres, e não bytes, de forma que caracteres multibyte são contados como caracteres simples.
             -- Cast converte uma expressão de um tipo de dados em outro, o resultado a seguir é 10. Então o retorno da informação depende do tipo de dado que estará usando.
             -- CAST é uma função complexa que transforma um ou mais valores de um tipo de dados para outro.
             SET INDICE = INDICE + 1;
        END WHILE;
        -- Define uma condição para a execução repetida de uma instrução ou um bloco de instruções SQL. As instruções serão executadas repetidamente desde que a condição especificada seja verdadeira. A execução de instruções no loop WHILE pode ser controlada internamente ao loop com as palavras-chave BREAK e CONTINUE.7
        
        SET DIGITO_2 = 11 - (SOMA % 11);
        IF DIGITO_2 > 9 THEN
            SET DIGITO_2 = 0;
        END IF;
       
        IF (DIGITO_1 = DIGITO_1_CPF) AND (DIGITO_2 = DIGITO_2_CPF) THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
 END IF;
END;
