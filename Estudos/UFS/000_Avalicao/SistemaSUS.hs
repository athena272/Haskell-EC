module SistemaSUS where
import Data.List 

--Tipo mais externo, para cadastro
type CadastroSUS = [Cidadao]

--Tipos para cada cadastro
type CPF = Integer
type Nome = String
type Genero = Char
type Dia = Int
type Mes = Int
type Ano = Int
type Data = (Dia, Mes, Ano)
type DataNasc = Data
type Endereco = String
type Municipio = String
type Estado = String
type Telefone = String
type Email = String 
type Cidadao = (CPF, Nome, Genero, DataNasc, Endereco, Municipio, Estado, Telefone, Email)

--Meus cadastros pre-existentes no banco de dados 
bancoDeCadastros :: CadastroSUS
bancoDeCadastros = [(26716347665, "Paulo Souza", 'M', (11,10,1996),"Rua A, 202","Muribeca", "SE", "999997000", "psouza@gmail.com"),(87717347115, "Ana Reis",'F', (5,4,1970), "Rua B, 304","Aracaju", "SE", "999826004", "areis@gmail.com")]

-- item a) Cadastramento de um cidadão no sistema. 
--Para cadastrar um novo cidadão, inicialmente é checado se o CPF já existe ou não no sistema com a função 
addCadastroSUS :: Cidadao -> CadastroSUS -> CadastroSUS
addCadastroSUS myCidadao myDataBase
    | checkCPF (getCPF myCidadao) myDataBase = error "Usuario existente"
    | otherwise = myCidadao : myDataBase
    
--item b)O cidadão pode querer modificar algum desses dados, por exemplo, o número de telefone ou endereço. Para isto, precisamos de funções de atualização dos dados no cadastro, passando os novos dados. Para simplificar o sistema, vamos supor apenas as funções de atualização do endereço e do telefone, já que as demais atualizações seguiriam o mesmo princípio. No processo de atualização, o cadastro SUS informado será copiado para um novo cadastro SUS. Neste novo cadastro, os registros de outros cidadãos permanecerão inalterados e somente os dados do cidadão que está sendo atualizado sofrerão modificações.
atualizaEnderecoSUS :: CPF -> CadastroSUS -> Endereco -> CadastroSUS
atualizaEnderecoSUS myCPF myDataBase newAdress = comeco ++ [(cpf,nome,gender,nasc,newAdress,muni,state,tel,email)| (cpf,nome,gender,nasc,newAdress,muni,state,tel,email) <- myDataBase, cpf == myCPF] ++ fim
    where position = findPosElem myCPF myDataBase
          comeco = take (position - 1) myDataBase
          fim = drop position myDataBase

atualizaTelefoneSUS :: CPF -> CadastroSUS -> Telefone -> CadastroSUS
atualizaTelefoneSUS myCPF myDataBase newTel = comeco ++ [(cpf,nome,gender,nasc,adress,muni,state,newTel,email) |  (cpf,nome,gender,nasc,adress,muni,state,newTel,email) <- myDataBase, cpf == myCPF] ++ fim
    where position = findPosElem myCPF myDataBase
          comeco = take (position - 1) myDataBase
          fim = drop position myDataBase

--item c) Quando um cidadão falece, a família tem que notificar o fato em um posto de saúde, para que ele seja retirado do cadastro corrente do SUS. Como há uma verificação do atestado de óbito, isto só pode ser feito no posto. O sistema precisará da função abaixo. Se o CPF existir no cadastro corrente do SUS, o registro do cidadão deve ser completamente excluído, gerando um novo cadastro sem os dados deste cidadão. Se o CPF não existir, uma mensagem de erro, usando error, sinalizando que o cidadão não pertence ao cadastro deve ser exibida.
cidadaoMortoSUS :: CPF -> CadastroSUS -> CadastroSUS
cidadaoMortoSUS myCPF myDataBase = [(cpf,nome,gender,nasc,adress,muni,state,tel,email) | (cpf,nome,gender,nasc,adress,muni,state,tel,email) <- myDataBase, myCPF /= cpf]

--item d)


--GETS e outras funçoes auxiliares
getCPF :: Cidadao -> CPF
getCPF (myCPF, _, _, _, _, _, _, _, _) = myCPF 

getEndereco :: Cidadao -> Endereco
getEndereco (_, _, _, _, myEndereco, _, _, _, _) = myEndereco

getTelefone :: Cidadao -> Telefone
getTelefone (_, _, _, _, _, _, _, myTelefone, _) = myTelefone

----Para cadastrar um novo cidadão, inicialmente é checado se o CPF já existe ou não no sistema com a função 
checkCPF :: CPF -> CadastroSUS -> Bool
checkCPF myCPF myDataBase = or [myCPF == cpfDataBase| (cpfDataBase, _, _, _, _, _, _, _, _) <- myDataBase] --Se pelo menos um for verdadeiro na lista, já é o bastante, por isso a funcao "or"

--Atribuir um valor(indixe) para cada cidadao que exisitir no "banco de dados"
posicionarElementosLista :: CadastroSUS -> [(Int, Cidadao)]
posicionarElementosLista myDataBase = zip posicoes myDataBase
    where posicoes = [1..(length myDataBase)]

--Encontrar a posicao do cidadao com base no seu CPF
findPosElem :: CPF -> CadastroSUS -> Int
findPosElem myCPF myDataBase
    |null posicao = 0
    |otherwise = head posicao
    where posicao = [ position | (position, cidadao) <- (posicionarElementosLista myDataBase), (getCPF cidadao)  == myCPF]